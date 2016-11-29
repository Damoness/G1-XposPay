//
//  NotificationViewController.m
//  GITestDemo
//
//  Created by wd on 16/5/24.
//  Copyright © 2016年 Kyson. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationTableViewCell.h"
#import "NotificationViewModel.h"
#import "NotificationModel.h"
#import "MJExtension.h"
#import "NotificationDetailViewController.h"
@interface NotificationViewController ()<UITableViewDataSource,UITableViewDelegate>



@property (nonatomic,strong) NSMutableArray<NotificationModel *> *notificationArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self p_initViews];
    
    [self p_getData];
}




- (NSMutableArray<NotificationModel *> *)notificationArray{
    
    if (!_notificationArray) {
        _notificationArray = [NSMutableArray array];
    }
    
    return _notificationArray;
    
}


-(void)p_getData{
    
    
    NSString *LoginPhoneNo = [[NSUserDefaults standardUserDefaults]stringForKey:kLoginPhoneNo];
    
    
    [NotificationViewModel getNotificationListByUserId:LoginPhoneNo success:^(id response) {
        
        
        
        self.notificationArray = [NotificationModel objectArrayWithKeyValuesArray:response];

        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    
        
    }];
    
}

-(void)p_initViews{
    
    self.title = @"消息通知";
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 20, 20);
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}


-(void)backAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //self.navigationController.navigationBar.barTintColor  = [
    
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:55/255 green:126/255 blue:180/255 alpha:1.0];

    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.notificationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
   static NSString *reuseInditifier = @"notificationCell" ;
    
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseInditifier];
    
    NotificationModel *model = self.notificationArray[indexPath.row];

    cell.model = model;
    
    return  cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 40;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NotificationModel *model = self.notificationArray[indexPath.row];
    
    model.readType = @"1";
    
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self performSegueWithIdentifier:@"goToDetail" sender:model];
    
    

    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"goToDetail"]) {
        
        
        NotificationDetailViewController *noti = segue.destinationViewController;
        
        noti.model = sender;
        
        
        
        
        
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
