//
//  NotificationViewModel.h
//  GITestDemo
//
//  Created by wd on 16/5/24.
//  Copyright © 2016年 Kyson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationViewModel : NSObject


typedef void (^success)(id response);

typedef void (^failure)(NSError *error);



+(void)getNotificationListByUserId:(NSString *)userId
                     success:(success)success
                     failure:(failure)failure;


+(void)updateNotificationStatusByUserId:(NSString *)userId
                                 newsId:(NSString *)newsId
                                success:(success)success
                                failure:(failure)failure;

@end
