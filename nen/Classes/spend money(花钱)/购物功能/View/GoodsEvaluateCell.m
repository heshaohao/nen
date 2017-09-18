//
//  GoodsEvaluateCell.m
//  nen
//
//  Created by nenios101 on 2017/6/13.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "GoodsEvaluateCell.h"
#import "GoodsEvaluateModel.h"

@interface  GoodsEvaluateCell()
// 头像
@property(nonatomic,strong) UIImageView *iconImagViews;
// 名称
@property(nonatomic,strong) UILabel *userName;
// 时间
@property(nonatomic,strong) UILabel * timeTitles;
// 主题内容
@property(nonatomic,strong) UILabel * mainTitle;

@property(nonatomic,strong) UIView *contrViews;

@end

@implementation GoodsEvaluateCell


- (void)setGoodsEvaluatemodel:(GoodsEvaluateModel *)goodsEvaluatemodel
{
    _goodsEvaluatemodel = goodsEvaluatemodel;
    
    [self.iconImagViews sd_setImageWithURL:[NSURL URLWithString:goodsEvaluatemodel.user]];
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubViewControll];
    }
    
    return self;
}

- (void)addSubViewControll
{
    UIView *contrView = [[UIView alloc] init];
    self.contrViews = contrView;
    contrView.backgroundColor = [UIColor whiteColor];
    contrView.frame = CGRectMake(0,5,ScreenWidth,205);
    [self.contentView addSubview:contrView];
    
    UIImageView *iconImage = [[UIImageView alloc] init];
    self.iconImagViews = iconImage;
    iconImage.frame = CGRectMake(10,5,60,60);
    iconImage.layer.cornerRadius = 30;
    iconImage.clipsToBounds = YES;
    [contrView addSubview:iconImage];
    
    UILabel *userName = [[UILabel alloc] init];
    self.userName = userName;
    userName.frame = CGRectMake(iconImage.sh_right + 5,10,120,20);
    userName.font = [UIFont systemFontOfSize:13];
    userName.textColor = [UIColor lightGrayColor];
    userName.text = @"1432423432423";
    [contrView addSubview:userName];
    
    UILabel *timeTitle = [[UILabel alloc] init];
    self.timeTitles = timeTitle;
    timeTitle.frame = CGRectMake(iconImage.sh_right + 5,userName.sh_bottom + 10,120,20);
    timeTitle.font = [UIFont systemFontOfSize:11];
    timeTitle.textColor = [UIColor lightGrayColor];
    timeTitle.text = @"2017-04-24";
    [contrView addSubview:timeTitle];
    
    UILabel *mainTitleLabel = [[UILabel alloc] init];
    self.mainTitle = mainTitleLabel;
    mainTitleLabel.frame = CGRectMake(15,iconImage.sh_bottom + 10,ScreenWidth - 30 ,20);
    mainTitleLabel.font = [UIFont systemFontOfSize:14];
    mainTitleLabel.textColor = [UIColor lightGrayColor];
    mainTitleLabel.text = @"dfdsfdsgfjhghghwehfwhfuh";
    [contrView addSubview:mainTitleLabel];
    
    
    
}


@end
