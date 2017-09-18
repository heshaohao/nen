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
@property(nonatomic,strong) UILabel * commentsTimeTitles;
// 主题内容
@property(nonatomic,strong) UILabel * commentsMainTitleLabel;

@property(nonatomic,strong) UIView *contrViews;

@property(nonatomic,strong) UILabel *shopMainTitleLabel;

@property(nonatomic,strong) UILabel *shopTimeTitle;

@end

@implementation GoodsEvaluateCell


- (void)setGoodsEvaluatemodel:(GoodsEvaluateModel *)goodsEvaluatemodel
{
    _goodsEvaluatemodel = goodsEvaluatemodel;
    
    [self.iconImagViews sd_setImageWithURL:[NSURL URLWithString:goodsEvaluatemodel.user_img]];
    
    self.userName.text = [NSString stringWithFormat:@"%@",goodsEvaluatemodel.user_name];
    self.commentsTimeTitles.text = goodsEvaluatemodel.create_time;
    self.commentsMainTitleLabel.text = goodsEvaluatemodel.content;
    
    self.shopMainTitleLabel.hidden = YES;
    self.shopMainTitleLabel.hidden = YES;
    
    if (goodsEvaluatemodel.reply.length !=0)
    {
        self.shopMainTitleLabel.hidden = NO;
        self.shopTimeTitle.hidden = NO;
        self.shopMainTitleLabel.text = [NSString stringWithFormat:@"商家回复: %@",goodsEvaluatemodel.reply];
    }
    
    
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
    contrView.frame = CGRectMake(0,5,ScreenWidth,145);
    [self.contentView addSubview:contrView];
    
    UIImageView *iconImage = [[UIImageView alloc] init];
    self.iconImagViews = iconImage;
    iconImage.frame = CGRectMake(10,5,30,30);
    iconImage.layer.cornerRadius = 15;
    iconImage.clipsToBounds = YES;
    [contrView addSubview:iconImage];
    
    UILabel *userName = [[UILabel alloc] init];
    self.userName = userName;
    userName.frame = CGRectMake(iconImage.sh_right + 5,10,120,20);
    userName.font = [UIFont systemFontOfSize:13];
    userName.textColor = [UIColor lightGrayColor];
    userName.text = @"1432423432423";
    [contrView addSubview:userName];
    
    UILabel *commentsTimeTitle = [[UILabel alloc] init];
    self.commentsTimeTitles = commentsTimeTitle;
    commentsTimeTitle.frame = CGRectMake(ScreenWidth - 210,10,200,25);
    commentsTimeTitle.textAlignment = NSTextAlignmentRight;
    commentsTimeTitle.font = [UIFont systemFontOfSize:13];
    commentsTimeTitle.textColor = [UIColor blackColor];
    commentsTimeTitle.text = @"2017-04-24";
    [contrView addSubview:commentsTimeTitle];
    
    UILabel *commentsMainTitleLabel = [[UILabel alloc] init];
    self.commentsMainTitleLabel = commentsMainTitleLabel;
    commentsMainTitleLabel.frame = CGRectMake(10,iconImage.sh_bottom + 10,ScreenWidth - 20 ,25);
    commentsMainTitleLabel.font = [UIFont systemFontOfSize:14];
    commentsMainTitleLabel.textColor = [UIColor lightGrayColor];
    commentsMainTitleLabel.text = @"dfdsfdsgfjhghghwehfwhfuh";
    [contrView addSubview:commentsMainTitleLabel];
    
    UILabel *shopMainTitleLabel = [[UILabel alloc] init];
    self.shopMainTitleLabel = shopMainTitleLabel;
    shopMainTitleLabel.frame = CGRectMake(10,commentsMainTitleLabel.sh_bottom + 10,ScreenWidth - 20 ,25);
    shopMainTitleLabel.font = [UIFont systemFontOfSize:12];
    shopMainTitleLabel.textColor = [UIColor lightGrayColor];
    shopMainTitleLabel.text = @"dfdsfdsgfjhghghwehfwhfuh";
    [contrView addSubview:shopMainTitleLabel];
    
    UILabel *shopTimeTitle = [[UILabel alloc] init];
    self.shopTimeTitle = shopTimeTitle;
    shopTimeTitle.frame = CGRectMake(ScreenWidth - 130,shopMainTitleLabel.sh_bottom + 10,120,25);
    shopTimeTitle.textAlignment = NSTextAlignmentRight;
    shopTimeTitle.font = [UIFont systemFontOfSize:13];
    shopTimeTitle.textColor = [UIColor blackColor];
    shopTimeTitle.text = @"2017-04-24";
    [contrView addSubview:shopTimeTitle];

}


- (CGFloat)returnGoodsEvaluateCellHegit
{
    
 
    
    if (![self.goodsEvaluatemodel.reply isEqualToString:@""])
    {
        self.contrViews.sh_height = self.shopTimeTitle.sh_bottom + 10;
       
       // NSLog(@"%f",self.contrViews.sh_bottom);
        return self.contrViews.sh_bottom;
    }else
    {   self.contrViews.sh_height = self.commentsMainTitleLabel.sh_bottom + 10;
       // NSLog(@"%f",self.contrViews.sh_bottom);
        self.shopTimeTitle.hidden = YES;
        self.shopMainTitleLabel.hidden = YES;
        return self.contrViews.sh_bottom;;
    }
    
}

@end
