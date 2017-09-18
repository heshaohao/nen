//
//  PhoneVerificationController.m
//  nen
//
//  Created by apple on 17/6/16.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "PhoneVerificationController.h"
#import "generalButton.h"
#import "CodeButton.h"
#import "SetAccountTextField.h"

@interface PhoneVerificationController ()<UITextFieldDelegate>

@property(nonatomic,strong) UILabel *headLabels;

@property(nonatomic,strong) generalButton *identityBtn;

@property(nonatomic,strong) generalButton *payPasswordBtn;

@property(nonatomic,strong) generalButton *completeBtn;

@property(nonatomic,strong) CodeButton *codeBtn;

@property(nonatomic,strong) SetAccountTextField *numberTextFields;

@property(nonatomic,strong) SetAccountTextField *smsTextFields;

@property(nonatomic,strong) SetAccountTextField *phoneTextFieldTextFields;

@property(nonatomic,strong) UIView *centernViews;

@property(nonatomic,strong) UIView *verificationCenterView;

@property(nonatomic,strong) UILabel *rightLabels;

@property(nonatomic,copy) NSString *codeStr;

@property(nonatomic,copy) NSString *phoneNumber;

@property(nonatomic,strong) UILabel *oneLabel;

@property(nonatomic,strong) UILabel *twoLabel;

@property(nonatomic,strong) UILabel *threeLabel;


@end

#define KTextFiledLeftViewW  5
#define KTextFiledLeftViewH  25

@implementation PhoneVerificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    UILabel *headLabel = [[UILabel alloc] init];
    self.headLabels = headLabel;
    headLabel.font = [UIFont systemFontOfSize:15];
    headLabel.frame = CGRectMake(0,80,ScreenWidth,40);
    headLabel.text = @"  验证身份";
    headLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headLabel];
    
    CGFloat W = (ScreenWidth - 80) / 3;
    
    generalButton *btn = [generalButton buttonWithType:UIButtonTypeCustom];
    self.identityBtn = btn;
    btn.frame = CGRectMake(20,headLabel.sh_bottom + 20,W,90);
    [btn setTitle:@"验证身份" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"ZHUCESEKUAI2"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"ZHUCESEKUAI"] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:btn];
    
    _oneLabel = [[UILabel alloc] init];
    _oneLabel.frame = CGRectMake(self.identityBtn.sh_x +(btn.sh_width *0.5) - 5,self.identityBtn.sh_y
                                 + 15,10,15);
    _oneLabel.textColor = [UIColor whiteColor];
    _oneLabel.textAlignment = NSTextAlignmentCenter;
    _oneLabel.text = @"1";
    [self.view addSubview:_oneLabel];

    
    
    generalButton *btn2 = [generalButton buttonWithType:UIButtonTypeCustom];
    self.payPasswordBtn = btn2;
    btn2.frame = CGRectMake(btn.sh_right + 20,btn.sh_y,W,90);
    [btn2 setTitle:@"修改验证号码" forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"ZHUCESEKUAI2"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"ZHUCESEKUAI"] forState:UIControlStateSelected];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:btn2];
    
    _twoLabel = [[UILabel alloc] init];
    _twoLabel.frame = CGRectMake(self.payPasswordBtn.sh_x +(btn.sh_width *0.5) - 5,self.payPasswordBtn.sh_y
                                 + 15,10,15);
    _twoLabel.textColor = [UIColor whiteColor];
    _twoLabel.textAlignment = NSTextAlignmentCenter;
    _twoLabel.text = @"2";
    [self.view addSubview:_twoLabel];
    
    
    
    
    generalButton *btn3 = [generalButton buttonWithType:UIButtonTypeCustom];
    self.completeBtn = btn3;
    btn3.frame = CGRectMake(btn2.sh_right + 20,btn.sh_y,W,90);
    [btn3 setTitle:@"完成" forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"ZHUCESEKUAI2"] forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"ZHUCESEKUAI"] forState:UIControlStateSelected];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn3.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn3.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:btn3];
    
    _threeLabel = [[UILabel alloc] init];
    _threeLabel.frame = CGRectMake(self.completeBtn.sh_x +(btn.sh_width *0.5) - 5,self.completeBtn.sh_y
                                 + 15,10,15);
    _threeLabel.textColor = [UIColor whiteColor];
    _threeLabel.textAlignment = NSTextAlignmentCenter;
    _threeLabel.text = @"3";
    [self.view addSubview:_threeLabel];

    [self addCenteriew];
    
}

