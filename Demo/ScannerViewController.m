//
//  ScannerViewController.m
//  Demo
//
//  Created by 淼视觉 on 2017/9/11.
//  Copyright © 2017年 倪大头. All rights reserved.
//

#import "ScannerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScannerViewController ()<AVCaptureMetadataOutputObjectsDelegate>//用于处理采集信息的代理

@end

@implementation ScannerViewController
{
    AVCaptureSession *session;//输入输出的中间桥梁
    NSTimer *timer;
    UIImageView *line;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self scannerAction];
}

- (void)scannerAction {
    //先判断摄像头硬件是否好用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //用户是否允许摄像头使用
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        //不允许弹出提示框
        if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"摄像头访问受限" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertView animated:YES completion:nil];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertView addAction:action];
        }else {
            //这里是摄像头可以使用的处理逻辑
            [self addCamera];
        }
    }else {
        // 硬件问题提示
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"手机摄像头设备损坏" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}

- (void)addCamera {
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    //设置扫描区域
    CGSize size = self.view.bounds.size;
    CGRect cropRect = CGRectMake(UI_SCREEN_WIDTH/375*37.5, 64+UI_SCREEN_HEIGHT/667*70, UI_SCREEN_WIDTH/375*300, UI_SCREEN_HEIGHT/667*300);
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = self.view.bounds.size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                           cropRect.origin.x/size.width,
                                           cropRect.size.height/fixHeight,
                                           cropRect.size.width/size.width);
    }else {
        CGFloat fixWidth = self.view.bounds.size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                           (cropRect.origin.x + fixPadding)/fixWidth,
                                           cropRect.size.height/size.height,
                                           cropRect.size.width/fixWidth);
    }
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    [self creatScannerUI];
    
    [self lineMove];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(lineMove) name:@"move" object:nil];
    
    //开始捕获
    [session startRunning];
}

- (void)creatScannerUI {
    //扫码窗口
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64)];
    
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self.view addSubview:maskView];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    
    [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(UI_SCREEN_WIDTH/375*67.5, UI_SCREEN_HEIGHT/667*100, UI_SCREEN_WIDTH/375*240, UI_SCREEN_HEIGHT/667*240) cornerRadius:1] bezierPathByReversingPath]];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.path = maskPath.CGPath;
    
    maskView.layer.mask = maskLayer;
    
    //扫描动画
    line = [[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/375*67.5, 64+UI_SCREEN_HEIGHT/667*100, UI_SCREEN_WIDTH/375*240, 2)];
    line.image = [UIImage imageNamed:@"扫描线"];
    line.center = CGPointMake(UI_SCREEN_WIDTH/2, 64+UI_SCREEN_HEIGHT/667*100);
    [self.view addSubview:line];
    
    UIImageView *borderImg = [[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/375*67.5, 64+UI_SCREEN_HEIGHT/667*100, UI_SCREEN_WIDTH/375*240, UI_SCREEN_HEIGHT/667*240)];
    borderImg.image = [UIImage imageNamed:@"扫描框"];
    [self.view addSubview:borderImg];
}

//扫码代理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0];
        //输出扫描字符串
        NSLog(@"%@",metadataObject.stringValue);
    }
}

//动画
- (void)lineMove {
    [UIView animateWithDuration:2.5 delay:0.0 options:UIViewAnimationOptionRepeat animations:^{
        line.center = CGPointMake(UI_SCREEN_WIDTH/2, 64+UI_SCREEN_HEIGHT/667*338);
    } completion:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"move" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
