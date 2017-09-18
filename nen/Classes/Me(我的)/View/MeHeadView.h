//
//  MeHeadView.h
//  nen
//
//  Created by nenios101 on 2017/3/2.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeHeadView : UIView

@property(nonatomic,copy) NSString *nameStr;

@property(nonatomic,copy) NSString *imageStr;

@property(nonatomic,copy) NSString *myTheLink;

@property(nonatomic,strong) NSMutableDictionary *dataDict;
@end
