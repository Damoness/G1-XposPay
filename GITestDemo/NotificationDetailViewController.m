//
//  NotificationDetailViewController.m
//  GITestDemo
//
//  Created by wd on 16/5/25.
//  Copyright © 2016年 Kyson. All rights reserved.
//

#import "NotificationDetailViewController.h"
#import "NotificationViewModel.h"
#import "UIViewController+Base.h"

@interface NotificationDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation NotificationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self p_initViews];

    [self p_updateData];
    
    
}

-(void)p_updateData{
    
    
    NSString *LoginPhoneNo = [[NSUserDefaults standardUserDefaults]stringForKey:kLoginPhoneNo];
    
    
    [NotificationViewModel updateNotificationStatusByUserId:LoginPhoneNo newsId:self.model.newsId success:^(id response) {
        
    
    } failure:^(NSError *error) {
        
    
    }];
    
    
    
}

-(void)p_initViews{
    
    
    self.title  = @"消息通知";
    

    
    //self.detailLabel.text = self.model.content;
    self.detailTextView.text = self.model.content;
    self.timeLabel.text = self.model.time;
    
    
    [self setBackIcon];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
