//
//  CommentsTheManagementCell.m
//  nen
//
//  Created by nenios101 on 2017/7/3.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "CommentsTheManagementCell.h"
#import "ShopGoodsCommentsModel.h"

@interface CommentsTheManagementCell()

@property(nonatomic,strong) UIImageView *iconImageView;

@property(nonatomic,strong) UILabel *goodsLabels;

@property(nonatomic,strong) UILabel *remarkLabels;

@property(nonatomic,strong) UILabel *priceLabels;

@property(nonatomic,strong) UILabel *shopName;

@property(nonatomic,strong) UIView *mainBodyViews;

@property(nonatomic,strong) UIImageView *starImage;

// 回复状态
@property(nonatomic,strong) UILabel *replyStateLabels;

//评价内容
@property(nonatomic,strong) UILabel *evaluationContentLabels;

// 回复者名称
@property(nonatomic,strong) UILabel *evaluationNameLabel;
// 时间
@property(nonatomic,strong) UILabel *evaluationTimeLabels;
// 回复内容
@property(nonatomic,strong) UILabel *replyContentLabels;
// 回复时间
@property(nonatomic,strong) UILabel *replyTimeLabel;


@end


#define KMarginX 10

@implementation CommentsTheManagementCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self addSubviewControll];
    }
    
    return self;
}


- (void)setModel:(ShopGoodsCommentsModel *)model
{
    _model = model;
    
    if (model.goods_img.length > 0)
    {
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_img]];
    }else
    {
        self.iconImageView.image = [UIImage imageNamed:@"appIcon"];
    }
    
    self.goodsLabels.text = model.goods_name;
//    self.remarkLabels.text = 
    self.priceLabels.text = [NSString stringWithFormat:@"¥%@",model.price];
    self.shopName.text = model.shop_name;
    
    // 评价内容
    NSString *evaluationStr = model.content;
    self.evaluationContentLabels.text = evaluationStr;
    NSDictionary *titleAttrs = @{NSFontAttributeName : self.evaluationContentLabels.font};
    CGSize titleSize = CGSizeMake(ScreenWidth - 20, MAXFLOAT);
    CGSize evaluationSize = [evaluationStr boundingRectWithSize:titleSize options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttrs context:nil].size;
    self.evaluationContentLabels.sh_height = evaluationSize.height;
    self.evaluationContentLabels.sh_width = evaluationSize.width;
    self.evaluationContentLabels.sh_y = self.starImage.sh_bottom + 5;

    
    
    self.evaluationNameLabel.text = model.user_name;
    NSString *timeStr = model.create_time;
    self.evaluationTimeLabels.text = [timeStr substringWithRange:NSMakeRange(0, 10)];
    
    self.evaluationNameLabel.sh_y = self.evaluationContentLabels.sh_bottom + 5;
    self.evaluationTimeLabels.sh_y = self.evaluationNameLabel.sh_y;

    
    if (model.reply.length == 0)
    {
        self.replyStateLabels.text = @"回复";
    }else
    {
        self.replyStateLabels.text = @"已回复";
    }
    
    // 回复内容
    NSString *contentLabelStr = model.reply;
    self.replyContentLabels.text = contentLabelStr;
    NSDictionary *contentLabelAttrs = @{NSFontAttributeName : self.evaluationContentLabels.font};
    CGSize contentSize = CGSizeMake(ScreenWidth - 20, MAXFLOAT);
    CGSize contentLabelSize = [contentLabelStr boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin attributes:contentLabelAttrs context:nil].size;
    self.replyContentLabels.sh_height = contentLabelSize.height;
    self.replyContentLabels.sh_width = contentLabelSize.width;
    self.replyContentLabels.sh_y = self.evaluationTimeLabels.sh_bottom + 5;
    
    NSString *replyTimeStr = model.reply_time;
    if (replyTimeStr.length !=0)
    {
        self.replyTimeLabel.text = [replyTimeStr substringWithRange:NSMakeRange(0, 10)];
        
    }
    self.replyTimeLabel.sh_y = self.replyContentLabels.sh_bottom + 5;
    
    
   // NSLog(@"%@",self.replyContentLabels.text);
    
    if (self.replyContentLabels.text.length != 0) {
        
        self.replyContentLabels.hidden = NO;
        self.replyTimeLabel.hidden = NO;
        self.mainBodyViews.sh_height = self.replyTimeLabel.sh_bottom + 10;
    }else
    {
        self.replyContentLabels.hidden = YES;
        self.replyTimeLabel.hidden = YES;
        self.mainBodyViews.sh_height = self.evaluationTimeLabels.sh_bottom + 10;
    }
    
}




-(void)addSubviewControll
{
    UIView *mainBodyView = [[UIView alloc] init];
    self.mainBodyViews = mainBodyView;
    mainBodyView.frame = CGRectMake(0,0,ScreenWidth,200);
    mainBodyView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:mainBodyView];
    
    UIImageView *iconImag = [[UIImageView alloc] init];
    self.iconImageView = iconImag;
    iconImag.frame = CGRectMake(KMarginX,10,120,130);
