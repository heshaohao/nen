//
//  ExpressCompanyList.h
//  nen
//
//  Created by nenios101 on 2017/8/8.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpressCompanyList : NSObject

// 快递公司拼音名称

@property (nonatomic,copy) NSString *express_name;

// 快递公司中文名称
@property (nonatomic,copy) NSString *name;

+ (void)expressCompanyListsuccess:(void(^)(NSMutableArray<ExpressCompanyList *> *companyListArray))successBlock error:(void(^)()) errorBlock;


@end
