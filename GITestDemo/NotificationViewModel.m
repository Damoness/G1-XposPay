//
//  NotificationViewModel.m
//  GITestDemo
//
//  Created by wd on 16/5/24.
//  Copyright © 2016年 Kyson. All rights reserved.
//

#import "NotificationViewModel.h"
#import "AFNetworking.h"
@implementation NotificationViewModel



+(void)getNotificationListByUserId:(NSString *)userId
                     success:(success)success
                     failure:(failure)failure{
    
    
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/PospAdmin/posp/pospternews.do?action=getPospTerNews&userId=%@",kServerIP,kServerPort,userId];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        failure(error);
        
    }];
    
    
}

+(void)updateNotificationStatusByUserId:(NSString *)userId
                                 newsId:(NSString *)newsId
                                success:(success)success
                                failure:(failure)failure{
    
    
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/PospAdmin/posp/pospternews.do?action=readNews&newsId=%@&userId=%@",kServerIP,kServerPort,newsId,userId];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        failure(error);
        
    }];
}



@end
