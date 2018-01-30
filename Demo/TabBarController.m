//
//  TabBarController.m
//  Demo
//
//  Created by 淼视觉 on 2017/9/8.
//  Copyright © 2017年 倪大头. All rights reserved.
//

#import "TabBarController.h"
#import "HomeViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController
{
    UINavigationController *navi1;
    UINavigationController *navi2;
    UINavigationController *navi3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTabBar];
}

- (void)createTabBar {
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    navi1 = [[UINavigationController alloc]initWithRootViewController:homeVC];
    navi1.tabBarItem.title = @"Demo";
    
    NSArray *controllers =[NSArray arrayWithObjects:navi1, nil];
    self.viewControllers = controllers;
    self.selectedIndex = 0;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    NSArray *tabArray = [NSArray arrayWithObjects:@"主页icon", nil];
    NSArray *tabSelectArray =[NSMutableArray arrayWithObjects: @"主页icon", nil];
    
    for (int i = 0; i < controllers.count; i++) {
        UINavigationController *vc = [controllers objectAtIndex:i];
        [vc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [UIFont systemFontOfSize:kScaleY*10], NSFontAttributeName,
                                               nil] forState:UIControlStateNormal];
        [vc.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:kScaleY*6], NSFontAttributeName, nil]];
        vc.tabBarItem.image = [[UIImage imageNamed:tabArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:tabSelectArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
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
