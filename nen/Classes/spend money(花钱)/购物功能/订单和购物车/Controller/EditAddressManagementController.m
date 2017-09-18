//
//  EditAddressManagementController.m
//  nen
//
//  Created by nenios101 on 2017/3/28.
//  Copyright © 2017年 nen. All rights reserved.
//编辑收货地址

#import "EditAddressManagementController.h"
#import "LZCityPickerView.h"
#import "LZCityPickerController.h"
#import "AdderessShowUpdataModel.h"
#import "MMCheckTool.h"
@interface EditAddressManagementController ()<UITextViewDelegate>

@property(nonatomic,strong)  UIButton * addressBtn;

@property(nonatomic,strong) UITextView *textView;

@property(nonatomic,strong) UITextField *nameTextField;

@property(nonatomic,strong) UITextField *numbereTextField;

@property(nonatomic,strong) UIButton *manBtn;

@property(nonatomic,strong) UIButton *woManBtn;

@property(nonatomic,strong) NSString *locationMerge;

// 男／女 记录单选按钮
@property(nonatomic,assign) NSInteger numner;

// 记录返回上一页的标记
@property(nonatomic,copy) NSString *popVcString;

@property(nonatomic,strong) AdderessShowUpdataModel *updateModel;

@end

@implementation EditAddressManagementController

- (void)viewDidLoad {
    [super viewDidLoad];

//    NSLog(@"%@",self.editId);
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
  [self addeditView];
    [self setNavBar];
  
    if (self.editId.length)
    {
        self.nameTextField.text = self.relation_name;
        
        self.numbereTextField.text = self.phoneNumber;
        
        self.numner = [self.sex integerValue];
        
        self.textView.text = self.address;
        
    [self.addressBtn setTitle:@"  " forState:UIControlStateNormal];
        
    }

}

#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"编辑收货地址";
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


