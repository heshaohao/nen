//
//  MyTheCommentCell.m
//  nen
//
//  Created by nenios101 on 2017/5/26.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MyTheCommentCell.h"
#import "PostCommentsModel.h"
@interface MyTheCommentCell ()
// 头像
@property(nonatomic,strong) UIImageView *iconImagViews;
// 名称
@property(nonatomic,strong) UILabel *userName;
// 时间
@property(nonatomic,strong) UILabel * timeTitles;
// 主题内容
@property(nonatomic,strong) UILabel * mainTitle;
// 标题
@property(nonatomic,strong) UILabel * posTitle;
// 第一张图片
@property(nonatomic,strong) UIImageView *themImage1;
// 第二张图片
@property(nonatomic,strong) UIImageView *themImage2;
// 第三张图片
@property(nonatomic,strong) UIImageView *themImage3;


@end

@implementation MyTheCommentCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubViewControll];
    }
    
    return self;
}

- (void)setModel:(PostCommentsModel *)model
{
    _model = model;
    
    if (self.model.tx.length == 0)
    {
        self.iconImagViews.image = [UIImage imageNamed:@"3"];
    }else
    {
        [self.iconImagViews sd_setImageWithURL:[NSURL URLWithString:model.tx]];
    }
    
    
    NSString *timeStr = model.create_time;
    self.timeTitles.text = [timeStr substringWithRange:NSMakeRange(0, 10)];
    self.userName.text = model.name;
    
    NSString *mainTitleStr = model.content;
    self.mainTitle.text = mainTitleStr;
    NSDictionary *mainTitleAttrs = @{NSFontAttributeName : self.mainTitle.font};
    CGSize maxSize = CGSizeMake(ScreenWidth - 50, MAXFLOAT);
    CGSize mainTitleSize = [mainTitleStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:mainTitleAttrs context:nil].size;
    self.mainTitle.sh_height = mainTitleSize.height;
    self.mainTitle.sh_width = mainTitleSize.width;
    
    
    NSString *postStr = model.title;
    self.posTitle.text = postStr;
    NSDictionary *titleAttrs = @{NSFontAttributeName : self.posTitle.font};
    CGSize titleSize = CGSizeMake(ScreenWidth - 50, MAXFLOAT);
    CGSize PostTitleSize = [postStr boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttrs context:nil].size;
    self.posTitle.sh_height = PostTitleSize.height;
    self.posTitle.sh_width = PostTitleSize.width;
    self.posTitle.sh_y = self.mainTitle.sh_bottom + 5;
    NSMutableArray *imageArray = model.imgs;
    
    // 每次加载图片先隐藏 防止重复cell里面图片重复错乱
    self.themImage1.hidden = YES;
    self.themImage2.hidden = YES;
    self.themImage3.hidden = YES;
    if (imageArray.count >0)
    {
        [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
            
            NSString *str = [NSString stringWithFormat:@"img%d",index + 1];
            
            switch (index + 1) {
                case 1:
                    self.themImage1.hidden = NO;
                    [self.themImage1 sd_setImageWithURL:[NSURL URLWithString:obj[str]]];
                    self.themImage1.sh_y = self.posTitle.sh_bottom + 5;
                    break;
                case 2:
                    self.themImage2.hidden = NO;
                    [self.themImage2 sd_setImageWithURL:[NSURL URLWithString:obj[str]]];
                    self.themImage2.sh_y = self.themImage1.sh_y;
                    break;
                case 3:
                    self.themImage3.hidden = NO;
                    [self.themImage3 sd_setImageWithURL:[NSURL URLWithString:obj[str]]];
                    self.themImage3.sh_y = self.themImage1.sh_y;
                    break;
                    
                default:
                    break;
            }
        }];
        
    }
    
}


