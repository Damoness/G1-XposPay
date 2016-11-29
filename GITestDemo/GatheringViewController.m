//
//  GatheringViewController.m
//  GITestDemo
//
//  Created by 吴狄 on 15/6/27.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import "GatheringViewController.h"
#import "WDCalculator.h"
#import "SwipingCardViewController.h"
#import "AFNetworking.h"
#import "CustomAlertView.h"
#import "ConnectDeviceViewController.h"
#import "JishiChooseController.h"
#import "AppDelegate.h"
#import "NotificationViewController.h"

@interface GatheringViewController ()<WDCalculatorDelegate>
{
    NSString *web_kernel;
    NSString *web_task;
    NSString *pos_kernel;
    NSString *pos_task;
    NSMutableArray *updateFiles;
    CustomAlertView *cav;
    

    BOOL isGetDeviceMsgAction;
    
    
    NSString *payType;

}
@property (nonatomic, strong) JishiChooseController *jishiVC;
@end

@implementation GatheringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.totalNum.text = @"0.00";
    self.showStr.text =@"0";
//    isFirstGetVersionInfo = true;
    self.isFirstGetVersionInfo = true;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccess) name:KconnectDeivesSuccess object:nil];
    
    [self p_initViews];
}


-(void)p_initViews{
    
    //UIab
    
    //UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"通知" style:UIBarButtonItemStylePlain target:self action:@selector(p_openNotification:)];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [button setTitle:@"通知" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(p_openNotification:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.tabBarController.navigationItem.rightBarButtonItem = item2;
    //self.navigationItem.rightBarButtonItem = item;
    
}

-(void)p_openNotification:(id)sender{
    
    
    NotificationViewController *notiVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    
    [self.navigationController pushViewController:notiVC animated:YES];
    
    
    
}


- (void)connectSuccess{

    [self normalConsume:nil];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KconnectDeivesSuccess object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    

    
    WDCalculator *calculator = [[WDCalculator alloc]initWithFrame:self.calculatorView.frame];
    calculator.delegate = self;
    [self.view addSubview:calculator];
    
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"支付页面";
    UIButton *btn = [[UIButton alloc] init];
//    [btn setTitle:@"222" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"ht"] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:self action:@selector(openOrCloseLeftView) forControlEvents:UIControlEventTouchUpInside];
    self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
//    UIButton *btn1 = [[UIButton alloc] init];
//    [btn1 setImage:[UIImage imageNamed:@"sjjb"] forState:UIControlStateNormal];
//    [btn1 sizeToFit];
//    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn1];

    
    MiniPosSDKInit();
    
    if (self.isFirstGetVersionInfo) {
            //获取设备信息的
        MiniPosSDKGetDeviceInfoCMD();
        //isFirstGetVersionInfo = false;
    }
    
}

- (void)openOrCloseLeftView{
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (tempAppDelegate.LeftSlideVC.closed)
    {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}


//常规消费
- (IBAction)normalConsume:(UIButton *)sender {
//    if(MiniPosSDKDeviceState()<0){
//        //[self showTipView:@"设备未连接"];
//        [self showConnectionAlert];
//        return;
//    }else{
//        if(MiniPosSDKPosLogin()>=0)
//        {
//            
//            [self showHUD:@"正在签到"];
//            
//        }
//        return;
//    }
//    
    if (self.totalNum.text.floatValue < 1 || self.totalNum.text.floatValue > 50000) {
        [self showTipView:@"常规消费区间是1~50000"];
        return;
    }
    
    if(MiniPosSDKDeviceState()<0){
        //[self showTipView:@"设备未连接"];
        
        [self showConnectionAlert];
        //[self connectLastHistoryDevice];
        return;
    }else{
        _quanjuQianDaoType = 0;
        [self verifyParamsSuccess:^{
            
            if (MiniPosSDKGetCurrentSessionType()== SESSION_POS_UNKNOWN) {
                
                int amount  = [self.totalNum.text doubleValue]*100;
                
                if (amount > 0) {
                    
                    char buf[20];
                    
                    sprintf(buf,"%012d",amount);
                    
                    NSLog(@"amount: %s",buf);
                    
                    
                    _type = 1;
                    
                        //sdk的消费方法
                    MiniPosSDKSaleTradeCMD(buf, NULL,"1");
                    self.totalNum.text = @"0.00";
                    self.showStr.text = @"0";
                    SwipingCardViewController *scvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SC"];
                    
                    [self.navigationController pushViewController:scvc animated:YES];
                    [scvc setValue:@"常规消费" forKey:@"type"];
                    
                    
                } else {
                    
                    [self showTipView:@"请确定交易金额！"];
                    
                    
                }
                
            }else{
                [self showTipView:@"设备繁忙，稍后再试"];
            }
            
        }];
    }
    
    
    
}

//即时收款
- (IBAction)immediatelyConsume:(UIButton *)sender {
    
    //return;
    
    if (self.totalNum.text.floatValue < 100) {
        [self showTipView:@"即时消费不能小于100"];
        return;
    }
    
    JishiChooseController *jishiVC = [[JishiChooseController alloc] init];
    self.jishiVC = jishiVC;
    jishiVC.count = self.totalNum.text;

    [self.navigationController pushViewController:jishiVC animated:YES];
    
    
    self.totalNum.text = @"0.00";
    self.showStr.text = @"0";
}


    //sdk 回调方法
- (void)recvMiniPosSDKStatus
{
    [super recvMiniPosSDKStatus];
    
    if ([self.statusStr isEqualToString:[NSString stringWithFormat:@"签到成功"]]) {
        [self hideHUD];
        NSLog(@"LoginViewController ----签到成功");
        
        [self showTipView:self.statusStr];
    }
    
    
    if ([self.statusStr isEqualToString:[NSString stringWithFormat:@"签到失败"]]) {
        [self hideHUD];
        NSLog(@"LoginViewController ----签到失败");
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"签到失败！" message:self.displayString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alertView show];
        
    }
    
    
    
    self.statusStr = @"";
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - WDCalculatorDelegate
-(void)WDCalculatorDidClick:(WDCalculator *)WDCalculator{
    //self.num.text  = [NSString stringWithFormat:@"￥ %.2f",WDCalculator.num];
    self.totalNum.text = [NSString stringWithFormat:@"%.2f",WDCalculator.totalNum];
    self.showStr.text = WDCalculator.str;
}
@end
