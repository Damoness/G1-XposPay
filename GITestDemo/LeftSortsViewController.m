//
//  LeftSortsViewController.m
//  LGDeckViewController
//
//  Created by jamie on 15/3/31.
//  Copyright (c) 2015年 Jamie-Ling. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import "CommonViewController.h"
#import "JiLuViewController.h"
#import "AFNetworking.h"

@interface LeftSortsViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageview.image = [UIImage imageNamed:@"leftbackiamge"];
    [self.view addSubview:imageview];

    UITableView *tableview = [[UITableView alloc] init];
    self.tableview = tableview;
    tableview.frame = self.view.bounds;
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"功能";
        UIImage *icon = [UIImage imageNamed:@"功能"];
        CGSize itemSize = CGSizeMake(36, 36);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [icon drawInRect:imageRect];
        
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"交易信息";
        
        UIImage *icon = [UIImage imageNamed:@"邮件"];
        CGSize itemSize = CGSizeMake(36, 36);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [icon drawInRect:imageRect];
        
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"通用";
        
        UIImage *icon = [UIImage imageNamed:@"通用"];
        CGSize itemSize = CGSizeMake(36, 36);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [icon drawInRect:imageRect];
        
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"退出";
        UIImage *icon = [UIImage imageNamed:@"退出"];
        CGSize itemSize = CGSizeMake(36, 36);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [icon drawInRect:imageRect];
        
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
//    else if (indexPath.row == 4) {
//        cell.textLabel.text = @"绑定新设备";
//        UIImage *icon = [UIImage imageNamed:@"Locked"];
//        CGSize itemSize = CGSizeMake(36, 36);
//        UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
//        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//        [icon drawInRect:imageRect];
//        
//        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    //[tempAppDelegate.mainNavigationController pushViewController:vc animated:NO];
    
    //otherViewController *vc = [[otherViewController alloc] init];
   // tempAppDelegate.i
    
    quanjubangding = @"0";
    
    switch (indexPath.row) {
        case 0://功能
        {
            
            UIStoryboard *mainStroy = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            
            UIViewController *vc = [tempAppDelegate.LeftSlideVC.presentingViewController.storyboard
                                    instantiateViewControllerWithIdentifier:@"MainVC"];
            [tempAppDelegate.LeftSlideVC replaceMainView:vc];
            break;
        }
  
        case 1:{
            {
//                UIViewController *vc = [tempAppDelegate.LeftSlideVC.presentingViewController.storyboard
//                                        instantiateViewControllerWithIdentifier:@"JYJL"];
//                [tempAppDelegate.LeftSlideVC replaceMainView:vc];
                JiLuViewController *jiluVc = [[JiLuViewController alloc] init];
                UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:jiluVc];
                [tempAppDelegate.LeftSlideVC replaceMainView:navVc];
                break;
            }
        }
 
            break;
        case 2://通用
        {
            
            UIViewController *vc = [tempAppDelegate.LeftSlideVC.presentingViewController.storyboard
                                    instantiateViewControllerWithIdentifier:@"TY"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            
            
            
            [tempAppDelegate.LeftSlideVC replaceMainView:nav];
            break;
        }
        case 3: //退出
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 4;
            [alert show];
        }
            
            
            break;
//        case 4://绑定新设备
//            
//            {
//                
//                //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newDeviceAppend) name:KconnectDeivesSuccess object:nil];
//                
//                UIViewController *connectVc = [tempAppDelegate.LeftSlideVC.presentingViewController.storyboard
//                                               instantiateViewControllerWithIdentifier:@"CD"];
//                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:connectVc];
//                connectVc.navigationItem.title  = @"绑定新设备";
//                quanjubangding = @"1";
//                [tempAppDelegate.LeftSlideVC replaceMainView:nav];
//                return;
//            }
            
        default:
            break;
    }
    
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 180;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 180)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


#pragma mark - alertView的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (buttonIndex == 1) {
        [tempAppDelegate.LeftSlideVC dismissViewControllerAnimated:YES completion:nil];
        
        //            [KVNProgress showWithStatus:@"感谢您的使用"];
        //
        //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //                [KVNProgress dismiss];
        //            });
        
        [self showProgressWithStatus:@"感谢您的使用"];
        
        [self hideProgressAfterDelaysInSeconds:3.0];
        _quanjuisTuiChu = YES;
    }
}


@end
