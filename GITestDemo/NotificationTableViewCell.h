//
//  NotificationTableViewCell.h
//  GITestDemo
//
//  Created by wd on 16/5/24.
//  Copyright © 2016年 Kyson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationModel.h"
@interface NotificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *notificationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *notificationTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *notificationReadType;

@property (strong,nonatomic)NotificationModel *model;

@end
