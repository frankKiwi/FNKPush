//
//  DreamPush.m
//  HuoGameBox
//
//  Created by LWW on 2019/4/20.
//  Copyright © 2019 huosdk. All rights reserved.
//

#import "DreamPush.h"
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
@interface DreamPush()<UNUserNotificationCenterDelegate,JPUSHRegisterDelegate>
@end
@implementation DreamPush

+ (instancetype)PushManager{
    static DreamPush *weaver;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weaver = [[DreamPush alloc] init];
    });
    return weaver;
}

- (id)init{
    if ([super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationWillResignActiveNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)
                                                     name:UIApplicationWillEnterForegroundNotification object:nil];
        
    }
    return self;
}
- (void)initConfigwithJpushKey:(NSString *)key withlaunchOptions:(NSDictionary*)launchOptions{
    [self initPush:launchOptions withPush:key];
 }
- (void)initPush:(NSDictionary*)launchOptions withPush:(NSString *)jpushKey{
    
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }else{
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:jpushKey
                          channel:@""
                 apsForProduction:YES
            advertisingIdentifier:nil];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
}






- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
    
    if ([JPUSHService registrationID].length > 0)
    {
        NSString *newToken = [NSString stringWithFormat:@"[JPUSHService registrationID] == %@",[JPUSHService registrationID]];
        if (newToken.length == 0)
        {
            return;
        }
        
    }
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}


@end
