//
//  JishiCiTiaoViewController.m
//  GITestDemo
//
//  Created by lcc on 15/9/11.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import "JishiCiTiaoViewController.h"
#import "SwipingCardViewController.h"

@interface JishiCiTiaoViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSString *payType;
}
@property (weak, nonatomic) IBOutlet UITextField *xingming;
@property (weak, nonatomic) IBOutlet UITextField *shenfenzhenghao;
@property (weak, nonatomic) IBOutlet UITextField *shoujihao;
@property (weak, nonatomic) IBOutlet UITextField *anquanma;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;

@property (nonatomic, strong) NSMutableArray *allIDArr;

@end

@implementation JishiCiTiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccess) name:KconnectDeivesSuccess object:nil];
    self.shenfenzhenghao.delegate = self;
    self.tableView.hidden = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self loadHistory];
}

- (void)loadHistory{
    
    self.allIDArr = [NSMutableArray array];
    self.shenfenzhenghao.text = [KUserDefault objectForKey:Kcitiaoshenfenzhenghao];
    NSDictionary *dict = [KUserDefault objectForKey:KcitiaoInfo];
    for (NSString *key in dict.allKeys) {
        [self.allIDArr addObject:key];
    }
    
    NSArray *arr = [dict objectForKey:self.shenfenzhenghao.text];
    self.xingming.text = arr[0];
    self.shoujihao.text = arr[1];
    [self.tableView reloadData];
    
    self.tableHeight.constant = self.allIDArr.count * 44;
    
}

- (void)connectSuccess{
    
    
    if ([payType isEqualToString:@"磁条卡"]) {
        [self queren:nil];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)queren:(id)sender {
    
     if (!self.shenfenzhenghao.text.length){
        
        [self showAlertViewWithMessage:@"身份证号不能为空"];
    }else if (!self.shoujihao.text.length){
        
        [self showAlertViewWithMessage:@"手机号不能为空"];
    }else {
        
        payType = @"磁条卡";
//        [[NSUserDefaults standardUserDefaults] setObject:self.shoujihao.text forKey:Kcitiaoyuliushoujihao];
//        [[NSUserDefaults standardUserDefaults] setObject:self.xingming.text forKey:Kcitiaoxingming];
        [[NSUserDefaults standardUserDefaults] setObject:self.shenfenzhenghao.text forKey:Kcitiaoshenfenzhenghao];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[KUserDefault objectForKey:KcitiaoInfo]];
        NSArray *arr = @[self.xingming.text,self.shoujihao.text];
        [dict setObject:arr forKey:self.shenfenzhenghao.text];
        
        [KUserDefault setObject:dict forKey:KcitiaoInfo];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        
        if(MiniPosSDKDeviceState()<0){
                //[self showTipView:@"设备未连接"];
            [self showConnectionAlert];
            return;
        }else{
            
//            dispatch_queue_t queue = dispatch_queue_create("jishixiaofei", NULL);
//            
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
                NSLog(@"%@",[NSThread currentThread]);
                [self verifyParamsSuccess:^{
                    
                    if (MiniPosSDKGetCurrentSessionType()== SESSION_POS_UNKNOWN) {
                        
                        int amount  = [self.count doubleValue]*100;
                        
                        if (amount > 0) {
                            
                            char buf[20];
                            
                            sprintf(buf,"%012d",amount);
                            
                            NSLog(@"amount: %s",buf);
                            
                            
                            _type = 1;
                            NSString *suijiStr = [NSString stringWithFormat:@"%d",(arc4random() % 89999999) + 10000000];

                            [[NSUserDefaults standardUserDefaults] setObject:suijiStr forKey:Kcitiaosuijishu];
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                            NSString *str = [NSString stringWithFormat:@"0\x1C%@",suijiStr];


                            _quanjuQianDaoType = 1;

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
//            });
            
            
            
            
        }
        
    }
    
}

int StrToHex(unsigned char* hex, unsigned char* str)
{
    int i;
    int j;
    unsigned char tmp;
    int len = strlen((char*)str);
    
    for(i = 0, j = 0; i < len; i++){
        tmp = 0xFF;
        
        if(str[i] >= '0' && str[i] <= '9'){
            tmp = str[i] - '0';
        }
        else if(str[i] >= 'A' && str[i] <= 'F'){
            tmp = str[i] - 'A' + 0x0A;
        }
        else if(str[i] >= 'a' && str[i] <= 'f'){
            tmp = str[i] - 'a' + 0x0A;
        }
        
        if(tmp < 0x10){
            if(j % 2 == 0){
                hex[j / 2] = tmp << 4;
            }
            else{
                hex[j / 2] &= 0xF0;
                hex[j / 2] |= (tmp & 0x0F);
            }
            j++;
        }
    }
    
    return j;
}

- (void)showAlertViewWithMessage:(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    self.tableView.hidden = YES;
}

#pragma mark - textField的代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    self.tableView.hidden = NO;
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    self.tableView.hidden = YES;
    
}

#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.allIDArr.count;
}

    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MenuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.allIDArr[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *shenfenzhenghao = self.allIDArr[indexPath.row];
    NSDictionary *dict = [KUserDefault objectForKey:KcitiaoInfo];
    NSArray *arr = [dict objectForKey:shenfenzhenghao];
    self.xingming.text = arr[0];
    self.shoujihao.text = arr[1];
    self.shenfenzhenghao.text = shenfenzhenghao;
    self.tableView.hidden = YES;
    [self.shenfenzhenghao endEditing:YES];
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
