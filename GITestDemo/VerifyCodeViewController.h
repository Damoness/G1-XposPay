//
//  VerifyCodeViewController.h
//  GITestDemo
//
//  Created by 吴狄 on 15/5/11.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface VerifyCodeViewController : RootViewController
//@property (strong, nonatomic) IBOutlet UILabel *phoneNo;

@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@property (weak, nonatomic) IBOutlet UITextField *phoneNo;
@property (weak, nonatomic) IBOutlet UIButton *huoquBtn;
@property (weak, nonatomic) IBOutlet UIButton *xieyiBtn;
@property (weak, nonatomic) IBOutlet UIButton *tijiaoBtn;

@property (strong, nonatomic) IBOutlet UITextField *verificationCode;
//@property (strong, nonatomic) IBOutlet UIButton *getVerCodeBtn;
//
//@property (strong, nonatomic) IBOutlet UILabel *getVerCodeLabel;



@end
