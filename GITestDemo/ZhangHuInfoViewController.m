//
//  ZhangHuInfoViewController.m
//  GITestDemo
//
//  Created by WS on 15/10/12.
//  Copyright © 2015年 Kyson. All rights reserved.
//

#import "ZhangHuInfoViewController.h"
#import "WDPickView.h"
#import "signUpModel.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "SubmitSuccessController.h"
#import "SelectBankInfoTableViewController.h"
#define kOFFSET_FOR_KEYBOARD 140
#define kOFFSET_FOR_KEYBOARD_PAD 140

@interface ZhangHuInfoViewController ()<UITextFieldDelegate,WDPickViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,SelectBankInfoTableViewControllerDelegate>{
    
    UIButton *_lastPressedBtn;
    NSData *_data;
    NSString *_imageDocPath;
}
@property (weak, nonatomic) IBOutlet UITextField *kaihushengTextField;//开户省
@property (weak, nonatomic) IBOutlet UITextField *kaihushiTextField;//开户市
@property (weak, nonatomic) IBOutlet UITextField *kaihumingTextField;
@property (weak, nonatomic) IBOutlet UITextField *kaihuhangTextField;
@property (weak, nonatomic) IBOutlet UITextField *zhihangTextField;
@property (weak, nonatomic) IBOutlet UITextField *yinghangkahaoTextField;
@property (weak, nonatomic) IBOutlet UITextField *lianhanghaoTextField;
@property (weak, nonatomic) IBOutlet UIButton *yinhangkaBtn;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, strong) UIImageView *coverImageV;
@property (nonatomic, strong) UIButton *coverBtn;

@property (strong,nonatomic) UIActionSheet *actionSheet;

@end

@implementation ZhangHuInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    _imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile_g"];
    [[NSFileManager defaultManager] createDirectoryAtPath:_imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    self.view.backgroundColor =rgb(229, 229, 229, 1);
    [self.submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.yinhangkaBtn addTarget:self action:@selector(yinhangkaChoose:) forControlEvents:UIControlEventTouchUpInside];
    
    self.kaihumingTextField.delegate = self;
    self.kaihumingTextField.tag = 1;
    
    self.navigationItem.title = @"填写账户信息";
    
    WDPickView *pickView = [[WDPickView alloc]initPickViewWithPlistName:@"Address"];
    pickView.delegate = self;
    self.kaihushengTextField.inputView = pickView;
    self.kaihushiTextField.inputView = pickView;

    
    self.kaihuhangTextField.delegate = self;
    self.kaihuhangTextField.tag = 4;
    
    self.zhihangTextField.delegate = self;
    self.zhihangTextField.tag = 5;
    
    self.yinghangkahaoTextField.delegate = self;
    self.yinghangkahaoTextField.tag = 6;
    
    self.lianhanghaoTextField.delegate = self;
    self.lianhanghaoTextField.tag = 7;

    
    self.kaihushiTextField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xla"]];
    self.kaihushengTextField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xla"]];
    self.kaihushiTextField.rightViewMode = UITextFieldViewModeAlways;
    self.kaihushengTextField.rightViewMode = UITextFieldViewModeAlways;
    
    [self loadHistory];
}

- (void)yinhangkaChoose:(UIButton *)btn{
    

        
    _lastPressedBtn = btn;
    
    self.actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册获取",@"拍照",nil];
    
    [self.actionSheet showInView:self.view];

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    
    
}

- (void)loadHistory{
    
    NSString *kaihuming = [KUserDefault objectForKey:Kkaihuming];
    self.kaihumingTextField.text = kaihuming;
    
    NSString *kaihusheng = [KUserDefault objectForKey:Kkaihusheng];
    self.kaihushengTextField.text = kaihusheng;
    
    NSString *kaihushi = [KUserDefault objectForKey:Kkaihushi];
    self.kaihushiTextField.text = kaihushi;
    
    NSString *kaihuhang = [KUserDefault objectForKey:Kkaihuhang];
    self.kaihuhangTextField.text = kaihuhang;
    
    NSString *zhihang = [KUserDefault objectForKey:Kzhihang];
    self.zhihangTextField.text = zhihang;
    
    NSString *yinhangkahao = [KUserDefault objectForKey:Kyinghangkahao];
    self.yinghangkahaoTextField.text = yinhangkahao;
    
    NSString *lianhanghao = [KUserDefault objectForKey:Klianhanghao];
    self.lianhanghaoTextField.text = lianhanghao;
    
    if (_data) {
        _data = [KUserDefault objectForKey:KGenRenYinHangKaZM];
        [self.yinhangkaBtn setBackgroundImage:[UIImage imageWithData:_data] forState:UIControlStateNormal];
    }
    
}

