//
//  LoginAndRegisterViewController.m
//  nen
//
//  Created by nenios101 on 2017/3/21.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "LoginAndRegisterViewController.h"
#import "SHTabBarViewController.h"
#import "RegisterViewController.h"
#import "ForgePasswordViewController.h"
#import "JPUSHService.h"
#import "LoginAndRegisterTextFiled.h"

// 引导页
#import "DHGuidePageHUD.h"

// 环信
#import "EMError.h"
#import "ChatUIHelper.h"
#import "MBProgressHUD.h"
#import "RedPacketUserConfig.h"

@interface LoginAndRegisterViewController ()<UITextFieldDelegate>
@property (strong, nonatomic)  LoginAndRegisterTextFiled *usernameTextField;

@property (strong, nonatomic)  LoginAndRegisterTextFiled *passwordTextField;

@property(weak,nonatomic)MBProgressHUD *HUD;
@end

@implementation LoginAndRegisterViewController

+ (LoginAndRegisterViewController *)sharedManager
{
    static LoginAndRegisterViewController *loginManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        loginManager = [[self alloc] init];
    });
    return loginManager;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
//        // 静态引导页
//        [self setStaticGuidePage];
//        
//        // 动态引导页
//        // [self setDynamicGuidePage];
//        
//        // 视频引导页
//        // [self setVideoGuidePage];
//    }

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 键盘关闭 联想 开头大写
    
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#e45b02"];
    
    UIImageView *iconImage = [[UIImageView alloc] init];
    iconImage.frame = CGRectMake(ScreenWidth *0.5 - 50,100,100,100);
    iconImage.image = [UIImage imageNamed:@"loginicon"];
    iconImage.layer.cornerRadius = 50;
    iconImage.clipsToBounds = YES;
    [self.view addSubview:iconImage];

    
    LoginAndRegisterTextFiled *userNameTextField = [[LoginAndRegisterTextFiled alloc] initWhitImageStr:@"userImage"];
    self.usernameTextField = userNameTextField;
    [_usernameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_usernameTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    userNameTextField.keyboardType = UIKeyboardTypeNumberPad;
    userNameTextField.backgroundColor = [UIColor whiteColor];
    userNameTextField.textColor = [UIColor blackColor];
    userNameTextField.alpha = 0.5;
    userNameTextField.layer.cornerRadius = 5;
    userNameTextField.clipsToBounds = YES;
    userNameTextField.delegate = self;
    userNameTextField.placeholder = @"请输入手机号";
    userNameTextField.frame = CGRectMake(20,iconImage.sh_bottom + 50,ScreenWidth - 40,40);
    [self.view addSubview:userNameTextField];
    self.usernameTextField.text = [defaults objectForKey:@"userNumber"];
    
    
    LoginAndRegisterTextFiled *passwordTextFields = [[LoginAndRegisterTextFiled alloc] initWhitImageStr:@"Loginpassword"];
    self.passwordTextField = passwordTextFields;
    [_passwordTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_passwordTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    passwordTextFields.secureTextEntry = YES;
    passwordTextFields.backgroundColor = [UIColor whiteColor];
    passwordTextFields.alpha = 0.5;
    passwordTextFields.layer.cornerRadius = 5;
    passwordTextFields.textColor = [UIColor blackColor];
    passwordTextFields.clipsToBounds = YES;
    passwordTextFields.delegate = self;
    passwordTextFields.placeholder = @"请输入密码";
    passwordTextFields.frame = CGRectMake(20,userNameTextField.sh_bottom + 20,ScreenWidth - 40,40);
    
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(0,0,50,40);
    passwordTextFields.leftView = leftView;
    passwordTextFields.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *leftImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftImageBtn.frame = CGRectMake(10, 5, 30, 30);
    [leftImageBtn setBackgroundImage:[UIImage imageNamed:@"hidePassword"] forState:UIControlStateNormal];
    [leftImageBtn setBackgroundImage:[UIImage imageNamed:@"displayPassword"] forState:UIControlStateSelected];
    [leftImageBtn addTarget:self action:@selector(showAndHideThePassword:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:leftImageBtn];
    
    [self.view addSubview:passwordTextFields];
    self.passwordTextField.text = [defaults objectForKey:@"password"];

    
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.clipsToBounds = YES;
    loginBtn.frame = CGRectMake(20,passwordTextFields.sh_bottom + 30,ScreenWidth - 40,40);
    [loginBtn setBackgroundColor:[UIColor colorWithHexString:@"#f97825"]];
    [loginBtn setTitle:@"登录"forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtn:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:loginBtn];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.layer.cornerRadius = 5;
    registerBtn.clipsToBounds = YES;
    registerBtn.frame = CGRectMake(ScreenWidth *0.5 - 100,loginBtn.sh_bottom + 30,80,20);
    registerBtn.backgroundColor = [UIColor clearColor];
    [registerBtn setTitle:@"立即注册"forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:registerBtn];
    
    
    UIView *ceternView = [[UIView alloc] init];
    ceternView.frame = CGRectMake(ScreenWidth *0.5 - 0.5,loginBtn.sh_bottom + 30,1,20);
    ceternView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:ceternView];
    
    
    UIButton *forgrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgrBtn.layer.cornerRadius = 5;
    forgrBtn.clipsToBounds = YES;
    forgrBtn.frame = CGRectMake(ceternView.sh_right + 20,loginBtn.sh_bottom + 30,80,20);
    forgrBtn.backgroundColor = [UIColor clearColor];
    [forgrBtn setTitle:@"忘记密码"forState:UIControlStateNormal];
    [forgrBtn addTarget:self action:@selector(forgrBtnClick) forControlEvents:UIControlEventTouchUpInside];
    forgrBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:forgrBtn];
    
}



