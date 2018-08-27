//
//  AppDelegate.m
//  LTxMsg
//
//  Created by liangtong on 2018/7/23.
//  Copyright © 2018年 LTx. All rights reserved.
//

#import "AppDelegate.h"
#import "LTxCoreConfig.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [LTxCoreConfig sharedInstance].skinColor = [UIColor darkGrayColor];
    [LTxCoreConfig sharedInstance].appId = @"68fb2fd2-4abb-42f2-8b49-34a2af38b3b0";
    [LTxCoreConfig sharedInstance].userId = @"59f05ffeabfd4a0e606075c0";
    [LTxCoreConfig sharedInstance].messageHost = @"http://125.46.29.147:6004/eepj-push";
    [[LTxCoreConfig sharedInstance] appSetup];
    
    return YES;
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
