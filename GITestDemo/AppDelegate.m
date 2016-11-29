//
//  AppDelegate.m
//  GITestDemo
//
//  Created by Femto03 on 14/11/25.
//  Copyright (c) 2014年 Kyson. All rights reserved.
//

#import "AppDelegate.h"
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>
#include "MiniPosSDK.h"
#include "BLEDriver.h"
#import "JPUSHService.h"
#import "NotificationModel.h"
#import "NotificationDetailViewController.h"
@interface AppDelegate ()<UIAlertViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //sleep(1);
    //[[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];
    _quanjuQianDaoType = 0;
    
    searchDevices = [NSMutableArray array];

    
    //启动基本SDK
    [[PgyManager sharedPgyManager] startManagerWithAppId:kPgyerAppID];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kPgyerAppID];
    
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    
    
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        [JPUSHService registerForRemoteNotificationTypes:( UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
        
    }else{
        
        [JPUSHService registerForRemoteNotificationTypes:( UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert ) categories:nil];
        
    }
    
    
    [JPUSHService setupWithOption:launchOptions appKey:@"22dc28ac57044cf3b679958f" channel:@"Publish channel" apsForProduction:YES];
    
    
    
    //firstNavi
    UINavigationController *nc  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"firstNavi"];

        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
         self.window=window;
        [self.window makeKeyAndVisible];
    
        self.window.rootViewController = nc;
    
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (userInfo) {

        [self handlePushNotify:userInfo];
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    return YES;
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required -    DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    
    NSLog(@"%@",userInfo);
    if (application.applicationState != UIApplicationStateActive) {
        [self handlePushNotify:userInfo];
    }
    
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService handleRemoteNotification:userInfo];
}

// 自己写的一个方法，用于统一处理通过push通知启动的情况
- (void)handlePushNotify:(NSDictionary *)userInfo {
    NotificationModel *model = [[NotificationModel alloc]init];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter stringFromDate:[NSDate date]];
    
    model.content = userInfo[@"aps"][@"alert"];
    model.time = [dateFormatter stringFromDate:[NSDate date]];
    
    UINavigationController *nc  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NotificationDetailViewController"];
    NotificationDetailViewController *ndvc =   nc.topViewController;
    ndvc.model = model;
    
    
    UIViewController *vc =   self.window.rootViewController;
    
    [vc presentViewController:nc animated:YES completion:nil];
}


//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    
//    // IOS 7 Support Required
//    [JPUSHService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//}






- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    //UIApplicationLaunchOptionsRemoteNotificationKey
}



- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error
          );
}




-(void)versionButton {
    //获取发布版本的Version
    NSString *string = [NSString stringWithContentsOfURL:[ NSURL URLWithString:[NSString stringWithFormat:@"http://%@/app/yuanzhen/IOS/XPOS/IOS_XPOS_Version.json", kBanBenDieDai]] encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"===============%@", string);
    if (string !=  nil && [string length] > 0 && [string rangeOfString:@"version"].length == 7) {
        [self checkAppUpdate:string];
    }
    
}

-(void)checkAppUpdate:(NSString *)appInfo {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *appInfo1 = [appInfo substringFromIndex:[appInfo rangeOfString:@"\"version\":"].location +10];
        appInfo1 = [[appInfo1 substringToIndex:[appInfo1 rangeOfString:@","].location] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    if (![appInfo1 isEqualToString:version]) {
        NSLog(@"新版本%@====当前版本%@", appInfo1, version);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"新版本 %@ 已发布", appInfo1] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        alert.delegate = self;
        [alert addButtonWithTitle:@"前往更新"];
        [alert show];
        alert.tag = 20;
        
        
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"已是最高版本" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 & alertView.tag == 20) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/app/yuanzhen/IOS/XPOS/IOS_XPOS_Version.json", kBanBenDieDai]]];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"===============%@", dic);
        NSString *str = dic[@"downloadUrl"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
        
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