#pragma mark 显示和隐藏密码 
- (void)showAndHideThePassword:(UIButton *)btn
{
    
     btn.selected = !btn.isSelected;
    
    if (btn.isSelected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.passwordTextField.text;
        self.passwordTextField.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.passwordTextField.secureTextEntry = NO;
        self.passwordTextField.text = tempPwdStr;
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.passwordTextField.text;
        self.passwordTextField.text = @"";
        self.passwordTextField.secureTextEntry = YES;
        self.passwordTextField.text = tempPwdStr;
        
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.passwordTextField && textField.isSecureTextEntry) {
        textField.text = toBeString;
        return NO;
    }
    return YES;
}




//#pragma mark - 设置APP静态图片引导页
//- (void)setStaticGuidePage {
//    NSArray *imageNameArray = @[@"guide1",@"guide2",@"guide3",@"guide4"];
//    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.frame imageNameArray:imageNameArray buttonIsHidden:NO];
//    guidePage.slideInto = YES;
//    [self.navigationController.view addSubview:guidePage];
//}

#pragma mark 点击立即注册
-(void)registerBtnClick
{
    [self.navigationController pushViewController:[[RegisterViewController alloc] init] animated:YES];
}
#pragma mark 点击忘记密码
-(void)forgrBtnClick
{
   [self.navigationController pushViewController:[[ForgePasswordViewController alloc] init] animated:YES];
}


#pragma mark 获取key 和 secret
- (void)setupData{
    
    NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
    NSString *recordStr = [defaluts objectForKey:@"key"];
    [defaluts synchronize];
    
    if (!recordStr.length) {
        AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
        
        
        [manager GET:@"http://api.neno2o.com/site/token" parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary * responseObject) {
            
            NSDictionary *dict = responseObject[@"obj"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:dict[@"key"] forKey:@"key"];
            [defaults setObject:dict[@"secret"] forKey:@"secret"];
            [defaults synchronize];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
           // NSLog(@"获取数据失败");
        }];
        
    }
}

