//
//  VerificationViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/26.
//  Copyright © 2017年 nen. All rights reserved.
//支付验证

#import "VerificationViewController.h"
#import "generalButton.h"
#import "CodeButton.h"
#import "SetAccountTextField.h"

@interface VerificationViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) generalButton *identityBtn;

@property(nonatomic,strong) generalButton *payPasswordBtn;

@property(nonatomic,strong) CodeButton *codeBtn;

@property(nonatomic,strong) SetAccountTextField *numberTextFields;

@property(nonatomic,strong) SetAccountTextField *smsTextFields;

@property(nonatomic,strong) SetAccountTextField *passwordTextFields;

@property(nonatomic,strong) SetAccountTextField *againPasswordTextFields;

@property(nonatomic,strong) UIView *centernViews;

@property(nonatomic,strong) UILabel *rightLabels;

@property(nonatomic,copy) NSString *codeStr;

@property(nonatomic,strong) UILabel *oneLabel;

@property(nonatomic,strong) UILabel *twoLabel;

@end

@implementation VerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    
    generalButton *btn = [generalButton buttonWithType:UIButtonTypeCustom];
    self.identityBtn = btn;
    btn.frame = CGRectMake(30,90,100,90);
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
    btn2.frame = CGRectMake(ScreenWidth - 140,90,100,90);
    [btn2 setTitle:@"设置支付密码" forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"ZHUCESEKUAI2"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"ZHUCESEKUAI"] forState:UIControlStateSelected];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:btn2];
    
    
    _twoLabel = [[UILabel alloc] init];
    _twoLabel.frame = CGRectMake(self.payPasswordBtn.sh_x +(btn2.sh_width *0.5) - 5,self.payPasswordBtn.sh_y
                                 + 15,10,15);
    _twoLabel.textColor = [UIColor whiteColor];
    _twoLabel.text = @"2";
    _twoLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:_twoLabel];

    
   [self addCenteriew];
    
   
}

// 添加验证试图
- (void)addCenteriew
{
    // 设置按钮状态
    self.identityBtn.selected = YES;
    self.payPasswordBtn.selected = NO;
    
    
    UIView *centernView = [[UIView alloc] init];
    self.centernViews = centernView;
    centernView.frame = CGRectMake(15,self.identityBtn.sh_bottom + 20,ScreenWidth - 30,290);
    centernView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:centernView];
    
    UILabel *headLabel = [[UILabel alloc] init];
    headLabel.frame = CGRectMake(10, 10,centernView.sh_width - 20,25);
    headLabel.text = @"已验证手机";
    headLabel.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    headLabel.font = [UIFont systemFontOfSize:13];
    [centernView addSubview:headLabel];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    

    
    SetAccountTextField *numberTextField = [[SetAccountTextField alloc] init];
    self.numberTextFields = numberTextField;
    numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    numberTextField.frame = CGRectMake(headLabel.sh_x,headLabel.sh_bottom + 10,centernView.sh_width - 20,25);
    numberTextField.text = [defaults objectForKey:@"userNumber"];
    numberTextField.font = [UIFont systemFontOfSize:13];
    numberTextField.layer.borderWidth = 1.0f;
    numberTextField.layer.cornerRadius = 5;
    numberTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    numberTextField.clipsToBounds = YES;
    [centernView addSubview:numberTextField];
    
    CodeButton *testingBtn = [CodeButton buttonWithType:UIButtonTypeCustom];
    self.codeBtn = testingBtn;
    testingBtn.frame = CGRectMake(headLabel.sh_x ,numberTextField.sh_bottom + 10,centernView.sh_width *0.3,30);
    [testingBtn setTitle:@"验证码" forState:UIControlStateNormal];
    testingBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    testingBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [testingBtn setBackgroundColor:[UIColor colorWithHexString:@"#FF5001"]];
    [testingBtn addTarget:self action:@selector(testingClcik) forControlEvents:UIControlEventTouchUpInside];
    testingBtn.layer.cornerRadius = 5;
    testingBtn.clipsToBounds = YES;
    [centernView addSubview:testingBtn];
    
    
    UILabel *introductionsLabel = [[UILabel alloc] init];
    introductionsLabel.font = [UIFont systemFontOfSize:13];
    introductionsLabel.frame = CGRectMake(testingBtn.sh_x,testingBtn.sh_bottom + 10,headLabel.sh_width,35);
    introductionsLabel.text = @"若手机还无法接收验证短信,请拨打客服电话400-800-2004申诉更改验证手机";
    introductionsLabel.textColor = [UIColor lightGrayColor];
    introductionsLabel.numberOfLines = 0;
    [centernView addSubview:introductionsLabel];
    
    UILabel *verifyLabel = [[UILabel alloc] init];
    verifyLabel.frame = CGRectMake(testingBtn.sh_x,introductionsLabel.sh_bottom + 10,130,25);
    verifyLabel.text = @"请填写短信验证码";
    verifyLabel.font = [UIFont systemFontOfSize:15];
    [centernView addSubview:verifyLabel];
    
    
    SetAccountTextField *smsTextField = [[SetAccountTextField alloc] init];
    self.smsTextFields = smsTextField;
    smsTextField.delegate = self;
    smsTextField.frame = CGRectMake(verifyLabel.sh_x,verifyLabel.sh_bottom + 10,centernView.sh_width - 20,25);
    smsTextField.placeholder = @"请输入短信验证码";
    smsTextField.font = [UIFont systemFontOfSize:13];
    smsTextField.layer.borderWidth = 1.0f;
    smsTextField.layer.cornerRadius = 5;
    smsTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    smsTextField.clipsToBounds = YES;
    smsTextField.keyboardType = UIKeyboardTypePhonePad;
    [centernView addSubview:smsTextField];

    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(centernView.sh_width *0.1 ,smsTextField.sh_bottom + 10,centernView.sh_width *0.8,30);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [nextBtn setBackgroundColor:[UIColor colorWithHexString:@"#FF5001"]];
    [nextBtn addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 5;
    nextBtn.clipsToBounds = YES;
    [centernView addSubview:nextBtn];

    
}

