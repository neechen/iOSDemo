//
//  QRCodeViewController.m
//  Demo
//
//  Created by 淼视觉 on 2017/9/8.
//  Copyright © 2017年 倪大头. All rights reserved.
//

#import "QRCodeViewController.h"
#import "ScannerViewController.h"

@interface QRCodeViewController ()

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createCustomNavi:@"二维码生成/扫描"];
    
    [self createView];
}

- (void)createView {
    //生成按钮
    UIButton *createBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScaleX*40, kScaleY*450, kScaleX*100, kScaleY*60)];
    [createBtn setTitle:@"生成" forState:UIControlStateNormal];
    [createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    createBtn.titleLabel.font = [UIFont fontWithName:LightFont size:18];
    createBtn.backgroundColor = [UIColor blackColor];
    createBtn.layer.cornerRadius = 4;
    createBtn.clipsToBounds = YES;
    [createBtn addTarget:self action:@selector(createAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createBtn];
    
    //扫描按钮
    UIButton *scannerBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScaleX*235, kScaleY*450, kScaleX*100, kScaleY*60)];
    [scannerBtn setTitle:@"扫描" forState:UIControlStateNormal];
    [scannerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    scannerBtn.titleLabel.font = [UIFont fontWithName:LightFont size:18];
    scannerBtn.backgroundColor = [UIColor blackColor];
    scannerBtn.layer.cornerRadius = 4;
    scannerBtn.clipsToBounds = YES;
    [scannerBtn addTarget:self action:@selector(scannerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scannerBtn];
}

- (void)createAction {
    //1.创建滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //2.恢复默认
    [filter setDefaults];
    
    //3.给滤镜添加数据
    NSString *dataString = @"你好,世界";
    //将数据转换成NSData类型
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    //通过KVC设置滤镜的二维码输入信息
    [filter setValue:data forKey:@"inputMessage"];
    
    //4.获取输出的二维码图片（CIImage类型）
    CIImage *outImage = [filter outputImage];
    //将CIImage类型的图片装换成UIImage类型的图片
    UIImage *image = [self excludeFuzzyImageFromCIImage:outImage size:kScaleY*200];
    
    //5.显示二维码图片
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(kScaleX*87.5, 64+kScaleY*40, kScaleX*200, kScaleY*200)];
    imageV.image = image;
    [self.view addSubview:imageV];
}

#pragma mark -- 对图像进行清晰处理，很关键！
- (UIImage *)excludeFuzzyImageFromCIImage:(CIImage *)image size:(CGFloat)size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    //通过比例计算，让最终的图像大小合理（正方形是我们想要的）
    CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext * context = [CIContext contextWithOptions: nil];
    
    CGImageRef bitmapImage = [context createCGImage: image fromRect: extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    //切记ARC模式下是不会对CoreFoundation框架的对象进行自动释放的，所以要我们手动释放
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    CGColorSpaceRelease(colorSpace);
    
    return [UIImage imageWithCGImage: scaledImage];
}

- (void)scannerAction {
    ScannerViewController *scannervc = [[ScannerViewController alloc]init];
    [self.navigationController pushViewController:scannervc animated:YES];
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
