//
//  CheckTheLogisticsCell.m
//  nen
//
//  Created by nenios101 on 2017/8/8.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "CheckTheLogisticsCell.h"
#import "LogisticsDetailsOtherModel.h"


@interface  CheckTheLogisticsCell()

@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@end

@implementation CheckTheLogisticsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addChild];
    }
    return self;
}

- (void)setModel:(LogisticsDetailsOtherModel *)model
{
    _model = model;
    
    self.contentLabel.text = model.context;
    self.timeLabel.text = model.time;
    
}


- (void)addChild
{
    UIView *leftView = [[UIView alloc] init];
    leftView.frame = CGRectMake(20,0,1,90);
    leftView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView  addSubview:leftView];
    
    UIImageView *leftIamge = [[UIImageView alloc] init];
    leftIamge.frame = CGRectMake(13.5,20, 15, 15);
    leftIamge.image = [UIImage imageNamed:@"lvqiu"];
    leftIamge.layer.cornerRadius = 7.5;
    leftIamge.clipsToBounds = YES;
    [self.contentView addSubview:leftIamge];
    
    UILabel *contentLabel= [[UILabel alloc] init];
    self.contentLabel = contentLabel;
    contentLabel.frame = CGRectMake(leftIamge.sh_right + 10,15,ScreenWidth - 45,40);
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.numberOfLines = 2;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.text = @"dsggwegwgwsgsvsfsdfdsfhrsdgsdfsdfsdfsfshwhwhwsadsadasddfdsfsasfgsgsgsfafdfcsvfs";
    [self.contentView addSubview:contentLabel];

    UILabel *timeLabel= [[UILabel alloc] init];
    self.timeLabel = timeLabel;
    timeLabel.frame = CGRectMake(leftIamge.sh_right + 10,contentLabel.sh_bottom + 5,ScreenWidth - 45,20);
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    timeLabel.text = @"时间";
    [self.contentView addSubview:timeLabel];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(leftIamge.sh_right + 10,89,ScreenWidth - 45,1);
    bottomView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:bottomView];
    
    
    
    
}

@end
