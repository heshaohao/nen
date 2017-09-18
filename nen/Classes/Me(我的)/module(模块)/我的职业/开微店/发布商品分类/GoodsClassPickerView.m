//
//  CoodsClassPickerView.m
//  nen
//
//  Created by apple on 17/6/4.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "GoodsClassPickerView.h"

#import "ReleaseGoodsModel.h"

#define lz_screenWidth ([UIScreen mainScreen].bounds.size.width)
#define lz_screenHeight ([UIScreen mainScreen].bounds.size.height)
// 216 UIPickerView固定高度
static NSInteger const lz_pickerHeight = 246;
static NSInteger const lz_buttonHeight = 30;

@interface GoodsClassPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource> {
    
    // 记录当前选择器是否已经显示
    BOOL __isShowed ;
    
    SHProvince *__currentProvience;
    SHProvince *__categoryId;
    SHCity *__currentCity;
    SHArea *__currentArea;
        

}
// 当前父视图
@property (nonatomic, strong) UIView *_superView;
@property (nonatomic, copy) lz_backBlock _selectBlock;
@property (nonatomic, copy) lz_actionBlock _cancelBlock;

// subViews
@property (strong, nonatomic)UIView *contentView;
@property (strong, nonatomic)UIPickerView *pickerView;
@property (strong, nonatomic)UIButton *commitButton;
@property (strong, nonatomic)UIButton *cancelButton;
@property (strong, nonatomic)UIImageView *bkgImageView;
@property (strong, nonatomic)UIVisualEffectView *blurView;
@property (strong, nonatomic)CALayer *topLine;
//dataSource
@property (nonatomic, strong) NSMutableArray *dataSource;


@property(nonatomic,strong) NSArray <ReleaseGoodsModel *> *oneColumnDataArray;
@property(nonatomic,strong) NSArray <ReleaseGoodsModel *> *twoColumnDataArray;
@property(nonatomic,strong) NSArray <ReleaseGoodsModel *> *threeColumnDataArray;


// 翻回参数
@property (nonatomic,copy) NSString *oneClassify;
@property (nonatomic,copy) NSString *oneClassifyId;
@property (nonatomic,copy) NSString *twoClassify;
@property (nonatomic,copy) NSString *threeClassify;



@end
@implementation GoodsClassPickerView

+ (instancetype)showInView:(UIView *)view didSelectWithBlock:(lz_backBlock)block cancelBlock:(lz_actionBlock)cancel {
    
    GoodsClassPickerView *cityPicker = [[GoodsClassPickerView alloc]init];
    cityPicker.frame = CGRectMake(0, lz_screenHeight, lz_screenWidth, 170);
    cityPicker._superView = view;
    
    cityPicker.autoChange = YES;
    [cityPicker showWithBlock:nil];
    
    cityPicker._selectBlock = block;
    cityPicker._cancelBlock = cancel;
    
    cityPicker.interval = 0.20;
    
    return cityPicker;
}

- (void)showWithBlock:(void(^)())block {
    if (__isShowed == YES) {
        return;
    }
    
    __isShowed = YES;
    [self._superView addSubview:self];
    [UIView animateWithDuration:self.interval animations:^{
        self.frame = CGRectMake(0, lz_screenHeight - lz_pickerHeight + 80, lz_screenWidth, 170);
    } completion:^(BOOL finished) {
        if (block) {
            block();
        }
    }];
}

- (void)dismissWithBlock:(void(^)())block {
    
    if (__isShowed == NO) {
        return;
    }
    
    __isShowed = NO;
    [UIView animateWithDuration:self.interval animations:^{
        self.frame = CGRectMake(0, lz_screenHeight, lz_screenWidth, lz_pickerHeight);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        if (block) {
            block();
        }
    }];
}

#pragma mark - property getter
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataSource;
}

- (NSDictionary *)textAttributes {
    if (_textAttributes == nil) {
        _textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor blueColor]};
    }
    
    return _textAttributes;
}

