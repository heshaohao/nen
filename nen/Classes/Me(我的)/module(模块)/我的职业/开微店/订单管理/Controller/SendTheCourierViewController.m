//
//  SendTheCourierViewController.m
//  nen
//
//  Created by nenios101 on 2017/6/8.
//  Copyright © 2017年 nen. All rights reserved.
//商家订单发货

#import "SendTheCourierViewController.h"
#import "ExpressCompanyList.h"
#import "TheConsigneeInformationModel.h"

@interface SendTheCourierViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

// 点击选择快递公司
@property (nonatomic,strong) UIButton *logisticsBtn;

// 快递订单号
@property(nonatomic,strong) UITextField *courierNumberTextFiled;

// 收货人名称
@property (nonatomic,strong) UILabel *nameLabels;

//收货人联系电话
@property (nonatomic,strong) UILabel *receivingContactNameLabels;

// 收货地址
@property (nonatomic,strong) UILabel *shippingAddressLabel;

// 邮编
@property (nonatomic,strong) UILabel *zipCode;


// 物流公司数据列表
@property (nonatomic,strong) NSMutableArray <ExpressCompanyList *>*companyListDataArray;

// 收货人数据模型
@property (nonatomic,strong) TheConsigneeInformationModel *informationModel;


@property (nonatomic,strong) UITableView *companyTableView;

@end

@implementation SendTheCourierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self logisticsCompanyloadData];
    [self theConsigneelodaData];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabels = nameLabel;
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.frame = CGRectMake(10,74,150,25);
    nameLabel.text = @"收货人名称:";
    [self.view addSubview:nameLabel];
    
    UILabel *receivingContactNameLabel = [[UILabel alloc] init];
    self.receivingContactNameLabels = receivingContactNameLabel;
    receivingContactNameLabel.font = [UIFont systemFontOfSize:13];
    receivingContactNameLabel.frame = CGRectMake(10,nameLabel.sh_bottom + 10,200,25);
    receivingContactNameLabel.text = @"收货人联系方式:";
    [self.view addSubview:receivingContactNameLabel];
    
    
    UILabel *shippingAddressLabel = [[UILabel alloc] init];
    self.shippingAddressLabel = shippingAddressLabel;
    shippingAddressLabel.font = [UIFont systemFontOfSize:13];
    shippingAddressLabel.frame = CGRectMake(10,receivingContactNameLabel.sh_bottom + 10,150,25);
    shippingAddressLabel.text = @"收货地址:";
    [self.view addSubview:shippingAddressLabel];
    
    
    UILabel *zipCode = [[UILabel alloc] init];
    self.zipCode = zipCode;
    zipCode.font = [UIFont systemFontOfSize:13];
    zipCode.frame = CGRectMake(10,shippingAddressLabel.sh_bottom + 10,150,25);
    zipCode.text = @"邮编:";
    [self.view addSubview:zipCode];
    
    
    
    UILabel *courierName = [[UILabel alloc] init];
    courierName.font = [UIFont systemFontOfSize:13];
    courierName.frame = CGRectMake(10,zipCode.sh_bottom + 10,60,25);
    courierName.text = @"快递名称:";
    [self.view addSubview:courierName];
    
    
    UIButton *logisticsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.logisticsBtn = logisticsBtn;
    logisticsBtn.frame = CGRectMake(courierName.sh_right + 10,courierName.sh_y,ScreenWidth - 90,25);
    [logisticsBtn setBackgroundColor:[UIColor whiteColor]];
    logisticsBtn.layer.borderWidth = 1.0f;
    logisticsBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [logisticsBtn setTitle:@"圆通" forState:UIControlStateNormal];
    logisticsBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    logisticsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [logisticsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [logisticsBtn addTarget:self action:@selector(chooseTheCompany) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logisticsBtn];

    
    UILabel *courierNumber = [[UILabel alloc] init];
    courierNumber.font = [UIFont systemFontOfSize:13];
    courierNumber.frame = CGRectMake(10,logisticsBtn.sh_bottom + 10,60,25);
    courierNumber.text = @"快递单号:";
    [self.view addSubview:courierNumber];
    
    
    UITextField * courierNumberTextFiled = [[UITextField alloc] init];
    self.courierNumberTextFiled = courierNumberTextFiled;
    courierNumberTextFiled.frame  = CGRectMake(courierNumber.sh_right + 10, courierNumber.sh_y,ScreenWidth - 90, 25);
    courierNumberTextFiled.autocorrectionType = UITextAutocorrectionTypeNo;
    courierNumberTextFiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    courierNumberTextFiled.placeholder = @"填写快递单号";
    courierNumberTextFiled.layer.borderColor = [UIColor lightGrayColor].CGColor;
    courierNumberTextFiled.layer.borderWidth = 1.0f;
    courierNumberTextFiled.tintColor = [UIColor lightBLue];
    courierNumberTextFiled.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:courierNumberTextFiled];
    
    
    UIButton *deliveryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deliveryBtn.frame = CGRectMake(30,courierNumberTextFiled.sh_bottom + 30,ScreenWidth - 60,25);
    [deliveryBtn setBackgroundColor:[UIColor orangeColor]];
    deliveryBtn.layer.cornerRadius = 5;
    deliveryBtn.clipsToBounds = YES;
    [deliveryBtn setTitle:@"发货" forState:UIControlStateNormal];
    deliveryBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    deliveryBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [deliveryBtn addTarget:self action:@selector(clcikDeliveryBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deliveryBtn];
    
}



