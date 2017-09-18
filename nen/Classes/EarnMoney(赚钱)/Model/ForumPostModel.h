//
//  ForumPostModel.h
//  nen
//
//  Created by nenios101 on 2017/5/10.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForumPostModel : NSObject
//帖子ID
@property(nonatomic,copy) NSString*id;

// 点赞数
@property(nonatomic,copy) NSString *praise_num;

//标题
@property(nonatomic,copy) NSString*title;
//内容
@property(nonatomic,copy) NSString*content;
//时间
@property(nonatomic,copy) NSString*create_time;
//回复量
@property(nonatomic,copy) NSString*reply_num;
//用户名
@property(nonatomic,copy) NSString*user_name;
//图片数组
@property(nonatomic,strong) NSMutableArray *imgs;
//头像
@property(nonatomic,copy) NSString*tx;
//是否置顶1：是
@property(nonatomic,copy) NSString*is_top;
//是否已点赞1：是0：否
@property(nonatomic,copy) NSString*is_praise;

+ (void)forumPostModelType:(NSString *)type PageSize:(NSString *)Pagesize Page:(NSString *)page success:(void(^)(NSMutableArray<ForumPostModel *> *forumPosArray))successBlock error:(void(^)()) errorBlock;


@end