#pragma mark 获取短信验证码
- (void)testingClcik
{
    [self.codeBtn timeFailBeginFrom:60];
    

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 加密地址
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/site/sendcode"];
    
    // 获取手机号码
    
    NSDictionary *dict= @{@"mobile":self.numberTextFields.text,@"type":@"4"};
    
   
    
    // POST数据
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
     //   NSLog(@"%@",responseObject);
         [JKAlert alertText:@"短信已发出,请查看"];
      
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}

//iOS TextField输入框点击键盘时随着键盘上移
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.smsTextFields)
    {
        int offset = self.view.frame.origin.y - 65;//iPhone键盘高
        [UIView animateWithDuration:0.5 animations:^{
            self.centernViews.transform = CGAffineTransformMakeTranslation(0, offset);
            self.payPasswordBtn.transform =CGAffineTransformMakeTranslation(0, offset);
            self.identityBtn.transform =CGAffineTransformMakeTranslation(0, offset);
            _oneLabel.transform = CGAffineTransformMakeTranslation(0, offset);
            _twoLabel.transform = CGAffineTransformMakeTranslation(0, offset);
        }];
        
    }
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.smsTextFields)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.centernViews.transform = CGAffineTransformIdentity;
            self.payPasswordBtn.transform = CGAffineTransformIdentity;
            self.identityBtn.transform = CGAffineTransformIdentity;
            _oneLabel.transform =CGAffineTransformIdentity;
            _twoLabel.transform =CGAffineTransformIdentity;
            
        }];
        
    }
}


