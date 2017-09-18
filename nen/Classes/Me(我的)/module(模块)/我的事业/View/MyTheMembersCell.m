//
//  MyTheMembersCell.m
//  nen
//
//  Created by nenios101 on 2017/5/27.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MyTheMembersCell.h"
#import "MembersModel.h"

@interface MyTheMembersCell ()

@property(nonatomic,strong) UILabel *serialNumberLabel;

@property(nonatomic,strong) UILabel *registeredLabel;

@property(nonatomic,strong) UILabel *mobileLabel;

@property(nonatomic,strong) UILabel *stateLabel;


@end

@implementation MyTheMembersCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubViewControll];
    }
    
    return self;
}

- (void)setModel:(MembersModel *)model
{
    _model = model;
    
    
    self.stateLabel.text = model.status;
    self.registeredLabel.text = model.create_time;
    self.mobileLabel.text = model.mobile;
    self.serialNumberLabel.text = self.index;
}

- (void)addSubViewControll
{
    UIView *formView = [[UIView alloc] init];
    formView.frame = CGRectMake(10,0,ScreenWidth - 20,40);
    formView.layer.borderWidth = 1.0f;
    formView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.contentView addSubview:formView];
    
    CGFloat W = (formView.sh_width - 46) / 3;
    
    UILabel *serialNumberLabel = [[UILabel alloc] init];
    self.serialNumberLabel = serialNumberLabel;
    serialNumberLabel.frame = CGRectMake(0,0,40,40);
    serialNumberLabel.text = @"SN";
    serialNumberLabel.textAlignment = NSTextAlignmentCenter;
    serialNumberLabel.backgroundColor = [UIColor seaShell];
    [formView addSubview:serialNumberLabel];
    
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.frame = CGRectMake(serialNumberLabel.sh_right,0,2,40);
    lineView1.backgroundColor = [UIColor lightGrayColor];
    [formView addSubview:lineView1];
    
    UILabel *registeredLabel = [[UILabel alloc] init];
    self.registeredLabel = registeredLabel;
    registeredLabel.frame = CGRectMake(lineView1.sh_right,0,W,40);
    registeredLabel.text = @"注册时间";
    registeredLabel.textAlignment = NSTextAlignmentCenter;
    registeredLabel.font = [UIFont systemFontOfSize:13];
    registeredLabel.backgroundColor = [UIColor seaShell];
    [formView addSubview:registeredLabel];
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.frame = CGRectMake(registeredLabel.sh_right,0,2,40);
    lineView2.backgroundColor = [UIColor lightGrayColor];
    [formView addSubview:lineView2];
    
    UILabel *mobileLabel = [[UILabel alloc] init];
    self.mobileLabel = mobileLabel;
    mobileLabel.font = [UIFont systemFontOfSize:11];
    mobileLabel.frame = CGRectMake(lineView2.sh_right,0,W,40);
    mobileLabel.text = @"成员手机号码";
    mobileLabel.textAlignment = NSTextAlignmentCenter;
    [formView addSubview:mobileLabel];
    
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.frame = CGRectMake(mobileLabel.sh_right,0,2,40);
    lineView3.backgroundColor = [UIColor lightGrayColor];
    [formView addSubview:lineView3];
    
    UILabel *stateLabel = [[UILabel alloc] init];
    self.stateLabel = stateLabel;
    stateLabel.frame = CGRectMake(lineView3.sh_right,0,W,40);
    stateLabel.font = [UIFont systemFontOfSize:13];
    stateLabel.text = @"成员状态";
    stateLabel.textAlignment = NSTextAlignmentCenter;
    [formView addSubview:stateLabel];

}


@end
