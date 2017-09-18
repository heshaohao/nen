//
//  MyAccountViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/26.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MyTheAccountViewController.h"
#import "SetModel.h"
#import "SetGroupModel.h"
#import "MyTheTableViewCell.h"
#import "VerificationViewController.h"
#import "TheLoginPasswordController.h"
#import "PhoneVerificationController.h"
#import "SecurityTipsController.h"


@interface MyTheAccountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSArray *setArray;

@end

@implementation MyTheAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    UITableView *tableV = [[UITableView alloc] init];
    tableV.frame = CGRectMake(0,0,ScreenWidth,279);
    tableV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.scrollEnabled = NO;
    tableV.rowHeight = 50;
    [self.view addSubview:tableV];
    
}

- (NSArray *)setArray{
    
    //1.判断是否为nil
    if (_setArray == nil) {
        //2.加载数据
        _setArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"MyTheCell" ofType:@"plist"]];
        
        //1. 定义可变数组
        NSMutableArray *nmArray = [NSMutableArray array];
        
        //2. 遍历字典数组
        for (NSDictionary *dict in _setArray) {
            //3. 字典转模型
            SetGroupModel *setGroup = [SetGroupModel carGroupWithDict:dict];
            
            //4. 添加到可变数组中
            [nmArray addObject:setGroup];
        }
        //5. 将模型数组赋值给字典数组
        _setArray = nmArray;
        
    }
    
    //3. 返回数据
    return _setArray;
    
}



#pragma mark tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.setArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    SetGroupModel *setGroup = self.setArray[section];
    return setGroup.setArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * Id = @"cell";
    
    MyTheTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    if (!cell)
    {
        cell = [[MyTheTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Id];
    }
    
    SetGroupModel *setGroup = self.setArray[indexPath.section];
    
    SetModel  *model = setGroup.setArray[indexPath.row];
    
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    if (indexPath.row == 1)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *nameStr = [defaults objectForKey:@"userNumber"];
        cell.rightTtitleStr = nameStr;
    }else if(indexPath.row == 2)
    {
        cell.rightTtitleStr = @"安全程度中";
    }
  
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 0;
    }else
    {
        return 15;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2)
    {
        [self.navigationController pushViewController:[[VerificationViewController alloc] init] animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 0)
    {
        [self.navigationController pushViewController:[[TheLoginPasswordController alloc] init] animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 1)
    {
        
        [self.navigationController pushViewController:[[PhoneVerificationController alloc] init] animated:YES];
        
    }else if(indexPath.section == 1 && indexPath.row == 0)
    {
        [self.navigationController pushViewController:[[SecurityTipsController alloc] init] animated:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"我的账户";
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
