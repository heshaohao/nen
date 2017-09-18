//
//  HomeViewController.m
//  nen
//
//  Created by nenios101 on 2017/2/27.
//
//

#import "HomeViewController.h"

#import "OptionModel.h"
#import "OptionView.h"
#import "YFRollingLabel.h"
#import "DeliciousFoodCell.h"
#import "CurrencyView.h"
#import "BrandView.h"
#import "familyCell.h"
#import "ReligiousViewController.h"
#import "TrainingEducationViewController.h"



#define Height 250

@interface HomeViewController ()<UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
// 图片轮播器
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
// 模型数组
@property (nonatomic, strong) NSArray *appList;
// 选项区
@property(nonatomic,strong) UIView *opctionview;

// 跑马灯文本
@property(nonatomic,strong) UIView  *horseView;
@property (nonatomic, strong) YFRollingLabel *horseRaceLampLabel;
@property(nonatomic,strong) UICollectionView *colletionView;


//品推荐
@property(nonatomic,strong) UIView *brandView;

@property(nonatomic,strong) familyCell *familyCellView;

@property(nonatomic,strong) UIView *familyVc;

@property(nonatomic,strong) NSArray<ShufflingFigureModel *> *shuffingMoldelArray;

@property(nonatomic,strong) ShufflingFigureModel *shufflingModel;

@end

@implementation HomeViewController


#pragma mark 模拟数据数组
- (NSArray *)appList
{
    if (_appList == nil) {
        NSMutableArray *mutArray = [NSMutableArray array];
        NSArray * array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"app.plist" ofType:nil]];
        for (NSDictionary *dict in array) {
            [mutArray addObject:[OptionModel modelWithDict:dict]];
        }
        _appList = mutArray;
    }
    
    return _appList;
}

#pragma mark 图片轮播器数组
- (NSArray *)shuffingMoldelArray{
    if (!_shuffingMoldelArray) {
        _shuffingMoldelArray = [NSArray array];
    }
    return _shuffingMoldelArray;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.scrollView.contentSize = CGSizeMake(0,_familyVc.sh_bottom + 5);
}

- (void)viewDidLoad {
    [super viewDidLoad];


    [ShufflingFigureModel shufflingFigureLocation:@"0" Success:^(NSArray<ShufflingFigureModel *> *shufflingFigure) {
        self.shuffingMoldelArray = shufflingFigure;
        
        [self addhead];
        
    } error:^{
     //   NSLog(@"失败");
    }];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cilck:) name:@"click"object:nil];
    
    [self addScrollView];
 
    [self setNav];

    [self optionView];
    
    [self horseRaceLamp];
    
    [self Foodpictures];
    
    [self brandRecommendation];
    
    [self familyLife];
    
   }
- (void)addScrollView
{
    // 创建底部scrollView
    UIScrollView *scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth,ScreenHeight)];
    self.scrollView = scrView;
    [self.view addSubview:scrView];
}

- (void)addhead
{
 
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, Height) delegate:self placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    
    NSMutableArray *arrTemp = [NSMutableArray array];
    
    [self.shuffingMoldelArray enumerateObjectsUsingBlock:^(ShufflingFigureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrTemp addObject:obj.img_url];
    }];

       cycleScrollView.imageURLStringsGroup = arrTemp;

    [self.scrollView addSubview:cycleScrollView];

}


#pragma mark图片轮播器点击跳转方法
- (void)selectItemAtIndex:(NSInteger)index {
    //NSLog(@"%ld",(long)index);
}

#pragma mark 点击几宫格按钮方法
- (void)cilck:(NSNotification *)notification
{
   NSNumber *inde = notification.userInfo[@"index"];

    switch ([inde integerValue]) {
        case 0:
            // 保险超市

            break;
        case 1:
            // 宗教圈
            [self.navigationController pushViewController:[[ReligiousViewController alloc] init] animated:YES];
            break;
        case 2:
            // 餐饮圈
            
            break;
        case 3:
            // 居家生活
            break;
        case 4:
            // 购物车
            break;
        case 5:
            // 培训圈
            [self.navigationController pushViewController:[[TrainingEducationViewController alloc] init] animated:YES];
            break;
        case 6:
            // 美容圈
            break;
        case 7:
            // 帮助
            
            break;
        default:
            break;
    }
    
    
}


#pragma mark 导航栏返回按钮方法
- (void)balck
{
   // NSLog(@"sssss");
}
#pragma mark 设置导航栏
- (void)setNav
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加左边导航栏按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刚需求" style:UIBarButtonItemStylePlain target:self action:@selector(balck)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];

    
}


#pragma mark 选项区九宫格方法
- (void)optionView{

    self.opctionview = [[UIView alloc] initWithFrame:CGRectMake(0,Height, ScreenWidth, 180)];
    [self appList];
    //控制总列数
    int totalColumns = 4;
    CGFloat Y = 0;
    CGFloat W = 60;
    CGFloat H = 80;
    CGFloat X = (self.view.frame.size.width - totalColumns * W) / (totalColumns + 1);
    
    for (int index = 0; index < _appList.count; index++) {
        
        OptionModel *model = _appList[index];
        int row = index / totalColumns;
        int col = index % totalColumns;
        CGFloat viewX = X + col * (W + X);
        CGFloat viewY = 20 + row * (H + Y);
        OptionView *view = [[OptionView alloc]initWithFrame:CGRectMake(viewX, viewY, W, H) Model:model Index:index];
        [self.opctionview addSubview:view];
       
    }
    [self.scrollView addSubview:self.opctionview];


}


