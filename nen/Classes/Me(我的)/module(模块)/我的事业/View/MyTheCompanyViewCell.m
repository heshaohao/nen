//
//  MyTheCompanyViewCell.m
//  nen
//
//  Created by nenios101 on 2017/5/27.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MyTheCompanyViewCell.h"
#import "MyemployeecountModel.h"

@interface MyTheCompanyViewCell()

@property (nonatomic,strong) UILabel *serialNumberLabel;

@property (nonatomic,strong) UILabel *subjectsLabel1;
@property (nonatomic,strong) UILabel *subjectsLabel2;


@property (nonatomic,strong) UILabel *countLabel1;
@property (nonatomic,strong) UILabel *countLabel2;

@property (nonatomic,strong) UIButton *stateBtn1;
@property (nonatomic,strong) UIButton *stateBtn2;

@end

@implementation MyTheCompanyViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubViewControll];
    }
    
    return self;
}

- (void)setModel:(MyemployeecountModel *)model
{
    _model = model;
    
    if ([self.index isEqualToString:@"1"])
    {
              
        self.countLabel1.text = [NSString stringWithFormat:@"%@",model.count];
        self.countLabel2.text = [NSString stringWithFormat:@"%@",model.allcount];
        
    }
    
}

-(void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    
    self.serialNumberLabel.text = dataDict[@"name"];
    self.subjectsLabel1.text =dataDict[@"one"];
    self.subjectsLabel2.text =dataDict[@"two"];
    
    NSString *operationStr = dataDict[@"operation"];
//    if ([operationStr isEqualToString:@"1"])
//    {
//        [self.stateBtn1 setTitle:@"查看" forState:UIControlStateNormal];
//         [self.stateBtn2 setTitle:@"查看" forState:UIControlStateNormal];
//    }
    

    
    
}
- (void)addSubViewControll
{
    UIView *formView = [[UIView alloc] init];
    formView.frame = CGRectMake(10,0,ScreenWidth - 20,80);
    formView.layer.borderWidth = 1.0f;
    formView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.contentView addSubview:formView];
    
    CGFloat W = (formView.sh_width - 6) /  4;
    
    // 公司名称
    UILabel *serialNumberLabel = [[UILabel alloc] init];
    self.serialNumberLabel = serialNumberLabel;
    serialNumberLabel.frame = CGRectMake(0,0,W,80);
    serialNumberLabel.text = @"营销公";
    serialNumberLabel.font = [UIFont systemFontOfSize:13];
    serialNumberLabel.textAlignment = NSTextAlignmentCenter;
    [formView addSubview:serialNumberLabel];
    
    
  // 科目
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.frame = CGRectMake(serialNumberLabel.sh_right,0,2,80);
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [formView addSubview:lineView1];
    
    UILabel *subjectsLabel1 = [[UILabel alloc] init];
    self.subjectsLabel1 = subjectsLabel1;
    subjectsLabel1.frame = CGRectMake(lineView1.sh_right,0,W,39);
    subjectsLabel1.text = @"科目";
    subjectsLabel1.textAlignment = NSTextAlignmentCenter;
    subjectsLabel1.font = [UIFont systemFontOfSize:13];
    [formView addSubview:subjectsLabel1];
   
    
    UILabel *subjectsLabel2 = [[UILabel alloc] init];
    self.subjectsLabel2 = subjectsLabel2;
    subjectsLabel2.frame = CGRectMake(lineView1.sh_right,subjectsLabel1.sh_bottom,W,39);
    subjectsLabel2.text = @"科目";
    subjectsLabel2.textAlignment = NSTextAlignmentCenter;
    subjectsLabel2.font = [UIFont systemFontOfSize:13];
    [formView addSubview:subjectsLabel2];
    
    
//    // 数量
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.frame = CGRectMake(subjectsLabel1.sh_right,0,2,80);
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [formView addSubview:lineView2];
    
    UILabel *countLabel1 = [[UILabel alloc] init];
    self.countLabel1 = countLabel1;
    countLabel1.font = [UIFont systemFontOfSize:13];
    countLabel1.frame = CGRectMake(lineView2.sh_right,0,W,39);
    countLabel1.text = @"0";
    countLabel1.textAlignment = NSTextAlignmentCenter;

    [formView addSubview:countLabel1];
    
    UILabel *countLabel2 = [[UILabel alloc] init];
    self.countLabel2 = countLabel2;
    countLabel2.font = [UIFont systemFontOfSize:13];
    countLabel2.frame = CGRectMake(lineView2.sh_right,countLabel1.sh_bottom,W,39);
    countLabel2.text = @"0";
    countLabel2.textAlignment = NSTextAlignmentCenter;
    
    [formView addSubview:countLabel2];
    
    
    // 操作
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.frame = CGRectMake(countLabel1.sh_right,0,2,80);
    lineView3.backgroundColor = [UIColor lightGrayColor];
    [formView addSubview:lineView3];
    
    
    UIButton *stateBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.stateBtn1 = stateBtn1;
    stateBtn1.frame = CGRectMake(lineView3.sh_right,0,W,39);
    stateBtn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [stateBtn1 setTitle:@"操作" forState:UIControlStateNormal];
    [stateBtn1 addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    stateBtn1.titleLabel.textAlignment = NSTextAlignmentCenter;
    [stateBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [formView addSubview:stateBtn1];
    
    
    UIButton *stateBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.stateBtn2 = stateBtn2;
    stateBtn2.frame = CGRectMake(lineView3.sh_right,stateBtn1.sh_bottom,W,39);
    stateBtn2.titleLabel.font = [UIFont systemFontOfSize:13];
    [stateBtn2 setTitle:@"操作" forState:UIControlStateNormal];
    [stateBtn2 addTarget:self action:@selector(tapActionTwo) forControlEvents:UIControlEventTouchUpInside];
    stateBtn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    [stateBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [formView addSubview:stateBtn2];

    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(subjectsLabel1.sh_x,subjectsLabel1.sh_bottom,(formView.sh_width - 3)-W,2);
    bottomView.backgroundColor = [UIColor lightGrayColor];
    [formView addSubview:bottomView];
    
}

#pragma mark 点击操作
- (void)tapAction
{
   NSString *MembersType = @"1";
    
    NSDictionary * dict = @{@"typeIndex":self.index,@"membersType":MembersType};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickTag" object:self userInfo:dict];
    
}
#pragma mark 二级成员
- (void)tapActionTwo
{
    // 成员
    NSString *MembersType = @"2";
    
   NSDictionary * dict = @{@"typeIndex":self.index,@"membersType":MembersType};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickTag" object:self userInfo:dict];
    
}


@end