- (IBAction)yinghangkazhengmianImageChick:(id)sender {
    
    UIImage *image = [UIImage imageNamed:@"yhk_big.jpg"];
    [self showBigImageWith:image];
}


- (void)showBigImageWith:(UIImage *)image{
    
    
    
    UIImageView *imagev = [[UIImageView alloc] init];
    [imagev setImage:image];
    CGFloat width =[UIScreen mainScreen].bounds.size.width;
    CGFloat heigh = width / 1.8;
    imagev.size = CGSizeMake(width, heigh);
    imagev.center = self.view.center;
    self.coverImageV = imagev;
    [self.view addSubview:imagev];
    
    
    UIButton *coverBtn = [[UIButton alloc] initWithFrame:self.view.bounds];
    coverBtn.backgroundColor = [UIColor blackColor];
    coverBtn.alpha = 0.1;
    [coverBtn addTarget:self action:@selector(coverBtnChick) forControlEvents:UIControlEventTouchUpInside];
    self.coverBtn = coverBtn;
    [self.view addSubview:coverBtn];
    
}


- (void)coverBtnChick{
    
    [self.coverBtn removeFromSuperview];
    [self.coverImageV removeFromSuperview];
    
}



- (void)submit{
    
    
    if (self.kaihumingTextField.text.length == 0) {
        [self showTipView:@"开户名不能为空"];
        return;
    }
    if (self.kaihushengTextField.text.length == 0 || self.kaihushiTextField.text.length == 0) {
        [self showTipView:@"请选择开户城市"];
        return;
    }
    if (self.kaihuhangTextField.text.length == 0) {
        [self showTipView:@"开户行不能为空"];
        return;
    }
    if (self.zhihangTextField.text.length == 0) {
        [self showTipView:@"支行不能为空"];
        return;
    }
    if (self.yinghangkahaoTextField.text.length == 0) {
        [self showTipView:@"银行卡号不能为空"];
        return;
    }
    if (self.lianhanghaoTextField.text.length == 0) {
        [self showTipView:@"联行号不能为空"];
        return;
    }
    
    if (!_data) {
        [self showTipView:@"请选择银行卡正面照片"];
        return;
    }
    
    
    
    NSString *suozaisheng = [KUserDefault objectForKey:Ksuozaisheng];
    NSString *suozaishi = [KUserDefault objectForKey:Ksuozaishi];
    NSString *suozaijiedao = [KUserDefault objectForKey:KsuozaiJiedao];
    
    signUpModel *sign = [[signUpModel alloc] init];
    sign.merType = @"6";
    sign.passwd = [KUserDefault objectForKey:KPassword];
    sign.areaCode = [KUserDefault objectForKey:Ksuozaidibianma];
    sign.lawMan = [KUserDefault objectForKey:Kxingming];
    sign.phone = [KUserDefault objectForKey:kSignUpPhoneNo];
    sign.certType = @"1";
    sign.certNo = [KUserDefault objectForKey:Kshenfenzhenghao];
    sign.certExpdate = @"20190909";
    sign.mchAddr = [NSString stringWithFormat:@"%@%@%@",suozaisheng,suozaishi,suozaijiedao];
    sign.accountType = @"1";
    sign.isPrivate = @"1";
    sign.bankName = [KUserDefault objectForKey:Kkaihuhang];
    sign.province = [KUserDefault objectForKey:Kkaihusheng];
    sign.city = [KUserDefault objectForKey:Kkaihushi];
    sign.bankBranch = [KUserDefault objectForKey:Kzhihang];
    sign.settleAccno = [KUserDefault objectForKey:Kyinghangkahao];
    sign.settleBank = [KUserDefault objectForKey:Klianhanghao];
    sign.accName = [KUserDefault objectForKey:Kkaihuming];
    sign.sn = [KUserDefault objectForKey:kMposG1SN];
    
    NSLog(@"-----%@",sign.keyValues);
    
    NSData *data1 = [KUserDefault objectForKey:KShenFenZM];
    NSData *data2 = [KUserDefault objectForKey:KShenFenFM];
    NSData *data3 = [KUserDefault objectForKey:KShouChiZhengJian];
    NSData *data4 = [KUserDefault objectForKey:KGenRenYinHangKaZM];
//    NSData *data10 = data1;

    assert(data1);
    assert(data2);
    assert(data3);
    assert(data4);
//    assert(data10);

    
    NSString *imagePath1 =[_imageDocPath stringByAppendingPathComponent:@"1.jpg"];
    NSLog(@"##########%@",imagePath1);
    NSString *imagePath2 =[_imageDocPath stringByAppendingPathComponent:@"2.jpg"];
    NSString *imagePath3 =[_imageDocPath stringByAppendingPathComponent:@"3.jpg"];
    NSString *imagePath4 =[_imageDocPath stringByAppendingPathComponent:@"4.jpg"];
//    NSString *imagePath10 =[_imageDocPath stringByAppendingPathComponent:@"10.jpg"];
    

    [[NSFileManager defaultManager] createFileAtPath:imagePath1 contents:data1 attributes:nil];
    [[NSFileManager defaultManager] createFileAtPath:imagePath2 contents:data2 attributes:nil];
    [[NSFileManager defaultManager] createFileAtPath:imagePath3 contents:data3 attributes:nil];
    [[NSFileManager defaultManager] createFileAtPath:imagePath4 contents:data4 attributes:nil];
//    [[NSFileManager defaultManager] createFileAtPath:imagePath10 contents:data10 attributes:nil];
    
    
    
    NSURL *filePath1 = [NSURL fileURLWithPath:imagePath1];
    NSURL *filePath2 = [NSURL fileURLWithPath:imagePath2];
    NSURL *filePath3 = [NSURL fileURLWithPath:imagePath3];
    NSURL *filePath4 = [NSURL fileURLWithPath:imagePath4];
//    NSURL *filePath10 = [NSURL fileURLWithPath:imagePath10];
    
    
    [self showHUD:@"正在提交"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/MposApp/registerMchInfo.action",kServerIP,kServerPort];
    [manager POST:url parameters:sign.keyValues constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
        [formData appendPartWithFileURL:filePath1 name:@"file1" error:nil];
        [formData appendPartWithFileURL:filePath2 name:@"file2" error:nil];
        [formData appendPartWithFileURL:filePath3 name:@"file3" error:nil];
        [formData appendPartWithFileURL:filePath4 name:@"file4" error:nil];
//        [formData appendPartWithFileURL:filePath10 name:@"file10" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        
        int code = [responseObject[@"resultMap"][@"code"]intValue];
        
        [self hideHUD];
        
        [self showTipView:responseObject[@"resultMap"][@"msg"]];
        
        if(code ==0){
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            
//            [alert show];
            SubmitSuccessController *submitVc = [[SubmitSuccessController alloc]     init];
            [self.navigationController pushViewController:submitVc animated:YES];
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self hideHUD];
        [self showTipView:@"提交失败"];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    [self setViewMovedUp:NO];
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    
    
    CGRect rect = self.view.frame;
    NSLog(@"%f",rect.size.height);
    if( (movedUp) )
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        if (rect.origin.y>=0)
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                rect.origin.y -= kOFFSET_FOR_KEYBOARD;
                rect.size.height += kOFFSET_FOR_KEYBOARD;
            }
            if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
                rect.origin.y -= kOFFSET_FOR_KEYBOARD_PAD;
                rect.size.height += kOFFSET_FOR_KEYBOARD_PAD;
            }
        }
        
    }
    else
    {
        
        if   (rect.origin.y<0)
            // revert back to the normal state.
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
                rect.origin.y += kOFFSET_FOR_KEYBOARD;
                rect.size.height -= kOFFSET_FOR_KEYBOARD;
            }
            if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
                rect.origin.y += kOFFSET_FOR_KEYBOARD_PAD;
                rect.size.height -= kOFFSET_FOR_KEYBOARD_PAD;
            }
            
        }
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}