#pragma mark 登录按钮
- (void)loginBtn:(UIButton *)sender
{
    
    if (self.usernameTextField.text.length == 0 || self.passwordTextField.text.length == 0)
    {
        [JKAlert alertText:@"没有输入账号或密码"];
        return ;
    }
    
    double number = [self.usernameTextField.text doubleValue];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/site/login"];
    
    NSDictionary *dict = @{@"username":@(number),@"password":self.passwordTextField.text};
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    

            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
                
               // NSDictionary *dic = responseObject[@"obj"];
                
                NSString *codeStr = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
                
                NSString *messageStr = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultMessage"]];
                
                
                if ([codeStr isEqualToString:@"0"])
                {
                    NSString *is_wx = [NSString stringWithFormat:@"%@",responseObject[@"obj"][@"is_wx"]];
                    
                    NSString *user_Id = [NSString stringWithFormat:@"%@",responseObject[@"obj"][@"id"]];
                    
                    NSString *is_audit = [NSString stringWithFormat:@"%@",responseObject[@"obj"][@"is_audit"]];
                    
                 //   NSLog(@"%@",is_audit);
                    
                    // 保存用户实名制 1是
                    [defaults setObject:is_audit forKey:@"is_audit"];
                    
                    // 保存用户是否绑定微信
                    [defaults setObject:is_wx forKey:@"is_wx"];
                    
                    // 保存用户ID
                    [defaults setObject:user_Id forKey:@"user_Id"];
                    
                    [defaults synchronize];
                    [defaults setObject:@"1" forKey:@"is_login"];
                    [defaults setObject:self.usernameTextField.text forKey:@"userNumber"];
                    [defaults setObject:self.passwordTextField.text forKey:@"password"];
                    
                    NSString *pushAlias = [defaults objectForKey:@"user_Id"];
                    
                    [defaults synchronize];
                    
                    // 根据用户ID设置推送别名
                    [JPUSHService setAlias:pushAlias callbackSelector:nil object:nil];
                    
                     // NSLog(@"%@",responseObject);
                    
                    [self loginWithUsername:self.usernameTextField.text password:@"kagnwei2017"];
                    
                }else
                {
                    
                    [JKAlert alertText:messageStr];
                }
                
                //隐藏
               // [hud hideAnimated:YES];
                
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
              NSLog(@"%@",error);
                //错误提示
           // hud.label.text = @"用户名或密码错误";
           // hud.detailsLabel.text = @"";
            
            //隐藏
            }];
}

//点击登陆后的操作
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    [self showHudInView:self.view hint:NSLocalizedString(@"login.ongoing", @"Is Login..")];
    //异步登陆账号
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] loginWithUsername:username password:password];
        
        NSLog(@"%@",error.errorDescription);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself hideHud];
            if (!error) {
                //设置是否自动登录
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                
                //获取数据库中数据
                [MBProgressHUD showHUDAddedTo:weakself.view animated:YES];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[EMClient sharedClient] migrateDatabaseToLatestSDK];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[ChatUIHelper shareHelper] asyncGroupFromServer];
                        [[ChatUIHelper shareHelper] asyncConversationFromDB];
                        [[ChatUIHelper shareHelper] asyncPushOptions];
                        [MBProgressHUD hideAllHUDsForView:weakself.view animated:YES];
                        //发送自动登陆状态通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[EMClient sharedClient] isLoggedIn])];
                        
                        //保存最近一次登录用户名
                        [weakself saveLastLoginUsername];
                        // 切换底部控制器
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        SHTabBarViewController *tabVc = [SHTabBarViewController sharedManager];
                        [UIApplication sharedApplication].keyWindow.rootViewController = tabVc;
                        
                        [JKAlert alertText:@"登录成功"];
                        
                    });
                });
            } else {

                [JKAlert alertText:[NSString stringWithFormat:@"%@",error.errorDescription]];
            }
        });
    });
}


#pragma  #pragma  mark - private
- (void)saveLastLoginUsername
{
    NSString *username = [[EMClient sharedClient] currentUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
        [ud synchronize];
    }
}




//#pragma mark 登录完成后调用
//- (void)loginComplete
//{
//    
//    NSString *loginCompleteStr = [NSString stringEncryptedAddress:@"/site/index"];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//   
//    [manager POST:loginCompleteStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//    
//        
//        NSLog(@"%@",responseObject);
//        
//        NSString *coder = responseObject[@"result"][@"resultCode"];
//        if ([coder isEqualToString:@"0"])
//        {
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setObject:@"1" forKey:@"is_login"];
//            [defaults setObject:self.usernameTextField.text forKey:@"userNumber"];
//            [defaults setObject:self.passwordTextField.text forKey:@"password"];
//            
//            NSString *pushAlias = [defaults objectForKey:@"user_Id"];
//            
//            [defaults synchronize];
//            
//            // 根据用户ID设置推送别名
//            [JPUSHService setAlias:pushAlias callbackSelector:nil object:nil];
//            
//            //  NSLog(@"%@",responseObject);
//            
//            
//            // 切换底部控制器
//            SHTabBarViewController *tabVc = [SHTabBarViewController sharedManager];
//            [UIApplication sharedApplication].keyWindow.rootViewController = tabVc;
//            tabVc.selectedIndex = 0;
//
//        }
//        
//        
////        [self presentViewController:tabVc animated:YES completion:^{
////            
//////            [self removeFromParentViewController];
////            
////        }];
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error);
//    }];
//}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self setNavBar];
}

#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"登录和注册";
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




-(void)dealloc{
    
}


@end
