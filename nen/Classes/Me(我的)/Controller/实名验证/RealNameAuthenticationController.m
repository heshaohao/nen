//
//  RealNameAuthenticationController.m
//  nen
//
//  Created by apple on 17/6/26.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "RealNameAuthenticationController.h"
#import "MMCheckTool.h"

@interface RealNameAuthenticationController ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *nameTextField;

// 身份证
@property(nonatomic,strong)UITextField *idCardTextField;
// 邀请码
@property(nonatomic,strong)UITextField *inviteCodeTextField;
// 客服电话
@property(nonatomic,strong)UITextField *customerServiceTelephoneTextField;

@property(nonatomic,strong) UIView *contenView;

@end

@implementation RealNameAuthenticationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    
    _contenView = [[UIView alloc] init];
    [self.view addSubview:_contenView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.frame = CGRectMake(10,10,150,25);
    nameLabel.textColor = [UIColor lightGrayColor];
    nameLabel.text = @"真实姓名:";
    [_contenView addSubview:nameLabel];
    
    _nameTextField = [[UITextField alloc] init];
    _nameTextField.backgroundColor = [UIColor whiteColor];
    _nameTextField.placeholder = @"  请输入与身份证姓名一致的真实姓名";
    _nameTextField.textColor = [UIColor lightGrayColor];
    _nameTextField.frame = CGRectMake(10,nameLabel.sh_bottom + 10,ScreenWidth - 20,35);
    _nameTextField.delegate = self;
    [_contenView addSubview:_nameTextField];
    
    UILabel *idCardLabel = [[UILabel alloc] init];
    idCardLabel.font = [UIFont systemFontOfSize:17];
    idCardLabel.frame = CGRectMake(10,_nameTextField.sh_bottom + 20,150,25);
    idCardLabel.textColor = [UIColor lightGrayColor];
    idCardLabel.text = @"身份证号码:";
    [_contenView addSubview:idCardLabel];
    
    _idCardTextField = [[UITextField alloc] init];
    _idCardTextField.backgroundColor = [UIColor whiteColor];
    _idCardTextField.placeholder = @"  请输入真实的身份证号码";
    _idCardTextField.textColor = [UIColor lightGrayColor];
    _idCardTextField.frame = CGRectMake(10,idCardLabel.sh_bottom + 10,ScreenWidth - 20,35);
    _idCardTextField.delegate = self;
    [_contenView addSubview:_idCardTextField];
    
    UILabel *inviteCodeLabel = [[UILabel alloc] init];
    inviteCodeLabel.font = [UIFont systemFontOfSize:17];
    inviteCodeLabel.frame = CGRectMake(10,_idCardTextField.sh_bottom + 20,150,25);
    inviteCodeLabel.textColor = [UIColor lightGrayColor];
    inviteCodeLabel.text = @"邀请码:";
    [_contenView addSubview:inviteCodeLabel];
    
    _inviteCodeTextField= [[UITextField alloc] init];
    _inviteCodeTextField.backgroundColor = [UIColor whiteColor];
    _inviteCodeTextField.placeholder = @"  请输入正确的邀请码  默认为0";
    _inviteCodeTextField.textColor = [UIColor lightGrayColor];
    _inviteCodeTextField.frame = CGRectMake(10,inviteCodeLabel.sh_bottom + 10,ScreenWidth - 20,35);
    _inviteCodeTextField.delegate = self;
    [_contenView addSubview:_inviteCodeTextField];
    
    UILabel *customerServiceTelephoneLabel = [[UILabel alloc] init];
    customerServiceTelephoneLabel.font = [UIFont systemFontOfSize:17];
    customerServiceTelephoneLabel.frame = CGRectMake(10,_inviteCodeTextField.sh_bottom + 20,150,25);
    customerServiceTelephoneLabel.textColor = [UIColor lightGrayColor];
    customerServiceTelephoneLabel.text = @"客服电话:";
    [_contenView addSubview:customerServiceTelephoneLabel];
    
    _customerServiceTelephoneTextField= [[UITextField alloc] init];
    _customerServiceTelephoneTextField.backgroundColor = [UIColor whiteColor];
    _customerServiceTelephoneTextField.placeholder = @"  请输入您商店的客服电话,方便客服联系您";
    _customerServiceTelephoneTextField.textColor = [UIColor lightGrayColor];
    _customerServiceTelephoneTextField.frame = CGRectMake(10,customerServiceTelephoneLabel.sh_bottom + 10,ScreenWidth - 20,35);
    _customerServiceTelephoneTextField.delegate = self;
    [_contenView addSubview:_customerServiceTelephoneTextField];
    
    
    UIButton *certificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    certificationBtn.layer.cornerRadius = 10;
    certificationBtn.clipsToBounds = YES;
    certificationBtn.frame = CGRectMake(30, _customerServiceTelephoneTextField.sh_bottom + 50,ScreenWidth - 60,40);
    [certificationBtn setTitle:@"开始认证" forState:UIControlStateNormal];
    [certificationBtn addTarget:self action:@selector(startCertification) forControlEvents:UIControlEventTouchUpInside];
    certificationBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    certificationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [certificationBtn setBackgroundColor:[UIColor orangeColor]];
    [_contenView addSubview:certificationBtn];
    
    _contenView.frame = CGRectMake(0,64,ScreenWidth,certificationBtn.sh_bottom + 10);
    
    
}

#pragma mark 开始验证按钮
- (void)startCertification
{
    
    if (![MMCheckTool isVaildRealName:self.nameTextField.text])
    {
        [JKAlert alertText:@"请输入正确的名称"];
        return;
        
    }
//    
//    if (![MMCheckTool isVaildIDCardNo:self.idCardTextField.text])
//    {
//            [JKAlert alertText:@"请输入正确的身证号码"];
//            return;
//   }
//    
//    
    if (![MMCheckTool isLandlineMobile:self.customerServiceTelephoneTextField.text])
    {
        [JKAlert alertText:@"输入的电话错误"];
        return;
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shop/certification"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSDictionary *dict = @{@"id_number":self.idCardTextField.text,@"real_name":self.nameTextField.text,@"recommend_code":_inviteCodeTextField.text,@"customer_mobile":_customerServiceTelephoneTextField.text};
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
       
        
        NSString *messesStr = responseObject[@"result"][@"resultMessage"];
        NSString *resultCodeStr = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
        
        if ([resultCodeStr isEqualToString:@"0"])
        {
            [JKAlert alertText:@"验证成功"];
            
            NSUserDefaults *defaluts = [NSUserDefaults standardUserDefaults];
             [defaluts setObject:@"1" forKey:@"is_audit"];
            [defaluts synchronize];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else
        {
            [JKAlert alertText:messesStr];
        }

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"实名验证";
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



//iOS TextField输入框点击键盘时随着键盘上移
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.customerServiceTelephoneTextField)
    {
        int offset = self.view.frame.origin.y - 65;//iPhone键盘高
        [UIView animateWithDuration:0.5 animations:^{
            self.contenView.transform = CGAffineTransformMakeTranslation(0, offset);
           
        }];
        
    }
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.customerServiceTelephoneTextField)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.contenView.transform = CGAffineTransformIdentity;
            
        }];
        
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.nameTextField resignFirstResponder];
    [self.inviteCodeTextField resignFirstResponder];
    [self.idCardTextField resignFirstResponder];
    [self.customerServiceTelephoneTextField resignFirstResponder];

    
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nameTextField resignFirstResponder];
    [self.inviteCodeTextField resignFirstResponder];
    [self.idCardTextField resignFirstResponder];
    [self.customerServiceTelephoneTextField resignFirstResponder];
}


@end
