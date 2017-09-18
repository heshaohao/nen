//
//  CommentsTableViewCell.m
//  nen
//
//  Created by apple on 17/5/15.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "CommentsTableViewCell.h"

@interface CommentsTableViewCell ()
// 头像
@property(nonatomic,strong) UIImageView *iconImagViews;
// 名称
@property(nonatomic,strong) UILabel *userName;
// 时间
@property(nonatomic,strong) UILabel * timeTitles;
// 主题内容
@property(nonatomic,strong) UILabel * mainTitle;
// 容器View
@property(nonatomic,strong) UIView * contrViews;
// 点赞按钮

@end

@implementation CommentsTableViewCell


- (void)setReplyDataDict:(NSDictionary *)replyDataDict
{
    _replyDataDict =replyDataDict;
    
    NSString *iconStr = replyDataDict[@"reply_tx"];
    
    if (iconStr.length)
    {
        [self.iconImagViews sd_setImageWithURL:[NSURL URLWithString:replyDataDict[@"reply_tx"]]];
        
    }else
    {
        self.iconImagViews.image = [UIImage imageNamed:@"3"];
    }
    
    self.userName.text = replyDataDict[@"reply_name"];
    
    NSString *timeStr = replyDataDict[@"reply_time"];
    self.timeTitles.text = [timeStr substringWithRange:NSMakeRange(0, 10)];
   
    NSString *mainTitleStr = replyDataDict[@"reply_content"];
    self.mainTitle.text = mainTitleStr;
    NSDictionary *mainTitleAttrs = @{NSFontAttributeName : self.mainTitle.font};
    CGSize maxSize = CGSizeMake(ScreenWidth - 50, MAXFLOAT);
    CGSize mainTitleSize = [mainTitleStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:mainTitleAttrs context:nil].size;
    self.mainTitle.sh_height = mainTitleSize.height;
    self.mainTitle.sh_width = mainTitleSize.width;

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
    [self.contentView addSubview:contrView];
    
    UIImageView *iconImage = [[UIImageView alloc] init];
    self.iconImagViews = iconImage;
    iconImage.image = [UIImage imageNamed:@"2"];
    iconImage.frame = CGRectMake(10,5,30,30);
    iconImage.layer.cornerRadius = 15;
    iconImage.clipsToBounds = YES;
    [contrView addSubview:iconImage];
    
    UILabel *userName = [[UILabel alloc] init];
    self.userName = userName;
    userName.frame = CGRectMake(iconImage.sh_right + 5,10,120,20);
    userName.font = [UIFont systemFontOfSize:13];
    userName.textColor = [UIColor blackColor];
    userName.text = @"1432423432423";
    [contrView addSubview:userName];
    
    UILabel *timeTitle = [[UILabel alloc] init];
    self.timeTitles = timeTitle;
    timeTitle.frame = CGRectMake(iconImage.sh_right + 5,userName.sh_bottom,120,15);
    timeTitle.font = [UIFont systemFontOfSize:11];
    timeTitle.textColor = [UIColor lightGrayColor];
    timeTitle.text = @"2017-04-24";
    [contrView addSubview:timeTitle];
    
    UILabel *mainTitleLabel = [[UILabel alloc] init];
    self.mainTitle = mainTitleLabel;
    NSString *mainTitleStr = @"sfdsafdsafdsfdsggfdfhgdfghfhfdhfdhdfgdfgdsfgd";
    mainTitleLabel.text = mainTitleStr;
    mainTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    mainTitleLabel.numberOfLines = 0;
    mainTitleLabel.sh_x = timeTitle.sh_x;
    mainTitleLabel.sh_y = timeTitle.sh_bottom;
    NSDictionary *mainTitleAttrs = @{NSFontAttributeName : mainTitleLabel.font};
    CGSize maxSize = CGSizeMake(ScreenWidth - 50, MAXFLOAT);
    CGSize mainTitleSize = [mainTitleStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:mainTitleAttrs context:nil].size;
    mainTitleLabel.sh_height = mainTitleSize.height;
    mainTitleLabel.sh_width = mainTitleSize.width;
    mainTitleLabel.font = [UIFont systemFontOfSize:12];
    mainTitleLabel.textColor = [UIColor lightGrayColor];
    [contrView addSubview:mainTitleLabel];
}

- (CGFloat)returnHight
{
    return self.mainTitle.sh_bottom + 5;
}


@end