// 添加验证试图
- (void)addCenteriew
{
    // 设置按钮状态
    self.identityBtn.selected = YES;
    self.payPasswordBtn.selected = NO;
    self.completeBtn.selected = NO;
    
    _centernViews = [[UIView alloc] init];
    _centernViews.frame = CGRectMake(15,self.identityBtn.sh_bottom + 20,ScreenWidth - 30,315);
    _centernViews.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_centernViews];
    
    UILabel  *verificationLabel = [[UILabel alloc] init];
    verificationLabel.frame = CGRectMake(10,10,_centernViews.sh_width,25);
    verificationLabel.font = [UIFont systemFontOfSize:15];
    verificationLabel.text = @"我们已经给您的手机发送了一条短信";
    [_centernViews addSubview:verificationLabel];
    
    UILabel *headLabel = [[UILabel alloc] init];
    headLabel.frame = CGRectMake(10,verificationLabel.sh_bottom + 10,_centernViews.sh_width - 20,25);
    headLabel.text = @"输入已验证手机";
    headLabel.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    headLabel.font = [UIFont systemFontOfSize:13];
    [_centernViews addSubview:headLabel];
    
    
    SetAccountTextField *numberTextField = [[SetAccountTextField alloc] init];
    self.numberTextFields = numberTextField;
    numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    numberTextField.frame = CGRectMake(headLabel.sh_x,headLabel.sh_bottom + 10,_centernViews.sh_width - 20,25);
    numberTextField.font = [UIFont systemFontOfSize:13];
    numberTextField.layer.borderWidth = 1.0f;
    numberTextField.placeholder = @"请输入更改的手机号码";
    numberTextField.layer.cornerRadius = 5;
    numberTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    numberTextField.clipsToBounds = YES;
    [_centernViews addSubview:numberTextField];

 
    SetAccountTextField *smsTextField = [[SetAccountTextField alloc] init];
    self.smsTextFields = smsTextField;
    smsTextField.delegate = self;
    smsTextField.frame = CGRectMake(10,numberTextField.sh_bottom + 20,_centernViews.sh_width - 150,25);
    smsTextField.placeholder = @"请输入短信验证码";
    smsTextField.font = [UIFont systemFontOfSize:13];
    smsTextField.layer.borderWidth = 1.0f;
    smsTextField.layer.cornerRadius = 5;
    smsTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    smsTextField.clipsToBounds = YES;
    smsTextField.keyboardType = UIKeyboardTypePhonePad;
    [_centernViews addSubview:smsTextField];
    
    
    
    CodeButton *testingBtn = [CodeButton buttonWithType:UIButtonTypeCustom];
    self.codeBtn = testingBtn;
    testingBtn.frame = CGRectMake(smsTextField.sh_right + 20 ,smsTextField.sh_y,110,25);
    [testingBtn setTitle:@"短信验证码" forState:UIControlStateNormal];
    testingBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    testingBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [testingBtn setBackgroundColor:[UIColor colorWithHexString:@"#FF5001"]];
    [testingBtn addTarget:self action:@selector(PhoneSMSClcik) forControlEvents:UIControlEventTouchUpInside];
    testingBtn.layer.cornerRadius = 5;
    testingBtn.clipsToBounds = YES;
    [_centernViews addSubview:testingBtn];
    
    
    UILabel *introductionsLabel = [[UILabel alloc] init];
    introductionsLabel.font = [UIFont systemFontOfSize:13];
    introductionsLabel.frame = CGRectMake(10,testingBtn.sh_bottom + 10,_centernViews.sh_width -20,35);
    introductionsLabel.text = @"短信验证码已发送到您的手机,如在120s内还没有收到短信验证码请重新发送";
    introductionsLabel.textColor = [UIColor lightGrayColor];
    introductionsLabel.numberOfLines = 0;
    [_centernViews addSubview:introductionsLabel];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(20 ,introductionsLabel.sh_bottom + 20,_centernViews.sh_width - 40,40);
    [nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [nextBtn setBackgroundColor:[UIColor colorWithHexString:@"#FF5001"]];
    [nextBtn addTarget:self action:@selector(submitTheValidationClcik) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 5;
    nextBtn.clipsToBounds = YES;
    [_centernViews addSubview:nextBtn];
    
}

#pragma mark 获取密码短信验证码
- (void)PhoneSMSClcik
{
    [self.numberTextFields resignFirstResponder];
    
    NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.numberTextFields.text];
    
    if(!isMatch)
    {
        [self.codeBtn timeFailBeginFrom:1];
        [JKAlert alertText:@"请输入正确的手机号"];
        return ;
    }
    
    [self.codeBtn timeFailBeginFrom:60];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 加密地址
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/site/sendcode"];
    
    // 获取手机号码
    
    NSDictionary *dict= @{@"mobile":self.numberTextFields.text,@"type":@"3"};
    
    // POST数据
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
      
        
        NSString *messageStr = responseObject[@"result"][@"resultMessage"];
        
        if ([messageStr isEqualToString:@"SUCCESS"]) {
            
            [JKAlert alertText:@"短信已发出,请查看"];
            
        }else
        {
            [JKAlert alertText:messageStr];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}

#pragma mark提交验证码
- (void)submitTheValidationClcik
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 加密地址
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/mine/checkcode"];
    
    // 获取手机号码
    
    NSDictionary *dict= @{@"mobile":self.numberTextFields.text,@"type":@"3",@"code":self.smsTextFields.text};
    
    // POST数据
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
       
        
        NSString *messageStr = responseObject[@"result"][@"resultMessage"];
        
        if ([messageStr isEqualToString:@"SUCCESS"]) {
            self.codeStr = self.smsTextFields.text;
            [JKAlert alertText:@"短信已发出,请查看"];
            [self.centernViews removeFromSuperview];
            [self verificationNumberCenter];
            
        }else
        {
            [JKAlert alertText:messageStr];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}

#pragma mark 修改验证号码
- (void)verificationNumberCenter
{
    // 设置按钮状态
    self.identityBtn.selected = NO;
    self.payPasswordBtn.selected = YES;
    self.completeBtn.selected = NO;
    
    _verificationCenterView = [[UIView alloc] init];
    _verificationCenterView.frame = CGRectMake(15,self.identityBtn.sh_bottom + 20,ScreenWidth - 30,270);
    _verificationCenterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_verificationCenterView];
    
    UILabel *headLabel = [[UILabel alloc] init];
    headLabel.frame = CGRectMake(10, 10,_verificationCenterView.sh_width - 20,25);
    headLabel.text = @"新的手机验证号码";
    headLabel.font = [UIFont systemFontOfSize:13];
    [_verificationCenterView addSubview:headLabel];

    
    SetAccountTextField *phoneTextField = [[SetAccountTextField alloc] init];
    self.phoneTextFieldTextFields = phoneTextField;
    phoneTextField.delegate = self;
    phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    phoneTextField.frame = CGRectMake(headLabel.sh_x,headLabel.sh_bottom + 20,_verificationCenterView.sh_width - 20,40);
    phoneTextField.font = [UIFont systemFontOfSize:13];
    phoneTextField.layer.borderWidth = 1.0f;
    phoneTextField.layer.cornerRadius = 5;
    phoneTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    phoneTextField.clipsToBounds = YES;
    
    [_verificationCenterView addSubview:phoneTextField];
    
    UIButton *confirmationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmationBtn.frame = CGRectMake(20,phoneTextField.sh_bottom + 30,_verificationCenterView.sh_width *0.8,40);
    [confirmationBtn setTitle:@"提交" forState:UIControlStateNormal];
    [confirmationBtn addTarget:self action:@selector(verificationSubmitClick) forControlEvents:UIControlEventTouchUpInside];
    confirmationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    confirmationBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [confirmationBtn setBackgroundColor:[UIColor colorWithHexString:@"#FF5001"]];
    [confirmationBtn setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    confirmationBtn.layer.cornerRadius = 5;
    confirmationBtn.clipsToBounds = YES;
    [_verificationCenterView addSubview:confirmationBtn];
}


#pragma  mark 提交新的手机号码
- (void)verificationSubmitClick
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 加密地址
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/site/bindmobile"];
    
    // 获取手机号码
    
    NSDictionary *dict= @{@"mobile":self.phoneTextFieldTextFields.text,@"code":self.codeStr};
    
    // POST数据
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
      
        
        NSString *messageStr = responseObject[@"result"][@"resultMessage"];
        
        if ([messageStr isEqualToString:@"SUCCESS"]) {
            self.phoneNumber = self.phoneTextFieldTextFields.text;
            [JKAlert alertText:@"短信已发出,请查看"];
            [self.verificationCenterView removeFromSuperview];
            [self completeView];
            
        }else
        {
            [JKAlert alertText:messageStr];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

}

#pragma mark 已完成
- (void)completeView
{
    // 按钮状态设置
    self.identityBtn.selected = NO;
    self.payPasswordBtn.selected = NO;
    self.completeBtn.selected = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.phoneNumber forKey:@"userNumber"];
    [defaults synchronize];
    
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.frame = CGRectMake(30,self.payPasswordBtn.sh_bottom + 50,ScreenWidth - 60,40);
    [completeBtn setTitle:@"已完成,点击返回" forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(completePopVc) forControlEvents:UIControlEventTouchUpInside];
    completeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    completeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [completeBtn setBackgroundColor:[UIColor colorWithHexString:@"#FF5001"]];
    [completeBtn setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    completeBtn.layer.cornerRadius = 5;
    completeBtn.clipsToBounds = YES;
    [self.view addSubview:completeBtn];

}

- (void)completePopVc
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.smsTextFields resignFirstResponder];
    [self.numberTextFields resignFirstResponder];
    [self.phoneTextFieldTextFields resignFirstResponder];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"修改手机验证";
    UIButton *leftButton = [[UIButton alloc]init];
    leftButton.frame = CGRectMake(0, 0,KNavBarBackBtnW, KNavBarBackBtnH);
    [leftButton setBackgroundImage:KNavBarBackIcon forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItems = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    nagetiveSpacer.width = KNavBarSpacing;   //这个值可以根据自己需要自己调整
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,leftBarButtonItems];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:KNavBarTittleFont],
       
       NSForegroundColorAttributeName:KNavBarTitleColor }];
    
    self.navigationController.navigationBar.barTintColor = KNavBarBarTintColor;
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
