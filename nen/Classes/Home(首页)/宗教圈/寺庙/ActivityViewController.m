
// 活动

#import "ActivityViewController.h"
#import "UIView+SHextension.h"
#import "ActivityView.h"
#import "SignUpChannelView.h"
@interface ActivityViewController ()<SDCycleScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;

// 最新动态
@property(nonatomic,strong) ActivityView *activityView;

// 图片轮播器
@property(nonatomic,strong) UIView *headView;

// 报名通道
@property(nonatomic,strong)SignUpChannelView *signView;

// 图片轮播器数据

@property(nonatomic,strong) NSArray *shuffingMoldelArray;

@end

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载数据
    [ShufflingFigureModel shufflingFigureLocation:@"17" Success:^(NSArray<ShufflingFigureModel *> *shufflingFigure) {
        self.shuffingMoldelArray = shufflingFigure;
        
        [self addHeadView];
        
    } error:^{
      //  NSLog(@"失败");
    }];

    [self addScrollView];

    
    [self addMiddleView];
    
    [self addSignView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)addScrollView
{
    UIScrollView *scrVc = [[UIScrollView alloc] init];
    self.scrollView = scrVc;
    scrVc.frame = CGRectMake(0, 99,ScreenWidth,ScreenHeight);
    scrVc.backgroundColor = [UIColor blueColor];
    scrVc.bounces = NO;
    [self.view addSubview:scrVc];
    
   
}


#pragma mark 图片轮播器数组
- (NSArray *)shuffingMoldelArray{
    if (!_shuffingMoldelArray) {
        _shuffingMoldelArray = [NSArray array];
    }
    return _shuffingMoldelArray;
}


#pragma mark 添加图片轮器
- (void)addHeadView
{
    _headView = [[UIView alloc] init];

    [self.scrollView addSubview:_headView];

    // 图片轮播器
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 200) delegate:self placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    
    NSMutableArray *arrTemp = [NSMutableArray array];
    
    [self.shuffingMoldelArray enumerateObjectsUsingBlock:^(ShufflingFigureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrTemp addObject:obj.img_url];
    }];
    
    cycleScrollView.imageURLStringsGroup = arrTemp;
    
    [_headView addSubview:cycleScrollView];

   
}

#pragma mark图片轮播器点击跳转方法
- (void)selectItemAtIndex:(NSInteger)index {

}



- (void)addMiddleView
{
    _activityView  = [[[NSBundle mainBundle] loadNibNamed:@"ActivtyView" owner:nil options:nil] lastObject];
    _activityView.frame = CGRectMake(0,200,ScreenWidth,280);
    
    [self.scrollView addSubview:_activityView];
    
}

- (void)addSignView
{
    _signView = [[[NSBundle mainBundle] loadNibNamed:@"SignUpChannelView" owner:nil options:nil] lastObject];
    _signView.frame = CGRectMake(0,_activityView.sh_bottom,ScreenWidth,250);
    
    [self.scrollView addSubview:_signView];
    
    self.scrollView.contentSize = CGSizeMake(0, _signView.sh_bottom + 99);
}


@end