#pragma mark 选择快递公司
- (void)chooseTheCompany
{
    _companyTableView = [[UITableView alloc] init];
    _companyTableView.frame = CGRectMake(0,self.logisticsBtn.sh_bottom,ScreenWidth,300);
    _companyTableView.delegate = self;
    _companyTableView.dataSource = self;
    _companyTableView.bounces = NO;
    [self.view addSubview:_companyTableView];
}

#pragma mark  物流公司列表
- (void)logisticsCompanyloadData
{
    [ExpressCompanyList expressCompanyListsuccess:^(NSMutableArray<ExpressCompanyList *> *companyListArray) {
        
        self.companyListDataArray = companyListArray;
        
        
    } error:^{
        
        NSLog(@"失败");
    }];
}

#pragma mark 收货人数据
- (void)theConsigneelodaData
{
    [
    TheConsigneeInformationModel theConsigneeInformationModelOrderId:self.orderId success:^(TheConsigneeInformationModel *theConsigneeInformationModel) {
        
        self.informationModel = theConsigneeInformationModel;
        
        self.nameLabels.text =[NSString stringWithFormat:@"收货人名称: %@",self.informationModel.relation_name];
        self.receivingContactNameLabels.text = [NSString stringWithFormat:@"收货人联系方式: %@",self.informationModel.relation_tel];
        self.shippingAddressLabel.text = [NSString stringWithFormat:@"收货地址: %@",self.informationModel.address];
        
        self.zipCode.text = [NSString stringWithFormat:@"邮编: %@",self.informationModel.postcode];
        
        
    } error:^{
    
        NSLog(@"失败");
        
    }];
    
}

// 点击发货按钮
- (void)clcikDeliveryBtn
{
    if (self.courierNumberTextFiled.text.length == 0) {
        [JKAlert alertText:@"快递单号不能为空"];
        return ;
    }
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
        NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/shopmanage/deliveryorder"];
        
        NSDictionary *dict = @{@"order_id":self.orderId,@"express_name":self.logisticsBtn.titleLabel.text,@"express_number":self.courierNumberTextFiled.text};
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
        
        [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSString *coder = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
            NSString *resultMessage = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultMessage"]];
            
            if ([coder isEqualToString:@"0"])
            {
                [JKAlert alertText:@"发货成功"];

                NSDictionary *dict = @{@"orderId":self.orderId};
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sendVcPop" object:self userInfo:dict];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else
            {
                [JKAlert alertText:resultMessage];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSLog(@"%@",error);
            
        }];
   
}

#pragma mark 移除tablView
- (void)removeCourierCompanyView
{
    [_companyTableView removeFromSuperview];
    _companyTableView = nil;
    
}



#pragma mark tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.logisticsBtn setTitle:self.companyListDataArray[indexPath.row].name forState:UIControlStateNormal];
    
    [self removeCourierCompanyView];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.companyListDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    
    cell.textLabel.text = self.companyListDataArray[indexPath.row].name;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
}




#pragma mark ------------------------------------------------------


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.courierNumberTextFiled resignFirstResponder];
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  
    [self.courierNumberTextFiled resignFirstResponder];
    [self removeCourierCompanyView];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBar];
    
}

#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"发货";
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
