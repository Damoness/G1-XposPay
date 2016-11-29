//
//  VerifyCodeViewController.m
//  GITestDemo
//
//  Created by 吴狄 on 15/5/11.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import "VerifyCodeViewController.h"
#import "GetPhoneVerificationCodeViewController.h"
#import "AFNetworking.h"
#import "xieyiView.h"
#import "SetPwdViewController.h"

@interface VerifyCodeViewController ()<xieyiViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) xieyiView *xieyiView;
@property (nonatomic, strong) SetPwdViewController *setPwdVc;
@property (weak, nonatomic) IBOutlet UIView *yanzhengchaoshiView;
@property (nonatomic, assign) BOOL isSelected;
@end


@implementation VerifyCodeViewController
{
 
    NSTimer *_timer;
    int seconds;
}

-(void)viewDidLoad{

    [super viewDidLoad];
    
    GetPhoneVerificationCodeViewController *gpvcc = self.navigationController.viewControllers[0];
    
    self.phoneNo.text = gpvcc.phoneNo.text;
    self.phoneNo.delegate = self;
    
    [self.selectedButton setBackgroundImage:[UIImage imageNamed:@"wxz.jpg"] forState:(UIControlStateNormal)];
    self.selectedButton.backgroundColor = [UIColor redColor];

    _isSelected = NO;
    [self.verificationCode becomeFirstResponder];
#warning 修改 隐藏获取验证码
//    self.huoquBtn.hidden = YES;
//    self.yanzhengchaoshiView.hidden = YES;
//    self.verificationCode.hidden = YES;
//    
    
    
    [self setUpNavgation];
    
    [self.huoquBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
    self.huoquBtn.backgroundColor = KMyBlueColor;
    [self.huoquBtn addTarget:self action:@selector(huoquYanZhengBTNChick) forControlEvents:UIControlEventTouchUpInside];
    self.tijiaoBtn.backgroundColor = KMyBlueColor;
    
    
    self.yanzhengchaoshiView.layer.borderWidth = 1;
    self.yanzhengchaoshiView.layer.borderColor = [[UIColor blueColor] CGColor];
    //    [self startCountDown];
    
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.phoneNo becomeFirstResponder];
    self.yanzhengchaoshiView.hidden = YES;
}

- (void)setUpNavgation{
    
    self.navigationController.navigationBar.barTintColor = KMyBlueColor;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"请填写手机号";
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;

    
}

- (void)startCountDown{
    seconds  = 180;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTime) userInfo:nil repeats:YES];
    [_timer fire];
}


- (IBAction)selectedButtonAction:(UIButton *)sender {
    
    if (_isSelected == NO)
    {
        _isSelected = YES;
        self.selectedButton.backgroundColor = [UIColor blueColor];

        [self.selectedButton setBackgroundImage:[UIImage imageNamed:@"xz.jpg"] forState:(UIControlStateNormal)];

    }else
    {
        _isSelected = NO;
        self.selectedButton.backgroundColor = [UIColor redColor];
        [self.selectedButton setBackgroundImage:[UIImage imageNamed:@"wxz.jpg"] forState:(UIControlStateNormal)];

    }
    
}

- (IBAction)xieyiBtnChick:(id)sender {
    
    [self.view endEditing:YES];
    
    UIView *coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    coverView.backgroundColor = [UIColor lightGrayColor];
    coverView.alpha = 0.5;
    self.coverView = coverView;
    [self.view addSubview:coverView];
    
    xieyiView *xieyi = [[xieyiView alloc] init];
    
    xieyi.size = CGSizeMake(280, 350);
    xieyi.center = self.view.center;
    
    xieyi.delegate = self;
    self.xieyiView = xieyi;
    [self.view addSubview:xieyi];
    
}

- (void)huoquYanZhengBTNChick{
    
    self.yanzhengchaoshiView.hidden = YES;
    
    NSString *phoneNo = self.phoneNo.text;
    
    if (![self checkPhoneNo:phoneNo]) {
        NSLog(@"The phoneNo is invalid");
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请输入正确的手机号" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        
        
        [alertView show];
        
        return;
        
    }
    
    if ([self.huoquBtn.titleLabel.text isEqualToString:@"获取短信验证码"]) {
        
        [self getPhoneVerificationCode:nil];
    }else{
        
        [self getVerCode:nil];
    }
}


