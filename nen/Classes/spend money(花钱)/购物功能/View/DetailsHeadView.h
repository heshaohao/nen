//
//  DetailsHeadView.h
//  nen
//
//  Created by nenios101 on 2017/3/6.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsProductModel;
@interface DetailsHeadView : UIView

@property(nonatomic,strong) GoodsProductModel *model;
@property(nonatomic,strong) NSMutableArray *imageArray;

@end
