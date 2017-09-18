//
//  brandView.h
//  nen
//
//  Created by nenios101 on 2017/2/28.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OptionModel;
@interface BrandView : UIView

@property (nonatomic, strong) OptionModel *model;

- (instancetype)initWithFrame:(CGRect)frame Model:(OptionModel *)model;


@end
