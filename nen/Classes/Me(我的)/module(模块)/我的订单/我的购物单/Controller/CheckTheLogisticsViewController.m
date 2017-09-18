//
//  CheckTheLogisticsViewController.m
//  nen
//
//  Created by nenios101 on 2017/5/24.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "CheckTheLogisticsViewController.h"
#import "LogisticsDetailsModel.h"
#import "CheckTheLogisticsCell.h"
#import "LogisticsDetailsOtherModel.h"

@interface CheckTheLogisticsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIView *headView;

// 物流状态
@property (nonatomic,strong) UILabel *logisticsStatus;

// 运输公司
@property (nonatomic,strong) UILabel *transportationCompany;
// 运单编号
@property (nonatomic,strong) UILabel *waybillNumber;
// 官方电话
@property (nonatomic,strong) UILabel *ftheOfficialPhone;

@property (nonatomic,strong) UIView *middBottomView;

@property (nonatomic,strong) LogisticsDetailsModel *logisticsDetailsModel;

@property (nonatomic,strong) UITableView *tablView;


@property (nonatomic,strong) NSMutableArray <LogisticsDetailsOtherModel *>*logisticsDetailsOtherModelDataArr;

@end

@implementation CheckTheLogisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self addHeadView];
    
    [self addMiddleView];
    
    [self loadData];
    
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(0,ScreenHeight - 50,ScreenWidth,50);
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.frame = CGRectMake(ScreenWidth - 100,10,80,30);
    rightLabel.text = @"派件评价";
    rightLabel.textColor = [UIColor lightGrayColor];
    rightLabel.font = [UIFont systemFontOfSize:14];
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    rightLabel.layer.borderWidth = 0.5f;
    [bottomView addSubview:rightLabel];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.frame = CGRectMake(ScreenWidth - 200,10,80,30);
    leftLabel.text = @"物流投诉";
    leftLabel.textColor = [UIColor lightGrayColor];
    leftLabel.font = [UIFont systemFontOfSize:14];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    leftLabel.layer.borderWidth = 0.5f;
    [bottomView addSubview:leftLabel];
    
}


- (void)loadData
{
    [LogisticsDetailsModel logisticsDetailsModelOrderId:self.Id success:^(LogisticsDetailsModel *logisticsDetailsModel) {
        
        self.logisticsDetailsModel = logisticsDetailsModel;
        
        NSMutableArray *dataArray = self.logisticsDetailsModel.parent;
        self.logisticsDetailsOtherModelDataArr  = [LogisticsDetailsOtherModel mj_objectArrayWithKeyValuesArray:dataArray];
        

        self.logisticsStatus.text = self.logisticsDetailsModel.state;
        self.transportationCompany.text = [NSString stringWithFormat:@"运输公司 : %@",self.logisticsDetailsModel.express_name];
        self.waybillNumber.text = [NSString stringWithFormat:@"运单编号 : %@",self.logisticsDetailsModel.express_number];
        
        _tablView = [[UITableView alloc] init];
        _tablView.frame = CGRectMake(0,self.middBottomView.sh_bottom,ScreenWidth,ScreenHeight - (self.middBottomView.sh_bottom + 50));
        _tablView.delegate = self;
        _tablView.dataSource = self;
        _tablView.bounces = NO;
        _tablView.rowHeight = 90;
        _tablView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tablView];
        
    } error:^{
        NSLog(@"失败");
    }];
    
}

