//
//  MyTheViewMemberController.m
//  nen
//
//  Created by nenios101 on 2017/5/25.
//  Copyright © 2017年 nen. All rights reserved.
//我的成员


#import "MyTheViewMemberController.h"
#import "MembersModel.h"
#import "MyTheMembersCell.h"
@interface MyTheViewMemberController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,copy) NSString * page;
@property(nonatomic,strong) NSMutableArray<MembersModel *> *memberModelArray;
@property(nonatomic,strong) UITextField *phoneTextField;

@end

@implementation MyTheViewMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addchildControl];
    
    
    
    [self pulldownNews];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [self setNavBar];
    
}

- (void)setNavBar
{
    self.navigationItem.title = @"我的成员";
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



- (NSMutableArray *)memberModelArray
{
    if (!_memberModelArray)
    {
        _memberModelArray = [NSMutableArray array];
    }
    
    return _memberModelArray;
}

#pragma mark 下拉刷新
- (void)pulldownNews
{
    [self pullUpNews];
    
    __weak __typeof(self)weakSelf = self;
    self.page = @"1";
    // 点击进入立即刷新
    self.tableView.mj_header = [SHRefreshHeader headerWithRefreshingBlock:^{
        __weak UITableView *tableView = self.tableView;
        
        [MembersModel mebersModelMobilePhone:nil PageSize:@"12" Page:@"1" MembersType:self.membersType success:^(NSMutableArray<MembersModel *> *membersArray) {
            
            weakSelf.memberModelArray = membersArray;
            [weakSelf.tableView reloadData];
            [tableView.mj_header endRefreshing];
            
        } error:^{
            
            NSLog(@"失败");
             [tableView.mj_header endRefreshing];
        }];
        
    }];
    
    // 马上进入刷新状态
    [weakSelf.tableView.mj_header beginRefreshing];
    

  }

#pragma mark 上啦刷新
- (void)pullUpNews
{
    
    __weak __typeof(self)weakSelf = self;
    self.tableView.mj_footer = [SHRefreshFooter footerWithRefreshingBlock:^{
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        // 每次下拉页数加1
        weakSelf.page = [NSString stringWithFormat:@"%d",[weakSelf.page integerValue] + 1];
        
        NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/mine/diremployee"];
        
        NSDictionary *dict = @{@"page":weakSelf.page,@"pagesize":@"12"};
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
        
        __weak UITableView *tableView = self.tableView;
        [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSString *temporaryPage = responseObject[@"result"][@"request_args"][@"page"];
            
            
            if (![weakSelf.page isEqualToString:temporaryPage])
            {
                weakSelf.page = temporaryPage;
                
                NSArray *dataArray = responseObject[@"list"];
                
                NSArray *array = [NSArray array];
                
                array = [MembersModel mj_objectArrayWithKeyValuesArray:dataArray];
                
                [weakSelf.memberModelArray addObjectsFromArray:array];
            }
            else
                
            {
                tableView.mj_footer.state = MJRefreshStateNoMoreData;
                
            }
            
            [tableView.mj_footer endRefreshing];
            [tableView reloadData];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
             [tableView.mj_footer endRefreshing];
            
        }];
    }];
    
}



