//
//  ConsultantIncomeController.m
//  nen
//
//  Created by nenios101 on 2017/3/14.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ConsultantIncomeController.h"
#import "ConsultantIncomeCell.h"
@interface ConsultantIncomeController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ConsultantIncomeController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self addTableView];

}

- (void)addTableView
{
    UITableView *tabVc = [[UITableView alloc] init];
    tabVc.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    tabVc.rowHeight = 200;
    tabVc.dataSource = self;
    tabVc.delegate = self;
    
    [self.view addSubview:tabVc];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    
    ConsultantIncomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ConsultantIncomeCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}


@end