#pragma mark - WDPickView的代理方法
- (void)toolBarDoneBtnHaveClicked:(WDPickView *)pickView resultString:(NSString *)resultString shengfen:(NSString *)shengfen{
    
    self.kaihushiTextField.text = [resultString substringToIndex:[resultString length] -5];
    NSString *areaCode  = [resultString substringFromIndex:[resultString length] -4];
    self.kaihushengTextField.text = shengfen;
    [KUserDefault setObject:shengfen forKey:Kkaihusheng];
    [KUserDefault setObject:self.kaihushiTextField.text forKey:Kkaihushi];
//    [KUserDefault setObject:areaCode forKey:Ksuozaidibianma];
    [KUserDefault synchronize];
    
    
    //    为了解决跳转时，如果焦点停留在所在地区上，奔溃的bug
    [self.view endEditing:YES];
    
}

#pragma mark - textField的代理方法

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 6 || textField.tag == 7) {
        [self setViewMovedUp:YES];
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self setViewMovedUp:NO];
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField.tag == 1) {
        
    }else if (textField.tag == 4){ //开户行
        
            NSString *url = [NSString stringWithFormat:@"http://%@:%@/MposApp/queryBank.action?flag=bank",kServerIP,kServerPort];
        
            SelectBankInfoTableViewController *sbiTVC = [[SelectBankInfoTableViewController alloc] init];
            sbiTVC.url = url;
            sbiTVC.delegate = self;
            sbiTVC.textField = textField;
            [self.navigationController pushViewController:sbiTVC animated:YES];
            [textField resignFirstResponder];
    
        
    }else if (textField.tag == 5){ //支行
        
        
        if (self.kaihushengTextField.text.length == 0 || self.kaihushiTextField.text.length == 0) {
            [self showTipView:@"请选择开户城市"];
            return;
        }
        if (self.kaihuhangTextField.text.length == 0) {
            [self showTipView:@"请先选择开户行"];
            return;
        }
        
        
        NSString *url1 = [NSString stringWithFormat:@"http://%@:%@/MposApp/querySubbranch.action?bankName=%@&cityName=%@",kServerIP,kServerPort,self.kaihuhangTextField.text,self.kaihushiTextField.text];
    
        
        SelectBankInfoTableViewController *sbiTVC = [[SelectBankInfoTableViewController alloc] init];
        sbiTVC.url = [url1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        sbiTVC.delegate = self;
        sbiTVC.textField = textField;
        [self.navigationController pushViewController:sbiTVC animated:YES];
        [textField resignFirstResponder];

  
    }else if (textField.tag == 6){ //银行卡号
        
      
    }else if (textField.tag == 7){ //联行号
        

    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.tag == 1) {
        [KUserDefault setObject:textField.text forKey:Kkaihuming];
    }else if (textField.tag == 4){ //开户行
        
        [KUserDefault setObject:textField.text forKey:Kkaihuhang];
    }else if (textField.tag == 5){ //支行
        
        [KUserDefault setObject:textField.text forKey:Kzhihang];
    }else if (textField.tag == 6){ //银行卡号
        
        [KUserDefault setObject:textField.text forKey:Kyinghangkahao];
    }else if (textField.tag == 7){ //联行号
        
        [KUserDefault setObject:textField.text forKey:Klianhanghao];
    }
    [KUserDefault synchronize];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 6) {
        if (range.location > 18) {
            return NO;
        }
    }
    
    if (textField.tag == 7) {
        if (range.location > 11) {
            return NO;
        }
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - ActionSheet的代理方法
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
        
        _data = data;
        [KUserDefault setObject:data forKey:KGenRenYinHangKaZM];
        
        [KUserDefault synchronize];
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

-(void)getLianhanghao{
    
    
    NSString *url  = [[NSString stringWithFormat:@"http://%@:%@/MposApp/querySubNumber.action?branchName=%@",kServerIP,kServerPort,self.zhihangTextField.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager =[AFHTTPRequestOperationManager manager];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        int code = [responseObject[@"resultMap"][@"code"]intValue];
        
        if (code == 0) {
            NSLog(@"%@",responseObject[@"resultMap"][@"subNumber"]);
            
            self.lianhanghaoTextField.text = responseObject[@"resultMap"][@"subNumber"];
            
            [KUserDefault setObject:self.lianhanghaoTextField.text forKey:Klianhanghao];
        }
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - SelectBankInfoTableViewControllerDelegate
-(void)selectBankInfoTableViewController:(SelectBankInfoTableViewController *)vc didSelect:(NSString *)str fromTextField:(UITextField *)textField{
    
    textField.text = str;

    if (textField.tag == 4){ //开户行
        
        [KUserDefault setObject:textField.text forKey:Kkaihuhang];
    }else if (textField.tag == 5){ //支行
        
        [KUserDefault setObject:textField.text forKey:Kzhihang];
        if ([textField.text isEqualToString:@""]) {
            self.lianhanghaoTextField.text = @"";
            [KUserDefault setObject:self.lianhanghaoTextField.text forKey:Klianhanghao];
        }
        
        [self getLianhanghao];
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