- (NSDictionary *)titleAttributes {
    if (_titleAttributes == nil) {
        _titleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor blueColor]};
    }
    
    return _titleAttributes;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSAssert(!self._superView, @"ERROR: Please use 'showInView:didSelectWithBlock:' to initialize, and the first parameter can not be nil!");
        //        NSLog(@"视图初始化了");
        self.backgroundColor = [UIColor whiteColor];
       // [self loadData];
        
      [ReleaseGoodsModel releaseGoodsModelParent_Id:@"0" success:^(NSMutableArray<ReleaseGoodsModel *> *ReleaseGoodsArray) {
          self.oneColumnDataArray = ReleaseGoodsArray;
          NSLog(@"%lu",(unsigned long)self.oneColumnDataArray.count);
          
          [self loadTwoColumData];
      } error:^{
          NSLog(@"失败");
      }];
        
    }
    
    return self;
}


#pragma mark 数据加载
- (void)loadTwoColumData
{
    [ReleaseGoodsModel releaseGoodsModelParent_Id:@"1" success:^(NSMutableArray<ReleaseGoodsModel *> *ReleaseGoodsArray) {
        
        self.twoColumnDataArray = ReleaseGoodsArray;
        NSLog(@"%lu",(unsigned long)self.twoColumnDataArray.count);
        
        [self loadThreeColumData];
        
    } error:^{
        NSLog(@"失败");
    }];

}
- (void)loadThreeColumData
{
    
    [ReleaseGoodsModel releaseGoodsModelParent_Id:@"3" success:^(NSMutableArray<ReleaseGoodsModel *> *ReleaseGoodsArray) {
        
        self.threeColumnDataArray = ReleaseGoodsArray;
        NSLog(@"%lu",(unsigned long)self.threeColumnDataArray.count);
        
        [self.pickerView reloadAllComponents];
        
    } error:^{
        NSLog(@"失败");
    }];

    
}

- (void)dealloc {
    //
    //    NSLog(@"视图销毁了");
}
#pragma mark - /** 加载数据源 */
//- (void)loadData {
//    
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"GoodsClass" ofType:@"plist"];
//    
//    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
//    
//    NSArray *provinces = [dic allKeys];
//    
//    for (NSString *tmp in provinces) {
//        
//        SHProvince *province = [[SHProvince alloc]init];
//        province.name = tmp;
//        
//        NSArray *arr = [dic objectForKey:tmp];
//        
//        NSDictionary *cityDic = [arr firstObject];
//        
//        [province configWithDic:cityDic];
//        
//        [self.dataSource addObject:province];
//    }
//    
//    // 设置当前数据
//    SHProvince *defPro = [self.dataSource firstObject];
//    
//    __currentProvience = defPro;
//    
//    SHCity *defCity = [defPro.cities firstObject];
//    
//    __currentCity = defCity;
//    
//    __currentArea = [defCity.areas firstObject];
//}

#pragma mark - 懒加载子视图
- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:self.bounds];
        _contentView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_contentView];
    }
    
    return _contentView;
}

- (UIImageView *)bkgImageView {
    if (_bkgImageView == nil) {
        _bkgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _bkgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bkgImageView.clipsToBounds = YES;
        [self insertSubview:_bkgImageView atIndex:0];
    }
    
    return _bkgImageView;
}

- (UIVisualEffectView *)blurView {
    if (_blurView == nil) {
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        blurView.frame = _bkgImageView.bounds;
        
        _blurView = blurView;
    }
    
    return _blurView;
}

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, lz_buttonHeight, lz_screenWidth,170)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        
        [self.contentView addSubview:_pickerView];
    }
    
    return _pickerView;
}

- (UIButton *)commitButton {
    if (_commitButton == nil) {
        
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"完成" attributes:self.titleAttributes];
        [_commitButton setAttributedTitle:str forState:UIControlStateNormal];
        
        [_commitButton addTarget:self action:@selector(commitButtonClic) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_commitButton];
    }
    
    return _commitButton;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"取消" attributes:self.titleAttributes];
        [_cancelButton setAttributedTitle:str forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClics) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cancelButton];
    }
    
    return _cancelButton;
}

- (CALayer *)topLine {
    if (_topLine == nil) {
        _topLine = [CALayer layer];
        _topLine.backgroundColor = [UIColor grayColor].CGColor;
    }
    
    return _topLine;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self pickerView];
    
    if (self.backgroundImage) {
        
        self.bkgImageView.image = self.backgroundImage;
        
        [self insertSubview:self.blurView aboveSubview:self.bkgImageView];
    }
    
    if (!self.autoChange) {
        
        
    }
    self.cancelButton.frame = CGRectMake(10, 5, 40, lz_buttonHeight - 10);
    
    self.commitButton.frame = CGRectMake(lz_screenWidth - 50, 5, 40, lz_buttonHeight - 10);
    
    self.topLine.frame = CGRectMake(0, 0, lz_screenWidth, 0.4);
    [self.contentView.layer addSublayer:self.topLine];
}


