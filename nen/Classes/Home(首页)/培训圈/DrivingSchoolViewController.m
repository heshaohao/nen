//
//  DrivingSchoolViewController.m
//  nen
//
//  Created by nenios101 on 2017/3/8.
//  Copyright © 2017年 nen. All rights reserved.
//  驾校

#import "DrivingSchoolViewController.h"
#import "EducationCell.h"
#import "DrivingTheDetailsController.h"
@interface DrivingSchoolViewController ()

@property(nonatomic,strong) UIButton *btn;

@end

@implementation DrivingSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 150;
    self.tableView.tableHeaderView = [self addHeadView];
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (UIView *)addHeadView
{
    UIView *headView = [[UIView alloc] init];
    
    UISearchBar *searBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 5,ScreenWidth * 0.9,30)];
    searBar.placeholder = @"找驾校 找家教 找教练 找家教";
    searBar.showsCancelButton = NO;
    searBar.searchBarStyle = UISearchBarStyleMinimal;
    [headView addSubview:searBar];
    
    NSArray *familyArray = @[@"1",@"2",@"3",@"4"];
    
    //控制总列数
    int totalColumns = 4;
    // CGFloat Y = 5 ;
    CGFloat W = 80;
    CGFloat H = 50;
    CGFloat X = (self.view.frame.size.width - totalColumns * W) / (totalColumns + 1);
    
    NSArray *nameArray = @[@"C1驾照",@"C2驾照",@"B1驾照",@"B2驾照"];
    
    for (int index = 0; index <familyArray.count ; index++) {
        
        // int row = index / totalColumns;
        int col = index % totalColumns;
        CGFloat viewX = X + col * (W + X);
        // CGFloat viewY = 20 + row * (H + Y);
        
        _btn = [[UIButton alloc] init];
        [_btn setTitle:[NSString stringWithFormat:@"%@",nameArray[index]] forState:UIControlStateNormal];
        
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn setBackgroundColor:[UIColor brownColor]];
        _btn.tag = index+1;
        _btn.frame = CGRectMake(viewX, searBar.sh_bottom + 5, W, H);
        
        [headView addSubview:_btn];
        
    }
//    // 分割线
    UIView *segmentationLine = [[UIView alloc] init];
    segmentationLine.frame = CGRectMake(0,_btn.sh_bottom + 10,ScreenWidth,1);
    segmentationLine.backgroundColor = [UIColor blackColor];
    [headView addSubview:segmentationLine];

    int labelTotalColumns = 4;
    // CGFloat Y = 5 ;
    CGFloat labelW = 80;
    CGFloat labelH = 30;
    CGFloat labelX = (self.view.frame.size.width - labelTotalColumns * labelW) / (labelTotalColumns + 1);
    
    NSArray *classIficationArray = @[@"全部分类 ↓",@"3km ↓",@"综合榜 ↓",@"筛选 ↓"];
    
    for (int index = 0; index <familyArray.count ; index++) {
        
        int col = index % labelTotalColumns;
        CGFloat viewX = labelX + col * (labelW + labelX);
        
        _btn = [[UIButton alloc] init];
        [_btn setTitle:[NSString stringWithFormat:@"%@",classIficationArray[index]] forState:UIControlStateNormal];
        
        [_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont systemFontOfSize: 13];
        _btn.tag = index+1;
        _btn.frame = CGRectMake(viewX, segmentationLine.sh_bottom, labelW, labelH);
        
        [headView addSubview:_btn];
        
    }
    
    // 底部分割线
    UIView *segmentationBottomLine = [[UIView alloc] init];
    segmentationBottomLine.frame = CGRectMake(0,_btn.sh_bottom,ScreenWidth,1);
    segmentationBottomLine.backgroundColor = [UIColor blackColor];
    [headView addSubview:segmentationBottomLine];
    headView.frame = CGRectMake(0, 0,ScreenWidth,segmentationBottomLine.sh_bottom);
    
   return headView;
}
#pragma mark - table view Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[DrivingTheDetailsController new] animated:YES];
}

#pragma mark - table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *ID = @"cell";
    
    
    EducationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EducationCell" owner:nil options:nil]lastObject];
    }
    
    return cell;
}



@end
