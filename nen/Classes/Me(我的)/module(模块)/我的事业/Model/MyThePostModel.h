//
//  PostPmmentsModel.h
//  nen
//
//  Created by nenios101 on 2017/5/26.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyThePostModel : NSObject

//帖子ID
@property(nonatomic,copy) NSString*id;
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


+ (void)myThePostModelPageSize:(NSString *)Pagesize Page:(NSString *)page Type:(NSString *)type success:(void(^)(NSMutableArray<MyThePostModel *> *PostArray))successBlock error:(void(^)()) errorBlock;
@end