#pragma mark 下一步按钮点击
- (void)nextClick
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 加密地址 判断输入的验证码是否正确
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/mine/checkcode"];
    
    // 获取手机号码
    
    NSDictionary *dict= @{@"mobile":self.numberTextFields.text,@"type":@"4",@"code":self.smsTextFields.text};
    
    self.codeStr = self.smsTextFields.text;
    
    // POST数据
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
       // NSLog(@"%@",responseObject);
        
        
        NSString *stateStr = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultMessage"]];
        
        if ([stateStr isEqualToString:@"SUCCESS"])
        {
            [self.centernViews removeFromSuperview];
            [self passwordCenter];
            [JKAlert alertText:@"验证成功"];
            
        }else
        {
            [JKAlert alertText:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultMessage"]]];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

}


#pragma mark 添加密码视图
- (void)passwordCenter
{
    // 设置按钮状态
    self.identityBtn.selected = NO;
    self.payPasswordBtn.selected = YES;
    
    UIView *passwordCenterView = [[UIView alloc] init];
    passwordCenterView.frame = CGRectMake(15,self.identityBtn.sh_bottom + 20,ScreenWidth - 30,270);
    passwordCenterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:passwordCenterView];
    
    UILabel *headLabel = [[UILabel alloc] init];
    headLabel.frame = CGRectMake(10, 10,passwordCenterView.sh_width - 20,25);
    headLabel.text = @"设置密码";
    headLabel.font = [UIFont systemFontOfSize:13];
    [passwordCenterView addSubview:headLabel];

    SetAccountTextField *passwordTextField = [[SetAccountTextField alloc] init];
    self.passwordTextFields = passwordTextField;
    [passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    passwordTextField.delegate = self;
    passwordTextField.keyboardType = UIKeyboardTypeDefault;
    [passwordTextField setSecureTextEntry:YES];
    passwordTextField.frame = CGRectMake(headLabel.sh_x,headLabel.sh_bottom + 5,passwordCenterView.sh_width - 20,25);
    passwordTextField.font = [UIFont systemFontOfSize:13];
    passwordTextField.layer.borderWidth = 1.0f;
    passwordTextField.layer.cornerRadius = 5;
    passwordTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    passwordTextField.clipsToBounds = YES;
    [passwordCenterView addSubview:passwordTextField];
    
    UILabel *inputAgainLabel = [[UILabel alloc] init];
    inputAgainLabel.frame = CGRectMake(10, passwordTextField.sh_bottom + 10,passwordCenterView.sh_width - 20,25);
    inputAgainLabel.text = @"请重新输入一遍:";
    inputAgainLabel.font = [UIFont systemFontOfSize:13];
    [passwordCenterView addSubview:inputAgainLabel];
    
    SetAccountTextField *againPasswordTextField = [[SetAccountTextField alloc] init];
    againPasswordTextField.delegate = self;
    self.againPasswordTextFields = againPasswordTextField;
    againPasswordTextField.keyboardType = UIKeyboardTypeDefault;
    againPasswordTextField.frame = CGRectMake(headLabel.sh_x,inputAgainLabel.sh_bottom + 5,passwordCenterView.sh_width - 20,25);
    againPasswordTextField.font = [UIFont systemFontOfSize:13];
    [againPasswordTextField setSecureTextEntry:YES];
    againPasswordTextField.layer.borderWidth = 1.0f;
    againPasswordTextField.layer.cornerRadius = 5;
    againPasswordTextField.placeholder = @"请重新输入密码";
    againPasswordTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    againPasswordTextField.clipsToBounds = YES;
    [passwordCenterView addSubview:againPasswordTextField];
    
    UILabel *rightLabel = [[UILabel alloc] init];
    self.rightLabels = rightLabel;
    rightLabel.frame = CGRectMake(10, againPasswordTextField.sh_bottom + 5,passwordCenterView.sh_width - 20,25);
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.text = @"密码强度 ";
    rightLabel.font = [UIFont systemFontOfSize:13];
    rightLabel.textColor = [UIColor lightGrayColor];
    [passwordCenterView addSubview:rightLabel];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(passwordCenterView.sh_width *0.1 ,rightLabel.sh_bottom + 15,passwordCenterView.sh_width *0.8,30);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [submitBtn setBackgroundColor:[UIColor colorWithHexString:@"#FF5001"]];
    submitBtn.layer.cornerRadius = 5;
    submitBtn.clipsToBounds = YES;
    [passwordCenterView addSubview:submitBtn];
    
}

#pragma mark 提交按钮
- (void)submitClick
{
    
    if ([self.passwordTextFields.text isEqualToString:self.againPasswordTextFields.text])
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        // 加密地址
        NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/site/paypassword"];
        
        // 获取手机号码
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *mobileStr = [defaults objectForKey:@"userNumber"];
        
        NSDictionary *dict= @{@"mobile":mobileStr,@"password":self.passwordTextFields.text,@"code":self.codeStr};
        
        // POST数据
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
        
        [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            
         //   NSLog(@"%@",responseObject);
            
            
            if ([responseObject[@"result"][@"resultMessage"] isEqualToString:@"SUCCESS"]) {
                
                [JKAlert alertText:@"设置成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }

            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSLog(@"%@",error);
            
        }];

        
        
    }else
    {
        [JKAlert alertText:@"输入密码不一致"];
    }
    
}

#pragma mark 监听文本输入
- (void)textFieldDidChange:(UITextField *)textField
{
    
    if (textField.text.length == 0)
    {
        self.rightLabels.text = @"密码强度 ";
    }else if(textField.text.length <= 1 || textField.text.length <= 6)
    {
        self.rightLabels.text = [NSString stringWithFormat:@"密码强度 弱"];
    }else if(textField.text.length > 6 || textField.text.length < 12)
    {
        self.rightLabels.text = [NSString stringWithFormat:@"密码强度 中"];
    }
    
    if(textField.text.length >= 12)
    {
        self.rightLabels.text = [NSString stringWithFormat:@"密码强度 强"];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.smsTextFields resignFirstResponder];
    [self.numberTextFields resignFirstResponder];
    [self.passwordTextFields resignFirstResponder];
    [self.againPasswordTextFields resignFirstResponder];
}

// 键盘返回按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.passwordTextFields || textField == self.againPasswordTextFields)
    {
        [self.passwordTextFields resignFirstResponder];
        [self.againPasswordTextFields resignFirstResponder];
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"支付验证";
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
