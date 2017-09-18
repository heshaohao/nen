//
//  SetTheControllerViewController.m
//  nen
//
//  Created by nenios101 on 2017/6/7.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "SetTheControllerViewController.h"

@interface SetTheControllerViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,strong) UITextField *contentTextField;

@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) UILabel *bottomRightLabel;

@property(nonatomic,strong) UITextView *shopTextView;

@end

@implementation SetTheControllerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBar];
    
    UIButton *rightButton = [[UIButton alloc]init];
    rightButton.frame = CGRectMake(0, 0, 30, 25);
    [rightButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    UIBarButtonItem *rightBarButtonItems = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    nagetiveSpacer.width = -12;//这个值可以根据自己需要自己调整
    self.navigationItem.rightBarButtonItems = @[nagetiveSpacer, rightBarButtonItems];

}

#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"店铺设置";
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
    
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    
    self.navigationController.navigationBar.barTintColor = KNavBarBarTintColor;
    
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self.group isEqualToString:@"1"] && [self.row isEqualToString:@"1"])
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.frame = CGRectMake(10,74,100,20);
        titleLabel.text = @"店铺介绍:";
        [self.view addSubview:titleLabel];
        
        self.shopTextView = [[UITextView alloc] init];
        self.shopTextView.delegate = self;
        self.shopTextView.textColor = [UIColor lightGrayColor];
        self.shopTextView.frame = CGRectMake(10,titleLabel.sh_bottom + 5,ScreenWidth - 20,100);
        self.shopTextView.layer.borderWidth = 2.0f;
        self.shopTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.shopTextView.text = @"请输入店铺介绍";
        self.shopTextView.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:self.shopTextView];
        
    }else
    {
        self.contentTextField = [[UITextField alloc] init];
        self.contentTextField.frame = CGRectMake(10,80,ScreenWidth - 10,30);
        self.contentTextField.delegate = self;
        self.contentTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.contentTextField.font = [UIFont systemFontOfSize:15];
        self.contentTextField.keyboardType = UIKeyboardTypeDefault;
        [self.contentTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        self.contentTextField.tintColor = [UIColor violetColor];
        self.contentTextField.textColor = [UIColor lightGrayColor];
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
        
        NSInteger group = [self.group integerValue];
        NSInteger row = [self.row integerValue];
        
        if (group == 1 && self.row == 0)
        {
            self.contentTextField.placeholder = @"请输入商店名称";
        }else if (group == 2 && row == 0)
        {
            self.contentTextField.placeholder = @"请输入发货地址";
        }else if(group == 2  && row == 1)
        {
            self.contentTextField.placeholder = @"请输入退货地址";
        }else if (group == 3 && row == 0)
        {
            self.contentTextField.placeholder = @"请输入客服电话";
        }
    }
    
}

// 文本开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    if([textView.text isEqualToString:@"请输入店铺介绍"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}

#pragma mark 导航栏完成
-(void)finishAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
   NSString *titleContentStr = self.contentTextField.text;
   
    NSString *textViewStr = self.shopTextView.text;
    
    NSDictionary *dict;
    
    
    if (textViewStr.length >0)
    {
        if (textViewStr.length !=0)
        {
            dict = @{@"group":self.group,@"row":self.row,@"title":textViewStr};
        }else
        {
            dict = @{@"group":self.group,@"row":self.row,@"title":@" "};
        }
        
    }else
    {
        
        if (titleContentStr.length !=0)
        {
            dict = @{@"group":self.group,@"row":self.row,@"title":titleContentStr};
            
        }else
        {
            dict = @{@"group":self.group,@"row":self.row,@"title":@" "};
        }
        
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([self.group isEqualToString:@"2"] && [self.row isEqualToString:@"0"])
    {
        if (titleContentStr.length != 0)
        {
            [defaults setObject:titleContentStr forKey:@"hairCargo"];
            [defaults synchronize];
            
        }
        
    }else if ([self.group isEqualToString:@"2"] && [self.row isEqualToString:@"1"])
    {
        if (titleContentStr.length != 0)
        {
            [defaults setObject:titleContentStr forKey:@"outCargo"];
            [defaults synchronize];
            
        }
        
        
    }else if ([self.group isEqualToString:@"3"])
    {
        if (titleContentStr.length !=0)
        {
            [defaults setObject:titleContentStr forKey:@"services"];
            [defaults synchronize];
            
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"contentLabel" object:self userInfo:dict];
}


//输入框编辑完成以后，将视图恢复到原始状态
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"请输入店铺介绍";
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
    [self.shopTextView resignFirstResponder];
    
}

//  控制器即将烧毁时发送通知调整前面界面的tableView的高度

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSDictionary *dict = @{@"flag":@"1"};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"adjustY" object:self userInfo:dict];
}


@end
