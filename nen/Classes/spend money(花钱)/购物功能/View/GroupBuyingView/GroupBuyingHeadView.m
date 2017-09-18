//
//  GroupBuyingHeadView.m
//  nen
//
//  Created by nenios101 on 2017/5/5.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "GroupBuyingHeadView.h"
#import "GroupBuyingItemGoodsItemModel.h"



#define KHeadImageHeight 240

@interface GroupBuyingHeadView ()<SDCycleScrollViewDelegate>
// 商品图片
@property(nonatomic,strong) UIImageView *goodsImageView;
// 商品标题
@property(nonatomic,strong) UILabel *goodsTitles;
// 商品描述标题
@property(nonatomic,strong) UILabel *subheadTitles;
// 折后价
@property(nonatomic,strong) UILabel *discountPriceTitles;
//原价
@property(nonatomic,strong) UILabel *originalPriceTitles;
//运费
@property(nonatomic,strong) UILabel *carriageLabels;
//已售
@property(nonatomic,strong) UILabel *soldLabels;
//发货地
@property(nonatomic,strong) UILabel *address;
// 图片轮播器
//@property (nonatomic, strong) JZLCycleView *headPictureCarouselView;

@property(nonatomic,weak) UIView *headViews;

@property (nonatomic,strong) UIButton *shareBtn;


@end

@implementation GroupBuyingHeadView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self addsubViewCopntroll];
    }
    return self;
}


- (void)addsubViewCopntroll
{

    UIView *headview = [[UIView alloc] init];
    self.headViews = headview;
    [self addSubview:headview];
  
    UILabel *goodsTitle = [[UILabel alloc] init];
    self.goodsTitles = goodsTitle;
    goodsTitle.lineBreakMode = NSLineBreakByCharWrapping;
    goodsTitle.font = [UIFont systemFontOfSize:13];
    goodsTitle.frame = CGRectMake(10,KHeadImageHeight + 5,ScreenWidth - 100,35 );
    goodsTitle.numberOfLines = 2;
    [headview addSubview:goodsTitle];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareBtn = shareBtn;
    shareBtn.frame = CGRectMake(goodsTitle.sh_right + 10,KHeadImageHeight + 10,70,25);
    [shareBtn setTitle:@"分享推广" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.layer.borderColor = [UIColor redColor].CGColor;
    shareBtn.layer.borderWidth = 1.0f;
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [headview addSubview:shareBtn];

    
    UILabel *subheadTitle = [[UILabel alloc] init];
    self.subheadTitles = subheadTitle;
    subheadTitle.lineBreakMode = NSLineBreakByCharWrapping;
    subheadTitle.font = [UIFont systemFontOfSize:13];
    subheadTitle.frame = CGRectMake(10,goodsTitle.sh_bottom + 5,ScreenWidth - 60,45);
    subheadTitle.textColor = [UIColor lightGrayColor];
    subheadTitle.numberOfLines = 2;
    [headview addSubview:subheadTitle];
    
    
    UILabel * discountPriceTitle = [[UILabel alloc] init];
    self.discountPriceTitles = discountPriceTitle;
    discountPriceTitle.frame = CGRectMake(10,subheadTitle.sh_bottom,80,20);
    discountPriceTitle.font = [UIFont systemFontOfSize:14];
    discountPriceTitle.textColor = [UIColor redColor];
    [headview addSubview:discountPriceTitle];
    
    
    UILabel * originalPriceTitle = [[UILabel alloc] init];
    self.originalPriceTitles = originalPriceTitle;
    originalPriceTitle.frame = CGRectMake(discountPriceTitle.sh_right + 20 ,discountPriceTitle.sh_y,discountPriceTitle.sh_width,20);
    originalPriceTitle.font = [UIFont systemFontOfSize:13];
    originalPriceTitle.textColor = [UIColor lightGrayColor];
//    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
//    originalPriceTitle.attributedText = [[NSAttributedString alloc] initWithString:@"¥12" attributes:attribtDic];
    [headview addSubview:originalPriceTitle];

    UILabel *carriageLabel = [[UILabel alloc] init];
    self.carriageLabels = carriageLabel;
    carriageLabel.font = [UIFont systemFontOfSize:13];
    carriageLabel.frame = CGRectMake(10,originalPriceTitle.sh_bottom + 10, 60,25);
    carriageLabel.textColor = [UIColor lightGrayColor];
    [headview addSubview:carriageLabel];
    
    UILabel *soldLabel = [[UILabel alloc] init];
    self.soldLabels = soldLabel;
    soldLabel.font = [UIFont systemFontOfSize:13];
    soldLabel.frame = CGRectMake(ScreenWidth *0.5 - 30,originalPriceTitle.sh_bottom + 10, 60,25);
    soldLabel.textColor = [UIColor lightGrayColor];
    [headview addSubview:soldLabel];
  
    UILabel *address = [[UILabel alloc] init];
    self.address = address;
    address.font = [UIFont systemFontOfSize:13];
    address.frame = CGRectMake(ScreenWidth - 70,originalPriceTitle.sh_bottom + 10, 60,25);
    address.textColor = [UIColor lightGrayColor];
    [headview addSubview:address];
    
    
    headview.sh_height = soldLabel.sh_bottom + 5;
    headview.sh_width = ScreenWidth;
    
}

-(void)setModel:(GroupBuyingItemGoodsItemModel *)model
{
    _model = model;
    
    if (model !=nil)
    {
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_all_img[@"img1"]]];
        self.goodsTitles.text = model.goods_name;
        self.subheadTitles.text = model.descriptionTitle;
        //  NSLog(@"%@",model.descriptionTitle);
        self.discountPriceTitles.text = [NSString stringWithFormat:@"¥%@",model.price];
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        self.originalPriceTitles.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",model.primeval_price]attributes:attribtDic];
        self.carriageLabels.text = [model.carriage isEqualToString:@"0.00"] ? @"含运费" : @"不含运费";
        self.soldLabels.text = [NSString stringWithFormat:@"已售 %@",model.sale_num];
        
        self.address.text = [NSString stringWithFormat:@"%@",model.delivesress];
        
    }else
    {
        self.goodsTitles.text = @"该商品已下架";
        self.shareBtn.hidden = YES;
    }
    

}

- (void)setImageArray:(NSMutableArray *)imageArray
{
    _imageArray= imageArray;
    
    // 判断服务器翻回的图片数组进行 单张或图片轮播器切换
    
//    if (imageArray.count <= 1)
//    {
//        UIImageView *goodsImage = [[UIImageView alloc] init];
//        self.goodsImageView = goodsImage;
//        goodsImage.image = [UIImage imageNamed:imageArray.firstObject];
//        goodsImage.frame = CGRectMake(0, 0,ScreenWidth,KHeadImageHeight);
//        [self.headViews addSubview:goodsImage];
//        
//    }else
//    {
    
        
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, KHeadImageHeight) delegate:self placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView.currentPageDotColor = [UIColor whiteColor];
        
        
        cycleScrollView.imageURLStringsGroup = imageArray;
        
        
        [self.headViews addSubview:cycleScrollView];
  

}
#pragma mark  图片轮播器的代理方法
- (void)selectItemAtIndex: (NSInteger)index
{
    
}


#pragma mark 分享按钮

- (void)shareBtnClick
{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"shoppingShar" object:self];
    
}


@end
