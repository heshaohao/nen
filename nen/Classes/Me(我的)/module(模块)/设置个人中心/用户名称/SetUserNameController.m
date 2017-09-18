//
//  SetUserNameController.m
//  nen
//
//  Created by nenios101 on 2017/6/15.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "SetUserNameController.h"

@interface SetUserNameController ()<UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,strong) UITextField *contentTextField;

@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) UILabel *bottomRightLabel;



@end

@implementation SetUserNameController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    
    UIButton *rightButton = [[UIButton alloc]init];
    rightButton.frame = CGRectMake(0, 0, 30, 25);
    [rightButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *rightBarButtonItems = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *rightNagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    rightNagetiveSpacer.width = 5;//这个值可以根据自己需要自己调整
    self.navigationItem.rightBarButtonItems = @[rightNagetiveSpacer, rightBarButtonItems];
    
    
    self.navigationItem.title = @"用户名";
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

#pragma mark 导航栏完成
-(void)finishAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
    NSString *titleContentStr = self.contentTextField.text;
    
    NSDictionary *dict1;
    
    
        if (titleContentStr.length !=0)
        {
            dict1 = @{@"group":self.group,@"row":self.row,@"title":titleContentStr};
            
        }else
        {
            dict1 = @{@"group":self.group,@"row":self.row,@"title":@"请输入用户名"};
        }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/mine/setname"];
    
     NSDictionary  *dict = @{@"name":titleContentStr};
    
    [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setUserName" object:self userInfo:dict1];
       
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
    }];
    

    

}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor]; 
    
    self.contentTextField = [[UITextField alloc] init];
    self.contentTextField.frame = CGRectMake(10,80,ScreenWidth - 10,30);
    self.contentTextField.delegate = self;
    self.contentTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.contentTextField.font = [UIFont systemFontOfSize:15];
    self.contentTextField.keyboardType = UIKeyboardTypeDefault;
    [self.contentTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    self.contentTextField.tintColor = [UIColor violetColor];
    self.contentTextField.textColor = [UIColor lightGrayColor];
    self.contentTextField.placeholder = @"请输入用户名";
    [self.view addSubview:self.contentTextField];
    
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(self.contentTextField.sh_x,self.contentTextField.sh_bottom,self.contentTextField.sh_width,1);
    self.bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bottomView];
    
    self.bottomRightLabel = [[UILabel alloc] init];
    self.bottomRightLabel.frame = CGRectMake(ScreenWidth - 110,self.bottomView.sh_bottom + 10,100,20);
    self.bottomRightLabel.text = @"20字以内";
    self.bottomRightLabel.font = [UIFont systemFontOfSize:13];
    self.bottomRightLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.bottomRightLabel];
    
//    NSInteger group = [self.group integerValue];
//    NSInteger row = [self.row integerValue];
    
    
  
}
#pragma mark textFieldChange

- (void)textFieldChange:(UITextField *)textField
{
    self.bottomRightLabel.text = [NSString  stringWithFormat:@"还可以输入%d字",20 - textField.text.length];
    
    if (textField.text.length >= 20)
    {
        textField.text = [textField.text substringToIndex:20];
        self.bottomRightLabel.text = [NSString  stringWithFormat:@"还可以输入%d字",20 - textField.text.length];
    }
    
}
// 键盘返回按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.contentTextField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //开始编辑时触发，文本字段将成为first responder
    if (textField == self.contentTextField)
    {
        self.bottomView.backgroundColor = [UIColor violetColor];
    }
}

// 结束文本编辑
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.contentTextField)
    {
        self.bottomView.backgroundColor = [UIColor blackColor];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.contentTextField resignFirstResponder];
    
}



@end
