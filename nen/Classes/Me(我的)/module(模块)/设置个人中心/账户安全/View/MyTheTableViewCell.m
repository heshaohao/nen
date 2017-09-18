//
//  MyTheTableViewCell.m
//  nen
//
//  Created by nenios101 on 2017/4/26.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MyTheTableViewCell.h"
#import "SetModel.h"

@interface  MyTheTableViewCell ()

@property(nonatomic,strong) UILabel *headlineTitle;

@property(nonatomic,strong) UILabel *subheadTitle;

@property(nonatomic,strong) UILabel *rightSubheadTitle;

@property(nonatomic,strong) UIButton *rightbtn;

@end

@implementation MyTheTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self addSubViewControl];
    }
    
    return self;
}


- (void)setModel:(SetModel *)model
{
    _model = model;
    
    self.headlineTitle.text = model.titleLabel;
    self.subheadTitle.text = model.dextTitle;
}

- (void)addSubViewControl
{
    UIView *holderView = [[UIView alloc] init];
    holderView.frame = CGRectMake(0, 0,ScreenWidth, 50);
    [self.contentView addSubview:holderView];
    
    UILabel *headlineTitle = [[UILabel alloc] init];
    self.headlineTitle = headlineTitle;
    headlineTitle.frame = CGRectMake(10,10,120,20);
    headlineTitle.font = [UIFont systemFontOfSize:15];
    [holderView addSubview:headlineTitle];
  
    UILabel *subheadTitle = [[UILabel alloc] init];
    self.subheadTitle = subheadTitle;
    subheadTitle.frame = CGRectMake(10,headlineTitle.sh_bottom,200,20);
    subheadTitle.font = [UIFont systemFontOfSize:11];
    subheadTitle.textColor = [UIColor lightGrayColor];
    [holderView addSubview:subheadTitle];
    
    UILabel *rightSubheadTitle = [[UILabel alloc] init];
    self.rightSubheadTitle = rightSubheadTitle;
    rightSubheadTitle.frame = CGRectMake(ScreenWidth *0.6,(holderView.sh_height *0.5) - 10,100,20);
    rightSubheadTitle.font = [UIFont systemFontOfSize:11];
    rightSubheadTitle.textAlignment = NSTextAlignmentRight;
    rightSubheadTitle.textColor = [UIColor lightGrayColor];
    [holderView addSubview:rightSubheadTitle];
   
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightbtn = rightbtn;
    rightbtn.frame = CGRectMake(rightSubheadTitle.sh_right,(holderView.sh_height *0.5) - 15,30,30);
    [rightbtn setTitle:@">" forState:UIControlStateNormal];
    [rightbtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [holderView addSubview:rightbtn];

}

- (void)setRightTtitleStr:(NSString *)rightTtitleStr
{
    _rightTtitleStr = rightTtitleStr;
    
    self.rightSubheadTitle.text = rightTtitleStr;
}


@end
