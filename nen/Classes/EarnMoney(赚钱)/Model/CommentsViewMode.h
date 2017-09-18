//
//  CommentsViewMode.h
//  nen
//
//  Created by nenios101 on 2017/5/12.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsViewMode : NSObject

// 标题
@property(nonatomic,copy)NSString *title;
// 内容
@property(nonatomic,copy)NSString *content;
// 时间
@property(nonatomic,copy)NSString *create_time;
// 帖子内容图片
@property(nonatomic,strong) NSArray *post_img;
// 发帖人昵称
@property(nonatomic,copy)NSString *user_name;
/* 回复人信息
*reply_content  回复内容
*reply_time  回复时间
*reply_name  回复人昵称
*reply_tx    回复者头像
*/
@property(nonatomic,strong) NSMutableArray *reply;

// 是否已收藏1：是0：否
@property(nonatomic,copy)NSString *is_collection;

+ (void)CommentsModelPostsID:(NSString *)PostsId PageSize:(NSString *)Pagesize Page:(NSString *)page success:(void(^)(CommentsViewMode *commentsMolde))successBlock error:(void(^)()) errorBlock;


@end