#pragma mark - 完成按钮点击事件
- (void)commitButtonClic {
    
    // 选择结果回调
    if (self._selectBlock) {
        
        NSString *address = [NSString stringWithFormat:@"%@%@%@",__currentArea.province,__currentArea.city,__currentArea.name];
        self._selectBlock(address,__currentArea.province,__currentArea.city,__currentArea.name);
    }
    
    NSDictionary *dict;
    if (self.oneClassify.length > 0)
    {
        dict = @{@"oneClasse":self.oneClassify,@"oneClasseId":self.oneClassifyId,@"twoClasse":self.twoClassify,@"threeClasse":self.threeClassify};
    }else
    {
        self.oneClassify = [self.oneColumnDataArray objectAtIndex:0].category_name;
        self.oneClassifyId = [self.oneColumnDataArray objectAtIndex:0].id;
        self.twoClassify  = [self.twoColumnDataArray objectAtIndex:0].category_name;
        self.threeClassify  = [self.threeColumnDataArray objectAtIndex:0].category_name;
        
        dict = @{@"oneClasse":self.oneClassify,@"oneClasseId":self.oneClassifyId,@"twoClasse":self.twoClassify,@"threeClasse":self.threeClassify};
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goodsClassification" object:self userInfo:dict];
    
    __weak typeof(self)ws = self;
    [self dismissWithBlock:^{
        
        if (ws._cancelBlock) {
            ws._cancelBlock();
        }
    }];
}

#pragma mark 取消按钮
- (void)cancelButtonClics{
    
    __weak typeof(self)ws = self;
    [self dismissWithBlock:^{
        
        if (ws._cancelBlock) {
            ws._cancelBlock();
        }
    }];
}

#pragma mark - UIPickerView 代理和数据源方法
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//
//    CGFloat width = lz_screenWidth/3.0;
//
//    if (component == 0) {
//        return width - 20;
//    } else if (component == 1) {
//
//        return width;
//    } else {
//
//        return width + 20;
//    }
//}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (component == 0) {
        
       
        return self.oneColumnDataArray.count;
        
    } else if (component == 1) {
        
       
        return self.twoColumnDataArray.count;
    } else {
        
       
        return self.threeColumnDataArray.count;
    }
}

//- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//
//    if (component == 0) {
//        
//    ReleaseGoodsModel *pro = [self.oneColumnDataArray objectAtIndex:row];
//        
//        return pro.category_name;
//    
//    } else if (component == 1) {
//    ReleaseGoodsModel *pro = [self.twoColumnDataArray objectAtIndex:row];
//        return pro.category_name;
//            }
//    else {
//        ReleaseGoodsModel *pro = [self.threeColumnDataArray objectAtIndex:row];
//        return pro.category_name;
//            }
//}



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
//    
//    if (component == 0) {
//        
//        GoodsClassPickerView *pro = [self.dataSource objectAtIndex:row];
//        NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:pro.name attributes:self.textAttributes];
////        label.attributedText = attStr;
//    } else if (component == 1) {
//        
////        if (__currentProvience.cities.count > row) {
////            
////            LZCity *city = [__currentProvience.cities objectAtIndex:row];
////            NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:city.name attributes:self.textAttributes];
////            label.attributedText = attStr;
////        }
//    } else {
//        
////        if (__currentCity.areas.count > row) {
////            
////            LZArea *area = [__currentCity.areas objectAtIndex:row];
////            NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:area.name attributes:self.textAttributes];
////            label.attributedText = attStr;
////        }
//    }
//
    if (component == 0) {
        
    ReleaseGoodsModel *pro = [self.oneColumnDataArray objectAtIndex:row];
    NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:pro.category_name attributes:self.textAttributes];
    label.attributedText = attStr;
        

    } else if (component == 1) {
        ReleaseGoodsModel *pro = [self.twoColumnDataArray   objectAtIndex:row];
        NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:pro.category_name attributes:self.textAttributes];
        label.attributedText = attStr;
    }
    else {
        
        ReleaseGoodsModel *pro = [self.threeColumnDataArray objectAtIndex:row];
        NSAttributedString *attStr = [[NSAttributedString alloc]initWithString:pro.category_name attributes:self.textAttributes];
        label.attributedText = attStr;
    }

    
    
    return label;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
