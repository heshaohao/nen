//
//  AddewessShowUpdataModel.h
//  nen
//
//  Created by nenios101 on 2017/3/31.
//  Copyright © 2017年 nen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdderessShowUpdataModel : NSObject

//姓名
@property(nonatomic,copy)NSString *relation_name;
//性别，0：女；1：男
@property(nonatomic,strong) NSNumber *sex;
//电话
@property(nonatomic,copy)NSString *relation_tel;
//string 详细地址
@property(nonatomic,copy)NSString *address;
//邮编
@property(nonatomic,copy)NSString *postcode;
//是否默认，0：不默认；1：默认
@property(nonatomic,strong)NSNumber *is_default;

+(void)addressUpdateModelNum:(NSString *)num succes:(void(^)(AdderessShowUpdataModel *addressUpdateModel))succesBlock error:(void(^)()) errorBlock;

@end
