//
//  ShopSetCell.m
//  nen
//
//  Created by nenios101 on 2017/6/6.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ShopSetCell.h"

@interface ShopSetCell()

@property(nonatomic,strong) UILabel *leftTitle;
@property(nonatomic,strong) UIImageView *shopIconImage;

// @property(nonatomic,strong) UIImageView *iconImage;

@property(nonatomic,strong) UILabel *rightLabel;

@end

@implementation ShopSetCell


- (void)setDict:(NSMutableDictionary *)dict
{
    _dict = dict;
    
    // 默认加载 组数 行数 加1
    if (self.section == 1) {
        
        [_shopIconImage sd_setImageWithURL:[NSURL URLWithString:dict[@"shop_logo"]]];
        _shopIconImage.hidden = NO;
        _rightLabel.hidden = YES;
      
    }

    if (self.section == 2 && self.line ==1)
    {
        self.rightLabel.text = dict[@"shop_name"];
       
    }
    
    if (self.section == 3 && self.line == 1)
    {
        self.rightLabel.text = dict[@"hair"];
       
       
    }
    
    if (self.section == 3 && self.line == 2)
    {
        self.rightLabel.text = dict[@"refund"];
        
        
    }
    
    if (self.section == 4 )
    {
        self.rightLabel.text = dict[@"services"];
        
    }
    
}


// 设置完成后的图片
- (void)setRightImage:(UIImage *)rightImage
{
    _rightImage = rightImage;
    
    if (self.grops == 0)
    {
        _shopIconImage.image = rightImage;
        
    }
}


// 设置完成后的文本
- (void)setTitleContent:(NSString *)titleContent
{
    _titleContent = titleContent;
    

    if (self.grops == 1 && self.row ==0)
    {
        // tbaleViewCell 重用问题
        _shopIconImage.hidden = YES;
        _rightLabel.hidden = NO;
        self.rightLabel.text = titleContent;
        
    }
    
    if (self.grops == 1 && self.row ==1)
    {
        // tbaleViewCell 重用问题
        _shopIconImage.hidden = YES;
        _rightLabel.hidden = YES;
        
        
    }
    
    if (self.grops == 2 && self.row == 0)
    {
        // tbaleViewCell 重用问题
        _shopIconImage.hidden = YES;
        _rightLabel.hidden = NO;
        self.rightLabel.text = titleContent;
        
    }
    
    if (self.grops == 2 && self.row == 1)
    {
       // tbaleViewCell 重用问题
        _shopIconImage.hidden = YES;
        _rightLabel.hidden = NO;
        self.rightLabel.text = titleContent;
        
        
    }
    
    if (self.grops == 3 )
    {
        // tbaleViewCell 重用问题
        _shopIconImage.hidden = YES;
        _rightLabel.hidden = NO;
        self.rightLabel.text = titleContent;
        
    }

    
}


- (void)setMode:(ShopSetNameModel *)mode
{
    _mode = mode;
    
    self.leftTitle.text = mode.name;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self addSubViewControl];
    }
    
    return self;
}

- (void)addSubViewControl
{
    
    UILabel *leftTitle = [[UILabel alloc] init];
    self.leftTitle = leftTitle;
    leftTitle.frame = CGRectMake(10,10,70,20);
    leftTitle.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:leftTitle];
//    
//    UIImageView *righticon = [[UIImageView alloc] init];
//    self.iconImage = righticon;
//    righticon.frame = CGRectMake(ScreenWidth -30,10,20,20);
//    righticon.image = [UIImage imageNamed:@"4"];
//    [self.contentView addSubview:righticon];
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.frame = CGRectMake(self.leftTitle.sh_right,10,ScreenWidth *0.5,20);
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    self.rightLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.rightLabel];
    
    _shopIconImage = [[UIImageView alloc] init];
    _shopIconImage.frame = CGRectMake(ScreenWidth *0.75,5,30,30);
    _shopIconImage.layer.cornerRadius = 15;
    _shopIconImage.clipsToBounds = YES;
    [self.contentView addSubview:_shopIconImage];
    _shopIconImage.hidden = YES;

    
}

@end