#pragma mark 加载跑马灯文本
- (void)horseRaceLamp
{
    _horseView = [[UIView  alloc] initWithFrame:CGRectMake(0,self.opctionview.sh_bottom,ScreenWidth  , 25)];
    _horseView.backgroundColor = [UIColor redColor];
    
    //添加文字内容
    NSArray *textArray = @[@"THIS IS THE FIRST TEXT",
                           @"THIS IS THE FIRST TEXTYY"
                           ];
    
    self.horseRaceLampLabel = [[YFRollingLabel alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 25)  textArray:textArray font:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor]];
    [_horseView addSubview:self.horseRaceLampLabel];
    self.horseRaceLampLabel.backgroundColor = [UIColor orangeColor];
    self.horseRaceLampLabel.speed = 2;
    [self.horseRaceLampLabel setOrientation:RollingOrientationLeft];
    [self.horseRaceLampLabel setInternalWidth:self.horseRaceLampLabel.frame.size.width / 3];;
    
    // 获取文字点击文字点击
    self.horseRaceLampLabel.labelClickBlock = ^(NSInteger index){
        NSString *text = [textArray objectAtIndex:index];
     //   NSLog(@"You Tapped item:%li , and the text is %@",(long)index,text);
    };
    
    
    [self.scrollView addSubview:_horseView];

}

#pragma mark 加载美食免费推荐
- (void)Foodpictures
{
    
    CurrencyView *foodPicturesHeadView = [CurrencyView currencyViewWithYvalue:_horseView.sh_bottom LeftTitle:@"免费吃推荐" andRightTitle:@"查看更多 >>"];
    
    
    [self.scrollView addSubview:foodPicturesHeadView];
    
    //创建一个layout布局类
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(220,150);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //创建collectionView 通过一个布局策略layout来创建
    _colletionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,foodPicturesHeadView.sh_bottom,ScreenWidth, 150) collectionViewLayout:flowLayout];
     //隐藏水平滚动条
    _colletionView.showsHorizontalScrollIndicator = NO;
    //取消弹簧效果
    _colletionView.bounces = NO;
    //代理设置
    _colletionView.dataSource = self;
    _colletionView.delegate = self;
    //注册item类型
    [_colletionView registerNib:[UINib nibWithNibName:NSStringFromClass([DeliciousFoodCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"foodCell"];
    
    [self.scrollView addSubview:_colletionView];

    
}
#pragma mark 加载品牌推荐方法
-(void)brandRecommendation
{
    
    CurrencyView *headBrandView = [CurrencyView currencyViewWithYvalue:_colletionView.sh_bottom LeftTitle:@"品牌推荐" andRightTitle:@"查看更多 >>"];

    [self.scrollView addSubview:headBrandView];
    
    self.brandView = [[UIView alloc] initWithFrame:CGRectMake(0,headBrandView.sh_bottom, ScreenWidth, 180)];
    [self appList];
    //控制总列数
    int totalColumns = 4;
    CGFloat Y = 0;
    CGFloat W = 80;
    CGFloat H = 70;
    CGFloat X = (self.view.frame.size.width - totalColumns * W) / (totalColumns + 1);
    
    for (int index = 0; index < _appList.count; index++) {
        
        OptionModel *model = _appList[index];
        int row = index / totalColumns;
        int col = index % totalColumns;
        CGFloat viewX = X + col * (W + X);
        CGFloat viewY = 20 + row * (H + Y);
        BrandView *view = [[BrandView alloc] initWithFrame:CGRectMake(viewX, viewY, W, H) Model:model];
        [self.brandView addSubview:view];
    }
    [self.scrollView addSubview:self.brandView];
    
}

#pragma mark 加载居家生活
-(void)familyLife
{
     CurrencyView *familyView = [CurrencyView currencyViewWithYvalue:self.brandView.sh_bottom  LeftTitle:@"居家生活" andRightTitle:@"查看更多 >>"];
    
    [self.scrollView addSubview:familyView];
    
    
    _familyVc = [[UIView alloc] initWithFrame:CGRectMake(0,familyView.sh_bottom, ScreenWidth, 220)];
    _familyVc.backgroundColor = [UIColor whiteColor];
    
    NSArray *familyArray = @[@"1",@"2",@"3",@"4"];
    
    //控制总列数
    int totalColumns = 2;
    CGFloat Y = 3 ;
    CGFloat W = 150;
    CGFloat H = 100;
    CGFloat X = (self.view.frame.size.width - totalColumns * W) / (totalColumns + 1);
    
    for (int index = 0; index <familyArray.count ; index++) {
        
        int row = index / totalColumns;
        int col = index % totalColumns;
        CGFloat viewX = X + col * (W + X);
        CGFloat viewY = 20 + row * (H + Y);
        self.familyCellView = [[[NSBundle mainBundle]loadNibNamed:@"familyCell" owner:nil options:nil] lastObject];
        self.familyCellView.frame = CGRectMake(viewX, viewY, W, H);
    
       

        [_familyVc addSubview:self.familyCellView];
        
    }
    [self.scrollView addSubview:_familyVc];
    
    
}


#pragma mark collection DataSource 方法
//返回item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    //返回图片数组的长度
    return 9;
    
}

//返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    DeliciousFoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"foodCell" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = collectionView.frame;
    
    [collectionView addSubview:imageView];
    //3. 设置数据
    cell.foodImageName = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
