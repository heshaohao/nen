
#import "TempleHomeViewController.h"
#import "Presentation.h"
#import "UIView+SHextension.h"
#import "HostView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface TempleHomeViewController ()<SDCycleScrollViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) SDCycleScrollView *cycleScrollView;

@property(nonatomic,strong) Presentation *presentationView;
@property(nonatomic,strong) HostView *hostView;

@property(nonatomic,strong) NSArray *shuffingMoldelArray;

@end


@implementation TempleHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       [self addHeadView];
    // 加载数据
    [ShufflingFigureModel shufflingFigureLocation:@"17" Success:^(NSArray<ShufflingFigureModel *> *shufflingFigure) {
        self.shuffingMoldelArray = shufflingFigure;
        
        [self addHeadView];
        
    } error:^{
        NSLog(@"失败");
    }];
    

    [self addscrollview];
    [self addPresentation];
    [self addHostView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)addscrollview
{
    UIScrollView *scrVc = [[UIScrollView alloc] init];
    scrVc.bounces = NO;
    self.scrollView = scrVc;
    scrVc.backgroundColor = [UIColor whiteColor];
    scrVc.frame = CGRectMake(0,95,ScreenWidth, ScreenHeight);
    [self.view addSubview:scrVc];
    

}
#pragma mark 添加图片轮播器
- (void)addHeadView
{
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 200) delegate:self placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    self.cycleScrollView = cycleScrollView;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor];

    NSMutableArray *arrTemp = [NSMutableArray array];
    
    [self.shuffingMoldelArray enumerateObjectsUsingBlock:^(ShufflingFigureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrTemp addObject:obj.img_url];
    }];
    
    cycleScrollView.imageURLStringsGroup = arrTemp;
    
   
    [self.scrollView addSubview:cycleScrollView];
    
}

#pragma mark 图片轮播器数组
- (NSArray *)shuffingMoldelArray{
    if (!_shuffingMoldelArray) {
        _shuffingMoldelArray = [NSArray array];
    }
    return _shuffingMoldelArray;
}



#pragma mark图片轮播器点击跳转方法
- (void)selectItemAtIndex:(NSInteger)index {
   
}

- (void)addPresentation
{
    _presentationView = [[[NSBundle mainBundle] loadNibNamed:@"Presentation" owner:nil options:nil] lastObject];
    _presentationView.backgroundColor = [UIColor blueColor];
    
    _presentationView.frame = CGRectMake(0,_cycleScrollView.sh_bottom, ScreenWidth, 250);
    
    [self.scrollView addSubview:_presentationView];
    
}

- (void)addHostView
{
    _hostView = [[[NSBundle mainBundle] loadNibNamed:@"HostView" owner:nil options:nil] lastObject];
    _hostView.frame = CGRectMake(0,_presentationView.sh_bottom + 5,ScreenWidth, 280);
    
    
    _hostView.backgroundColor = [UIColor orangeColor];
    [self.scrollView addSubview:_hostView];
    
    
    self.scrollView.contentSize = CGSizeMake(0,_hostView.sh_bottom + 94);
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

@end