- (void)addSubViewControll
{
    UIImageView *iconImage = [[UIImageView alloc] init];
    self.iconImagViews = iconImage;
    iconImage.frame = CGRectMake(10,5,60,60);
    iconImage.layer.cornerRadius = 30;
    iconImage.clipsToBounds = YES;
    [self.contentView addSubview:iconImage];
    
    UILabel *userName = [[UILabel alloc] init];
    self.userName = userName;
    userName.frame = CGRectMake(iconImage.sh_right + 5,10,120,20);
    userName.font = [UIFont systemFontOfSize:13];
    userName.textColor = [UIColor lightGrayColor];
    userName.text = @"1432423432423";
    [self.contentView addSubview:userName];
    
    UILabel *timeTitle = [[UILabel alloc] init];
    self.timeTitles = timeTitle;
    timeTitle.frame = CGRectMake(iconImage.sh_right + 5,userName.sh_bottom + 10,120,20);
    timeTitle.font = [UIFont systemFontOfSize:11];
    timeTitle.textColor = [UIColor lightGrayColor];
    timeTitle.text = @"2017-04-24";
    [self.contentView addSubview:timeTitle];

    
    UIImageView *mainTitleIcon = [[UIImageView alloc] init];
    mainTitleIcon.frame = CGRectMake(iconImage.sh_x,iconImage.sh_bottom + 5,15, 15);
    mainTitleIcon.image = [UIImage imageNamed:@"3"];
    [self.contentView addSubview:mainTitleIcon];
    
    UILabel *mainTitleLabel = [[UILabel alloc] init];
    self.mainTitle = mainTitleLabel;
    NSString *mainTitleStr = @"sfdsafdsafdsfdsggfdfhgdfghfhfdhfdhdfgdfgdsfgd";
    mainTitleLabel.text = mainTitleStr;
    mainTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    mainTitleLabel.numberOfLines = 0;
    mainTitleLabel.sh_x = mainTitleIcon.sh_right + 5;
    mainTitleLabel.sh_y = mainTitleIcon.sh_y;
    NSDictionary *mainTitleAttrs = @{NSFontAttributeName : mainTitleLabel.font};
    CGSize maxSize = CGSizeMake(ScreenWidth -60, MAXFLOAT);
    CGSize mainTitleSize = [mainTitleStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:mainTitleAttrs context:nil].size;
    mainTitleLabel.sh_height = mainTitleSize.height;
    mainTitleLabel.sh_width = mainTitleSize.width;
    mainTitleLabel.font = [UIFont systemFontOfSize:16];
    mainTitleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:mainTitleLabel];
    
    
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    self.posTitle  = titleLabel;
    NSString *titleStr = @"sfdsfxckgkdsfwfdsfffgd";
    titleLabel.text = mainTitleStr;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.numberOfLines = 0;
    titleLabel.sh_x = 15;
    titleLabel.sh_y = mainTitleLabel.sh_bottom ;
    NSDictionary *titleAttrs = @{NSFontAttributeName : mainTitleLabel.font};
    CGSize titleSize = CGSizeMake(ScreenWidth -60, MAXFLOAT);
    CGSize PostTitleSize = [titleStr boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttrs context:nil].size;
    titleLabel.sh_height = PostTitleSize.height;
    titleLabel.sh_width = PostTitleSize.width;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:titleLabel];
    CGFloat themImageX = (ScreenWidth - 240) / 4;
    
    UIImageView *themImage1 = [[UIImageView alloc] init];
    themImage1.hidden = YES;
    self.themImage1 = themImage1;
    themImage1.frame = CGRectMake(themImageX,titleLabel.sh_bottom, 80,80);
    themImage1.image = [UIImage imageNamed:@"1"];
    [self.contentView addSubview:themImage1];
    
    UIImageView *themImage2 = [[UIImageView alloc] init];
    themImage2.hidden = YES;
    self.themImage2 = themImage2;
    themImage2.frame = CGRectMake(themImage1.sh_right + themImageX,titleLabel.sh_bottom, 80,80);
    themImage2.image = [UIImage imageNamed:@"2"];
    [self.contentView addSubview:themImage2];
    
    UIImageView *themImage3 = [[UIImageView alloc] init];
    themImage3.hidden = YES;
    self.themImage3 = themImage3;
    themImage3.frame = CGRectMake(themImage2.sh_right + themImageX,titleLabel.sh_bottom, 80,80);
    themImage3.image = [UIImage imageNamed:@"3"];
    [self.contentView addSubview:themImage3];

    
}


- (CGFloat)rowHeight
{
    
    if (self.model.imgs.count == 0)
    {
        return self.posTitle.sh_bottom + 10;
    }else
    {
        return self.themImage1.sh_bottom + 10;
    }
}

@end
