//
//  ZhuCeInfoController.m
//  GITestDemo
//
//  Created by WS on 15/10/12.
//  Copyright © 2015年 Kyson. All rights reserved.
//

#import "ZhuCeInfoController.h"
#import "AddressViewController.h"
#import "ShangHuInfoController.h"
#import "UIUtils.h"
@interface ZhuCeInfoController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UIButton *_lastPressedBtn;
    BOOL _isGeRen;
    NSData *_data1;
    NSData *_data2;
    NSData *_data3;
//    NSData *_data5;
    NSData *_data8;
}

@property (weak, nonatomic) IBOutlet UIView *topButtonView;
@property (weak, nonatomic) IBOutlet UIButton *GeRenBtn;
@property (weak, nonatomic) IBOutlet UIButton *QiYeBtn;

@property (weak, nonatomic) IBOutlet UIView *xingmingView;
@property (weak, nonatomic) IBOutlet UIView *shenfenzhenghaoView;

@property (weak, nonatomic) IBOutlet UITextField *xingmingTextField;
@property (weak, nonatomic) IBOutlet UITextField *shenfenzhengTextField;

@property (weak, nonatomic) IBOutlet UIImageView *xingmingImageV;
@property (weak, nonatomic) IBOutlet UIImageView *shenfenzhengImageV;

@property (weak, nonatomic) IBOutlet UIView *shuiwuDengjiView;
//@property (weak, nonatomic) IBOutlet UIView *kaihuxukeView;

@property (weak, nonatomic) IBOutlet UIView *yingyezhizhaoView;

@property (weak, nonatomic) IBOutlet UILabel *shuiwudengjiLabel;
@property (weak, nonatomic) IBOutlet UILabel *kaihuxukeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shuiwudengjiImage;
//@property (weak, nonatomic) IBOutlet UIImageView *kaihuxukeImage;
@property (weak, nonatomic) IBOutlet UIImageView *yingyezhizhaoImage;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UIButton *shenfenzhengmianBtn;
@property (weak, nonatomic) IBOutlet UIButton *shenfenfanmianBtn;
//@property (weak, nonatomic) IBOutlet UIButton *shuiwudengjiBtn;
@property (weak, nonatomic) IBOutlet UIButton *shouchizhengjianBtn;

//@property (weak, nonatomic) IBOutlet UIButton *kaihuxukeBtn;
@property (weak, nonatomic) IBOutlet UIButton *yingyezhizhaoBtn;

@property (weak, nonatomic) IBOutlet UILabel *shuiwudengjiShili;
@property (weak, nonatomic) IBOutlet UILabel *shouchizhengjianLabel;


@property (nonatomic, strong) UIImageView *coverImageV;
@property (nonatomic, strong) UIButton *coverBtn;



@property (strong,nonatomic) UIActionSheet *actionSheet;
@end

@implementation ZhuCeInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isGeRen = YES;
    self.view.backgroundColor =rgb(229, 229, 229, 1);
    self.xingmingTextField.delegate = self;
    self.xingmingTextField.tag = 1;
    
    self.shenfenzhengTextField.delegate = self;
    self.shenfenzhengTextField.tag = 2;
    
    self.xingmingView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.xingmingView.layer.borderWidth = 1;
    
    self.shenfenzhenghaoView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.shenfenzhenghaoView.layer.borderWidth = 1;
    
    [self GeRenBtnChick:nil];
    
    self.nextBtn.backgroundColor = KMyBlueColor;
    [self.nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    
    [self setUpNavgation];
    
    self.topButtonView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.topButtonView.layer.borderWidth = 1;
    
    
    [self.yingyezhizhaoBtn setBackgroundImage:[UIImage imageNamed:@"khxk11"] forState:UIControlStateNormal];
    

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
    titleLabel.text = @"填写个人信息";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
}

- (IBAction)shenfenzhengImageChick:(UIButton *)sender {
    
    UIImage *image = [UIImage imageNamed:@"sfzzm_big.jpg"];
    [self showBigImageWith:image];
}

- (IBAction)shenfenzhengFmImageChick:(id)sender {
    UIImage *image = [UIImage imageNamed:@"sfzfm_big.jpg"];
    [self showBigImageWith:image];

}

- (IBAction)shouchizhengjianImageChcik:(id)sender {
    
    UIImage *image = [UIImage imageNamed:@"scsfz_big.jpg"];
    [self showBigImageWith:image];
    
}

