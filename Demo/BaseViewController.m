//
//  BaseViewController.m
//  Demo
//
//  Created by 淼视觉 on 2017/9/8.
//  Copyright © 2017年 倪大头. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createCustomNavi:@""];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)createCustomNavi:(NSString *)vcTitle {
    //导航栏
    UIView *customNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 64)];
    customNavi.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:customNavi];
    
    UILabel *vcTitleLabel = [[UILabel alloc]init];
    vcTitleLabel.text = vcTitle;
    vcTitleLabel.textColor = [UIColor colorWithHexString:@"#333333" alpha:1];
    vcTitleLabel.font = [UIFont fontWithName:LightFont size:18];
    [vcTitleLabel sizeToFit];
    vcTitleLabel.center = CGPointMake(customNavi.frame.size.width/2, 20+44/2);
    [self.view addSubview:vcTitleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 50, 44);
    [backBtn addTarget:self action:@selector(backPre) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"arrow-left"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
}

- (void)backPre {
    [self.navigationController popViewControllerAnimated:YES];
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
