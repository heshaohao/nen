//
//  ShopIntroduceView.m
//  nen
//
//  Created by nenios101 on 2017/3/10.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ShopIntroduceView.h"

@interface ShopIntroduceView()
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
// 商铺名称
@property (weak, nonatomic) IBOutlet UILabel *shopName;
// ❤️等级
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
// 开店时间
@property (weak, nonatomic) IBOutlet UILabel *openShopTime;
// 好评率
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
// 店铺介绍
@property (weak, nonatomic) IBOutlet UITextView *introduceLabel;


@end

@implementation ShopIntroduceView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.introduceLabel.layer.borderWidth = 2.0f;
    self.introduceLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.introduceLabel.editable = NO;
    self.introduceLabel.selectable  = NO;
    
}

- (void)setShopIntroducedDict:(NSDictionary *)shopIntroducedDict
{
    _shopIntroducedDict = shopIntroducedDict;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:shopIntroducedDict[@"shop_logo"]]];
    self.shopName.text = [NSString stringWithFormat:@"%@",shopIntroducedDict[@"shop_name"]];
    self.openShopTime.text = shopIntroducedDict[@"create_time"];
    self.rateLabel.text = shopIntroducedDict[@"rate"];
    
    switch ([shopIntroducedDict[@"star"] integerValue]) {
        case 1:
            self.starLabel.text = @"❤️";
            break;
        case 2:
            self.starLabel.text = @"❤️❤️";
            break;
        case 3:
            self.starLabel.text = @"❤️❤️❤️";
            break;
        case 4:
            self.starLabel.text = @"❤️❤️❤️❤️";
            break;
        case 5:
            self.starLabel.text = @"❤️❤️❤️❤️❤️";
            break;
            
        default:
            break;
    }
    
    NSString *introdStr = [NSString stringWithFormat:@"%@",shopIntroducedDict[@"introduce"]];
    
    if (![introdStr isEqualToString:@"<null>"])
    {
        self.introduceLabel.text = introdStr;
        
    }
    
}

- (CGFloat)returnShopIntroduceViewHeight
{
    return self.introduceLabel.sh_bottom;
}

@end
