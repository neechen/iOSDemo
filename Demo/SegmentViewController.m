//
//  SegmentViewController.m
//  Demo
//
//  Created by 淼视觉 on 2018/1/30.
//  Copyright © 2018年 倪大头. All rights reserved.
//

#import "SegmentViewController.h"
#import "SegmentView.h"

@interface SegmentViewController ()<UIScrollViewDelegate>

@end

@implementation SegmentViewController
{
    SegmentView *segmentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createCustomNavi:@"自定义Segment"];
    
    [self createView];
}

- (void)createView {
    //创建SegmentView
    NSArray *titleArray = @[@"一",@"两个",@"三个字",@"四个字的",@"一",@"两个",@"三个字",@"四个字的"];
    segmentView = [[SegmentView alloc]initWithFrame:CGRectMake(0, 64, UI_SCREEN_WIDTH, 40)];
    segmentView.backgroundColor = [UIColor whiteColor];
    [segmentView setTitleViewWithArray:titleArray];
    [self.view addSubview:segmentView];
    
    //创建一个Scrollview作为主界面
    UIScrollView *myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(segmentView.frame), UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - segmentView.frame.size.height - 64)];
    myScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH * titleArray.count, 0);
    myScrollView.showsHorizontalScrollIndicator = NO;//隐藏滚轮
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    
    for (int i = 0; i < titleArray.count; i++) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(i*UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, myScrollView.frame.size.height)];
        //随机背景色
        bgView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
        [myScrollView addSubview:bgView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.bounds.size.width) {
        return;
    }

    CGFloat progress = scrollView.contentOffset.x/UI_SCREEN_WIDTH;
    [segmentView beginMoveWithProgress:progress];
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
