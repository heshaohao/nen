//
//  TheProblemOfFeedbackController.m
//  nen
//
//  Created by nenios101 on 2017/6/15.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "TheProblemOfFeedbackController.h"

@interface TheProblemOfFeedbackController ()<UITextViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong) UITextView *shopTextView;

@property(nonatomic,strong) UITextField *contentTextField;

@end

@implementation TheProblemOfFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
  
    UILabel *headLabel = [[UILabel alloc] init];
    headLabel.frame = CGRectMake(10, 80,200,25);
    headLabel.text = @"反馈内容";
    headLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:headLabel];
    
    
    self.shopTextView = [[UITextView alloc] init];
    self.shopTextView.delegate = self;
    self.shopTextView.textColor = [UIColor lightGrayColor];
    self.shopTextView.frame = CGRectMake(10,headLabel.sh_bottom + 10,ScreenWidth - 20,200);
    self.shopTextView.layer.borderWidth = 2.0f;
    self.shopTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.shopTextView.text = @"我们的产品离不开您的反馈";
    self.shopTextView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.shopTextView];
    
    UILabel *contactLabel = [[UILabel alloc] init];
    contactLabel.frame = CGRectMake(10, self.shopTextView.sh_bottom + 10,200,25);
    contactLabel.text = @"联系方式";
    contactLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:contactLabel];
    
    UIView *contenLeftView = [[UIView alloc] init];
    contenLeftView.frame = CGRectMake(0,0,10,40);
    
    self.contentTextField = [[UITextField alloc] init];
    self.contentTextField.leftView = contenLeftView;
    self.contentTextField.leftViewMode = UITextFieldViewModeAlways;
    self.contentTextField.frame = CGRectMake(10,contactLabel.sh_bottom  + 10,ScreenWidth - 20,40);
    self.contentTextField.delegate = self;
    self.contentTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.contentTextField.layer.borderWidth = 2.0f;
    self.contentTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentTextField.layer.cornerRadius = 5;
    self.contentTextField.clipsToBounds = YES;
    self.contentTextField.font = [UIFont systemFontOfSize:15];
    self.contentTextField.keyboardType = UIKeyboardTypeDefault;
    self.contentTextField.placeholder = @"请输入您的邮箱地址";
    self.contentTextField.textColor = [UIColor lightGrayColor];
    [self.view addSubview:self.contentTextField];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(20 ,self.contentTextField.sh_bottom + 50,ScreenWidth - 40,40);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [submitBtn setBackgroundColor:[UIColor colorWithHexString:@"#FF5001"]];
    [submitBtn setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 5;
    submitBtn.clipsToBounds = YES;
    [self.view addSubview:submitBtn];
}


#pragma mark 提交按钮
- (void)submitBtnClick
{
    if ([self.shopTextView.text isEqualToString:@"我们的产品离不开您的反馈"] || self.shopTextView.text.length == 0)
    {
        [JKAlert alertText:@"请输入反馈内容"];
        return ;
    }
        
    
    if (![self isValidateEmail:self.contentTextField.text])
    {
        [JKAlert alertText:@"输入的邮箱格式不正确"];
        return ;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 加密地址
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/mine/setfeedback"];
    
    
    NSDictionary *dict= @{@"content":self.shopTextView.text,@"email":self.contentTextField.text};
    // POST数据
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
       /// NSLog(@"%@",responseObject);
        
        [JKAlert alertText:@"反馈成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
    }];

    
    
}


-(BOOL)isValidateEmail:(NSString *)email

{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

#pragma mark textFieldDelegate
// 键盘返回按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.contentTextField resignFirstResponder];
    return YES;
    
}


#pragma mark textViewDelegate
// 文本开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    if([textView.text isEqualToString:@"我们的产品离不开您的反馈"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}

//输入框编辑完成以后，将视图恢复到原始状态
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"我们的产品离不开您的反馈";
        textView.textColor = [UIColor grayColor];
    }
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.shopTextView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
     [self.contentTextField resignFirstResponder];
    [self.shopTextView resignFirstResponder];
    
}

#pragma mark 设置导航栏

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"问题反馈";
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
