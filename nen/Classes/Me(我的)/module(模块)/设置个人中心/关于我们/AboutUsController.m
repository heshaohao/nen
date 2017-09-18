//
//  AboutUsController.m
//  nen
//
//  Created by nenios101 on 2017/6/16.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "AboutUsController.h"
#import "UseHelpViewController.h"
@interface AboutUsController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSArray *dataArray;

@end


@implementation AboutUsController

- (NSArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = @[@"关于我们"];
    }
    
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    UIImageView *titleIcon = [[UIImageView alloc] init];
    titleIcon.frame = CGRectMake((ScreenWidth *0.5)*0.5,100,ScreenWidth *0.5,100);
    titleIcon.image = [UIImage imageNamed:@"WYW"];
    titleIcon.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:titleIcon];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.font = [UIFont systemFontOfSize:15];
    versionLabel.frame = CGRectMake(10,titleIcon.sh_bottom + 10,ScreenWidth - 20,25);
    versionLabel.text = @"For iphone V1.0";
    versionLabel.textColor = [UIColor lightGrayColor];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.numberOfLines = 0;
    [self.view addSubview:versionLabel];

    
   
    UIImageView *logoIcon = [[UIImageView alloc] init];
    logoIcon.frame = CGRectMake(ScreenWidth *0.5 - 65,versionLabel.sh_bottom + 20,130,120);
    logoIcon.image = [UIImage imageNamed:@"appIcon"];
    [self.view addSubview:logoIcon];
    
    UITableView *tabcleV = [[UITableView alloc] init];
    self.tableView = tabcleV;
    tabcleV.delegate = self;
    tabcleV.dataSource = self;
    tabcleV.frame = CGRectMake(0,logoIcon.sh_bottom + 20,ScreenWidth,44);
    [self.view addSubview:tabcleV];
    
    
    UILabel *copyrightLabel = [[UILabel alloc] init];
    copyrightLabel.font = [UIFont systemFontOfSize:13];
    copyrightLabel.frame = CGRectMake(10,ScreenHeight - 50,ScreenWidth - 20,50);
    copyrightLabel.text = @" Copyright©2013-2017 \n  广州网一网信息科技有限公司 版权所有";
    copyrightLabel.textColor = [UIColor blackColor];
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    copyrightLabel.numberOfLines = 0;
    [self.view addSubview:copyrightLabel];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *Id = @"useHelp";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark cell 分割线 两端封头
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
//cell 分割线 两端封头 实现这个两个方法 1
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[UseHelpViewController alloc] init]animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
 
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"关于";
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
