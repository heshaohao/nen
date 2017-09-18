//
//  EducationOptionsView.h
//  nen
//
//  Created by nenios101 on 2017/3/8.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EducationOptionModel;
@interface EducationOptionsView : UIView

@property (nonatomic, strong) EducationOptionModel *model;

- (instancetype)initWithFrame:(CGRect)frame Model:(EducationOptionModel *)model Index:(NSInteger)index;


@end
