//
//  TopicManagementController.m
//  nen
//
//  Created by nenios101 on 2017/3/14.
//  Copyright © 2017年 nen. All rights reserved.
//话题管理


#import "TopicManagementController.h"
#import "TopicManagementCell.h"
@interface TopicManagementController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) UIButton *btn;

@end

@implementation TopicManagementController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISearchBar *searBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 64,ScreenWidth * 0.9,40)];
    searBar.placeholder = @"我的话题搜索";
    searBar.showsCancelButton = NO;
    searBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.view addSubview:searBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTableView];
    
    [self addBtn];

}

- (void)addTableView
{
    UITableView *tabVc = [[UITableView alloc] init];
    tabVc.delegate = self;
    tabVc.dataSource = self;
    tabVc.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabVc.rowHeight = 150;
    self.tableView = tabVc;
    tabVc.frame = CGRectMake(0,104,ScreenWidth,ScreenHeight - 154);
    [self.view addSubview:tabVc];
    
}

- (void)addBtn
{
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(ScreenWidth * 0.1,ScreenHeight - 40,ScreenWidth * 0.8,30);
    [_btn setBackgroundColor:[UIColor orangeColor]];
    [_btn setTitle:@"发布话题" forState:UIControlStateNormal];
    _btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btn.clipsToBounds = YES;
    _btn.layer.cornerRadius=5;
    [self.view addSubview:_btn];
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    
    TopicManagementCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TopicManagementCell" owner:nil options:nil] lastObject];
        
    }
    
    return cell;
}



@end
