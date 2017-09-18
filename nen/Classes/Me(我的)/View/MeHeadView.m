//
//  MeHeadView.m
//  nen
//
//  Created by nenios101 on 2017/3/2.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MeHeadView.h"

@interface MeHeadView()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UIImageView *twoCodeImage;

@property (weak, nonatomic) IBOutlet UILabel *numberLebael;

@end

@implementation MeHeadView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.headImage.layer.cornerRadius = 35;
    self.headImage.clipsToBounds = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * nickName = [defaults objectForKey:@"userNumber"];
    self.numberLebael.text = nickName;
    
}

- (IBAction)pushMeesage:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushMessages" object:self];
}


// 二维码图片
- (IBAction)twoCodeImageClick:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"twoCodes" object:self];
    
}

- (void)setNameStr:(NSString *)nameStr
{
    _nameStr = nameStr;
    
    self.nameLabel.text =_nameStr;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.imageStr]];
}



- (void)setDataDict:(NSMutableDictionary *)dataDict
{
    _dataDict = dataDict;
    
    NSString *nickName = [NSString stringWithFormat:@"%@",dataDict[@"nickname"]];
    
    if (nickName.length == 0 || [nickName isEqualToString:@"<null>"])
    {
        
    }else
    {
        self.nameLabel.text = nickName;
    }
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:dataDict[@"head_img"]]];
    
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    // 2. 给滤镜添加数据
    NSString *linkStr = dataDict[@"qr_code"];
    
   // NSLog(@"%@",linkStr);
    NSData *data = [linkStr dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    
    // 4. 显示二维码
    self.twoCodeImage.image = [UIImage imageWithCIImage:image];
    
}




- (IBAction)setBtn:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"set" object:self];
}


@end
