//
//  ConnectDeviceViewController.m
//  GITestDemo
//
//  Created by Femto03 on 14/12/1.
//  Copyright (c) 2014年 Kyson. All rights reserved.
//

#import "ConnectDeviceViewController.h"
#import "UIUtils.h"
#include "Common.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
@interface ConnectDeviceViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSTimer *timer;
    UILabel *curLabel;
    NSString *connectedBluetoothName;
}
@end

@implementation ConnectDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isNeedAutoConnect = NO;
    [self _initSubViews];
    

}

- (void)_initSubViews
{
    self.addBtn.layer.borderWidth = 1.0;
    self.addBtn.layer.borderColor = [rgb(0,122,255,1) CGColor];
    
    _deviceView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-200, kScreenWidth, 200)];
    _deviceView.layer.cornerRadius = 2.0;
    _deviceView.layer.masksToBounds = YES;
    _deviceView.hidden = YES;
    _deviceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_deviceView];
    
    _deviceTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 160) style:UITableViewStylePlain];
    _deviceTable.delegate = self;
    _deviceTable.dataSource = self;
    _deviceTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_deviceView addSubview:_deviceTable];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 10, 40, 40);
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_deviceView addSubview:button];
    
    
    UIButton *finish = [UIButton buttonWithType:UIButtonTypeCustom];
    finish.frame = CGRectMake(_deviceView.frame.size.width-40-10,10,40,40);
    [finish setTitle:@"完成" forState:UIControlStateNormal];
    [finish addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [finish setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_deviceView addSubview:finish];
    
    
    
    
    curLabel = self.bleStatusLabel;
    
    
}

- (void)openOrCloseLeftList:(id)sender
{
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    if(MiniPosSDKDeviceState()==0){
        self.statusLabel.text = @"已连接";
        self.bleStatusLabel.text = @"已连接";
        
    }
    
    if ([quanjubangding isEqualToString:@"1"]) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(openOrCloseLeftList:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDiscoverDevice) name:kDidDiscoverDevice object:nil];

}


-(void)getPosParams{
    
    NSLog(@"didConnectDevice");
    
    char paramname[100];
    
    memset(paramname, 0x00, sizeof(paramname));
    strcat(paramname, "TerminalNo");
    strcat(paramname, "\x1C");
    strcat(paramname, "MerchantNo");
    strcat(paramname, "\x1C");
    strcat(paramname, "SnNo");
    
    MiniPosSDKGetParams("88888888", paramname);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _isNeedAutoConnect = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back
{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)bleConnectAction:(UIButton *)sender {
    
    
    curLabel = self.bleStatusLabel;
        //开始查询蓝牙
    [[BleManager sharedManager] startScan];
    self.deviceView.hidden = NO;
    [self.deviceTable reloadData];
    
}


//复写父类方法
- (void)recvMiniPosSDKStatus
{
    [super recvMiniPosSDKStatus];
    
    if([self.statusStr isEqualToString:@"设备已插入"]){
        NSLog(@"ConnectDevice:设备已经插入");
        curLabel.text = @"已连接";
        self.statusLabel.text =@"已连接";
        _isConnect = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            [self getPosParams];
            
        });
        

    }
    
    if ([self.statusStr isEqualToString:@"设备已拔出"]) {
        curLabel.text = @"未连接";
        self.statusLabel.text =@"未连接";
        _isConnect = NO;
    }

    if ([self.statusStr isEqualToString:@"获取参数成功"]) {
        
        
        NSString *phoneNo = [KUserDefault objectForKey:kLoginPhoneNo];
        if (phoneNo!=nil) {
            
            NSMutableDictionary *userSNDict  =  [NSMutableDictionary dictionaryWithDictionary:[KUserDefault objectForKey:kUserSNDict]];
            if (userSNDict ==nil) {
                userSNDict  =  [NSMutableDictionary dictionary];
            }
            
            [userSNDict setObject:connectedBluetoothName forKey:phoneNo];
            
            [KUserDefault setObject:userSNDict forKey:kUserSNDict];
            [KUserDefault synchronize];
            
        }

        
        
        

        NSString *SnNo = [NSString stringWithCString:MiniPosSDKGetParam("SnNo") encoding:NSUTF8StringEncoding];
        NSString *TerminalNo = [NSString stringWithCString:MiniPosSDKGetParam("TerminalNo") encoding:NSUTF8StringEncoding];
        NSString *MerchantNo = [NSString stringWithCString:MiniPosSDKGetParam("MerchantNo") encoding:NSUTF8StringEncoding];
        
        [[NSUserDefaults standardUserDefaults] setObject:SnNo forKey:kMposG1SN];
        [[NSUserDefaults standardUserDefaults] setObject:TerminalNo forKey:kMposG1TerminalNo];
        [[NSUserDefaults standardUserDefaults] setObject:MerchantNo forKey:kMposG1MerchantNo];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSLog(@"SnNo:%@,TerminalNo:%@,MerchantNo:%@",[[NSUserDefaults standardUserDefaults]stringForKey:kMposG1SN],[[NSUserDefaults standardUserDefaults]stringForKey:kMposG1TerminalNo],[[NSUserDefaults standardUserDefaults]stringForKey:kMposG1MerchantNo]);

        self.bluetoothName.text = connectedBluetoothName;
        self.SN.text = [[NSUserDefaults standardUserDefaults]stringForKey:kMposG1SN];
        self.time.text = [UIUtils stringFromDate:[NSDate date] formate:@"yyyy.MM.dd"];
        [self hideHUD];
        [self showTipView:@"连接成功"];
        
        [self performSelector:@selector(popView) withObject:self afterDelay:2];
    }
    
    
    if ([self.statusStr isEqualToString:@"签到成功"]) {
        [self hideHUD];
    }
    
    self.statusStr = @"";
    
}

