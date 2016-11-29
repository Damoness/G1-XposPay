//
//  JiLuViewController.m
//  GITestDemo
//
//  Created by WS on 15/10/9.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import "JiLuViewController.h"
#import "JiaoyijiluCell.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "AppDelegate.h"
#import "ConnectDeviceViewController.h"

@interface JiLuViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *snTableView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *stateArr;
@property (weak, nonatomic) IBOutlet UIButton *snBtn;

@property (nonatomic, strong) NSMutableArray *snArr; //sn号的数组
@property (nonatomic,strong) NSMutableDictionary *dic_SN_URL; //sn号对应的交易记录查询地址
@end

@implementation JiLuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.snTableView.delegate = self;
    self.snTableView.dataSource = self;
    self.snTableView.tableFooterView = [[UIView alloc] init];
    self.snTableView.hidden = YES;
    self.snTableView.tag = 0;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tag  = 1;
    self.tableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0);
    //[self showHUD:@"正在查询记录"];

    
    self.snArr  = [NSMutableArray array];
    self.dic_SN_URL = [NSMutableDictionary dictionary];
    
    [self setNavgation];
    
    //[self requestJiaoyijiluWithSn:sn];
    
    
    self.snBtn.hidden = YES;
    [self acquireUserSN];
    
}

//获取用户对应的设备信息
- (void)acquireUserSN{
    
    NSString *phoneNo = [[NSUserDefaults standardUserDefaults] stringForKey:kLoginPhoneNo];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSString *urlStr  = [NSString stringWithFormat:@"http://%@:%@/MposApp/queryTidInfo.action?user=%@&flag=120002",kServerIP,kServerPort,phoneNo];
    NSLog(@"urlStr:%@",urlStr);
    
    
    [mgr POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [responseObject objectForKey:@"resultMap"];
        int code = [[dict objectForKey:@"code"] intValue];
        
        //NSLog(@"dict:%@",dict);
        
        //查询成功
        if (code == 6){
            
            NSArray *arr = [dict objectForKey:@"searchList"];
            
            for (NSDictionary *d in arr) {
                NSLog(@"d:%@",d);
                NSString *url = [NSString stringWithFormat:@"http://%@:%@/MposApp/queryTrans.action?sn=%@&user=%@&mid=%@&tid=%@&flag=120001",kServerIP,kServerPort,d[@"sn"],phoneNo,d[@"mid"],d[@"tid"]];
                NSLog(@"url:%@",url);
                [self.snArr addObject:d[@"sn"]];
                [self.dic_SN_URL setObject:url forKey:d[@"sn"]];
                
            }
            
            //self.snTableViewHeight.constant = self.snArr.count * 44;
        }
        
        self.snBtn.hidden = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        //[self hideHUD];
        //[self showTipView:@"获取交易记录超时"];
    }];
    
    
}

//获取某个设备的交易记录
- (void)acquireTradingRecordWithSN:(NSString *)sn{
    
    [self showHUD:@"正在查询记录"];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    
    NSString *urlStr = [self.dic_SN_URL objectForKey:sn];
    NSLog(@"urlStr:%@",urlStr);
    
    [mgr POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [responseObject objectForKey:@"resultMap"];
        NSString *code = [dict objectForKey:@"code"];
        self.stateArr = [Jiaoyijilu objectArrayWithKeyValuesArray:[dict objectForKey:@"searchList"]];
        if (_stateArr.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"交易记录为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];
        }
        NSLog(@"%@",self.stateArr);
        [self.tableView reloadData];
        [self hideHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self hideHUD];
        [self showTipView:@"获取交易记录超时"];
    }];
    
    
}


- (void)setNavgation{
    
    
    self.navigationItem.title = @"交易记录查询";
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    
    [btn addTarget:self  action:@selector(openOrCloseLeftView) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
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


- (IBAction)btnChick:(id)sender {
    
    self.snTableView.hidden = NO;
    [self.snTableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView的代理和数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        return self.stateArr.count;
    }else{
        
        return self.snArr.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1) {
        static NSString *ID = @"cell";
        JiaoyijiluCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"JiaoyijiluCell" owner:nil options:nil];
            cell = [nibs lastObject];
        }
        Jiaoyijilu *jilu = self.stateArr[indexPath.row];
        cell.jilu = jilu;
        
        return cell;
    }else{
        
        static NSString *ID = @"snCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.text = self.snArr[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.height = 30;
        return cell;
    }
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
////    if (self.tableView.tag == 1) {
////        return 100;
////    }
//    if (self.tableView.tag == 0) {
//        return 30;
//        
//    }else{
//        return 100;
//    }
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1) {
        Jiaoyijilu *jilu = self.stateArr[0];
        if (indexPath.row == 0 && [jilu.txnId isEqualToString:@"200022"] && [jilu.tranStatus isEqualToString:@"1"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"撤销" message:@"是否进行撤销" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"撤销", nil];
            [alert show];
            
        }
        
    }else{
        
        [self.snBtn setTitle:self.snArr[indexPath.row] forState:UIControlStateNormal];
        [self acquireTradingRecordWithSN:self.snArr[indexPath.row]];
    }
    self.snTableView.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.snTableView.hidden = YES;
}
#pragma mark - 懒加载
- (NSMutableArray *)snArr{
    
    if (_snArr == nil) {
        _snArr = [NSMutableArray array];
    }
    return _snArr;
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
