//
//  PushMessageModel.h
//  nen
//
//  Created by nenios101 on 2017/6/6.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushMessageModel : NSObject

//推送信息的ID
@property(nonatomic,copy) NSString *id;
//推送的内容
@property(nonatomic,copy) NSString *content;
//推送的时间戳
@property(nonatomic,copy) NSString *add_time;
//标题
@property(nonatomic,copy) NSString *title;
//默认0是否已阅读
@property(nonatomic,copy) NSString *read;
//图片
@property(nonatomic,copy) NSString *img;

+ (void)pushMessageModelPage:(NSString *)page PageSzie:(NSString *)pageSize Success:(void(^)(NSMutableArray<PushMessageModel *> *pushMessageArray))successBlock error:(void(^)()) errorBlock;
@end