//    
//    if (component == 0) {
//        
//        SHProvince *province = [self.dataSource objectAtIndex:row];
//        __currentProvience = province;
//        
//        SHCity *city = [province.cities firstObject];
//        __currentCity = city;
//        
//        __currentArea = [city.areas firstObject];
//        
//        [pickerView reloadComponent:1];
//        [pickerView selectRow:0 inComponent:1 animated:YES];
//        
//        [pickerView reloadComponent:2];
//        [pickerView selectRow:0 inComponent:2 animated:YES];
//    } else if (component == 1) {
//        
//        if (__currentProvience.cities.count > row) {
//            
//            SHCity *city = [__currentProvience.cities objectAtIndex:row];
//            __currentCity = city;
//            
//            __currentArea = [city.areas firstObject];
//        }
//        
//        [pickerView reloadComponent:2];
//        [pickerView selectRow:0 inComponent:2 animated:YES];
//    } else if (component == 2) {
//        
//        if (__currentCity.areas.count > row) {
//            __currentArea = [__currentCity.areas objectAtIndex:row];
//        }
//    }
//    
     //  NSNumber *index;
    
    if (component == 0)
    {
        
        NSString *indexId= [self.oneColumnDataArray objectAtIndex:row].id;
      
        [ReleaseGoodsModel releaseGoodsModelParent_Id:indexId success:^(NSMutableArray<ReleaseGoodsModel *> *ReleaseGoodsArray) {
            self.twoColumnDataArray = ReleaseGoodsArray;
                       [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            
            
            
            NSString *threeIndexId= [self.twoColumnDataArray objectAtIndex:0].id;
            
            [ReleaseGoodsModel releaseGoodsModelParent_Id:threeIndexId success:^(NSMutableArray<ReleaseGoodsModel *> *ReleaseGoodsArray) {
                self.threeColumnDataArray = ReleaseGoodsArray;
                
                [pickerView reloadComponent:2];
                [pickerView selectRow:0 inComponent:2 animated:YES];
                
                [self didSelectPickerView];
                
            } error:^{
            //    NSLog(@"失败");
            }];

            
        } error:^{
          //  NSLog(@"失败");
        }];
        
        
        
    }else if (component == 1)
    {
        
        NSString *indexId= [self.twoColumnDataArray objectAtIndex:row].id;
        
        
        [ReleaseGoodsModel releaseGoodsModelParent_Id:indexId success:^(NSMutableArray<ReleaseGoodsModel *> *ReleaseGoodsArray) {
            self.threeColumnDataArray = ReleaseGoodsArray;
            
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            [self didSelectPickerView];
            
        } error:^{
            //NSLog(@"失败");
        }];
    }else
    {
        [self didSelectPickerView];
    }
  
    
}

#pragma mark 滚动停止后 获得选中的的分类
- (void)didSelectPickerView
{
    NSInteger oneClassIndex = [self.pickerView selectedRowInComponent:0];
    
    NSInteger twoClassIndex = [self.pickerView selectedRowInComponent:1];
    
    NSInteger threeClassIndex = [self.pickerView selectedRowInComponent:2];
    
    
    self.oneClassify = [self.oneColumnDataArray objectAtIndex:oneClassIndex].category_name;
    self.oneClassifyId = [self.oneColumnDataArray objectAtIndex:oneClassIndex].id;
    
    self.twoClassify  = [self.twoColumnDataArray objectAtIndex:twoClassIndex].category_name;
    
  //  NSLog(@"%@",[self.threeColumnDataArray objectAtIndex:threeClassIndex].category_name);
    
    NSLog(@"%@",self.threeColumnDataArray);
    
    self.threeClassify  = [self.threeColumnDataArray objectAtIndex:threeClassIndex].category_name;
    
   // NSLog(@"%@",[NSString stringWithFormat:@"%@-%@-%@-%@",self.oneClassify,self.oneClassifyId,self.twoClassify,self.threeClassify]);

        // 选择结果回调
//        if (__selectBlock && self.autoChange) {
//    
//            // 滚动完成后选中显示到文本中
//            NSString *address = [NSString stringWithFormat:@"%@-%@-%@",__currentArea.province,__currentArea.city,__currentArea.name];
//            __selectBlock(address,__currentArea.province,__currentArea.city,__currentArea.name);
//        }
}



@end
