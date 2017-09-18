//
//  InvestmentCompanyCell.m
//  nen
//
//  Created by nenios101 on 2017/6/21.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "InvestmentCompanyCell.h"
#import "ForumPostModel.h"
#import "PostBtn.h"

@interface InvestmentCompanyCell()
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
@property(nonatomic,strong) PostBtn *thumbUpBtns;
// 评论按钮
@property(nonatomic,strong) PostBtn *commentsBtn;
// 第一张图片
@property(nonatomic,strong) UIImageView *themImage1;
// 第二张图片
@property(nonatomic,strong) UIImageView *themImage2;
// 第三张图片
@property(nonatomic,strong) UIImageView *themImage3;

@end

@implementation InvestmentCompanyCell


- (void)setModel:(ForumPostModel *)model
{
    _model = model;
    self.userName.text = model.user_name;
    
    [self.thumbUpBtns setTitle:[NSString stringWithFormat:@"%@",model.praise_num] forState:UIControlStateNormal];
    [self.thumbUpBtns setTitle:[NSString stringWithFormat:@"%@",model.praise_num] forState:UIControlStateSelected];
    
    if (model.tx.length >0)
    {
        [self.iconImagViews sd_setImageWithURL:[NSURL URLWithString:model.tx]];
        
    }else
    {
        self.iconImagViews.image = [UIImage imageNamed:@"2"];
    }
    
    [self.commentsBtn setTitle:model.reply_num forState:UIControlStateNormal];
    
    self.thumbUpBtns.selected = [model.is_praise isEqualToString:@"1"] ? YES : NO;
    
    NSString *timeStr = model.create_time;
    self.timeTitles.text = [timeStr substringWithRange:NSMakeRange(0, 10)];
    
    
    self.mainTitle.textColor = [UIColor lightGrayColor];
    if ([model.is_top isEqualToString:@"1"])
    {
        self.mainTitle.text = [NSString stringWithFormat:@"%@(热帖)",model.title];
        self.mainTitle.textColor = [UIColor redColor];
    }else
    {
        self.mainTitle.text = model.title;
    }
    
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
                    break;
                case 2:
                    self.themImage2.hidden = NO;
                    [self.themImage2 sd_setImageWithURL:[NSURL URLWithString:obj[str]]];
                    break;
                case 3:
                    self.themImage3.hidden = NO;
                    [self.themImage3 sd_setImageWithURL:[NSURL URLWithString:obj[str]]];
                    break;
                    
                default:
                    break;
            }
        }];
        
    }
    
    
    if (model.imgs.count <= 0)
    {
        self.thumbUpBtns.frame = CGRectMake(ScreenWidth *0.6,self.mainTitle.sh_bottom + 10,60,20);
        self.commentsBtn.frame = CGRectMake(self.thumbUpBtns.sh_right + 20 ,self.thumbUpBtns.sh_y,60,20);
        
    }else
    {
        
        self.thumbUpBtns.frame = CGRectMake(ScreenWidth *0.6,self.themImage1.sh_bottom + 5,60,20);
        self.commentsBtn.frame = CGRectMake(self.thumbUpBtns.sh_right + 20 ,self.thumbUpBtns.sh_y,60,20);
    }
    
    
    self.contrViews.sh_height = self.thumbUpBtns.sh_bottom + 5;
    
    
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
    
    CGFloat W = (ScreenWidth - 20) / 3;
    CGFloat H = 130;
    CGFloat X = (ScreenWidth - 3 * W) / (3 + 1);
    
    
    UIImageView *themImage1 = [[UIImageView alloc] init];
    themImage1.hidden = YES;
    self.themImage1 = themImage1;
    themImage1.frame = CGRectMake(X,mainTitleLabel.sh_bottom, W,H);
    themImage1.image = [UIImage imageNamed:@"1"];
    [contrView addSubview:themImage1];
    
    UIImageView *themImage2 = [[UIImageView alloc] init];
    themImage2.hidden = YES;
    self.themImage2 = themImage2;
    themImage2.frame = CGRectMake(themImage1.sh_right + X,mainTitleLabel.sh_bottom, W,H);
    themImage2.image = [UIImage imageNamed:@"2"];
    [contrView addSubview:themImage2];
    
    UIImageView *themImage3 = [[UIImageView alloc] init];
    themImage3.hidden = YES;
    self.themImage3 = themImage3;
    themImage3.frame = CGRectMake(themImage2.sh_right + X,mainTitleLabel.sh_bottom, W,H);
    themImage3.image = [UIImage imageNamed:@"3"];
    [contrView addSubview:themImage3];
    
    
    PostBtn *thumbUpBtn = [PostBtn buttonWithType:UIButtonTypeCustom];
    self.thumbUpBtns = thumbUpBtn;
    [thumbUpBtn addTarget:self action:@selector(thumbUpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [thumbUpBtn horizontalCenterImageAndTitle:-6];
    [thumbUpBtn setImage:[UIImage imageNamed:@"dianzanN"] forState:UIControlStateNormal];
    [thumbUpBtn setImage:[UIImage imageNamed:@"dianzanH"] forState:UIControlStateSelected];
    thumbUpBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [thumbUpBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    thumbUpBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contrViews addSubview:thumbUpBtn];
    
    
    PostBtn *commentsBtn = [PostBtn buttonWithType:UIButtonTypeCustom];
    [commentsBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.commentsBtn = commentsBtn;
    [commentsBtn horizontalCenterImageAndTitle:-6];
    [commentsBtn setImage:[UIImage imageNamed:@"comments"] forState:UIControlStateNormal];
    commentsBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [commentsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    commentsBtn.frame = CGRectMake(ScreenWidth - 45 ,self.thumbUpBtns.sh_y,20,15);
    commentsBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contrViews addSubview:commentsBtn];
}


#pragma mark 评论按钮
- (void)commentBtnClick
{
    
    NSDictionary *dict = @{@"id":self.model.id};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"investmentCommentBtn" object:self userInfo:dict];
    
}


#pragma mark 点赞按钮
- (void)thumbUpBtnClick:(UIButton *)btn
{
    
    if (!self.thumbUpBtns.selected)
    {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/post/addpraise"];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
        
        NSDictionary *dict = @{@"id":self.model.id};
        
        [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            
          //  NSLog(@"%@",responseObject);
            
            self.thumbUpBtns.selected = YES;
            
            NSInteger thumbCount = [btn.titleLabel.text integerValue];
            [btn setTitle:[NSString stringWithFormat:@"%d",thumbCount + 1] forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"%d",thumbCount + 1] forState:UIControlStateSelected];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"investmentThumbBtn" object:self];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSLog(@"%@",error);
            
        }];
        
    }else
    {
        [JKAlert alertText:@"你已经点赞过"];
    }
    
    
}

- (CGFloat)rowHeight
{
    
    
    return self.thumbUpBtns.sh_bottom + 10;
}

@end
