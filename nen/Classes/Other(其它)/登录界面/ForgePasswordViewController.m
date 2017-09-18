//
//  ForgePasswordViewController.m
//  nen
//
//  Created by nenios101 on 2017/3/21.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ForgePasswordViewController.h"
#import "CodeButton.h"
#import "LoginAndRegisterTextFiled.h"
@interface ForgePasswordViewController ()<UITextFieldDelegate>
// 手机号
@property (strong, nonatomic)  LoginAndRegisterTextFiled *usernameTextField;
// 手机验证码
@property (strong, nonatomic)  LoginAndRegisterTextFiled *codeNumberTextField;
// 验证码按钮
@property (strong, nonatomic)  CodeButton *codeBtn;
// 设置密码
@property (strong, nonatomic)  LoginAndRegisterTextFiled *passwordTextField;
// 再次确认密码
@property (strong, nonatomic)  LoginAndRegisterTextFiled *doubleCheckPasswordTextField;

@property(strong,nonatomic) UILabel *rightLabels;


@end

@implementation ForgePasswordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self layoutOfChildControls];
}

- (void)layoutOfChildControls
{
    LoginAndRegisterTextFiled *userNameTextField = [[LoginAndRegisterTextFiled alloc] initWhitImageStr:@"phone"];
    self.usernameTextField = userNameTextField;
    userNameTextField.backgroundColor = [UIColor whiteColor];
    userNameTextField.alpha = 0.5;
    userNameTextField.layer.cornerRadius = 5;
    userNameTextField.clipsToBounds = YES;
    userNameTextField.delegate = self;
    userNameTextField.layer.borderWidth = 1.0f;
    userNameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    userNameTextField.placeholder = @"11位手机号码";
    userNameTextField.textColor = [UIColor lightGrayColor];
    userNameTextField.frame = CGRectMake(20,90,ScreenWidth - 40,40);
    [self.view addSubview:userNameTextField];
    
    UIView *codeBtnView = [[UIView alloc] init];
    codeBtnView.frame = CGRectMake(0,0,110,40);
    
    CodeButton *codeBtn = [CodeButton buttonWithType:UIButtonTypeCustom];
    self.codeBtn = codeBtn;
    codeBtn.frame = CGRectMake(0, 5,100,30);
    [codeBtn setTitle:@"验证码" forState:UIControlStateNormal];
    [codeBtn setBackgroundColor:[UIColor colorWithHexString:@"#FF5001"]];
    [codeBtn addTarget:self action:@selector(forgeCodeBtn:) forControlEvents:UIControlEventTouchUpInside];
    codeBtn.layer.cornerRadius = 5;
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    codeBtn.clipsToBounds = YES;
    codeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [codeBtnView addSubview:codeBtn];
    
    LoginAndRegisterTextFiled *codeTextField = [[LoginAndRegisterTextFiled alloc] initWhitImageStr:@"phone"];
    self.codeNumberTextField = codeTextField;
    self.usernameTextField = userNameTextField;
    codeTextField.rightView = codeBtnView;
    codeTextField.rightViewMode = UITextFieldViewModeAlways;
    codeTextField.backgroundColor = [UIColor whiteColor];
    codeTextField.alpha = 0.5;
    codeTextField.layer.cornerRadius = 5;
    codeTextField.clipsToBounds = YES;
    codeTextField.delegate = self;
    codeTextField.layer.borderWidth = 1.0f;
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    codeTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    codeTextField.placeholder = @"手机验证码";
    codeTextField.textColor = [UIColor lightGrayColor];
    codeTextField.frame = CGRectMake(20,userNameTextField.sh_bottom + 20,ScreenWidth - 40,40);
    [self.view addSubview:codeTextField];
    
   LoginAndRegisterTextFiled *passwordTextField = [[LoginAndRegisterTextFiled alloc] initWhitImageStr:@"Repeatpassword"];
    self.passwordTextField = passwordTextField;
    passwordTextField.backgroundColor = [UIColor whiteColor];
    [passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    passwordTextField.alpha = 0.5;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.layer.cornerRadius = 5;
    passwordTextField.clipsToBounds = YES;
    passwordTextField.delegate = self;
    passwordTextField.layer.borderWidth = 1.0f;
    passwordTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    passwordTextField.placeholder = @"6-12位密码";
    passwordTextField.textColor = [UIColor lightGrayColor];
    passwordTextField.frame = CGRectMake(20,codeTextField.sh_bottom + 20,ScreenWidth - 40,40);
    [self.view addSubview:passwordTextField];
    
    
    LoginAndRegisterTextFiled *doubleCheckPasswordTextField = [[LoginAndRegisterTextFiled alloc] initWhitImageStr:@"Repeatpassword"];
    self.doubleCheckPasswordTextField = doubleCheckPasswordTextField;
    doubleCheckPasswordTextField.backgroundColor = [UIColor whiteColor];
    doubleCheckPasswordTextField.secureTextEntry = YES;
    doubleCheckPasswordTextField.alpha = 0.5;
    doubleCheckPasswordTextField.layer.cornerRadius = 5;
    doubleCheckPasswordTextField.clipsToBounds = YES;
    doubleCheckPasswordTextField.delegate = self;
    doubleCheckPasswordTextField.layer.borderWidth = 1.0f;
    doubleCheckPasswordTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    doubleCheckPasswordTextField.placeholder = @"6-12位密码";
    doubleCheckPasswordTextField.textColor = [UIColor lightGrayColor];
    doubleCheckPasswordTextField.frame = CGRectMake(20,passwordTextField.sh_bottom + 20,ScreenWidth - 40,40);
    [self.view addSubview:doubleCheckPasswordTextField];
    
    UILabel *rightLabel = [[UILabel alloc] init];
    self.rightLabels = rightLabel;
    rightLabel.frame = CGRectMake(ScreenWidth - 120,doubleCheckPasswordTextField.sh_bottom +10,100,25);
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.text = @"密码强度";
    rightLabel.font = [UIFont systemFontOfSize:13];
    rightLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:rightLabel];
    
    
    UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.layer.cornerRadius = 5;
    commitBtn.clipsToBounds = YES;
    commitBtn.frame = CGRectMake(20,rightLabel.sh_bottom + 50,ScreenWidth - 40,40);
    [commitBtn setBackgroundColor:[UIColor colorWithHexString:@"#f97825"]];
    [commitBtn setTitle:@"提交"forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitBtn:) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:commitBtn];
    
}
#pragma mark 验证按钮
- (void)forgeCodeBtn:(UIButton *)sender {
    NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.usernameTextField.text];
    
    //NSString *numberStr = self.usernameTextField.text;
    if(isMatch) {
        //有效手机号
        [self.codeBtn timeFailBeginFrom:60];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        // 加密地址
        NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/mine/getcode"];
        
        // 获取手机号码
      //  double num = [numberStr doubleValue];
        NSDictionary *dict= @{@"mobile":self.usernameTextField.text};
        
        // POST数据
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
        
        [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [JKAlert alertText:@"验证码已发送，请查看"];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
          //  NSLog(@"%@",error);
            
        }];
        
    }else//无效手机号
    {
        [self.codeBtn timeFailBeginFrom:1];
        [JKAlert alertText:@"请输入正确的手机号"];
    }
    
}

