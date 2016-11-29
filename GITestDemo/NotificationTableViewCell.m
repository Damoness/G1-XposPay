//
//  NotificationTableViewCell.m
//  GITestDemo
//
//  Created by wd on 16/5/24.
//  Copyright © 2016年 Kyson. All rights reserved.
//

#import "NotificationTableViewCell.h"


@implementation NotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(NotificationModel *)model{
    
    if (_model!=model) {
        
        _model = model;
        
        self.notificationTitleLabel.text = model.title;
        self.notificationContentLabel.text = model.content;
        self.notificationTimeLabel.text = model.time;
        
        
        if ([model.readType isEqualToString:@"0"]) {
            
            self.notificationReadType.backgroundColor = [UIColor redColor];
            
        }else{
            
            
            self.notificationReadType.backgroundColor = [UIColor whiteColor];
            
        }
        
        
        
    }
    
    
    
}

@end
