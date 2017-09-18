//
//  WithdrawCashViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/26.
//  Copyright © 2017年 nen. All rights reserved.
// 金额提现

#import "WithdrawCashViewController.h"

@interface WithdrawCashViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField *cashTextField;

@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) UITextField *PlayPasswordTextFied;

@end

@implementation WithdrawCashViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavBar];
}

- (void)setNavBar
{
    self.navigationItem.title = @"现金提现";
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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(15,100,100,20);
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.text = @"提现金额";
    [self.view addSubview:titleLabel];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.font = [UIFont systemFontOfSize:20];
    moneyLabel.frame = CGRectMake(15,titleLabel.sh_bottom + 10,20,20);
    moneyLabel.text = @"¥";
    [self.view addSubview:moneyLabel];
    
    self.cashTextField = [[UITextField alloc] init];
    self.cashTextField.frame = CGRectMake(moneyLabel.sh_right,moneyLabel.sh_y,ScreenWidth - 60,15);
    self.cashTextField.delegate = self;
    self.cashTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.cashTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.cashTextField.tintColor = [UIColor violetColor];
    [self.view addSubview:self.cashTextField];
    
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(self.cashTextField.sh_x,self.cashTextField.sh_bottom,self.cashTextField.sh_width,1);
    self.bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bottomView];
    
    UILabel *playLabel = [[UILabel alloc] init];
    playLabel.frame = CGRectMake(15,self.bottomView.sh_bottom + 30,100,20);
    playLabel.font = [UIFont systemFontOfSize:13];
    playLabel.textColor = [UIColor lightGrayColor];
    playLabel.text = @"支付密码";
    [self.view addSubview:playLabel];
    
    self.PlayPasswordTextFied = [[UITextField alloc] init];
    self.PlayPasswordTextFied.frame = CGRectMake(15,playLabel.sh_bottom + 10,ScreenWidth - 40,30);
    self.PlayPasswordTextFied.delegate = self;
    self.PlayPasswordTextFied.autocorrectionType = UITextAutocorrectionTypeNo;
    self.PlayPasswordTextFied.keyboardType = UIKeyboardTypeDefault;
    self.PlayPasswordTextFied.tintColor = [UIColor violetColor];
    self.PlayPasswordTextFied.layer.borderWidth = 1.0f;
    self.PlayPasswordTextFied.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.PlayPasswordTextFied setSecureTextEntry:YES];
    self.PlayPasswordTextFied.layer.cornerRadius = 5;
    self.PlayPasswordTextFied.clipsToBounds = YES;
    [self.view addSubview:self.PlayPasswordTextFied];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenWidth *0.15,self.PlayPasswordTextFied.sh_bottom + 50,ScreenWidth *0.7,30);
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn addTarget:self action:@selector(withdrawClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    [btn setBackgroundColor:[UIColor orpimentColor]];
    [self.view addSubview:btn];
}

- (void)withdrawClick:(UIButton *)btn
{
 
    
    btn.userInteractionEnabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 加密地址
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/wallet/tixian"];
    
    NSDictionary *dict= @{@"money":self.cashTextField.text,@"password":self.PlayPasswordTextFied.text,@"type":@"wx"};
    
    // POST数据
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
       // NSLog(@"%@",responseObject);
        
        NSString *resultMessageStr = responseObject[@"result"][@"resultMessage"];
        
        if ([resultMessageStr isEqualToString:@"SUCCESS"])
        {
            [JKAlert alertText:@"提取成功"];
            self.PlayPasswordTextFied.text = nil;
            self.cashTextField.text = nil;
            btn.userInteractionEnabled = NO;
        }else
        {
            [JKAlert alertText:resultMessageStr];
            btn.userInteractionEnabled = NO;
        }
            
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    


}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSDictionary *dict = @{@"popStr":@"1"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pop" object:self userInfo:dict];
    
}

// 键盘返回按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.PlayPasswordTextFied)
    {
        [self.cashTextField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //开始编辑时触发，文本字段将成为first responder
    if (textField == self.cashTextField)
    {
        self.bottomView.backgroundColor = [UIColor violetColor];
    }
}

// 结束文本编辑
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.cashTextField)
    {
        self.bottomView.backgroundColor = [UIColor blackColor];
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.cashTextField resignFirstResponder];
    [self.PlayPasswordTextFied resignFirstResponder];
}

@end