- (void)addchildControl
{
    UIView *headView = [[UIView alloc] init];
    [self.view addSubview:headView];
    headView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(ScreenWidth *0.5 - 40,30,80,20);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"成员列表";
    [headView addSubview:titleLabel];
    
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.frame = CGRectMake(10,titleLabel.sh_bottom + 30,80,30);
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.font = [UIFont systemFontOfSize:14];
    leftLabel.text = @"成员手机号";
    leftLabel.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [headView addSubview:leftLabel];
    
    
    UITextField *phoneTextField = [[UITextField alloc] init];
    self.phoneTextField = phoneTextField;
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneTextField.frame = CGRectMake(leftLabel.sh_right + 10,leftLabel.sh_y,150,30);
    phoneTextField.delegate = self;
    phoneTextField.placeholder = @"请输入成员手机";
    phoneTextField.font = [UIFont systemFontOfSize:14];
    phoneTextField.tintColor = [UIColor lightPink];
    phoneTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    phoneTextField.layer.borderWidth = 1.0f;
    [headView addSubview:phoneTextField];
    
    UIButton *inquiryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    inquiryBtn.frame = CGRectMake(phoneTextField.sh_right + 20,phoneTextField.sh_y + 3,40,24);
    [inquiryBtn setTitle:@"查询" forState:UIControlStateNormal];
    [inquiryBtn setBackgroundColor:[UIColor orangeRed]];
    [inquiryBtn addTarget:self action:@selector(inquiryBtnClick) forControlEvents:UIControlEventTouchUpInside];
    inquiryBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [headView addSubview:inquiryBtn];
    
    UIView *formView = [[UIView alloc] init];
    formView.frame = CGRectMake(10,phoneTextField.sh_bottom + 30,ScreenWidth - 20,40);
    formView.layer.borderWidth = 1.0f;
    formView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [headView addSubview:formView];
    
    CGFloat W = (formView.sh_width - 46) / 3;
    
    UILabel *serialNumberLabel = [[UILabel alloc] init];
    serialNumberLabel.frame = CGRectMake(0,0,40,40);
    serialNumberLabel.text = @"SN";
    serialNumberLabel.textAlignment = NSTextAlignmentCenter;
    serialNumberLabel.backgroundColor = [UIColor seaShell];
    [formView addSubview:serialNumberLabel];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.frame = CGRectMake(serialNumberLabel.sh_right,0,2,40);
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [formView addSubview:lineView1];
    
    UILabel *registeredLabel = [[UILabel alloc] init];
    registeredLabel.frame = CGRectMake(lineView1.sh_right,0,W,40);
    registeredLabel.text = @"注册时间";
    registeredLabel.textAlignment = NSTextAlignmentCenter;
    registeredLabel.font = [UIFont systemFontOfSize:13];
    registeredLabel.backgroundColor = [UIColor seaShell];
    [formView addSubview:registeredLabel];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.frame = CGRectMake(registeredLabel.sh_right,0,2,40);
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [formView addSubview:lineView2];
    
    UILabel *mobileLabel = [[UILabel alloc] init];
    mobileLabel.font = [UIFont systemFontOfSize:13];
    mobileLabel.frame = CGRectMake(lineView2.sh_right,0,W,40);
    mobileLabel.text = @"成员手机号码";
    mobileLabel.textAlignment = NSTextAlignmentCenter;
    mobileLabel.backgroundColor = [UIColor seaShell];
    [formView addSubview:mobileLabel];
    
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.frame = CGRectMake(mobileLabel.sh_right,0,2,40);
    lineView3.backgroundColor = [UIColor lightGrayColor];
    [formView addSubview:lineView3];
    
    UILabel *stateLabel = [[UILabel alloc] init];
    stateLabel.frame = CGRectMake(lineView3.sh_right,0,W,40);
    stateLabel.font = [UIFont systemFontOfSize:13];
    stateLabel.text = @"成员状态";
    stateLabel.textAlignment = NSTextAlignmentCenter;
    stateLabel.backgroundColor = [UIColor seaShell];
    [formView addSubview:stateLabel];
    
    headView.frame = CGRectMake(0,64,ScreenWidth,180);
    
    UITableView *tableV = [[UITableView alloc] init];
    self.tableView = tableV;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableV.frame = CGRectMake(0,headView.sh_bottom,ScreenWidth,(ScreenHeight - headView.sh_height) - 49);
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.rowHeight = 40;
    [self.view addSubview:tableV];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.memberModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id  =@"cell";
    
    MyTheMembersCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    MembersModel *model = self.memberModelArray[indexPath.row];
    
    if (!cell)
    {
        cell = [[MyTheMembersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.index = [NSString stringWithFormat:@"%d",indexPath.row + 1];
    }
    
    cell.model = model;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = [NSString stringWithFormat:@"%d",indexPath.row + 1];
    
    return cell;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneTextField resignFirstResponder];
    
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneTextField resignFirstResponder];
}

-(void)inquiryBtnClick
{
    [self.phoneTextField resignFirstResponder];
    NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.phoneTextField.text];
    
     __weak __typeof(self)weakSelf = self;
    if(isMatch) {
        
        [MembersModel mebersModelMobilePhone:nil PageSize:@"12" Page:@"1" MembersType:@"1" success:^(NSMutableArray<MembersModel *> *membersArray) {
            weakSelf.memberModelArray = membersArray;
            [weakSelf.tableView reloadData];
        } error:^{
            
            NSLog(@"失败");
        }];

//        
//        [MembersModel mebersModelMobilePhone:self.phoneTextField.text PageSize:@"12" Page:@"1"success:^(NSMutableArray<MembersModel *> *membersArray) {
//          
//        } error:^{
//            
//        }];
        
    }else//无效手机号
    {

    [JKAlert alertText:@"请输入正确的手机号"];
    }
}







@end
