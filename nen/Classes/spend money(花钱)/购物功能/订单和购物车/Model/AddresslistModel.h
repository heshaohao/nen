//
//  AddresslistModel.h
//  nen
//
//  Created by nenios101 on 2017/3/29.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddresslistModel : NSObject
//地址ID
@property(nonatomic,copy) NSString *id;
//联系人
@property(nonatomic,copy) NSString *relation_name;
//手机号码
@property(nonatomic,copy) NSString *relation_tel;
//详细地址
@property(nonatomic,copy) NSString *address;
//邮编
@property(nonatomic,copy) NSString *postcode;
// 1：默认地址，0：不是默认地址
@property(nonatomic,copy) NSString *is_default;

/**
 *  返回单个地址
 */
+(void)addressModelNum:(NSString *)num succes:(void(^)(AddresslistModel *addressModel))succesBlock error:(void(^)()) errorBlock;

/**
 *  返回多个地址
 */

+(void)addressArrayModelNum:(NSString *)num success:(void(^)(NSMutableArray<AddresslistModel *>* addressModelArray))succesBlock error:(void(^)())errorBlock;

@end
