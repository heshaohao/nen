//
//  MyTheCompanyViewController.m
//  nen
//
//  Created by nenios101 on 2017/5/27.
//  Copyright © 2017年 nen. All rights reserved.
//我的事业 更多

#import "MyTheCompanyViewController.h"
#import "MyTheCompanyViewCell.h"
#import "MyemployeecountModel.h"
#import "CJCalendarViewController.h"
#import"GuidanceInstructionsViewController.h"
#import "myCareerViewController.h"

@interface MyTheCompanyViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CalendarViewControllerDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) UITextField * startTimeTextField;
@property(nonatomic,strong) UITextField * endTimeTextField;
@property(nonatomic,strong) MyemployeecountModel *dataModel;

@property(nonatomic,assign) NSInteger sign;

@property(nonatomic,strong) NSArray *companyDataArray;

@end

@implementation MyTheCompanyViewController

- (NSArray *)companyDataArray
{
    if (!_companyDataArray)
    {
        
        _companyDataArray = @[@{@"name":@"营销公司",@"one":@"直属一级",@"two":@"直属二级",@"operation":@"1"},@{@"name":@"招商公司",@"one":@"直属人员",@"two":@"直属人员",@"operation":@"2"},@{@"name":@"创新公司",@"one":@"直属人员",@"two":@"直属人员级",@"operation":@"2"}];
    }
    
    return _companyDataArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"我的公司";
    self.navigationController.navigationBarHidden = NO;
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
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [MyemployeecountModel MyemployeeModelBeginTime:nil EndTime:nil success:^(MyemployeecountModel *employeeModel) {
        
        self.dataModel = employeeModel;
        
        [self addChildControll];
        
    } error:^{
        
        NSLog(@"失败");
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelCalendarCilck) name:@"cancelCalendar" object:nil];
    
    // 点击操作调整到对应的分类公司成员
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMyCareerViewControll:) name:@"clickTag" object:nil];
}

#pragma mark 跳转到分类公司成员
- (void)pushMyCareerViewControll:(NSNotification *)notification
{
    NSString *companyTypeStr = notification.userInfo[@"typeIndex"];
    NSString *vocaloidtype = notification.userInfo[@"membersType"];
    
    myCareerViewController *myCareerVc = [[myCareerViewController alloc] init];
    myCareerVc.type = companyTypeStr;
    myCareerVc.membersType = vocaloidtype;
    myCareerVc.page = @"1";
    [self.navigationController pushViewController:myCareerVc animated:YES];
    
}
    
    
    
#pragma mark 日历取消按钮

- (void)cancelCalendarCilck
{
    [self.startTimeTextField resignFirstResponder];
    [self.endTimeTextField resignFirstResponder];
}

