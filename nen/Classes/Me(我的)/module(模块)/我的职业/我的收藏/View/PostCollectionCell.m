//
//  PostCollectionCell.m
//  nen
//
//  Created by nenios101 on 2017/6/20.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "PostCollectionCell.h"
#import "PostCollectionModel.h"
#import "PostBtn.h"

@interface PostCollectionCell()

@property(nonatomic,strong) UILabel *contenLabel;

@property(nonatomic,strong) UILabel *releaseName;

@property(nonatomic,strong) UIView *contentViews;

// 评论按钮
@property(nonatomic,strong) PostBtn *commentsBtn;
// 删除按钮
@property(nonatomic,strong) UIButton *deleteBtn;

@end

@implementation PostCollectionCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubViewControll];
    }
    
    return self;
}


- (void)setPostModel:(PostCollectionModel *)postModel
{
    _postModel = postModel;
    
    self.contenLabel.text = postModel.title;
    
    NSString *userTitleStr = postModel.user_name;
    self.releaseName.text = userTitleStr;
    NSDictionary *mainTitleAttrs = @{NSFontAttributeName : self.releaseName.font};
    CGSize maxSize = CGSizeMake(MAXFLOAT,20);
    CGSize mainTitleSize = [userTitleStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:mainTitleAttrs context:nil].size;
    self.releaseName.sh_height = 20;
    self.releaseName.sh_width = mainTitleSize.width;
    
    [self.commentsBtn setTitle:[NSString stringWithFormat:@"%@",postModel.reply_num] forState:UIControlStateNormal];
}
- (void)addSubViewControll
{
    UIView *contenrView = [[UIView alloc] init];
    contenrView.backgroundColor = [UIColor whiteColor];
    self.contentViews = contenrView;
    contenrView.frame = CGRectMake(0,0,ScreenWidth,75);
    [self.contentView addSubview:contenrView];
    
    UILabel *contenLabel = [[UILabel alloc] init];
    self.contenLabel = contenLabel;
    contenLabel.frame = CGRectMake(10,0,ScreenWidth - 20,30);
    contenLabel.numberOfLines = 0;
    contenLabel.font = [UIFont systemFontOfSize:15];
    contenLabel.textColor = [UIColor blackColor];
    contenLabel.text = @"1432423432423";
    [contenrView addSubview:contenLabel];

    
    UILabel *releaseName = [[UILabel alloc] init];
    self.releaseName = releaseName;
    releaseName.frame = CGRectMake(10,contenLabel.sh_bottom + 10,150,20);
    releaseName.numberOfLines = 0;
    releaseName.textColor = [UIColor whiteColor];
    releaseName.backgroundColor = [UIColor lightGrayColor];
    releaseName.font = [UIFont systemFontOfSize:13];
    [contenrView addSubview:releaseName];
    
    
    PostBtn *commentsBtn = [PostBtn buttonWithType:UIButtonTypeCustom];
    [commentsBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.commentsBtn = commentsBtn;
    [commentsBtn horizontalCenterImageAndTitle:-6];
    [commentsBtn setImage:[UIImage imageNamed:@"comments"] forState:UIControlStateNormal];
    [commentsBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    commentsBtn.frame = CGRectMake(ScreenWidth - 100 ,self.releaseName.sh_y,60,20);
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
    deleteBtn.frame = CGRectMake(commentsBtn.sh_right + 5 ,self.commentsBtn.sh_y,15,20);
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [self.contentView addSubview:deleteBtn];

    
}

//  评论按钮
- (void)commentBtnClick
{
    NSDictionary *dict = @{@"postId":self.postModel.id};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"collectionCommentPushVc" object:self userInfo:dict];
}
//  删除按钮
- (void)deleteBtnClick
{
    
    NSDictionary *dict = @{@"postDeleteId":self.postModel.id};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelTheCollection" object:self userInfo:dict];
}


@end
