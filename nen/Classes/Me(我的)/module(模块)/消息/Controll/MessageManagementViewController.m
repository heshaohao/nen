//
//  MessageManagementViewController.m
//  nen
//
//  Created by nenios101 on 2017/6/28.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MessageManagementViewController.h"
#import "NotificationMessageViewController.h"
#import "MainViewController.h"

@interface MessageManagementViewController ()

@property(nonatomic,strong) NSArray *dataArray;

@end

@implementation MessageManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.scrollEnabled = NO;
}


- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@[@{@"icon":@"PushMessageIcon",@"title":@"聊天消息"}],@[@{@"icon":@"PushMessageIcon",@"title":@"通知消息"}]];
    }
    return _dataArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *sectionArray = self.dataArray[section];
    
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *Id = @"messageCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    
    
    NSArray *array = self.dataArray[indexPath.section];
    
    cell.imageView.image = [UIImage imageNamed:array[indexPath.row][@"icon"]];
    cell.textLabel.text = array[indexPath.row][@"title"];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [self.navigationController pushViewController:[[MainViewController alloc] init] animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 0)
    {
        [self.navigationController pushViewController:[[NotificationMessageViewController alloc] init] animated:YES];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBar];
}

#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"消息管理";
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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
    if (section == 0)
    {
        return 20;
    }else
    {
        return 10;
    }
    
}

@end
