//
//  EvaluationViewController.m
//  nen
//
//  Created by nenios101 on 2017/3/6.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "EvaluationViewController.h"
#import "GoodsEvaluateModel.h"
#import "GoodsEvaluateCell.h"

@interface EvaluationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tabelView;

@property(nonatomic,strong) GoodsEvaluateCell *goodsCell;
@property(nonatomic,strong) NSMutableArray<GoodsEvaluateModel *> *goodsEvalteArray;

@end

@implementation EvaluationViewController

- (NSMutableArray *)goodsEvalteArray
{
    if (!_goodsEvalteArray) {
        _goodsEvalteArray = [NSMutableArray array];
    }
    return _goodsEvalteArray;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0,99,ScreenWidth,100);
    [UIColor colorWithHexString:@"#F0F0F0"];
    [self.view addSubview:headView];
    
    CGFloat W = ScreenWidth - 50;
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(10,10,W *0.2,30);
    [btn1 setBackgroundColor:[UIColor orangeColor]];
    [btn1 setTitle:@"全部" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.layer.cornerRadius = 5;
    btn1.clipsToBounds = YES;
    btn1.titleLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(btn1.sh_right + 10,10,W *0.25,30);
    [btn2 setBackgroundColor:[UIColor lightGrayColor]];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setTitle:@"追加()" forState:UIControlStateNormal];
    btn2.layer.cornerRadius = 10;
    btn2.clipsToBounds = YES;
    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:btn2];

    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(btn2.sh_right + 10,10,W *0.25,30);
    [btn3 setBackgroundColor:[UIColor lightGrayColor]];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 setTitle:@"有图()" forState:UIControlStateNormal];
    btn3.layer.cornerRadius = 10;
    btn3.clipsToBounds = YES;
    btn3.titleLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(btn3.sh_right + 10,10,W *0.3,30);
    [btn4 setBackgroundColor:[UIColor lightGrayColor]];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn4 setTitle:@"服务不错()" forState:UIControlStateNormal];
    btn4.layer.cornerRadius = 10;
    btn4.clipsToBounds = YES;
    btn4.titleLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:btn4];

    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake(10,btn1.sh_bottom + 10,W *0.3,30);
    [btn5 setBackgroundColor:[UIColor lightGrayColor]];
    [btn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn5 setTitle:@"质量不错()" forState:UIControlStateNormal];
    btn5.layer.cornerRadius = 10;
    btn5.clipsToBounds = YES;
    btn5.titleLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:btn5];

    UIButton *btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn6.frame = CGRectMake(btn5.sh_right + 10,btn5.sh_y,W *0.25,30);
    [btn6 setBackgroundColor:[UIColor lightGrayColor]];
    [btn6 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn6 setTitle:@"物流快()" forState:UIControlStateNormal];
    btn6.layer.cornerRadius = 10;
    btn6.clipsToBounds = YES;
    btn6.titleLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:btn6];
    
    UIButton *btn7 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn7.frame = CGRectMake(btn6.sh_right + 10,btn5.sh_y,W *0.25,30);
    [btn7 setBackgroundColor:[UIColor lightGrayColor]];
    [btn7 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn7 setTitle:@"很实用()" forState:UIControlStateNormal];
    btn7.layer.cornerRadius = 10;
    btn7.clipsToBounds = YES;
    btn7.titleLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:btn7];
    
    UIButton *btn8 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn8.frame = CGRectMake(btn7.sh_right + 10,btn5.sh_y,W *0.2,30);
    [btn8 setBackgroundColor:[UIColor lightGrayColor]];
    [btn8 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn8 setTitle:@"正品()" forState:UIControlStateNormal];
    btn8.layer.cornerRadius = 10;
    btn8.clipsToBounds = YES;
    btn8.titleLabel.font = [UIFont systemFontOfSize:15];
    [headView addSubview:btn8];
   
     __weak typeof(self) weakself = self;
    
    NSString  *evaluationId;
    
    if (self.goodsId.length >0)
    {
        evaluationId = self.goodsId;
    }else
    {
        evaluationId = self.groupGoodsId;
    }
    
    [GoodsEvaluateModel goodsEvaluateModelGoodsId:evaluationId success:^(NSMutableArray<GoodsEvaluateModel *> *goodsEvaluateArray) {
        weakself.goodsEvalteArray  = goodsEvaluateArray;
        
        UITableView *tableV = [[UITableView alloc] init];
        tableV.frame  =CGRectMake(0,199,ScreenWidth,ScreenHeight - 199);
        tableV.delegate = self;
        tableV.dataSource = self;
        tableV.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:tableV];
        tableV.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
        
    } error:^{
        
       // NSLog(@"失败");
        
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // NSLog(@"%lu",(unsigned long)self.goodsEvalteArray.count);
    
    return self.goodsEvalteArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"cell";
    
    GoodsEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if (!cell)
    {
        cell = [[GoodsEvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        self.goodsCell = cell;
    }
    
    cell.goodsEvaluatemodel = self.goodsEvalteArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.goodsCell returnGoodsEvaluateCellHegit];
}

#pragma mark cell 分割线 两端封头
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tabelView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tabelView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tabelView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tabelView setLayoutMargins:UIEdgeInsetsZero];
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



@end