- (void)addeditView
{
    // 默认为 1
    self.numner = 1;
    
    UIView *editView = [[UIView alloc] init];
    editView.backgroundColor = [UIColor whiteColor];
    editView.frame = CGRectMake(0,64,ScreenWidth,ScreenHeight *0.5);
    [self.view addSubview:editView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(20,10,50, 25);
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor lightGrayColor];
    nameLabel.text = @"姓名:";
    [editView addSubview:nameLabel];
    
    UITextField *nameTextField = [[UITextField alloc] init];
    self.nameTextField = nameTextField;
    [nameTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [nameTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    nameTextField.frame = CGRectMake(nameLabel.sh_right + 20,10,ScreenWidth *0.6,30);
    nameTextField.layer.borderWidth = 1;
    nameTextField.clipsToBounds = YES;
    nameTextField.layer.cornerRadius = 5;
    nameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [editView addSubview:nameTextField];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    bottomLineView.frame = CGRectMake(0,nameTextField.sh_bottom + 10,ScreenWidth, 1);
    
    [editView addSubview:bottomLineView];
    
    
    UILabel *sexualLabel = [[UILabel alloc] init];
    sexualLabel.frame = CGRectMake(20,bottomLineView.sh_bottom + 10,50, 25);
    sexualLabel.font = [UIFont systemFontOfSize:15];
    sexualLabel.textColor = [UIColor lightGrayColor];
    sexualLabel.text = @"性别:";
    [editView addSubview:sexualLabel];

    UIButton *manBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.manBtn = manBtn;
    manBtn.frame = CGRectMake(sexualLabel.sh_right,bottomLineView.sh_bottom + 10,50,25);
    [manBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    manBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-10, 0, 0);
    [manBtn setTitle:@"男" forState:UIControlStateNormal];
    manBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [manBtn addTarget:self action:@selector(manBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    manBtn.selected = YES;
    [manBtn setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [manBtn setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateSelected];
    [editView addSubview:manBtn];
    
    UIButton *woManBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.woManBtn = woManBtn;
    woManBtn.frame = CGRectMake(manBtn.sh_right + 40,bottomLineView.sh_bottom + 10,50,25);
    woManBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [woManBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [woManBtn addTarget:self action:@selector(woManBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    woManBtn.imageEdgeInsets = UIEdgeInsetsMake(0,-10, 0, 0);
    [woManBtn setTitle:@"女" forState:UIControlStateNormal];
    [woManBtn setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [woManBtn setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateSelected];
    [editView addSubview:woManBtn];

    UIView *bottomLineView1 = [[UIView alloc] init];
    bottomLineView1.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    bottomLineView1.frame = CGRectMake(0,_woManBtn.sh_bottom + 10,ScreenWidth, 1);
    [editView addSubview:bottomLineView1];

   UILabel *numnerLabel = [[UILabel alloc] init];
    numnerLabel.frame = CGRectMake(10,bottomLineView1.sh_bottom + 10,70, 25);
    numnerLabel.font = [UIFont systemFontOfSize:15];
    numnerLabel.textColor = [UIColor lightGrayColor];
    numnerLabel.text = @"联系电话:";
    [editView addSubview:numnerLabel];
    
   UITextField *numbereTextField= [[UITextField alloc] init];
    self.numbereTextField = numbereTextField;
  
    numbereTextField.frame = CGRectMake(numnerLabel.sh_right + 10 ,bottomLineView1.sh_bottom + 10 ,ScreenWidth *0.6,30);
    numbereTextField.layer.borderWidth = 1;
    numbereTextField.clipsToBounds = YES;
    numbereTextField.keyboardType = UIKeyboardTypeNumberPad;
    numbereTextField.layer.cornerRadius = 5;
    numbereTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [editView addSubview:numbereTextField];

    
    UIView *bottomLineView2 = [[UIView alloc] init];
    bottomLineView2.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    bottomLineView2.frame = CGRectMake(0,numnerLabel.sh_bottom + 10,ScreenWidth, 1);
    [editView addSubview:bottomLineView2];
    
    UILabel * locationLabel = [[UILabel alloc] init];
    locationLabel.frame = CGRectMake(10,bottomLineView2.sh_bottom + 10,60,25);
    locationLabel.text = @"区域地址";
    locationLabel.font = [UIFont systemFontOfSize:13];
    [editView addSubview:locationLabel];
    
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addressBtn = addressBtn;
    addressBtn.frame = CGRectMake(locationLabel.sh_right + 20,bottomLineView2.sh_bottom + 10,ScreenWidth *0.6,30);
    addressBtn.backgroundColor = [UIColor orangeColor];
    addressBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    addressBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [addressBtn setBackgroundColor:[UIColor whiteColor]];
    [addressBtn addTarget:self action:@selector(toAddressBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [addressBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    addressBtn.layer.cornerRadius = 5;
    addressBtn.clipsToBounds = YES;
    addressBtn.layer.borderWidth = 1.0f;
    addressBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [editView addSubview:addressBtn];

    
//    UIButton * toAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    toAddressBtn.frame = CGRectMake(ScreenWidth * 0.8,bottomLineView2.sh_bottom + 10,ScreenWidth *0.2,25);
//    [toAddressBtn setTitle:@"选择地址" forState:UIControlStateNormal];
//    toAddressBtn.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
//    [toAddressBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    toAddressBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//    [toAddressBtn addTarget:self action:@selector(toAddressBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [editView addSubview:toAddressBtn];
    
    UITextView *textView = [[UITextView alloc] init];
    self.textView = textView;
    [textView setAutocorrectionType:UITextAutocorrectionTypeNo];
    textView.font = [UIFont systemFontOfSize:15];
    [textView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    textView.frame = CGRectMake(ScreenWidth *0.1,locationLabel.sh_bottom + 20,ScreenWidth *0.8,60);
    textView.text = @"请输入详细地址";
    textView.textColor = [UIColor grayColor];
    textView.layer.borderWidth = 1;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.clipsToBounds = YES;
    textView.layer.cornerRadius = 5;
    textView.delegate = self;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    [editView addSubview:textView];
    
    
    UIButton *submitBtn = [[UIButton alloc] init];
    submitBtn.frame = CGRectMake(ScreenWidth *0.15, ScreenHeight* 0.7, ScreenWidth *0.7 , 35);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 5;
    submitBtn.clipsToBounds = YES;
    [submitBtn setBackgroundColor:[UIColor colorWithHexString:@"#FF5001"]];
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:submitBtn];
    
}

#pragma mark 提交按钮
- (void)submitClick
{
    if (![MMCheckTool isVaildRealName:self.nameTextField.text])
    {
        [JKAlert alertText:@"请输入正确的名称"];
        return;
    }
    
    if (![MMCheckTool isVaildMobileNo:self.numbereTextField.text])
    {
        [JKAlert alertText:@"请输入正确的手机号码"];
        return;
    }

    // 编辑地址
    if (self.editId.length)
    {

        [self editUpdate];
    }else
    {
        // 新增地址
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
        
        NSString *completeStr = [NSString stringEncryptedAddress:@"/mine/addresscreate"];
        
        NSDictionary *dict = @{@"relation_name":self.nameTextField.text,@"sex":@(self.numner),@"relation_tel":self.numbereTextField.text,@"address":[self.addressBtn.titleLabel.text stringByAppendingString:self.textView.text]};
        
        [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
           // NSLog(@"%@",error);
        }];
        
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark 编辑完成后调用
- (void)editUpdate
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/mine/updateaddress"];
 
//    
    NSDictionary *dict = @{@"address_id":self.editId,@"relation_name":self.nameTextField.text,@"sex":@(self.numner),@"relation_tel":self.numbereTextField.text,@"address":[self.addressBtn.titleLabel.text stringByAppendingString:self.textView.text],@"postcode":self.postcode};
    
    [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
      //  NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       // NSLog(@"%@",error);
    }];
}

#pragma mark 男
- (void)manBtnClick:(UIButton *)btn
{
    self.numner = 1;
    if (!btn.selected)
    {
      _manBtn.selected = YES;
        _woManBtn.selected = NO;
        
    }

}
#pragma mark 女
-(void)woManBtnClick:(UIButton *)btn
{
    self.numner = 0;
    if (!btn.selected)
    {
        _woManBtn.selected = YES;
        _manBtn.selected = NO;
        
    }

}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"请输入详细地址";
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入详细地址"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}

#pragma mark 选择地址
- (void)toAddressBtnClick
{
    [_textView resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_numbereTextField resignFirstResponder];

    [LZCityPickerController showPickerInViewController:self selectBlock:^(NSString *address, NSString *province, NSString *city, NSString *area) {
        
        // 选择结果回调
        [self.addressBtn setTitle:address forState:UIControlStateNormal] ;
        
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
    [_nameTextField resignFirstResponder];
    [_numbereTextField resignFirstResponder];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popVc" object:self];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
