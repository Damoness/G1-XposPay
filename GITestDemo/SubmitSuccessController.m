//
//  SubmitSuccessController.m
//  GITestDemo
//
//  Created by WS on 15/10/13.
//  Copyright © 2015年 Kyson. All rights reserved.
//

#import "SubmitSuccessController.h"

@interface SubmitSuccessController ()

@end

@implementation SubmitSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.navigationItem.title = @"提交成功";
    [self setUpNavgation];
}
- (void)setUpNavgation{
    
    UIButton *backButton =[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton setImage:[UIImage imageNamed:@"ht"] forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"提交成功";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)queren:(id)sender {
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
