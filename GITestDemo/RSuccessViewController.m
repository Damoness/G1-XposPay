//
//  RSuccessViewController.m
//  GITestDemo
//
//  Created by 吴狄 on 10/12/15.
//  Copyright © 2015 Kyson. All rights reserved.
//

#import "RSuccessViewController.h"

@interface RSuccessViewController ()

@end

@implementation RSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)confirm:(UIButton *)sender {
    
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

@end