- (void)popView{
    
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:KconnectDeivesSuccess object:nil];
    
    if ([quanjubangding isEqualToString: @"1"]) {
        [self bindNewDevice];
    }
}

- (void)bindNewDevice{
    
    NSString *sn = [KUserDefault objectForKey:kMposG1SN];
    NSString *loginPhone = [KUserDefault objectForKey:kLoginPhoneNo];
    NSString *mima = [KUserDefault objectForKey:KPassword];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@/MposApp/bindMpos.action?sn=%@&user=%@&passwd=%@&flag=0800464",kServerIP,kServerPort,sn,loginPhone,mima];
    NSLog(@"urlStr:%@",urlStr);
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"%@",responseObject);
        NSDictionary *dict = [responseObject objectForKey:@"resultMap"];
        
        
        if ([dict[@"code"]intValue] == 7) {
            
            [self showHUD:@"正在写入参数"];
            
            NSString *mainKey  = [self decryptMainKey:dict[@"tmk"]];
            NSString *tid = dict[@"tid"];
            NSString *mid = dict[@"mid"];
            NSLog(@"mainKey:%@",mainKey);
            
            NSDictionary *dictionary = @{@"商户号":mid,@"终端号":tid,@"主密钥1":mainKey};
            
            [self setPosWithParams:dictionary success:^{
//                if(MiniPosSDKPosLogin()>=0)
//                {
//                    [self showHUD:@"正在签到"];
//                }
                
                [[NSUserDefaults standardUserDefaults] setBool:false forKey:kHasSignedIn];
                
                [[NSUserDefaults standardUserDefaults]setObject:mid forKey:kMposG1MerchantNo];
                [[NSUserDefaults standardUserDefaults]setObject:tid forKey:kMposG1TerminalNo];
                [[NSUserDefaults standardUserDefaults]setObject:mainKey forKey:kMposG1MainKey];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [self showAlertViewWithMessage:@"绑定设备成功"];
            }];
            

            
        }else{
            
            //[self showTipView:[dict objectForKey:@"msg"]];
            
            if([[dict objectForKey:@"msg"] isEqualToString:@"新设备绑定失败，该MPOS机身码已提交注册或已绑定商户"]){
                [self showAlertViewWithMessage:@"新设备绑定失败，该MPOS已绑定其他商户，请重新选择"];
            }else{
                [self showAlertViewWithMessage:[dict objectForKey:@"msg"]];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [self showTipView:@"绑定新设备失败"];
        [self showAlertViewWithMessage:@"绑定新设备失败"];
    }];
}

#pragma mark - 新设备绑定


- (void)showAlertViewWithMessage:(NSString *)str{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark -
#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchDevices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"myCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-5, 44)];
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 100;
        [cell.contentView addSubview:label];
        
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    
    CBPeripheral *aper = [searchDevices objectAtIndex:indexPath.row];
    label.text = aper.name;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 40)];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor blueColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"设备目录";
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self showHUD:@"正在连接" afterTime:8 failStr:@"连接失败"];

    self.bluetoothName.text = @"";
    self.SN.text = @"";
    self.time.text = @"";
    MiniPosSDKInit();
    
    _deviceView.hidden = YES;
    [[BleManager sharedManager].imBT connect:[searchDevices objectAtIndex:indexPath.row]];
    
    CBPeripheral *aper = [searchDevices objectAtIndex:indexPath.row];
    connectedBluetoothName = aper.name;
    
}

- (void)cancelAction
{
    self.deviceView.hidden = YES;
}

- (void)didDiscoverDevice
{
    [_deviceTable reloadData];
}



@end
