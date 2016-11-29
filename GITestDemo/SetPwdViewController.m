//
//  SetPwdViewController.m
//  GITestDemo
//
//  Created by WS on 15/10/11.
//  Copyright © 2015年 Kyson. All rights reserved.
//

#import "SetPwdViewController.h"
#import "ZhuCeInfoController.h"

@interface SetPwdViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UIView *rePwdView;
@property (weak, nonatomic) IBOutlet UITextField *rePwdTextField;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIImageView *pwdImageV;
@property (weak, nonatomic) IBOutlet UIImageView *rePwdImageV;

@property (weak, nonatomic) IBOutlet UILabel *waringLabel;


@property (nonatomic, strong) ZhuCeInfoController *zhuceVc;

@end

@implementation SetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setOneViewBorderWith:self.pwdView];
    [self setOneViewBorderWith:self.rePwdView];
    [self setUpNavgation];
    
    self.nextBtn.backgroundColor = KMyBlueColor;
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    self.pwdTextField.delegate = self;
    self.pwdTextField.tag = 1;
    
    self.rePwdTextField.delegate = self;
    self.rePwdTextField.tag = 2;
    
    [self loadHistory];
}

//- (void)viewWillAppear:(BOOL)animated{
//    
//    [super viewWillAppear:animated];
//    
//}

- (void)loadHistory{
    NSLog(@"=======%@", [KUserDefault objectForKey:kSignUpPhoneNo]);
    
    self.pwdTextField.text = [KUserDefault objectForKey:KPassword];
}

- (void)setOneViewBorderWith:(UIView *)view{
    
    
    view.layer.borderWidth = 1;
    view.layer.borderColor = [[UIColor lightGrayColor] CGColor];

}

- (void)setUpNavgation{
    
    UIButton *backButton =[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton setImage:[UIImage imageNamed:@"ht"] forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"输入密码";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;

}

//- (void)setUptextFieldWith:(UITextField *)textField{
//    
//    textField.delegate = self;
//    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jycg"]];
//
//    textField.leftView = imageV;
//}

- (void)next{
    
    [self.view endEditing:YES];
    
    if (DEBUG) {
        ZhuCeInfoController *zhuceVc = [[ZhuCeInfoController alloc] init];
        self.zhuceVc = zhuceVc;
        [self.navigationController pushViewController:zhuceVc animated:YES];

    }
    
    if (self.pwdTextField.text.length == 0) {
        
        [self showTipView:@"请输入密码"];
        return;
    }
    if (![self.pwdTextField.text isEqualToString:self.rePwdTextField.text]) {
        self.rePwdImageV.image = [UIImage imageNamed:@"jysb"];
        self.rePwdImageV.hidden = NO;
        self.waringLabel.hidden = NO;
        self.rePwdTextField.text = @"";
        return;
    }
    
    ZhuCeInfoController *zhuceVc = [[ZhuCeInfoController alloc] init];
    self.zhuceVc = zhuceVc;
    [self.navigationController pushViewController:zhuceVc animated:YES];
    
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}


#pragma mark - textField的代理方法
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 1) {
        self.pwdImageV.hidden = NO;
        
        
    }else{
        
        if ([self.pwdTextField.text isEqualToString:self.rePwdTextField.text]) {
            
            self.rePwdImageV.image = [UIImage imageNamed:@"jycg"];
            self.waringLabel.hidden = YES;
            [KUserDefault setObject:self.pwdTextField.text forKey:KPassword];
            [KUserDefault synchronize];
        }else{
            
            self.rePwdImageV.image = [UIImage imageNamed:@"jysb"];
            self.waringLabel.hidden = NO;
            self.rePwdTextField.text = @"";
        }
        self.rePwdImageV.hidden = NO;
        
    }
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 2) {
        self.waringLabel.hidden = YES;
    }
    return YES;
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
