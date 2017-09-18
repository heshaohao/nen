//
//  IncomeTableViewController.m
//  nen
//
//  Created by nenios101 on 2017/3/9.
//  Copyright © 2017年 nen. All rights reserved.
//  店铺收入   暂时没用

#import "IncomeTableViewController.h"
#import "ReceivablesCell.h"
@interface IncomeTableViewController ()

@end

@implementation IncomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 210;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   NSString *identifier = @"cell";
    
    ReceivablesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ReceivablesCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
}



@end
