
//

#import "ManagementViewController.h"
#import "UIView+SHextension.h"
#import "PublishMessagesView.h"
#import "TransactionManagement.h"
#import "DocumentsView.h"
#import "StaffingView.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


@interface ManagementViewController ()


@property(nonatomic,strong) UIScrollView *scrollview;

@property(nonatomic,weak) UIView *headViewBottomLineView;
// 信息发布
@property(nonatomic,strong) PublishMessagesView *messagesView;
// 事务管理
@property(nonatomic,strong) TransactionManagement *transactionView;
// 文档中心
@property(nonatomic,strong) DocumentsView *documentsView;
// 人事中心
@property(nonatomic,strong) StaffingView *staffingView;

@end

@implementation ManagementViewController

- (void)viewDidLoad {
 [super viewDidLoad];
 
  
    UIScrollView *srVc = [[UIScrollView alloc] init];
    self.scrollview = srVc;
    srVc.backgroundColor= [UIColor whiteColor];
    srVc.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
    [self.view addSubview:srVc];
    [self addHeadView];
    [self addPublishMessages];
    [self addTransactionManagement];
    [self addDocuments];
    [self addStaffingView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollview.contentSize =CGSizeMake(0,self.staffingView.sh_bottom);
}
#pragma mark 添加头部
- (void)addHeadView
{
    UIView *headVc = [[UIView alloc] init];
    
    UILabel *headLabel = [[UILabel alloc] init];
    headLabel.text = @"当前位置：接引侍 | 内务管理";
    headLabel.font = [UIFont systemFontOfSize:12];
    headLabel.textColor = [UIColor whiteColor];
    headLabel.sh_x = 15;
    headLabel.sh_height = 25;
    headLabel.sh_y = 0;
    headLabel.sh_width = ScreenWidth *0.5;
    [headVc addSubview:headLabel];
    
    headVc.sh_height = 25;
    headVc.sh_width = ScreenWidth;
    headVc.sh_y = 99;
    headVc.sh_x = 0;
    headVc.backgroundColor = [UIColor orangeColor];
    
    UIView  *headViewBottomLine = [[UIView alloc] init];
    headViewBottomLine.backgroundColor = [UIColor grayColor];
    headViewBottomLine.sh_x = 0;
    headViewBottomLine.sh_y = headVc.sh_bottom + 5;
    headViewBottomLine.sh_width = ScreenWidth;
    headViewBottomLine.sh_height = 1;
    self.headViewBottomLineView = headVc;
    [self.scrollview addSubview:headViewBottomLine];
    
    [self.scrollview addSubview:headVc];
    
}
#pragma mark 信息发布
- (void)addPublishMessages
{
    _messagesView= [[[NSBundle mainBundle] loadNibNamed:@"PublishMessagesView" owner:nil options:nil] firstObject];
    _messagesView.sh_x = 0;
    _messagesView.sh_y = self.headViewBottomLineView.sh_bottom;
    _messagesView.sh_height = 140;
    _messagesView.sh_width = ScreenWidth;
    [self.scrollview addSubview:_messagesView];
}
#pragma mark 事务管理
- (void)addTransactionManagement
{
    _transactionView = [[[NSBundle mainBundle] loadNibNamed:@"TransactionManagement" owner:nil options:nil] firstObject];
    _transactionView.sh_x = 0;
    _transactionView.sh_y = _messagesView.sh_bottom + 5;
    _transactionView.sh_height = 140;
    _transactionView.sh_width = ScreenWidth;
    [self.scrollview addSubview:_transactionView];
}
#pragma mark 文档中心
- (void)addDocuments
{
    _documentsView = [[[NSBundle mainBundle] loadNibNamed:@"Documents" owner:nil options:nil] firstObject];
    _documentsView.sh_x = 0;
    _documentsView.sh_y = _transactionView.sh_bottom + 5;
    _documentsView.sh_height = 140;
    _documentsView.sh_width = ScreenWidth;
    [self.scrollview addSubview:_documentsView];
}
#pragma mark 人事中心
- (void)addStaffingView
{
    _staffingView = [[[NSBundle mainBundle] loadNibNamed:@"Staffing" owner:nil options:nil] firstObject];
    _staffingView.sh_x = 0;
    _staffingView.sh_y = _documentsView.sh_bottom + 5;
    _staffingView.sh_height = 140;
    _staffingView.sh_width = ScreenWidth;
    [self.scrollview addSubview:_staffingView];
}

@end
