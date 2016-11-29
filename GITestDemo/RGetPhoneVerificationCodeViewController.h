//
//  RGetPhoneVerificationCodeViewController.h
//  GITestDemo
//
//  Created by 吴狄 on 15/6/4.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface RGetPhoneVerificationCodeViewController  : RootViewController
@property (strong, nonatomic) IBOutlet UITextField *phoneNo;
@property (strong, nonatomic) IBOutlet UILabel *getVerLabel;
@property (strong, nonatomic) IBOutlet UIButton *getVerBtn;
@property (strong, nonatomic) IBOutlet UITextField *verificationCode;

@end
