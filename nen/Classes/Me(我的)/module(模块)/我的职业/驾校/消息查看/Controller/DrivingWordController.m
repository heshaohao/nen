//
//  DrivingWordController.m
//  nen
//
//  Created by nenios101 on 2017/3/14.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "DrivingWordController.h"
#import "DrivingWordCell.h"
@interface DrivingWordController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;

@end

@implementation DrivingWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISearchBar *searBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 64,ScreenWidth * 0.9,40)];
    searBar.placeholder = @"我的话题搜索";
    searBar.showsCancelButton = NO;
    searBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.view addSubview:searBar];
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self addTableView];
}

- (void)addTableView
{
    UITableView *tabVc = [[UITableView alloc] init];
    tabVc.delegate = self;
    tabVc.dataSource = self;
    tabVc.rowHeight = 100;
    self.tableView = tabVc;
    tabVc.frame = CGRectMake(0,104,ScreenWidth,ScreenHeight - 104);
    [self.view addSubview:tabVc];
    
}


#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    
    
    DrivingWordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DrivingWordCell" owner:nil options:nil] lastObject];
        
    }
    
    return cell;
}

@end
