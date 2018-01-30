//
//  DrawViewController.m
//  Demo
//
//  Created by 淼视觉 on 2017/9/25.
//  Copyright © 2017年 倪大头. All rights reserved.
//

#import "DrawViewController.h"
#import "DrawView.h"

@interface DrawViewController ()<drawViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation DrawViewController
{
    DrawView *drawView;
    UIImageView *paletteView;//调色板
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createCustomNavi:@"贝塞尔曲线"];
    
    [self createView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)createView {
    drawView = [[DrawView alloc]initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-64-44)];
    drawView.myDelegate = self;
    [self.view addSubview:drawView];
    
    //toolbar
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self.navigationController.toolbar setBarStyle:UIBarStyleDefault];
    self.navigationController.toolbar.frame = CGRectMake(0, UI_SCREEN_HEIGHT-44, UI_SCREEN_WIDTH, 44);
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *colorItem = [[UIBarButtonItem alloc]initWithTitle:@"颜色" style:UIBarButtonItemStyleDone target:self action:@selector(colorAction)];
    
    UIBarButtonItem *eraseItem = [[UIBarButtonItem alloc]initWithTitle:@"橡皮" style:UIBarButtonItemStyleDone target:self action:@selector(eraserAction)];
    
    UIBarButtonItem *undoItem = [[UIBarButtonItem alloc]initWithTitle:@"撤销" style:UIBarButtonItemStyleDone target:self action:@selector(undoAction)];
    
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc]initWithTitle:@"清屏" style:UIBarButtonItemStyleDone target:self action:@selector(clearAction)];
    
    self.toolbarItems = @[colorItem,spaceItem,eraseItem,spaceItem,undoItem,spaceItem,clearItem];
}

- (void)colorAction {//调色板
    if (!paletteView) {
        paletteView = [[UIImageView alloc]initWithFrame:CGRectMake(kScaleX*5, UI_SCREEN_HEIGHT-44-kScaleY*5-kScaleY*296, kScaleX*300, kScaleY*296)];
        paletteView.image = [UIImage imageNamed:@"palette"];
        [self.view addSubview:paletteView];
        UITapGestureRecognizer *paletteViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseColor:)];
        paletteViewTap.delegate = self;
        paletteView.userInteractionEnabled = YES;
        [paletteView addGestureRecognizer:paletteViewTap];
    }else {
        [paletteView removeFromSuperview];
        paletteView = nil;
    }
}

- (void)chooseColor:(UITapGestureRecognizer *)tap {//选择颜色
    CGPoint point = [tap locationInView:paletteView];
    
    if (CGRectContainsPoint(CGRectMake(0.0f, 0.0f, paletteView.image.size.width, paletteView.image.size.height), point)) {
        NSInteger pointX = trunc(point.x);
        NSInteger pointY = trunc(point.y);
        CGImageRef cgImage = paletteView.image.CGImage;
        NSUInteger width = paletteView.image.size.width;
        NSUInteger height = paletteView.image.size.height;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        int bytesPerPixel = 4;
        int bytesPerRow = bytesPerPixel * 1;
        NSUInteger bitsPerComponent = 8;
        unsigned char pixelData[4] = { 0, 0, 0, 0 };
        CGContextRef context = CGBitmapContextCreate(pixelData,
                                                     1,
                                                     1,
                                                     bitsPerComponent,
                                                     bytesPerRow,
                                                     colorSpace,
                                                     kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
        CGColorSpaceRelease(colorSpace);
        CGContextSetBlendMode(context, kCGBlendModeCopy);
        
        CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
        CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
        CGContextRelease(context);
        
        CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
        CGFloat green = (CGFloat)pixelData[1] / 255.0f;
        CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
        CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
        
        drawView.isErase = NO;
        drawView.lineColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        NSLog(@"%lf %lf %@",point.x,point.y,drawView.lineColor);
    }
}

- (void)drawViewTouchBegan {//DrawView代理方法，关闭调色板
    if (paletteView) {
        [paletteView removeFromSuperview];
        paletteView = nil;
    }
}

- (void)eraserAction {//橡皮
    drawView.isErase = YES;
}

- (void)undoAction {//撤销
    [drawView undoAction];
}

- (void)clearAction {//清屏
    [drawView clearAction];
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