- (void)addChildControll
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(ScreenWidth *0.5 - 80,30,160,20);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我们的世袭企业一揽表";
    titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:titleLabel];
    
    UILabel *startLabel = [[UILabel alloc] init];
    startLabel.frame = CGRectMake(10,titleLabel.sh_bottom + 30,80,30);
    startLabel.textAlignment = NSTextAlignmentCenter;
    startLabel.font = [UIFont systemFontOfSize:14];
    startLabel.text = @"开始时间";
    startLabel.textColor= [UIColor lightGrayColor];
    [self.view addSubview:startLabel];
    
    
    UITextField *startTimeTextField = [[UITextField alloc] init];
    self.startTimeTextField = startTimeTextField;
    startTimeTextField.keyboardType = UIKeyboardTypeNumberPad;
    startTimeTextField.frame = CGRectMake(startLabel.sh_right +5,startLabel.sh_y,150,30);
    startTimeTextField.delegate = self;
    startTimeTextField.placeholder = @"开始时间";
    startTimeTextField.tintColor = [UIColor lightPink];
    startTimeTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    startTimeTextField.layer.borderWidth = 1.0f;
    [self.view addSubview:startTimeTextField];
    
    
    UILabel *endLabel = [[UILabel alloc] init];
    endLabel.frame = CGRectMake(10,startTimeTextField.sh_bottom + 10,80,30);
    endLabel.textAlignment = NSTextAlignmentCenter;
    endLabel.font = [UIFont systemFontOfSize:14];
    endLabel.text = @"结束时间";
    endLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:endLabel];
    
    
    UITextField *endTimeTextField = [[UITextField alloc] init];
    self.endTimeTextField = endTimeTextField;
    endTimeTextField.keyboardType = UIKeyboardTypeNumberPad;
    endTimeTextField.frame = CGRectMake(endLabel.sh_right +5,endLabel.sh_y,150,30);
    endTimeTextField.delegate = self;
    endTimeTextField.placeholder = @"结束时间";
    endTimeTextField.tintColor = [UIColor lightPink];
    endTimeTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    endTimeTextField.layer.borderWidth = 1.0f;
    [self.view addSubview:endTimeTextField];
    
    
    UIButton *inquiryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    inquiryBtn.frame = CGRectMake(endTimeTextField.sh_right + 20,endTimeTextField.sh_y + 3,40,24);
    [inquiryBtn setTitle:@"查询" forState:UIControlStateNormal];
    [inquiryBtn setBackgroundColor:[UIColor orangeRed]];
    [inquiryBtn addTarget:self action:@selector(inquiryBtnClick) forControlEvents:UIControlEventTouchUpInside];
    inquiryBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:inquiryBtn];
    
    
    UIView *formView = [[UIView alloc] init];
    formView.frame = CGRectMake(10,endTimeTextField.sh_bottom + 20,ScreenWidth - 20,40);
    formView.layer.borderWidth = 1.0f;
    formView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:formView];
    
    CGFloat W = (formView.sh_width - 6) /  4;
    
    UILabel *serialNumberLabel = [[UILabel alloc] init];
    serialNumberLabel.frame = CGRectMake(0,0,W,40);
    serialNumberLabel.text = @"企业类别";
    serialNumberLabel.textAlignment = NSTextAlignmentCenter;
    [formView addSubview:serialNumberLabel];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.frame = CGRectMake(serialNumberLabel.sh_right,0,2,40);
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [formView addSubview:lineView1];
    
    UILabel *registeredLabel = [[UILabel alloc] init];
    registeredLabel.frame = CGRectMake(lineView1.sh_right,0,W,40);
    registeredLabel.text = @"科目";
    registeredLabel.textAlignment = NSTextAlignmentCenter;
    registeredLabel.font = [UIFont systemFontOfSize:13];

    [formView addSubview:registeredLabel];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.frame = CGRectMake(registeredLabel.sh_right,0,2,40);
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [formView addSubview:lineView2];
    
    UILabel *mobileLabel = [[UILabel alloc] init];
    mobileLabel.font = [UIFont systemFontOfSize:13];
    mobileLabel.frame = CGRectMake(lineView2.sh_right,0,W,40);
    mobileLabel.text = @"数量";
    mobileLabel.textAlignment = NSTextAlignmentCenter;

    [formView addSubview:mobileLabel];
    
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.frame = CGRectMake(mobileLabel.sh_right,0,2,40);
    lineView3.backgroundColor = [UIColor lightGrayColor];
    [formView addSubview:lineView3];
    
    UILabel *stateLabel = [[UILabel alloc] init];
    stateLabel.frame = CGRectMake(lineView3.sh_right,0,W,40);
    stateLabel.font = [UIFont systemFontOfSize:13];
    stateLabel.text = @"操作";
    stateLabel.textAlignment = NSTextAlignmentCenter;
    [formView addSubview:stateLabel];
    
    UITableView *tableV = [[UITableView alloc] init];
    self.tableView = tableV;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableV.frame = CGRectMake(0,formView.sh_bottom,ScreenWidth,self.companyDataArray.count * 80);
    tableV.delegate = self;
    tableV.scrollEnabled = NO;
    tableV.bounces = YES;
    tableV.dataSource = self;
    tableV.rowHeight = 80;
    [self.view addSubview:tableV];
    
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.frame = CGRectMake(10,tableV.sh_bottom + 10,20,20);
    leftLabel.font = [UIFont systemFontOfSize:13];
    leftLabel.text = @"注:";
    leftLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:leftLabel];
    
    UIButton *bottomTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomTitleBtn.frame = CGRectMake(leftLabel.sh_right ,leftLabel.sh_y,150,20);
    [bottomTitleBtn setTitle:@"关于世袭传承操作说明" forState:UIControlStateNormal];
    [bottomTitleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [bottomTitleBtn addTarget:self action:@selector(bottomTitleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    bottomTitleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:bottomTitleBtn];

}

#pragma mark 底部栏按钮
- (void)pushControll
{
    [self pushInstructionsViewControll];
}
#pragma 底部文字按钮
- (void)bottomTitleBtnClick
{
    [self pushInstructionsViewControll];
}

#pragma mark  跳转说明控制器
- (void)pushInstructionsViewControll
{
    [self.navigationController pushViewController:[[GuidanceInstructionsViewController alloc] init] animated:YES];
}
#pragma mark 按钮查询
- (void)inquiryBtnClick

{   __weak __typeof(self)weakSelf = self;
    [MyemployeecountModel MyemployeeModelBeginTime:self.startTimeTextField.text EndTime:self.endTimeTextField.text success:^(MyemployeecountModel *employeeModel) {
        self.dataModel = employeeModel;
        [weakSelf.tableView reloadData];
        
    } error:^{
        NSLog(@"失败");
    }];

}


#pragma mark tableViewDetegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return  self.companyDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id  =@"cell";
    
    MyTheCompanyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    if (!cell)
    {
        cell = [[MyTheCompanyViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.index = [NSString stringWithFormat:@"%d",indexPath.row + 1];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = [NSString stringWithFormat:@"%d",indexPath.row + 1];
    cell.dataDict = self.companyDataArray[indexPath.row];
    cell.model = self.dataModel;
    cell.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
    
}

#pragma mark textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.startTimeTextField resignFirstResponder];
    [self.endTimeTextField resignFirstResponder];
    
    return YES;
}
// 准备开始输入  文本字段将成为第一响应者
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.startTimeTextField)
    {
        self.sign = 1;
    }else
    {
        self.sign = 2;
    }
    
  
    CJCalendarViewController *calendarController = [[CJCalendarViewController alloc] init];
    calendarController.view.frame = self.view.frame;
    
    calendarController.delegate = self;

  [self presentViewController:calendarController animated:YES completion:nil];
    

}
//文本彻底结束编辑时调用
-(void)textFieldDidEndEditing:(UITextField *)textField
{

    
}


#pragma mark 日历代理方法
-(void)CalendarViewController:(CJCalendarViewController *)controller didSelectActionYear:(NSString *)year month:(NSString *)month day:(NSString *)day{
    
    if (self.sign == 1)
    {
        self.startTimeTextField.text = [NSString stringWithFormat:@"%@-%@", year, month];
        [self.startTimeTextField resignFirstResponder];
            }else
    {
         self.endTimeTextField.text = [NSString stringWithFormat:@"%@-%@", year, month];
        [self.endTimeTextField resignFirstResponder];

    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.startTimeTextField resignFirstResponder];
    [self.endTimeTextField resignFirstResponder];
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
