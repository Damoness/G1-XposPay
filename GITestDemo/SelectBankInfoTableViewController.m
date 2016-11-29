//
//  SelectBankInfoTableViewController.m
//  GITestDemo
//
//  Created by wd on 15/12/22.
//  Copyright © 2015年 Kyson. All rights reserved.
//

#import "SelectBankInfoTableViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
@interface SelectBankInfoTableViewController ()
{
    MBProgressHUD *_hud;
    
}
@end

@implementation SelectBankInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.searchBar.delegate = self;
    
    [self showHUD:@"正在加载数据"];
    
    [self getWebData];
    
}

-(void)getWebData{
    
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    
    [manager GET:self.url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
  
        
        
        NSLog(@"%@",responseObject[@"resultMap"][@"searchList"]);
        
        self.allData = [NSMutableArray arrayWithArray:responseObject[@"resultMap"][@"searchList"]];
        self.data = [NSMutableArray arrayWithArray:self.allData];
        [self hideHUD];
        
        if([self.allData count]>0){
            [self.tableView reloadData];
        }else{
         
            [self showTipView:@"获取数据为空,请重现选择城市或开户行"];
            
            if ([self.delegate respondsToSelector:@selector(selectBankInfoTableViewController:didSelect:fromTextField:)]) {
                [self.delegate selectBankInfoTableViewController:self didSelect:@"" fromTextField:self.textField];
                
//                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows

    
    return [self.data count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell ;
    
    static NSString *Identifier = @"Identifier1";
    cell= [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    cell.textLabel.text = self.data[indexPath.row];

    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate
//
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    

    if ([self.delegate respondsToSelector:@selector(selectBankInfoTableViewController:didSelect:fromTextField:)]) {
        [self.delegate selectBankInfoTableViewController:self didSelect:self.data[indexPath.row] fromTextField:self.textField];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    

}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    NSArray *indexList = [NSMutableArray arrayWithObjects:
//                              @"A", @"B", @"C", @"D", @"E", @"F",
//                              @"G", @"H", @"I", @"J", @"K", @"L",
//                              @"M", @"N", @"O", @"P", @"Q", @"R",
//                              @"S", @"T", @"U", @"V", @"W", @"X",
//                              @"Y", @"Z", @"#", nil];
//    NSLog(@"%@",indexList);
//    return indexList ;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"searchText:%@",searchText);
    if ([searchText isEqualToString:@""]) {
        self.data = [NSMutableArray arrayWithArray:self.allData];
        [self.tableView reloadData];
        [self.view endEditing:YES];
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.data = [NSMutableArray arrayWithArray:self.allData];
    [self.tableView reloadData];
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSString *str = self.searchBar.text;
    
    if (![str isEqualToString:@""]) {
        
        [self.data removeAllObjects];
        
        for (NSString *s in self.allData) {
            if ([s containsString:str]) {
                [self.data addObject:s];
            }
        }
        
        [self.tableView reloadData];
        
    }
    //[searchBar becomeFirstResponder];
    
    [self.view endEditing:YES];
    
}


@end
