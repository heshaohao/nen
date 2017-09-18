//
//  MyThePublishedViewCell.m
//  nen
//
//  Created by nenios101 on 2017/5/26.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MyThePublishedViewCell.h"
#import "MyThePostModel.h"
#import "PostBtn.h"

@interface MyThePublishedViewCell ()
// 主题内容
@property(nonatomic,strong) UILabel * mainTitle;
// 时间
@property(nonatomic,strong) UILabel * timeTitles;
// 第一张图片
@property(nonatomic,strong) UIImageView *themImage1;
// 第二张图片
@property(nonatomic,strong) UIImageView *themImage2;
// 第三张图片
@property(nonatomic,strong) UIImageView *themImage3;
// 点赞按钮
@property(nonatomic,strong) PostBtn *thumbUpBtns;
// 评论按钮
@property(nonatomic,strong) PostBtn *commentsBtn;
// 删除按钮
@property(nonatomic,strong) UIButton *deleteBtn;
@end

@implementation MyThePublishedViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubViewControll];
    }
    
    return self;
}


- (void)setModel:(MyThePostModel *)model
{
    _model = model;

    [self.commentsBtn setTitle:model.reply_num forState:UIControlStateNormal];
    
    NSString *mainTitleStr = model.title;
    self.mainTitle.text = mainTitleStr;
    NSDictionary *mainTitleAttrs = @{NSFontAttributeName : self.mainTitle.font};
    CGSize maxSize = CGSizeMake(ScreenWidth - 50, MAXFLOAT);
    CGSize mainTitleSize = [mainTitleStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:mainTitleAttrs context:nil].size;
    self.mainTitle.sh_height = mainTitleSize.height;
    self.mainTitle.sh_width = mainTitleSize.width;
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
                    self.themImage1.sh_y = self.mainTitle.sh_bottom + 5;
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
    
    if (imageArray.count == 0)
    {
        self.timeTitles.sh_y =  self.mainTitle.sh_bottom + 10;
        self.thumbUpBtns.sh_y = self.timeTitles.sh_y;
        self.commentsBtn.sh_y = self.thumbUpBtns.sh_y;
        self.deleteBtn.sh_y = self.thumbUpBtns.sh_y;

    }else
    {
        self.timeTitles.sh_y =  self.themImage1.sh_bottom + 10;
        self.thumbUpBtns.sh_y = self.timeTitles.sh_y;
        self.commentsBtn.sh_y = self.thumbUpBtns.sh_y;
        self.deleteBtn.sh_y = self.thumbUpBtns.sh_y;
    }
    
}

- (void)addSubViewControll
{

    UILabel *mainTitleLabel = [[UILabel alloc] init];
    self.mainTitle = mainTitleLabel;
    NSString *mainTitleStr = @"sfdsafdsafdsfdsggfdfhgdfghfhfdhfdhdfgdfgdsfgd";
    mainTitleLabel.text = mainTitleStr;
    mainTitleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    mainTitleLabel.numberOfLines = 0;
    mainTitleLabel.sh_x = 15;
    mainTitleLabel.sh_y = 10;
    NSDictionary *mainTitleAttrs = @{NSFontAttributeName : mainTitleLabel.font};
    CGSize maxSize = CGSizeMake(ScreenWidth -60, MAXFLOAT);
    CGSize mainTitleSize = [mainTitleStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:mainTitleAttrs context:nil].size;
    mainTitleLabel.sh_height = mainTitleSize.height;
    mainTitleLabel.sh_width = mainTitleSize.width;
    mainTitleLabel.font = [UIFont systemFontOfSize:16];
    mainTitleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:mainTitleLabel];
    
    CGFloat themImageX = (ScreenWidth - 240) / 4;
    UIImageView *themImage1 = [[UIImageView alloc] init];
    themImage1.hidden = YES;
    self.themImage1 = themImage1;
    themImage1.frame = CGRectMake(themImageX,mainTitleLabel.sh_bottom, 60,60);
    themImage1.image = [UIImage imageNamed:@"1"];
    [self.contentView addSubview:themImage1];
    
    UIImageView *themImage2 = [[UIImageView alloc] init];
    themImage2.hidden = YES;
    self.themImage2 = themImage2;
    themImage2.frame = CGRectMake(themImage1.sh_right + themImageX,themImage1.sh_y, 60,60);
    themImage2.image = [UIImage imageNamed:@"2"];
    [self.contentView addSubview:themImage2];
    
    UIImageView *themImage3 = [[UIImageView alloc] init];
    themImage3.hidden = YES;
    self.themImage3 = themImage3;
    themImage3.frame = CGRectMake(themImage2.sh_right + themImageX,themImage1.sh_y, 60,60);
    themImage3.image = [UIImage imageNamed:@"3"];
    [self.contentView addSubview:themImage3];
    
    
    UILabel *timeTitle = [[UILabel alloc] init];
    self.timeTitles = timeTitle;
    timeTitle.frame = CGRectMake(20,themImage1.sh_bottom + 10,80,20);
    timeTitle.font = [UIFont systemFontOfSize:11];
    timeTitle.textColor = [UIColor lightGrayColor];
    timeTitle.text = @"2017-04-24";
    [self.contentView addSubview:timeTitle];
    
    PostBtn *thumbUpBtn = [PostBtn buttonWithType:UIButtonTypeCustom];
    self.thumbUpBtns = thumbUpBtn;
        thumbUpBtn.frame = CGRectMake(ScreenWidth - 180,timeTitle.sh_y,60,20);
    [thumbUpBtn horizontalCenterImageAndTitle:-6];
    [thumbUpBtn setImage:[UIImage imageNamed:@"dianzanN"] forState:UIControlStateNormal];
    [thumbUpBtn setImage:[UIImage imageNamed:@"dianzanH"] forState:UIControlStateSelected];
    [thumbUpBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    thumbUpBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [thumbUpBtn setTitle:@"6" forState:UIControlStateNormal];
    [self.contentView addSubview:thumbUpBtn];
    
    
    PostBtn *commentsBtn = [PostBtn buttonWithType:UIButtonTypeCustom];
    [commentsBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.commentsBtn = commentsBtn;
    [commentsBtn horizontalCenterImageAndTitle:-6];
    [commentsBtn setImage:[UIImage imageNamed:@"comments"] forState:UIControlStateNormal];
    [commentsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    commentsBtn.frame = CGRectMake(thumbUpBtn.sh_right + 5 ,self.thumbUpBtns.sh_y,60,20);
    commentsBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [commentsBtn setTitle:@"0" forState:UIControlStateNormal];
    [self.contentView addSubview:commentsBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBtn = deleteBtn;
    [deleteBtn horizontalCenterImageAndTitle:10];
    [deleteBtn setImage:[UIImage imageNamed:@"postDeleteIcon"] forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [deleteBtn sizeToFit];
    deleteBtn.frame = CGRectMake(commentsBtn.sh_right + 5 ,self.thumbUpBtns.sh_y + 5,15,20);
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [self.contentView addSubview:deleteBtn];
    
}

//  评论按钮
- (void)commentBtnClick
{
    NSDictionary *dict = @{@"postId":self.model.id};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushCommentPostVc" object:self userInfo:dict];
}
//  删除按钮
- (void)deleteBtnClick
{
    
    NSDictionary *dict = @{@"postDeleteId":self.model.id};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteIdPost" object:self userInfo:dict];
}

- (CGFloat)rowHeight
{
    
    
    return self.timeTitles.sh_bottom + 10;

    
}


@end
