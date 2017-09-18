//
//  NotificationMessageCell.m
//  nen
//
//  Created by nenios101 on 2017/6/28.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "NotificationMessageCell.h"
#import "PushMessageModel.h"

@interface NotificationMessageCell()

@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *messageTitle;


@property(nonatomic,strong) UILabel *timeTitle;

@property(nonatomic,strong) UILabel *orderTitle;

@end

@implementation NotificationMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self addSubviewControll];
    }
    
    return self;
}

- (void)setModel:(PushMessageModel *)model
{
    _model = model;
    
    self.timeTitle.text = [NSString stringWithFormat:@"%@",model.add_time];
    self.orderTitle.text = model.content;
    //[self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
    
}

-(void)addSubviewControll
{
    UIView *mainBodyView = [[UIView alloc] init];
    mainBodyView.frame = CGRectMake(0,0,ScreenWidth,95);
    mainBodyView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:mainBodyView];
    
    UIImageView *iconImag = [[UIImageView alloc] init];
    self.iconImageView = iconImag;
    iconImag.frame = CGRectMake(10,10,50,50);
    iconImag.image = [UIImage imageNamed:@"appIcon"];
    [mainBodyView addSubview:iconImag];
    
    
    UILabel *messageTitle = [[UILabel alloc] init];
    self.messageTitle = messageTitle;
    messageTitle.frame = CGRectMake(iconImag.sh_right + 10,iconImag.sh_y,100,25);
    messageTitle.text= @"网一网平台消息";
    messageTitle.numberOfLines = 0;
    messageTitle.lineBreakMode = NSLineBreakByWordWrapping;
    messageTitle.font = [UIFont systemFontOfSize:13];
    [mainBodyView addSubview:messageTitle];
    
    UILabel *timeTitle = [[UILabel alloc] init];
    self.timeTitle = timeTitle;
    timeTitle.frame = CGRectMake(messageTitle.sh_right+ 10,messageTitle.sh_y,130,25);
    timeTitle.text = @"时间";
    timeTitle.font = [UIFont systemFontOfSize:13];
    timeTitle.textColor = [UIColor lightGrayColor];
    [mainBodyView addSubview:timeTitle];
    
    UILabel *orderTitle = [[UILabel alloc] init];
    self.orderTitle = orderTitle;
    orderTitle.frame = CGRectMake(messageTitle.sh_x,messageTitle.sh_bottom +10,ScreenWidth - 90,40);
    orderTitle.text = @"订单信息";
    orderTitle.numberOfLines = 0;
    orderTitle.lineBreakMode = NSLineBreakByCharWrapping;
    orderTitle.font = [UIFont systemFontOfSize:13];
    orderTitle.textColor = [UIColor lightGrayColor];
    [mainBodyView addSubview:orderTitle];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(0,95,ScreenWidth, 5);
    bottomView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self.contentView addSubview:bottomView];
    
}





@end
