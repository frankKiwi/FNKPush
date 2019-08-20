//
//  DreamPush.h
//  HuoGameBox
//
//  Created by LWW on 2019/4/20.
//  Copyright © 2019 huosdk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DreamPush : NSObject
+ (instancetype)PushManager;
- (void)initConfigwithJpushKey:(NSString *)key withlaunchOptions:(NSDictionary*)launchOptions;
@end

NS_ASSUME_NONNULL_END
