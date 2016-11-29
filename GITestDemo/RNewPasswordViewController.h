//
//  RNewPasswordViewController.h
//  GITestDemo
//
//  Created by 吴狄 on 15/6/5.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface RNewPasswordViewController : RootViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *st;

@property (strong,nonatomic) NSString *phoneNo;


@property (strong, nonatomic) IBOutlet UIView *pView;
@property (strong, nonatomic) IBOutlet UITextField *pTextField;
@property (strong, nonatomic) IBOutlet UIImageView *pImage;



@property (strong, nonatomic) IBOutlet UIView *rView;
@property (strong, nonatomic) IBOutlet UITextField *rTextField;
@property (strong, nonatomic) IBOutlet UIImageView *rImage;


@property (strong, nonatomic) IBOutlet UILabel *errorLabel;

@end