//重新获取手机验证码
- (void)getVerCode:(UIButton *)sender {
    
    [self.view endEditing:YES];

    [self showHUD:@"正在获取"];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/MposApp/queryAuthCode.action?phone=%@",kServerIP,kServerPort,self.phoneNo.text];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"json:%@",responseObject);
        
        int code = [responseObject[@"resultMap"][@"code"] intValue];
        
        [self hideHUD];
        
        
        if (code == 0) {
            
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

//提交服务器验证
- (IBAction)submit:(id)sender {
    
    if (DEBUG) {
        [[NSUserDefaults standardUserDefaults] setObject:self.phoneNo.text forKey:kSignUpPhoneNo];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        [self performSegueWithIdentifier:@"VerifyToSignup" sender:self];
        SetPwdViewController *setPwdVc = [[SetPwdViewController alloc] init];
        self.setPwdVc = setPwdVc;
        [self.navigationController pushViewController:setPwdVc animated:YES];
        return;
    }
    
    [self.view endEditing:YES];
    if (self.phoneNo.text.length < 11) {
        [self showTipView:@"请输入正确的手机号"];
        return;
    }
    
    if (self.selectedButton.backgroundColor == [UIColor redColor]) {
        [self showTipView:@"请同意《立得支付Xpos服务协议》"];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.phoneNo.text forKey:kSignUpPhoneNo];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    SetPwdViewController *setPwdVc = [[SetPwdViewController alloc] init];
//    self.setPwdVc = setPwdVc;
//    [self.navigationController pushViewController:setPwdVc animated:YES];
    
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
        
//                        [self performSegueWithIdentifier:@"VerifyToSignup" sender:self];
                        SetPwdViewController *setPwdVc = [[SetPwdViewController alloc] init];
                        self.setPwdVc = setPwdVc;
                        [self.navigationController pushViewController:setPwdVc animated:YES];
                        
                    }else{
                        
//                        NSLog(@"+++++++%@",responseObject);
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

-(void)showTime{
    
    if(seconds == 0){
        [_timer invalidate];
        //        self.getVerCodeLabel.text = @"重新获取";
        //        self.getVerCodeBtn.enabled = YES;
        [self.huoquBtn setTitle:@"重新获取短信验证码" forState:UIControlStateNormal];
        self.huoquBtn.enabled = YES;
        //        self.getVerCodeLabel.enabled = YES;
    }else{
        
        //        [self.getVerCodeBtn setEnabled:NO];
        //        [self.getVerCodeLabel setEnabled:NO];
        //        self.getVerCodeLabel.text = [[NSString alloc]initWithFormat:@"(%d秒)重新获取",--seconds];
        [self.huoquBtn setEnabled:NO];
        [self.huoquBtn setTitle:[NSString stringWithFormat:@"%ds",--seconds] forState:UIControlStateNormal];
        
    }
    
    
    
}


- (void)getPhoneVerificationCode:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *phoneNo = self.phoneNo.text;
    
    
    
    [self showHUD:@"正在获取"];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/MposApp/queryAuthCode.action?phone=%@",kServerIP,kServerPort,phoneNo];
    NSLog(@"url:%@",url);
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"json:%@",responseObject);
        
        int code = [responseObject[@"resultMap"][@"code"] intValue];
        
        [self hideHUD];
        
        //返回就跳转到下个界面
        if (code == 0) {
            
            [self showTipView:@"获取成功，请稍后"];
            [self startCountDown];
            
        }else{
            
            NSLog(@"json:%@",responseObject);
            
            [self showTipView:responseObject[@"resultMap"][@"msg"]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self hideHUD];
        NSLog(@"failure");
        [self showTipView:@"获取失败"];
        
    }];
    
    
    
    
}

- (BOOL)checkPhoneNo:(NSString *)str{
    
    NSString *regex = @"^1\\d{10}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
    
    return isMatch;
}

#pragma mark - xieyiView的代理方法
- (void)xieyiViewCancleBtnChick{
    
    [self.coverView removeFromSuperview];
    [self.xieyiView removeFromSuperview];
}

#pragma mark - textField的代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.location > 10) {
        return NO;
    }else{
        
        return YES;
    }
}


@end
