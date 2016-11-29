//
//  SelectBankInfoTableViewController.h
//  GITestDemo
//
//  Created by wd on 15/12/22.
//  Copyright © 2015年 Kyson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class SelectBankInfoTableViewController;
@protocol SelectBankInfoTableViewControllerDelegate <NSObject>

-(void)selectBankInfoTableViewController:(SelectBankInfoTableViewController *)vc didSelect:(NSString *)str fromTextField:(UITextField*)textField;

@end

@interface SelectBankInfoTableViewController : BaseViewController<UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *allData; //所有数据
@property (nonatomic,strong) NSMutableArray *data; //
@property (nonatomic,strong) NSString *url; //数据加载的链接
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,weak) id<SelectBankInfoTableViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar; //搜索框

@end