//    iconImag.image = [UIImage imageNamed:@"SHOUCANG"];
    [mainBodyView addSubview:iconImag];
    
    
    UILabel *goodsLabel = [[UILabel alloc] init];
    self.goodsLabels = goodsLabel;
    goodsLabel.frame = CGRectMake(iconImag.sh_right + 10,5,ScreenWidth - 150,40);
    goodsLabel.text= @"sdfdsfdsfsfgdflgjkhdfjkgdflsdhfjshdkjffjksdfkjfjks";
    goodsLabel.numberOfLines = 2;
    goodsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    goodsLabel.font = [UIFont systemFontOfSize:15];
    [mainBodyView addSubview:goodsLabel];
    
    
    UILabel *remarkLabel = [[UILabel alloc] init];
    self.remarkLabels = remarkLabel;
    remarkLabel.frame = CGRectMake(iconImag.sh_right + 10,goodsLabel.sh_bottom + 10 ,ScreenWidth - 230,40);
    remarkLabel.text= @"sdfdsfdsfsfgdflgjkhdfjkgdflsdhsdfjshdkjffjksdfkjfjks";
    remarkLabel.lineBreakMode = NSLineBreakByWordWrapping;
    remarkLabel.numberOfLines = 2;
    remarkLabel.font = [UIFont systemFontOfSize:15];
    [mainBodyView addSubview:remarkLabel];

    
    UILabel *priceLabel = [[UILabel alloc] init];
    self.priceLabels = priceLabel;
    priceLabel.frame = CGRectMake(iconImag.sh_right + 10,remarkLabel.sh_bottom + 10 ,80,20);
    priceLabel.text= @"价格";
    priceLabel.textColor = [UIColor orangeRed];
    priceLabel.font = [UIFont systemFontOfSize:13];
    [mainBodyView addSubview:priceLabel];
    
    
    UILabel *shopName = [[UILabel alloc] init];
    self.shopName = shopName;
    shopName.frame = CGRectMake(ScreenWidth - 80,remarkLabel.sh_y ,60,20);
    shopName.text= @"店铺名称";
    shopName.textAlignment = NSTextAlignmentCenter;
    shopName.font = [UIFont systemFontOfSize:13];
    [mainBodyView addSubview:shopName];

    
    UIView *segmentationLine = [[UIView alloc] init];
    segmentationLine.frame = CGRectMake(0,iconImag.sh_bottom + 5,ScreenWidth,1);
    segmentationLine.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [mainBodyView addSubview:segmentationLine];
    
    UIImageView *starImage = [[UIImageView alloc] init];
    self.starImage = starImage;
    starImage.image = [UIImage imageNamed:@"SHOUCANG"];
    starImage.frame = CGRectMake(KMarginX,segmentationLine.sh_bottom + 10,20,20);
    [mainBodyView addSubview:starImage];
    
    
    UILabel *replyStateLabel = [[UILabel alloc] init];
    self.replyStateLabels = replyStateLabel;
    replyStateLabel.frame = CGRectMake(ScreenWidth - 50,starImage.sh_y,50,20);
    replyStateLabel.text = @"回复";
    replyStateLabel.font = [UIFont systemFontOfSize:15];
    [mainBodyView addSubview:replyStateLabel];
    
    UILabel *evaluationContentLabel =[[UILabel alloc] init];
    self.evaluationContentLabels = evaluationContentLabel;
    evaluationContentLabel.font = [UIFont systemFontOfSize:14];
    evaluationContentLabel.frame = CGRectMake(KMarginX,replyStateLabel.sh_bottom + 10,ScreenWidth - 20,20);
    evaluationContentLabel.numberOfLines = 0;
    evaluationContentLabel.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [mainBodyView addSubview:evaluationContentLabel];
    
    UILabel *evaluationNameLabel = [[UILabel alloc] init];
    self.evaluationNameLabel = evaluationNameLabel;
    evaluationContentLabel.text = @"姓名";
    evaluationNameLabel.frame = CGRectMake(KMarginX,evaluationContentLabel.sh_bottom + 5,60,20);
    evaluationNameLabel.font = [UIFont systemFontOfSize:14];
    evaluationContentLabel.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [mainBodyView addSubview:evaluationNameLabel];
    
    UILabel *evaluationTimeLabel = [[UILabel alloc] init];
    self.evaluationTimeLabels = evaluationTimeLabel;
    evaluationTimeLabel.frame = CGRectMake(ScreenWidth - 110 ,evaluationNameLabel.sh_y + 5,100,20);
    evaluationTimeLabel.textAlignment = NSTextAlignmentRight;
    evaluationTimeLabel.font = [UIFont systemFontOfSize:14];
    evaluationTimeLabel.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [mainBodyView addSubview:evaluationTimeLabel];
    
    UILabel *replyContentLabel = [[UILabel alloc] init];
    self.replyContentLabels = replyContentLabel;
    replyContentLabel.frame = CGRectMake(KMarginX,evaluationTimeLabel.sh_bottom + 10,ScreenWidth - KMarginX *2,20);
    replyContentLabel.font = [UIFont systemFontOfSize:14];
    replyContentLabel.numberOfLines = 0;
    replyContentLabel.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [mainBodyView addSubview:replyContentLabel];
    
    UILabel *replyTimeLabel = [[UILabel alloc] init];
    self.replyTimeLabel = replyTimeLabel;
    replyTimeLabel.frame = CGRectMake(ScreenWidth - 110,replyContentLabel.sh_bottom + 10, 100,20);
    replyTimeLabel.textAlignment = NSTextAlignmentRight;
    replyTimeLabel.font = [UIFont systemFontOfSize:14];
    replyTimeLabel.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    [mainBodyView addSubview:replyTimeLabel];

}

- (CGFloat)returnCommentsHeight
{
    return self.mainBodyViews.sh_bottom;
}


@end
