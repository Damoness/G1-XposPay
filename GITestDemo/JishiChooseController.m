//
//  JishiChooseController.m
//  GITestDemo
//
//  Created by lcc on 15/9/11.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import "JishiChooseController.h"
#import "SwipingCardViewController.h"
#import "JishiCiTiaoViewController.h"

@interface JishiChooseController (){
    
    NSString *payType;
}
@property (weak, nonatomic) IBOutlet UIButton *cipian;
@property (weak, nonatomic) IBOutlet UIButton *citiao;

@end

@implementation JishiChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccess) name:KconnectDeivesSuccess object:nil];
}

- (void)connectSuccess{
    
    
    if ([payType isEqualToString:@"芯片卡"]) {
        [self xinpian:nil];
    }
    
}

- (IBAction)xinpian:(id)sender {
    
    
    
    if (self.count.floatValue <100 || self.count.floatValue > 50000) {
        
        [self showTipView:@"芯片卡消费区间为100~50000"];
        return;
    }
    
    payType = @"芯片卡";
    if(MiniPosSDKDeviceState()<0){
            //[self showTipView:@"设备未连接"];
        [self showConnectionAlert];
        return;
    }else{
        
        [self verifyParamsSuccess:^{
            _quanjuQianDaoType = 0;
            if (MiniPosSDKGetCurrentSessionType()== SESSION_POS_UNKNOWN) {
                
                int amount  = [self.count doubleValue]*100;
                
                if (amount > 0) {
                    
                    char buf[20];
                    
                    sprintf(buf,"%012d",amount);
                    
                    NSLog(@"amount: %s",buf);
//                    NSString *suijiStr = [NSString stringWithFormat:@"%d",(arc4random() % 89999999) + 10000000];
                    NSString *str = [NSString stringWithFormat:@"0\x1C"];
                    _type = 1;
                    MiniPosSDKSaleTradeCMD(buf, NULL,str.UTF8String);
                    
                    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    SwipingCardViewController *scvc = [mainStory instantiateViewControllerWithIdentifier:@"SC"];
                    [self.navigationController pushViewController:scvc animated:YES];
                    [scvc setValue:@"即时收款" forKey:@"type"];
                    
                    
                    
                    
                } else {
                    
                    [self showTipView:@"请确定交易金额！"];
                }
                
            }else{
                [self showTipView:@"设备繁忙，稍后再试"];
            }
            
        }];
        
        
        
    }

}
- (IBAction)citiao:(id)sender {
    
    _quanjuQianDaoType = 0;
    
    if (self.count.floatValue <100 || self.count.floatValue > 20000) {
        
        [self showTipView:@"磁条卡消费区间为100~20000"];
        return;
    }
    
    JishiCiTiaoViewController *jishicitiaoVc = [[JishiCiTiaoViewController alloc] init];
    jishicitiaoVc.count = self.count;
    [self.navigationController pushViewController:jishicitiaoVc animated:YES];
    
    
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