#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logisticsDetailsModel.parent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"cell";
    CheckTheLogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    if (!cell)
    {
        cell = [[CheckTheLogisticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    
    cell.model = self.logisticsDetailsOtherModelDataArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    return cell;

}



#pragma mark 头部
- (void)addHeadView
{
    UIView *headView = [[UIView alloc] init];
    self.headView = headView;
    headView.backgroundColor = [UIColor whiteColor];
    headView.frame = CGRectMake(0,69,ScreenWidth,130);
    [self.view addSubview:headView];
    
    UIImageView *headIconImage = [[UIImageView alloc] init];
    headIconImage.frame = CGRectMake(10,10,ScreenWidth *0.3,110);
    [headIconImage sd_setImageWithURL:[NSURL URLWithString:self.goodsImage]];
    [headView addSubview:headIconImage];
    
    CGFloat W = ScreenWidth - (headIconImage.sh_width + 20);
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(headIconImage.sh_right + 10,headIconImage.sh_y,65,20);
    title.text = @"物流状态 : ";
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:13];
    [headView addSubview:title];
    
    UILabel *logisticsStatus = [[UILabel alloc] init];
    self.logisticsStatus = logisticsStatus;
    logisticsStatus.font = [UIFont systemFontOfSize:13];
    logisticsStatus.frame = CGRectMake(title.sh_right,headIconImage.sh_y,W*0.5,20);
    logisticsStatus.text = @"物流状态";
    logisticsStatus.textColor = [UIColor paleGodenrod];
    [headView addSubview:logisticsStatus];
    

    UILabel *transportationCompany = [[UILabel alloc] init];
    self.transportationCompany = transportationCompany;
    transportationCompany.font = [UIFont systemFontOfSize:13];
    transportationCompany.frame = CGRectMake(headIconImage.sh_right + 10,title.sh_bottom + 10,W,20);
    transportationCompany.text = @"运输公司 :";
    transportationCompany.textColor = [UIColor lightGrayColor];
    [headView addSubview:transportationCompany];

    UILabel *waybillNumber = [[UILabel alloc] init];
    self.waybillNumber = waybillNumber;
    waybillNumber.font = [UIFont systemFontOfSize:13];
    waybillNumber.frame = CGRectMake(headIconImage.sh_right + 10,transportationCompany.sh_bottom + 10,W,20);
    waybillNumber.text = @"运单编号";
    waybillNumber.textColor = [UIColor lightGrayColor];
    [headView addSubview:waybillNumber];

    UILabel *theOfficialPhone = [[UILabel alloc] init];
    self.ftheOfficialPhone = theOfficialPhone;
    theOfficialPhone.font = [UIFont systemFontOfSize:13];
    theOfficialPhone.frame = CGRectMake(headIconImage.sh_right + 10,waybillNumber.sh_bottom + 10,W,20);
    theOfficialPhone.text = @"官方电话 : ";
    theOfficialPhone.textColor = [UIColor lightGrayColor];
    [headView addSubview:theOfficialPhone];
    
}

#pragma mark 中部
- (void)addMiddleView
{
    UIView *middView = [[UIView alloc] init];
    middView.frame = CGRectMake(0,self.headView.sh_bottom + 10,ScreenWidth,80);
    middView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:middView];
    
    UIImageView *headIconImage = [[UIImageView alloc] init];
    headIconImage.frame = CGRectMake(20,10,60,60);
    headIconImage.layer.cornerRadius = 30;
    headIconImage.clipsToBounds = YES;
    headIconImage.image = [UIImage imageNamed:@"3"];
    [middView addSubview:headIconImage];
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(headIconImage.sh_right + 10,headIconImage.sh_y + 10,60,20);
    title.text = @"派送员";
    title.textColor = [UIColor lightGrayColor];
    title.font = [UIFont systemFontOfSize:13];
    [middView addSubview:title];
    
    UILabel *title1 = [[UILabel alloc] init];
    title1.font = [UIFont systemFontOfSize:15];
    title1.frame = CGRectMake(title.sh_x,title.sh_bottom,60,20);
    title1.text = @"里默默";
    title1.textColor = [UIColor blackColor];
    [middView addSubview:title1];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@">" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(ScreenWidth - 80 ,middView.sh_height * 0.5 - 15,80, 30);
    [rightBtn setImage:[UIImage imageNamed:@"shoppingCart"] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:25];
    [rightBtn horizontalCenterImageAndTitle:25];
    [middView addSubview:rightBtn];
    
    UIView *middBottomView = [[UIView alloc] init];
    self.middBottomView = middBottomView;
    middBottomView.frame = CGRectMake(0,middView.sh_bottom + 10,ScreenWidth,40);
    middBottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:middBottomView];
    
    UIImageView *middHeadIconImage1 = [[UIImageView alloc] init];
    middHeadIconImage1.frame = CGRectMake(30,5,30,30);
    middHeadIconImage1.layer.cornerRadius = 15;
    middHeadIconImage1.clipsToBounds = YES;
    middHeadIconImage1.image = [UIImage imageNamed:@"3"];
    [middBottomView addSubview:middHeadIconImage1];
    
    UILabel *middTitle = [[UILabel alloc] init];
    middTitle.frame = CGRectMake(headIconImage.sh_right + 10,middBottomView.sh_height*0.5 - 10 ,120,20);
    middTitle.text = @"数据有菜鸟果果提供";
    middTitle.textColor = [UIColor lightGrayColor];
    middTitle.font = [UIFont systemFontOfSize:13];
    [middBottomView addSubview:middTitle];
    
    UIButton *middRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [middRightBtn setTitle:@">" forState:UIControlStateNormal];
    [middRightBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    middRightBtn.frame = CGRectMake(ScreenWidth - 30,middBottomView.sh_height * 0.5 - 7.5,15, 15);
    middRightBtn.titleLabel.font = [UIFont systemFontOfSize:25];
    [middBottomView addSubview:middRightBtn];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    [self setNavBar];
}



#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"查看物流";
    UIButton *leftButton = [[UIButton alloc]init];
    leftButton.frame = CGRectMake(0, 0,KNavBarBackBtnW, KNavBarBackBtnH);
    [leftButton setBackgroundImage:KNavBarBackIcon forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItems = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    nagetiveSpacer.width = KNavBarSpacing;   //这个值可以根据自己需要自己调整
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,leftBarButtonItems];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:KNavBarTittleFont],
       
       NSForegroundColorAttributeName:KNavBarTitleColor }];
    
    self.navigationController.navigationBar.barTintColor = KNavBarBarTintColor;
    
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}






@end
