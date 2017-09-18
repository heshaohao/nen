//
//  CZCountDownView.m
//  countDownDemo


#import "FLCountDownView.h"
// label数量
#define KlabelCount 4
#define KseparateLabelCount 3
#define Kpadding 5

#define KSizeFont 13
#define KtitleColor [UIColor orangeColor]


@interface FLCountDownView (){
    // 定时器
    NSTimer *timer;
}
@property (nonatomic,strong)NSMutableArray *timeLabelArrM;
@property (nonatomic,strong)NSMutableArray *separateLabelArrM;
// day
@property (nonatomic,strong)UILabel *dayLabel;
// hour
@property (nonatomic,strong)UILabel *hourLabel;
// minues
@property (nonatomic,strong)UILabel *minuesLabel;
// seconds
@property (nonatomic,strong)UILabel *secondsLabel;

@property (nonatomic,strong) UILabel *headTitle;
@property (nonatomic,strong) UILabel *endTitle;
@end


@implementation FLCountDownView
// 创建单例
+ (instancetype)fl_shareCountDown{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FLCountDownView alloc] init];
        
    });
    return instance;
}

+ (instancetype)fl_countDown{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.dayLabel];
        [self addSubview:self.hourLabel];
        [self addSubview:self.minuesLabel];
        [self addSubview:self.secondsLabel];
        
        
        for (NSInteger index = 0; index < KseparateLabelCount; index ++) {
            UILabel *separateLabel = [[UILabel alloc] init];
            separateLabel.text = @":";
            separateLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:separateLabel];
            [self.separateLabelArrM addObject:separateLabel];
        }
    }
    return self;
}

- (void)setBackgroundImageName:(NSString *)backgroundImageName{
    _backgroundImageName = backgroundImageName;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:backgroundImageName]];
    imageView.frame = self.bounds;
    [self addSubview:imageView];
//    [self bringSubviewToFront:imageView];
}

// 拿到外界传来的时间戳
- (void)setTimestamp:(NSInteger)timestamp{
    _timestamp = timestamp;
    if (_timestamp != 0) {
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        else{
            timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }
}

-(void)timer:(NSTimer*)timerr{
    _timestamp--;
    [self getDetailTimeWithTimestamp:_timestamp];
    if (_timestamp == 0) {
        [timer invalidate];
        timer = nil;
        // 执行block回调
        self.timerStopBlock();
    }
}

- (void)getDetailTimeWithTimestamp:(NSInteger)timestamp{
    NSInteger ms = timestamp;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
//    NSLog(@"%zd日:%zd时:%zd分:%zd秒",day,hour,minute,second);
    
    self.dayLabel.text = [NSString stringWithFormat:@"%zd天",day];
    self.hourLabel.text = [NSString stringWithFormat:@"%zd时",hour];
    self.minuesLabel.text = [NSString stringWithFormat:@"%zd分",minute];
    self.secondsLabel.text = [NSString stringWithFormat:@"%zd秒",second];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    // 获得view的宽、高
    CGFloat viewW = self.frame.size.width;
    CGFloat viewH = self.frame.size.height;
    // 单个label的宽高
    CGFloat labelW = viewW / KlabelCount;
    CGFloat labelH = viewH;
    
    self.headTitle.text = @"剩余";
    self.headTitle.font = [UIFont systemFontOfSize:KSizeFont];
    self.headTitle.frame = CGRectMake(0,0,20,labelH);
    [self addSubview:self.headTitle];
    
    self.dayLabel.frame = CGRectMake(0, 0, labelW, labelH);
    self.dayLabel.font = [UIFont systemFontOfSize:KSizeFont];
    
    self.hourLabel.frame = CGRectMake(labelW  , 0, labelW, labelH);
    self.hourLabel.font = [UIFont systemFontOfSize:KSizeFont];
    
    self.minuesLabel.frame = CGRectMake(2 * labelW , 0, labelW, labelH);
    self.minuesLabel.font = [UIFont systemFontOfSize:KSizeFont];
    
    self.secondsLabel.frame = CGRectMake(3 * labelW, 0, labelW, labelH);
    self.secondsLabel.font = [UIFont systemFontOfSize:KSizeFont];
    
    
    for (NSInteger index = 0; index < self.separateLabelArrM.count ; index ++) {
        UILabel *separateLabel = self.separateLabelArrM[index];
        separateLabel.frame = CGRectMake((labelW - 1) * (index + 1) ,-1, 5, labelH);
    }
}


#pragma mark - setter & getter

- (NSMutableArray *)timeLabelArrM{
    if (_timeLabelArrM == nil) {
        _timeLabelArrM = [[NSMutableArray alloc] init];
    }
    return _timeLabelArrM;
}

- (NSMutableArray *)separateLabelArrM{
    if (_separateLabelArrM == nil) {
        _separateLabelArrM = [[NSMutableArray alloc] init];
    }
    return _separateLabelArrM;
}

- (UILabel *)dayLabel{
    if (_dayLabel == nil) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
//        _dayLabel.backgroundColor = [UIColor grayColor];
    }
    return _dayLabel;
}

- (UILabel *)hourLabel{
    if (_hourLabel == nil) {
        _hourLabel = [[UILabel alloc] init];
        _hourLabel.textAlignment = NSTextAlignmentCenter;
//        _hourLabel.backgroundColor = [UIColor redColor];
    }
    return _hourLabel;
}

- (UILabel *)minuesLabel{
    if (_minuesLabel == nil) {
        _minuesLabel = [[UILabel alloc] init];
        _minuesLabel.textAlignment = NSTextAlignmentCenter;
//        _minuesLabel.backgroundColor = [UIColor orangeColor];
    }
    return _minuesLabel;
}

- (UILabel *)secondsLabel{
    if (_secondsLabel == nil) {
        _secondsLabel = [[UILabel alloc] init];
        _secondsLabel.textAlignment = NSTextAlignmentCenter;
//        _secondsLabel.backgroundColor = [UIColor yellowColor];
    }
    return _secondsLabel;
}


@end
