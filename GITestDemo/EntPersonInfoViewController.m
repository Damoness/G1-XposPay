//
//  EntPersonInfoViewController.m
//  GITestDemo
//
//  Created by 吴狄 on 15/6/8.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//


#import "EntPersonInfoViewController.h"
#import "UIUtils.h"
@interface EntPersonInfoViewController ()
{
    UIButton *_lastPressedBtn;
    NSString *_imageDocPath;
    NSData *_data1;
    NSData *_data2;
    NSData *_data3;
    NSData *_data5;
    NSData *_data10;
}
@property (nonatomic, strong) UIDatePicker *datePicker;
@end

@implementation EntPersonInfoViewController



- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    [self loadHistory];
    
    [self _initViews];
    
    [self setUpDatePicker];
    
}

- (void)loadHistory{
    

    self.password.text = [[NSUserDefaults standardUserDefaults] objectForKey:qiyeMima];
    self.name.text = [[NSUserDefaults standardUserDefaults] objectForKey:qiyeName];
    self.ID.text = [[NSUserDefaults standardUserDefaults] objectForKey:qiyeID];
    self.certExpdate.text = [[NSUserDefaults standardUserDefaults] objectForKey:qiyeShenfenzhengyouxiaoqi];
    
    _data1 = [[NSUserDefaults standardUserDefaults] objectForKey:qiyeImage1];
    [self.IDPhotoFront setBackgroundImage:[UIImage imageWithData:_data1] forState:UIControlStateNormal];
    _data2 = [[NSUserDefaults standardUserDefaults] objectForKey:qiyeImage2];
    [self.IDPhotoBack setBackgroundImage:[UIImage imageWithData:_data2] forState:UIControlStateNormal];
    _data3 = [[NSUserDefaults standardUserDefaults] objectForKey:qiyeImage3];
    [self.IDPhotoAndPerson setBackgroundImage:[UIImage imageWithData:_data3] forState:UIControlStateNormal];
    _data5 = [[NSUserDefaults standardUserDefaults] objectForKey:qiyeImage5];
    [self.KaiHuXuKeZheng setBackgroundImage:[UIImage imageWithData:_data5] forState:UIControlStateNormal];
    _data10 = [[NSUserDefaults standardUserDefaults] objectForKey:qiyeImage10];
    [self.XianChangZhaoPian setBackgroundImage:[UIImage imageWithData:_data10] forState:UIControlStateNormal];
}


- (void)setUpDatePicker{
    
    UIDatePicker *datepick = [[UIDatePicker alloc] init];
    _datePicker = datepick;
    [datepick setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    datepick.minimumDate = [NSDate date];
    
    datepick.datePickerMode=UIDatePickerModeDate;
    
    self.certExpdate.inputView = datepick;
    
    UIToolbar *toolbar=[[UIToolbar alloc]init];
    
    toolbar.barTintColor=[UIColor brownColor];
    
    toolbar.frame=CGRectMake(0, 0, 320, 44);
    
        //给工具条添加按钮
    UIBarButtonItem *item0=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *item3=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(DateClick)];
    
    toolbar.items = @[item0, item1, item2, item3];
        //    toolbar.items = @[item3];
        //设置文本输入框键盘的辅助视图
    self.certExpdate.inputAccessoryView=toolbar;
}

- (void)DateClick{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *str = [formatter stringFromDate:self.datePicker.date];
    self.certExpdate.text = str;
    [self.view endEditing:YES];
}


- (void)_initViews{
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 180, 44)];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 60, 44)];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 60, 44)];
    [label1 setText:@"个人信息"];
    [label2 setText:@"商户信息"];
    [label3 setText:@"银行账号"];
    [label1 setFont:[UIFont systemFontOfSize:14]];
    [label2 setFont:[UIFont systemFontOfSize:14]];
    [label3 setFont:[UIFont systemFontOfSize:14]];
    [titleView addSubview:label1];
    [titleView addSubview:label2];
    [titleView addSubview:label3];
    
    label1.textColor = [UIColor blackColor];
    label2.textColor = [UIColor grayColor];
    label3.textColor = [UIColor grayColor];
    
    self.navigationItem.titleView = titleView;
    
    
    self.password.delegate = self;
    self.password.tag = 1;
//    self.rePassword.delegate = self;
    self.name.delegate = self;
    self.name.tag = 3;
    
    self.ID.delegate = self;
    self.ID.tag = 4;
    
    self.certExpdate.delegate = self;
    self.certExpdate.tag = 5;
    
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    _imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile_q"];
    //创建ImageFile文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:_imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    
    self.imagePath1 = @"";
    self.imagePath2 = @"";
    self.imagePath3 = @"";
    self.imagePath5 = @"";
    self.imagePath10 = @"";
}


- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)changeImage:(UIButton*)sender {
    
    _lastPressedBtn = sender;
    
    self.actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册获取",@"拍照",nil];
    
    
    [self.actionSheet showInView:self.view];
    
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //从相册选择
            [self OpenLocalPhoto];
            break;
        case 1:
            //拍照
            [self takePhoto];
            break;
        default:
            break;
    }
}

-(void)takePhoto{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

-(void)OpenLocalPhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (IBAction)next:(id)sender {
    
    if (DEBUG) {
        [self performSegueWithIdentifier:@"NEXT" sender:nil];
        return;
    }
    
    //校验信息
    
    if (![UIUtils isCorrectPassword:self.password.text]) {
        [self showTipView:@"请输入正确的密码"];
        return;
    }else if (![self.rePassword.text isEqualToString:self.password.text]) {
        [self showTipView:@"2次密码不一致，请重新输入"];
        return;
    }else if ([UIUtils isEmptyString:self.name.text]||[self.name.text length] > 10) {
        [self showTipView:@"请输入正确的姓名"];
        return;
    }else if (![UIUtils isCorrectID:self.ID.text]) {
        [self showTipView:@"请输入正确的身份证号码"];
        return;
    }else if ([UIUtils isEmptyString:self.certExpdate.text]) {
        [self showTipView:@"请输入正确的身份证有效期"];
        return;
    }else if (!_data1){
        [self showTipView:@"请选择身份证正面照"];
        return;
    }else if (!_data2){
        [self showTipView:@"请选择身份证反面照"];
        return;
    }else if (!_data3){
        [self showTipView:@"请选择手持身份证照"];
        return;
    }else if (!_data10){
        [self showTipView:@"请选择现场照片"];
        return;
    }else if (!_data5){
        [self showTipView:@"请选择开户许可证照片"];
        return;
    }
    
    //跳转
    [self performSegueWithIdentifier:@"NEXT" sender:nil];
    
    
    
}



#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"imagePickerControllerDidCancel");
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo{
    
    NSLog(@"didFinishPickingImage");
    
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        //图片显示在按钮上
        [_lastPressedBtn setBackgroundImage:image forState:UIControlStateNormal];
        
        //把图片转成NSData类型的数据来保存文件
        NSData *data;
        //判断图片是不是png格式的文件
        
        data = UIImageJPEGRepresentation(image, 0.1);
        
        
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        
        
        //保存
        if (_lastPressedBtn == self.IDPhotoFront) {
            self.imagePath1 = [_imageDocPath stringByAppendingPathComponent:@"1.jpg"];
//            [[NSFileManager defaultManager] createFileAtPath:self.imagePath1 contents:data attributes:nil];
            _data1 = data;
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:qiyeImage1];
        }else if (_lastPressedBtn == self.IDPhotoBack){
            self.imagePath2 = [_imageDocPath stringByAppendingPathComponent:@"2.jpg"];
            _data2 = data;
//            [[NSFileManager defaultManager] createFileAtPath:self.imagePath2 contents:data attributes:nil];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:qiyeImage2];
        }else if (_lastPressedBtn == self.IDPhotoAndPerson){
            self.imagePath3 = [_imageDocPath stringByAppendingPathComponent:@"3.jpg"];
            _data3 = data;
//            [[NSFileManager defaultManager] createFileAtPath:self.imagePath3 contents:data attributes:nil];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:qiyeImage3];
        }else if (_lastPressedBtn == self.XianChangZhaoPian){
            self.imagePath10 = [_imageDocPath stringByAppendingPathComponent:@"10.jpg"];
            _data10 = data;
//            [[NSFileManager defaultManager] createFileAtPath:self.imagePath10 contents:data attributes:nil];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:qiyeImage10];
        }else if (_lastPressedBtn == self.KaiHuXuKeZheng){
            self.imagePath5 = [_imageDocPath stringByAppendingPathComponent:@"5.jpg"];
            _data5 = data;
//            [[NSFileManager defaultManager] createFileAtPath:self.imagePath5 contents:data attributes:nil];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:qiyeImage5];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    /*
     @property (strong, nonatomic) IBOutlet UITextField *password; //登录密码  tag:1
     @property (strong, nonatomic) IBOutlet UITextField *rePassword; //确认密码   tag:2
     @property (strong, nonatomic) IBOutlet UITextField *name; //姓名   tag:3
     @property (strong, nonatomic) IBOutlet UITextField *ID; //身份证  tag:4
     @property (strong, nonatomic) IBOutlet UITextField *certExpdate; //身份证有效期   tag:5
     */
    if (textField.tag == 1) {
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:qiyeMima];
    }else if (textField.tag == 3){
        
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:qiyeName];
    }else if (textField.tag == 4){
        
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:qiyeID];
    }else if (textField.tag == 5){
        
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:qiyeShenfenzhengyouxiaoqi];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 4) {
        if (range.location >= 18){
            return NO; // return NO to not change text
            
        }else{
            
            return YES;
        }
        
    }
    return YES;
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
