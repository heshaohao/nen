//
//  AdviserCompleteController.m
//  nen
//
//  Created by nenios101 on 2017/3/14.
//  Copyright © 2017年 nen. All rights reserved.
//已完成

#import "AdviserCompleteController.h"
#import "AdviserCompleteCell.h"
@interface AdviserCompleteController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AdviserCompleteController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableView];
    
}

- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 150;
    tableView.bounces = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.frame = CGRectMake(0,64 + 39,ScreenWidth,ScreenHeight);
    
    UIView *colorView = [[UIView alloc] init];
    colorView.backgroundColor = [UIColor orangeColor];
    tableView.backgroundView = colorView;
    
    [self.view addSubview:tableView];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * ID = @"cell";
    
    AdviserCompleteCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AdviserCompleteCell" owner:nil options:nil] lastObject];
    }
    
    return  cell;
    
}
@end