- (IBAction)yingyezhizhaoImageChick:(id)sender {
    UIImage *image = [UIImage imageNamed:@"yyzz11.jpg"];
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


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadHistory{
    
    
    NSString *xingming = [KUserDefault objectForKey:Kxingming];
    NSString *shenfenzhenghao = [KUserDefault objectForKey:Kshenfenzhenghao];
    self.xingmingTextField.text = xingming;
    self.shenfenzhengTextField.text = shenfenzhenghao;
    
    _data1 = [KUserDefault objectForKey:KShenFenZM];
    if (_data1) {
        [self.shenfenzhengmianBtn setBackgroundImage:[UIImage imageWithData:_data1] forState:UIControlStateNormal];
    }
    
    
    _data2 = [KUserDefault objectForKey:KShenFenFM];
    if (_data2) {
        [self.shenfenfanmianBtn setBackgroundImage:[UIImage imageWithData:_data2] forState:UIControlStateNormal];
    }
    
    _data3 = [KUserDefault objectForKey:KShouChiZhengJian];
    if (_data3) {
        [self.shouchizhengjianBtn setBackgroundImage:[UIImage imageWithData:_data3] forState:UIControlStateNormal];
    }
    

    _data8 = [KUserDefault objectForKey:Kyingyezhizhao];
    if (_data8) {
        [self.yingyezhizhaoBtn setBackgroundImage:[UIImage imageWithData:_data8] forState:UIControlStateNormal];
    }else{
        
        [self.yingyezhizhaoBtn setBackgroundImage:[UIImage imageNamed:@"khxk11"] forState:UIControlStateNormal];
    }

    

    
//    _data5 = [KUserDefault objectForKey:KKaiHuXuKe];
//    if (_data5) {
//        [self.kaihuxukeBtn setBackgroundImage:[UIImage imageWithData:_data5] forState:UIControlStateNormal];
//    }
    
    
    
}

- (IBAction)GeRenBtnChick:(id)sender {
    
    [self selectBtnHeightLightWith:self.GeRenBtn];
    self.shuiwudengjiLabel.text = @"本人手持证件";
    self.yingyezhizhaoView.hidden = YES;
    self.shuiwudengjiImage.image = [UIImage imageNamed:@"scsfz"];
    self.shuiwudengjiShili.hidden = NO;
    _isGeRen = YES;
    
    [self setTitleWithString:@"填写个人信息"];
    [self loadHistory];
}
- (IBAction)QiYeBtnChcik:(id)sender {
    
    [self selectBtnHeightLightWith:self.QiYeBtn];
//    self.shuiwudengjiLabel.text = @"税务登记证";
//    self.shuiwudengjiImage.image = [UIImage imageNamed:@"khxk1"];
    self.yingyezhizhaoImage.image = [UIImage imageNamed:@"yyzz11.jpg"];
    self.yingyezhizhaoView.hidden = NO;
    self.shuiwudengjiShili.hidden = YES;
    _isGeRen = NO;

    [self setTitleWithString:@"注册"];
    [self loadHistory];
}

- (void)setTitleWithString:(NSString *)str{
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = str;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (IBAction)shenfenzhengmianChick:(UIButton *)sender {
    
    [self showSheetWith:sender];
}
- (IBAction)shenfenfanmianChick:(UIButton *)sender {
    
    [self showSheetWith:sender];
}
- (IBAction)shouchizhengjianChick:(id)sender {
    
    [self showSheetWith:sender];
}
- (IBAction)yingyezhizhaoChick:(id)sender {
    
    [self showSheetWith:sender];
}


- (void)showSheetWith:(UIButton *)btn{
    
    _lastPressedBtn = btn;
    
    self.actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册获取",@"拍照",nil];
    
    [self.actionSheet showInView:self.view];
}

- (void)selectBtnHeightLightWith:(UIButton *)btn{
    
    self.GeRenBtn.backgroundColor = [UIColor whiteColor];
    self.GeRenBtn.titleLabel.textColor = KMyBlueColor;
    
    self.QiYeBtn.backgroundColor = [UIColor whiteColor];
    self.QiYeBtn.titleLabel.textColor = KMyBlueColor;
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = KMyBlueColor;
    
    
}

- (void)next{
    
    
    if (self.xingmingTextField.text.length == 0) {
        [self showTipView:@"请输入姓名"];
        return;
    }
//    if (self.shenfenzhengTextField.text.length == 0) {
//        [self showTipView:@"请输入身份证号"];
//        return;
//    }
    
    if (![UIUtils isCorrectID:self.shenfenzhengTextField.text]) {
        [self showTipView:@"请输入正确的身份证号"];
        return;
    }
    if (!_data1) {
        [self showTipView:@"请选择身份证正面"];
        return;
    }
    if (!_data2) {
        [self showTipView:@"请选择身份证反面"];
        return;
    }
    if (!_data3) {
        [self showTipView:@"请选择本人手持证件照片"];
        return;
    }
    
    if (_isGeRen) {
        
        
        
        AddressViewController *addressVC = [[AddressViewController alloc] init];
        [self.navigationController pushViewController:addressVC animated:YES];
    }else{
        
        if (!_data8) {
            [self showTipView:@"请选择营业执照"];
            return;
        }
        
        
        ShangHuInfoController *shanghuVc = [[ShangHuInfoController alloc] init];
        [self.navigationController pushViewController:shanghuVc animated:YES];
    }
    
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
        
        

        if (_lastPressedBtn == self.shenfenzhengmianBtn) {
            _data1 = data;
            [KUserDefault setObject:data forKey:KShenFenZM];
        }else if (_lastPressedBtn == self.shenfenfanmianBtn){
            
            _data2 = data;
            [KUserDefault setObject:data forKey:KShenFenFM];
        }else if (_lastPressedBtn == self.shouchizhengjianBtn){
            

            _data3 = data;
            [KUserDefault setObject:data forKey:KShouChiZhengJian];

        }else if (_lastPressedBtn == self.yingyezhizhaoBtn){
            
            _data8 = data;
            [KUserDefault setObject:data forKey:Kyingyezhizhao];
        }
        
        [KUserDefault synchronize];
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
}

#pragma mark - textField的代理方法
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (textField.tag == 1) {

        [KUserDefault setObject:textField.text forKey:Kxingming];
    }else if (textField.tag == 2){
        
        [KUserDefault setObject:textField.text forKey:Kshenfenzhenghao];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 2) {
        if (range.location > 17) {
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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
