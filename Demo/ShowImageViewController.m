//
//  ShowImageViewController.m
//  Demo
//
//  Created by 淼视觉 on 2017/10/10.
//  Copyright © 2017年 倪大头. All rights reserved.
//

#import "ShowImageViewController.h"

@interface ShowImageViewController ()

@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showImage];
}

- (void)showImage {
    UIImageView *myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    myImageView.image = self.myImage;
    myImageView.contentMode = UIViewContentModeScaleAspectFill;
    myImageView.clipsToBounds = YES;
    [self.view addSubview:myImageView];
    UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popViewController)];
    myImageView.userInteractionEnabled = YES;
    [myImageView addGestureRecognizer:imgTap];
}

- (void)popViewController {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UIPreviewActionItem
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    UIPreviewAction *likeAction = [UIPreviewAction actionWithTitle:@"赞" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
    }];
    
    return @[likeAction];
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
