//
//  AppDelegate.m
//  APNS1508
//
//  Created by HeHui on 16/4/29.
//  Copyright © 2016年 Hawie. All rights reserved.
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#import <AVOSCloud.h>

static NSString *const appKey = @"3d9b9665c095fc19ef94d891";
static NSString *const channel = @"1";
static BOOL const isProduct = NO;

static NSString * const LeanAppID = @"7M4o6OvNMphKJLVadBYVHRmN-gzGzoHsz";

static NSString *const LeanAppKey = @"kjrHPMKu2N3ezaxTAnu2owpe";

#define LEANCLOUD



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#ifdef LEANCLOUD
    // LeanCloud推送
    [AVOSCloud setApplicationId:LeanAppID clientKey:LeanAppKey];
    [AVOSCloud registerForRemoteNotification];
    
#else
    
    // 用极光相当于将后台与APNS通信的这块交给极光来完成

    // 让此应用注册 苹果的APNS服务 和本地通知注册一样
    
    [JPUSHService registerForRemoteNotificationTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    
    
    
    // 向极光服务器注册我们的应用，
    // 参数1： launchOptions
    // 参数2： appKey
    // 参数3： 频道  标识， 自定义的
    // 参数4： 是否是发布的版本，(测试和发布)
    
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:isProduct];
    
#endif

    return YES;
}

/** 应用程序获得devicetToken */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"deviceToken= %@",deviceToken);
    
#ifdef LEANCLOUD
    // 将deviceToken 交给LeanCloud
    [AVOSCloud handleRemoteNotificationsWithDeviceToken:deviceToken];
#else
    
    // 将deviceToken 本来应该交给 -- > 后台服务器
    // 因为是极光帮我们管理和APNS交互，所以交给极光来处理
    [JPUSHService registerDeviceToken:deviceToken];
#endif
}

/** 接受到推送消息的回调 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // ios 7 以前
    NSLog(@"接收到推送消息啦");

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"接收到推送消息啦");
    NSLog(@"userInfo = %@",userInfo);
    NSDictionary *apns = userInfo[@"aps"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:apns[@"alert"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    
    
    
    if ([userInfo[@"color"] isEqualToString:@"red"]) {
        self.window.rootViewController.view. backgroundColor = [UIColor redColor];
    }
    
    
    //
    completionHandler(UIBackgroundFetchResultNewData);
    
    
}





@end
