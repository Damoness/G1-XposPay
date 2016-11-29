//
//  RNewPasswordViewController.m
//  GITestDemo
//
//  Created by 吴狄 on 15/6/5.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import "RNewPasswordViewController.h"
#import "AFNetworking.h"
#import "UIUtils.h"
@interface RNewPasswordViewController ()

@end

@implementation RNewPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.st addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    self.pView.layer.borderWidth = 1;
    self.pView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.pTextField.delegate = self;
    self.pTextField.tag = 1;
    
    
    self.rView.layer.borderWidth =1;
    self.rView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.rTextField.delegate = self;
    self.rTextField.tag = 2;
    
}

-(void)switchAction: (UISwitch *) st{
    self.pTextField.secureTextEntry = !st.on;
    self.rTextField.secureTextEntry = !st.on;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submit:(id)sender {
//    AFHTTPRequestOperation *
    
    
//    if (![UIUtils isCorrectPassword:self.pTextField.text] || ![UIUtils isCorrectPassword:self.rTextField.text]||![self.pTextField.text isEqualToString:self.rTextField.text]) {
//        [self showTipView:@"请输入正确的密码"];
//        return;
//    }
    
    if (self.pTextField.text.length == 0) {
        [self showTipView:@"密码不能为空"];
        return;
    }
    
    if (![self.rTextField.text isEqualToString: self.pTextField.text]) {
        [self showTipView:@"两次输入的密码不一致"];
        return;
    }
    
    [self.view endEditing:YES];
    
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/MposApp/updatePwd.action",kServerIP,kServerPort];
    NSLog(@"url:%@",url);
    self.phoneNo = [[NSUserDefaults standardUserDefaults] stringForKey:kSignUpPhoneNo];
    //self.phoneNo = @"13202264038";
    NSDictionary *parameters = @{@"phone":self.phoneNo,@"passwd":self.rTextField.text};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSLog(@"parameters:%@",parameters);
    
    [self showHUD:@"正在提交修改"];
    
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        int code = [responseObject[@"resultMap"][@"code"] intValue];
        
        NSLog(@"responseObject:%@",responseObject);
        [self hideHUD];

        
        if (code == 0) {
        
            [self performSegueWithIdentifier:@"suceess" sender:self];
            
            //[self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            [self showTipView:responseObject[@"resultMap"][@"msg"]];
        }
        
        
  
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHUD];
        NSLog(@"failure");
        [self showTipView:@"验证失败"];
    }];
}



-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 1) {
        if ([UIUtils isCorrectPassword:self.pTextField.text]) {
            self.pImage.image = [UIImage imageNamed:@"k8cg"];
            self.pImage.hidden = false;
        }else{
            self.pImage.hidden = false;
            self.pImage.image = [UIImage imageNamed:@"k8sb"];
        }
    }else{
        

        if (![self.rTextField.text isEqualToString:@""]&&[self.rTextField.text isEqualToString:self.pTextField.text]) {
            self.rImage.image = [UIImage imageNamed:@"k8cg"];
            self.rImage.hidden = false;
            self.errorLabel.hidden = true;
        }else{
            self.rImage.hidden = false;
            self.rImage.image = [UIImage imageNamed:@"k8sb"];
            self.errorLabel.hidden = false;
            self.rTextField.text = @"";
        }
        
    }
    
    
    
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.errorLabel.hidden = YES;
    
    if (textField.tag ==1) {
        self.rImage.hidden = YES;
        self.pImage.hidden = YES;
    }else{
        self.rImage.hidden = YES;
    }
    
    
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
