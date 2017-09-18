//
//  PostCommentsModel.h
//  nen
//
//  Created by nenios101 on 2017/5/26.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostCommentsModel : NSObject
//帖子ID
@property(nonatomic,copy) NSString*id;
//标题
@property(nonatomic,copy) NSString*title;
//内容
@property(nonatomic,copy) NSString*content;
//时间
@property(nonatomic,copy) NSString*create_time;
//头像
@property(nonatomic,copy) NSString *tx;
//回复量
@property(nonatomic,copy) NSString*reply_num;
//用户名
@property(nonatomic,copy) NSString *name;
//图片数组
@property(nonatomic,strong) NSMutableArray *imgs;

+ (void)postCommentsModelPageSize:(NSString *)Pagesize Page:(NSString *)page success:(void(^)(NSMutableArray<PostCommentsModel *> *PostArray))successBlock error:(void(^)()) errorBlock;

@end
