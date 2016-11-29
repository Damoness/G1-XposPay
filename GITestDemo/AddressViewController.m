//
//  AddressViewController.m
//  GITestDemo
//
//  Created by WS on 15/10/12.
//  Copyright © 2015年 Kyson. All rights reserved.
//

#import "AddressViewController.h"
#import "WDPickView.h"
#import "ConnectDeviceViewController.h"
#import "ZhangHuInfoViewController.h"

@interface AddressViewController ()<WDPickViewDelegate,UITextFieldDelegate>
//@property (weak, nonatomic) IBOutlet UIButton *suozaishengBtn;
//@property (weak, nonatomic) IBOutlet UIButton *suozaishiBtn;
@property (weak, nonatomic) IBOutlet UITextField *suozaishengTextField;
@property (weak, nonatomic) IBOutlet UITextField *suizaishiTextField;
@property (weak, nonatomic) IBOutlet UITextField *suozaijiedaoTextField;

@property (weak, nonatomic) IBOutlet UILabel *SNLabel;
@property (weak, nonatomic) IBOutlet UIButton *GetSnBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *HowToGetSn;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBorder];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"填写位置信息";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;

    self.HowToGetSn.numberOfLines = 0;
    self.HowToGetSn.hidden = YES;
    
    [self.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextBtn setBackgroundColor:KMyBlueColor];
    [self.nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    
    WDPickView *pickView = [[WDPickView alloc]initPickViewWithPlistName:@"Address"];
    pickView.delegate = self;
    self.suozaishengTextField.inputView = pickView;
    self.suizaishiTextField.inputView = pickView;
    
    self.suozaijiedaoTextField.delegate = self;
    
    self.suozaishengTextField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xla"]];
    self.suizaishiTextField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xla"]];
    self.suozaishengTextField.rightViewMode = UITextFieldViewModeAlways;
    self.suizaishiTextField.rightViewMode = UITextFieldViewModeAlways;
    
    [self initBLESDK];
    
    [self loadHistory];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.SNLabel.text = [KUserDefault objectForKey:kMposG1SN];
}

- (void)loadHistory{
    
    NSString *shengfen = [KUserDefault objectForKey:Ksuozaisheng];
    NSString *shi = [KUserDefault objectForKey:Ksuozaishi];
    self.suozaishengTextField.text = shengfen;
    self.suizaishiTextField.text = shi;
    
    NSString *suozaijiedao = [KUserDefault objectForKey:KsuozaiJiedao];
    self.suozaijiedaoTextField.text = suozaijiedao;
    
    self.SNLabel.text = [KUserDefault objectForKey:kMposG1SN];
}
- (IBAction)help:(id)sender {
    
    self.HowToGetSn.hidden = NO;
}

- (void)setBorder{
    

    [self setOneBorderWithView:self.SNLabel];
}

- (void)setOneBorderWithView:(UIView *)view{
    
    view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    view.layer.borderWidth = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)GetSn:(id)sender {
    
    
    if(MiniPosSDKDeviceState()<0){
        
        
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"设备未连接" message:@"点击跳转设备连接界面" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        
        [alert1 show];
        
        return;
    }
    
    
    MiniPosSDKGetDeviceInfoCMD();
}

- (void)next{
    
    if (self.suozaishengTextField.text.length == 0 || self.suizaishiTextField.text.length == 0) {
        [self showTipView:@"请选择城市"];
        return;
    }
    if (self.suozaijiedaoTextField.text.length == 0) {
        [self showTipView:@"请填写街道信息"];
        return;
    }
    if (self.SNLabel.text.length == 0) {
        [self showTipView:@"请获取SN号"];
        return;
    }
    
    ZhangHuInfoViewController *zhanghuVC = [[ZhangHuInfoViewController alloc] init];
    [self.navigationController pushViewController:zhanghuVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark - WDPickView的代理方法
- (void)toolBarDoneBtnHaveClicked:(WDPickView *)pickView resultString:(NSString *)resultString shengfen:(NSString *)shengfen{

    self.suizaishiTextField.text = [resultString substringToIndex:[resultString length] -5];
    NSString *areaCode  = [resultString substringFromIndex:[resultString length] -4];
    self.suozaishengTextField.text = shengfen;
    [KUserDefault setObject:shengfen forKey:Ksuozaisheng];
    [KUserDefault setObject:self.suizaishiTextField.text forKey:Ksuozaishi];
    [KUserDefault setObject:areaCode forKey:Ksuozaidibianma];
    [KUserDefault synchronize];

    
//    为了解决跳转时，如果焦点停留在所在地区上，奔溃的bug
    [self.view endEditing:YES];
    
}

#pragma mark - textField的代理方法
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [KUserDefault setObject:textField.text forKey:KsuozaiJiedao];
    [KUserDefault synchronize];
}


#pragma mark - mpos的回调方法{

- (void)recvMiniPosSDKStatus{
    [super recvMiniPosSDKStatus];
    
    if ([self.statusStr isEqualToString:@"获取设备信息成功"]) {
        
        NSString *sn = [NSString stringWithFormat:@"%s",MiniPosSDKGetDeviceID()];
//        self.sn.text = sn;
        self.SNLabel.text = sn;
        
        [[NSUserDefaults standardUserDefaults] setObject:sn forKey:kMposG1SN];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
#pragma mark - alertView的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        
        UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ConnectDeviceViewController *cdvc = [mainStory instantiateViewControllerWithIdentifier:@"CD"];
        [self.navigationController pushViewController:cdvc animated:YES];
        
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
