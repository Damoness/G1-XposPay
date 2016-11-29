//
//  LoginWaitViewController.m
//  GITestDemo
//
//  Created by WS on 15/10/15.
//  Copyright © 2015年 Kyson. All rights reserved.
//

#import "LoginWaitViewController.h"
#import "AppDelegate.h"
#import "LeftSortsViewController.h"

@interface LoginWaitViewController (){
    
    UIView *_showView;
    UIImageView *_imageView;
    int count;
    NSTimer *timer;
}

@end

@implementation LoginWaitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showWaiting];
    [self setUpNavgation];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_quanjuisTuiChu) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

+ (void)show{
    
    
}
+ (void)dismiss{
    
    
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
    titleLabel.text = @"用户登录";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
}
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pushToLeft{
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    LeftSortsViewController *leftVC = [[LeftSortsViewController alloc]init];
    
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    UINavigationController *mainVC = [mainStory instantiateViewControllerWithIdentifier:@"MainVC"];
    
    LeftSlideViewController *leftSlideVC = [[LeftSlideViewController alloc]initWithLeftView:leftVC andMainView:mainVC];
    tempAppDelegate.LeftSlideVC = leftSlideVC;
    
    [self presentViewController:leftSlideVC animated:YES completion:nil];
}

-(void)showWaiting{
    
    
    _showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _showView.backgroundColor = [UIColor whiteColor];
    
    int width = 95;
    int height = 25;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width - width)/2, (self.view.height - height)/2, width, height)];
    [_showView addSubview:_imageView];
    _imageView.image = [UIImage imageNamed:@"wait1"];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake((self.view.width -width*2)/2, (self.view.height -height)/2+height, width *2, height)];
    
    lable.text = @"数据读取中，请稍后. . . .";
    lable.textAlignment = NSTextAlignmentCenter;
    [_showView addSubview:lable];
    
    //    [[UIApplication sharedApplication].keyWindow addSubview:_showView];
    //    self.navigationController pushViewController:_showView animated:YES
    
    count = 1;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    
    [timer fire];
    [self.view addSubview:_showView];
}

-(void)changeImage{
    
    NSString *str = [NSString stringWithFormat:@"wait%d",count%3];
    
    
    _imageView.image = [UIImage imageNamed:str];
    
    count ++;
}

-(void)stopWaiting{
    [_showView removeFromSuperview];
    [timer invalidate];
    count =0;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self stopWaiting];
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
