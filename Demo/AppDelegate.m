//
//  AppDelegate.m
//  Demo
//
//  Created by 淼视觉 on 2017/9/8.
//  Copyright © 2017年 倪大头. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "QRCodeViewController.h"
#import "RecordingViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    TabBarController *tabBarController;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    tabBarController = [[TabBarController alloc]init];
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    
    [self setup3DTouch:application];//3D Touch调用
    
    return YES;
}

- (void)setup3DTouch:(UIApplication *)application {
    /*
     type 该item 唯一标识符
     localizedTitle ：标题
     localizedSubtitle：副标题
     icon：icon图标 可以使用系统类型 也可以使用自定义的图片
     userInfo：用户信息字典 自定义参数，完成具体功能需求
     */
    UIApplicationShortcutIcon *QRCodeIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCapturePhoto];
    UIApplicationShortcutItem *QRCodeItem = [[UIApplicationShortcutItem alloc]initWithType:@"QRCode" localizedTitle:@"扫码" localizedSubtitle:@"" icon:QRCodeIcon userInfo:nil];
    
    UIApplicationShortcutIcon *recordingIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypePlay];
    UIApplicationShortcutItem *recordingItem = [[UIApplicationShortcutItem alloc]initWithType:@"Recording" localizedTitle:@"录音" localizedSubtitle:@"" icon:recordingIcon userInfo:nil];
    
    //将items添加到app图标
    application.shortcutItems = @[QRCodeItem,recordingItem];
}

//图标3DTouch回调
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    UINavigationController *nav = (UINavigationController *)tabBarController.selectedViewController;
    if ([shortcutItem.type isEqualToString:@"QRCode"]) {
        QRCodeViewController *qrvc = [[QRCodeViewController alloc]init];
        qrvc.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:qrvc animated:YES];
    }else if ([shortcutItem.type isEqualToString:@"Recording"]) {
        RecordingViewController *recordvc = [[RecordingViewController alloc]init];
        recordvc.hidesBottomBarWhenPushed = YES;
        [nav pushViewController:recordvc animated:YES];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
