//
//  BaseViewController.h
//  Demo
//
//  Created by 淼视觉 on 2017/9/8.
//  Copyright © 2017年 倪大头. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

- (void)createCustomNavi:(NSString *)vcTitle;//自定义导航栏

@end
