//
//  CheackTableViewCell.m
//  nen
//
//  Created by nenios101 on 2017/4/20.
//

#import "CheackTableViewCell.h"

@interface CheackTableViewCell ()

@property(nonatomic,strong) UIImageView *iconImage;

@property(nonatomic,strong) UILabel  *chectTitleLabel;

@end

@implementation CheackTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
   
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self  addChildControl];
    }
    
    return self;
}

- (void)addChildControl
{
    self.iconImage = [[UIImageView alloc] init];
    self.iconImage.frame = CGRectMake(20,5,20,20);
    [self addSubview:self.iconImage];
    
    self.chectTitleLabel = [[UILabel alloc] init];
    self.chectTitleLabel.frame = CGRectMake(self.iconImage.sh_right + 20,5,150,20);
    self.chectTitleLabel.font = [UIFont systemFontOfSize:13];
    self.chectTitleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.chectTitleLabel];
}

- (void)setImageStr:(NSString *)imageStr
{
    _imageStr = imageStr;
    
    self.iconImage.image = [UIImage imageNamed:imageStr];
    self.chectTitleLabel.text = self.titleStr;
}

@end