#pragma mark 修改密码
- (void)commitBtn:(UIButton *)sender
{
   // double nuber = [self.usernameTextField.text doubleValue];
//    
  // NSString *passwordStr = self.passwordTextField.text;
//    
//    NSString *codeStr = self.codeNumberTextField.text;
    
    if (!(self.passwordTextField.text.length <6))
    {
        if ([self.passwordTextField.text isEqualToString: self.doubleCheckPasswordTextField.text])
        {
            NSDictionary *dict = @{@"mobile":self.usernameTextField.text,@"password":self.passwordTextField.text,@"code":self.codeNumberTextField.text,@"repassword":self.doubleCheckPasswordTextField.text};
            
            NSString *completeStr = [NSString stringEncryptedAddress:@"/mine/setpassword"];
            
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
                
              
                NSString *resultMessage = responseObject[@"result"][@"resultMessage"];
                 NSString *resultCode = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
                
                if ([resultCode isEqualToString:@"0"])
                {
                    [JKAlert alertText:@"修改成功"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else
                {
                    [JKAlert alertText:resultMessage];
                }
                
                
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
             //   NSLog(@"%@",error);
            }];
            
        }else
        {
          //  NSLog(@"错误");
        }
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
    [self.usernameTextField resignFirstResponder];
    [self.codeNumberTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.doubleCheckPasswordTextField resignFirstResponder];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}


@end
