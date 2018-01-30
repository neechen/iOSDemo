//
//  continueScrollView.m
//  Demo
//
//  Created by 淼视觉 on 2017/9/8.
//  Copyright © 2017年 倪大头. All rights reserved.
//

#import "ContinueScrollView.h"
#import "ShowImageViewController.h"

@interface ContinueScrollView ()<UIViewControllerPreviewingDelegate>

@end

@implementation ContinueScrollView
{
    UIScrollView *myScrollView;
    NSArray *images;
    UIImageView *leftImgV;//ScrollView由三张图构成，循环使用
    UIImageView *centerImgV;
    UIImageView *rightImgV;
    NSInteger currentImageIndex;//当前图片下标
    UIPageControl *pageControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createCustomNavi:@"ScrollView循环滑动"];
    self.view.clipsToBounds = YES;//去掉这句退出页面时会有图片残留
    
    images = @[@"Dva1",@"Dva2",@"Dva3"];
    
    [self createView];
}

- (void)createView {
    myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(kScaleX*47.5, 64 + kScaleY*50, kScaleX*280, kScaleY*450)];
    myScrollView.delegate = self;
    myScrollView.pagingEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.clipsToBounds = NO;
    NSInteger imageCount = images.count > 2 ? images.count : 3;//contentSize至少为ScrollView宽度的3倍，少于3张图也要把contentSize补到3倍宽
    myScrollView.contentSize = CGSizeMake(myScrollView.frame.size.width * imageCount, 0);
    myScrollView.contentOffset = CGPointMake(myScrollView.frame.size.width, 0);
    [self.view addSubview:myScrollView];
    
    //3DTouch
    if ([self respondsToSelector:@selector(traitCollection)]) {
        if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                [self registerForPreviewingWithDelegate:self sourceView:myScrollView];
            }
        }
    }
    
    //图片视图：左边
    leftImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kScaleX*15, 0, myScrollView.frame.size.width - kScaleX*30, myScrollView.frame.size.height)];
    leftImgV.contentMode = UIViewContentModeScaleAspectFill;
    leftImgV.clipsToBounds = YES;
    [myScrollView addSubview:leftImgV];
    
    //图片视图：中间
    centerImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kScaleX*15 + myScrollView.frame.size.width, 0, myScrollView.frame.size.width - kScaleX*30, myScrollView.frame.size.height)];
    centerImgV.contentMode = UIViewContentModeScaleAspectFill;
    centerImgV.clipsToBounds = YES;
    [myScrollView addSubview:centerImgV];
    
    //图片视图：右边
    rightImgV = [[UIImageView alloc]initWithFrame:CGRectMake(kScaleX*15 + myScrollView.frame.size.width*2, 0, myScrollView.frame.size.width - kScaleX*30, myScrollView.frame.size.height)];
    rightImgV.contentMode = UIViewContentModeScaleAspectFill;
    rightImgV.clipsToBounds = YES;
    [myScrollView addSubview:rightImgV];
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(myScrollView.frame.origin.x, CGRectGetMaxY(myScrollView.frame)-kScaleY*30, myScrollView.frame.size.width, kScaleY*30)];
    pageControl.numberOfPages = images.count;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self.view addSubview:pageControl];
    
    currentImageIndex = 0;
    [self setInfoByCurrentImageIndex:currentImageIndex];
}

- (void)setInfoByCurrentImageIndex:(NSInteger)index {
    leftImgV.image = [UIImage imageNamed:images[(index - 1 + images.count) % images.count]];
    
    centerImgV.image = [UIImage imageNamed:images[index]];
    
    rightImgV.image = [UIImage imageNamed:images[(index + 1 + images.count) % images.count]];
    
    pageControl.currentPage = index;
}

- (void)reloadImage {
    CGPoint contentOffset = myScrollView.contentOffset;
    if (contentOffset.x > myScrollView.frame.size.width) { //向左滑动
        currentImageIndex = (currentImageIndex + 1) % images.count;
    }else if (contentOffset.x < myScrollView.frame.size.width) { //向右滑动
        currentImageIndex = (currentImageIndex - 1 + images.count) % images.count;
    }

    [self setInfoByCurrentImageIndex:currentImageIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == myScrollView) {
        [self reloadImage];
        
        myScrollView.contentOffset = CGPointMake(myScrollView.frame.size.width, 0);
    }
}

#pragma mark - UIViewControllerPreviewingDelegate
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    //previewingContext.sourceView: 触发Peek & Pop操作的视图
    //previewingContext.sourceRect: 设置触发操作的视图的不被虚化的区域
    ShowImageViewController *showimgvc = [[ShowImageViewController alloc]init];
    //showimgvc.preferredContentSize = CGSizeMake(0, 300);//预览区域大小(可不设置)
    showimgvc.myImage = [UIImage imageNamed:images[currentImageIndex]];
    return showimgvc;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
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
