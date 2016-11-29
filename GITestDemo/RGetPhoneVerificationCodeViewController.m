//
//  RGetPhoneVerificationCodeViewController.m
//  GITestDemo
//
//  Created by 吴狄 on 15/6/4.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import "RGetPhoneVerificationCodeViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "VerifyCodeViewController.h"
#import "LPPopup.h"
@interface RGetPhoneVerificationCodeViewController ()
@property (weak, nonatomic) IBOutlet UIView *yanzhengchaoshiView;

@end

@implementation RGetPhoneVerificationCodeViewController{
    NSTimer *_timer;
    int seconds;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    //self.phoneNo.
    //[self.phoneNo becomeFirstResponder];
    self.yanzhengchaoshiView.layer.borderColor = [[UIColor blueColor] CGColor];
    self.yanzhengchaoshiView.layer.borderWidth = 1;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.yanzhengchaoshiView.hidden = YES;
}


//获取手机验证码
- (IBAction)getPhoneVerificationCode:(id)sender {
    
    [self.view endEditing:YES];
    
    self.yanzhengchaoshiView.hidden = YES;
    
    NSString *phoneNo = self.phoneNo.text;
    
    if (![self checkPhoneNo:phoneNo]) {
        NSLog(@"The phoneNo is invalid");
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的手机号" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        
        
        [alertView show];
        
        return;
        
    }
    
//    if (DEBUG) {
//        [self performSegueWithIdentifier:@"GetPinToVerify" sender:self];
//        return;
//    }
    
    [self showHUD:@"正在获取"];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/MposApp/queryCodePwd.action?phone=%@",kServerIP,kServerPort,phoneNo];
    NSLog(@"url:%@",url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"json:%@",responseObject);
        
        int code = [responseObject[@"resultMap"][@"code"] intValue];
        
        [self hideHUD];
        
        //获取成功
        if (code == 0) {
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self performSegueWithIdentifier:@"GetPinToVerify" sender:self];
//            });
            [self startCountDown];
        }else{
            
            [self showTipView:responseObject[@"resultMap"][@"msg"]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self hideHUD];
        NSLog(@"failure");
        [self showTipView:@"获取失败"];
        
    }];
    
 
    
}


- (void)startCountDown{
    seconds  = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTime) userInfo:nil repeats:YES];
    [_timer fire];
}

-(void)showTime{
    
    if(seconds == 0){
        [_timer invalidate];
        self.getVerLabel.text = @"重新获取";
        self.getVerBtn.enabled = YES;
        //self.getVerLabel.enabled = YES;
        self.getVerLabel.textColor = [UIColor whiteColor];
    }else{
        
        [self.getVerBtn setEnabled:NO];
        self.getVerLabel.textColor = [UIColor redColor];
        //[self.getVerLabel setEnabled:NO];
        self.getVerLabel.text = [[NSString alloc]initWithFormat:@"%ds",--seconds];
        
    }
    
    
    
}


//提交服务器验证
- (IBAction)submit:(id)sender {
    
    if (DEBUG) {
        [[NSUserDefaults standardUserDefaults] setObject:self.phoneNo.text forKey:kSignUpPhoneNo];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"VerifyToRecover" sender:self];
        return;
    }
    
    [self.view endEditing:YES];
    
    if ([self.verificationCode.text isEqualToString:@""]) {
        [self showTipView:@"请输入您收到的短信验证码"];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/MposApp/checkAuthCode.action",kServerIP,kServerPort];
    NSLog(@"url:%@",url);
    NSDictionary *parameters = @{@"phone":self.phoneNo.text,@"authCode":self.verificationCode.text};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    [self showHUD:@"正在提交验证"];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        int code = [responseObject[@"resultMap"][@"code"] intValue];
        
        
        [self hideHUD];
        
        
        if(code == 0){
            
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneNo.text forKey:kSignUpPhoneNo];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self performSegueWithIdentifier:@"VerifyToRecover" sender:self];
            
        }else{
            
            if ([responseObject[@"resultMap"][@"msg"] isEqualToString:@"验证码失效，请重新获取短信验证码！"]) {
                self.yanzhengchaoshiView.hidden = NO;
            }else{
                
                
                [self showTipView:responseObject[@"resultMap"][@"msg"]];
            }
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHUD];
        NSLog(@"failure");
        [self showTipView:@"验证失败"];
    }];
    
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue
sender:(id)sender{
    
    
    if ([segue.identifier isEqualToString:@"GetPinToVerify"]) {
        //VerifyCodeViewController *vcvc = segue.destinationViewController;
    }
}



- (BOOL)checkPhoneNo:(NSString *)str{
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,2,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    return isMatch;
}


@end