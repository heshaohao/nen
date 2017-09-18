//
//  PostCollectionModel.h
//  nen
//
//  Created by nenios101 on 2017/6/19.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostCollectionModel : NSObject
//帖子ID
@property(nonatomic,copy) NSString *id;
//帖子标题
@property(nonatomic,copy) NSString *title;
//帖子内容
@property(nonatomic,copy) NSString *content;
//发帖时间
@property(nonatomic,copy) NSString *create_time;
//回复数量
@property(nonatomic,copy) NSString *reply_num;
//发帖人名称
@property(nonatomic,copy) NSString *user_name;

+(void)PostCollectionModelsuccess:(void(^)(NSMutableArray<PostCollectionModel *> *postCollectionArray))successBlock error:(void(^)()) errorBlock;


@end
