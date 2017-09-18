//
//  TheOrderViewController.m
//  nen
//
//  Created by nenios101 on 2017/3/7.
//  Copyright © 2017年 nen. All rights reserved.
// 提交订单

#import "TheOrderViewController.h"
#import "UIView+SHextension.h"
#import "TheOrderContentView.h"
#import "OrderModel.h"
#import "AddresslistModel.h"
#import "AddressManagementController.h"
#import "PaymentCenterViewController.h"
#import "GroupOrderView.h"
@interface TheOrderViewController ()


@property(nonatomic,strong) TheOrderContentView *contrntView;


@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) NSArray <OrderModel *>*orderArr;

@property(nonatomic,strong) AddresslistModel *addressModel;

@property(nonatomic,strong) UILabel *nameLabel;

@property(nonatomic,strong) UILabel *number;

@property(nonatomic,strong) UILabel *cargoLocationLabel;

// 总价格
@property(nonatomic,strong) UILabel *sumMoney;
// 件数
@property(nonatomic,strong) UILabel *sumLabel;
// 总件数
@property(nonatomic,copy) NSString *count;
// 价格总和
@property(nonatomic,assign) CGFloat sum;
// 选择中奖方式
@property(nonatomic,copy) NSString *options;

@property(nonatomic,strong) PaymentCenterViewController *patmentVc;

@end

@implementation TheOrderViewController

#pragma mark 数据加载完毕
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavBar];
    if (self.is_groupStr == nil )
    {
        self.is_groupStr = @"0";
    }
    
    
    [AddresslistModel addressModelNum:@"1"succes:^(AddresslistModel *addressModel) {
        self.addressModel = addressModel;
       
        [self addHeadView];
    
        // 判断收货地址是否为空
        if (self.addressModel.id.length)
        {
            self.nameLabel.text = self.addressModel.relation_name;
            self.number.text = self.addressModel.relation_tel;
            self.cargoLocationLabel.text = self.addressModel.address;
        
        }
        
    } error:^{
        NSLog(@"失败");
    }];
    // 判断是否为 立即购买／购物车购买
    if (self.record !=nil)
    {
         NSString *Str = [self.shoppingCarGoodsId componentsJoinedByString:@","];
        
        [OrderModel orderModelIsCarId:@"1" GoodsId:Str AndNum:@"1" Is_group:self.is_groupStr succes:^(NSArray<OrderModel *> *orderArray) {
            self.orderArr = orderArray;
            
           [self addChildControl];
        
        } error:^{
            NSLog(@"失败");
        }];
        
    
    }else{
        
         [OrderModel orderModelIsCarId:@"0" GoodsId:self.goodsId AndNum:self.goods_num Is_group:self.is_groupStr succes:^(NSArray<OrderModel *> *orderArray) {
             self.orderArr = orderArray;
             
           [self addChildControl];
             
             
         } error:^{
             NSLog(@"失败");
         }];
        
    }
    
    
//    if ([self.is_groupStr isEqualToString:@"1"])
//    {
//        [OrderModel orderModelIsCarId:@"0" GoodsId:self.goodsId AndNum:self.goods_num Is_group:self.is_groupStr succes:^(NSArray<OrderModel *> *orderArray) {
//            self.orderArr = orderArray;
//            [self addChildControl];
//            
//        } error:^{
//             NSLog(@"失败");
//        }];
//        
//    }

    // 购买数量减少
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(minBtn:) name:@"min" object:nil];
    // 购买数量增加
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(maxBtn:) name:@"max" object:nil];
    // 选择消费中奖 / 全额返还
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(options:) name:@"options" object:nil];
    // 文本输入框开始编写
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldBegin) name:@"textFieldBegin" object:nil];
    // 文本输入框结束编写
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEnd) name:@"textFieldEnd" object:nil];
}


#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"提交订单";
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



#pragma 添加子控件
- (void)addChildControl
{
    [self addScrollview];
    
    [self addContentView];
    
    [self addBottomView];

}

#pragma makr 点击数量开始编辑输入调整键盘高度
- (void)textFieldBegin
{
    int offset = self.view.frame.origin.y - 65;//iPhone键盘高
    [UIView animateWithDuration:0.5 animations:^{
        
//        self.centernViews.transform = CGAffineTransformMakeTranslation(0, offset);
//        self.payPasswordBtn.transform =CGAffineTransformMakeTranslation(0, offset);
//        self.identityBtn.transform =CGAffineTransformMakeTranslation(0, offset);
        self.scrollView.transform = CGAffineTransformMakeTranslation(0, offset);
        
    }];

}

#pragma makr 结束编辑调整键盘高度
- (void)textFieldEnd
{
    [UIView animateWithDuration:0.5 animations:^{
//        self.centernViews.transform = CGAffineTransformIdentity;
//        self.payPasswordBtn.transform = CGAffineTransformIdentity;
//        self.identityBtn.transform = CGAffineTransformIdentity;
        self.scrollView.transform = CGAffineTransformIdentity;
        
    }];

}

#pragma makr 选择消费中奖 / 全额返还
- (void)options:(NSNotification *)notification
{
    NSString *options = notification.userInfo[@"options"];
   
    self.options = options;
}

//懒加载购物车id
- (NSMutableArray*)shoppingCarGoodsId
{
    if (!_shoppingCarGoodsId) {
        _shoppingCarGoodsId = [NSMutableArray array];
    }
    return _shoppingCarGoodsId;
}

#pragma mark 下一页返回后重新刷新

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [AddresslistModel addressModelNum:@"1"succes:^(AddresslistModel *addressModel) {
        self.addressModel = addressModel;
        
     
        if (self.addressModel.id.length)
        {
            self.nameLabel.text = self.addressModel.relation_name;
            self.number.text = self.addressModel.relation_tel;
            self.cargoLocationLabel.text = self.addressModel.address;
            
        }else
        {
            self.nameLabel.text = @"";
            self.number.text = @"";
            self.cargoLocationLabel.text = @"你还未添加地址, 点击添加!";
        }
        
        
    } error:^{
        NSLog(@"失败");
    }];
    

}


#pragma mark 数量减少
- (void)minBtn:(NSNotification *)notification
{
    
  //  NSLog(@"数量减少");
    self.goods_num = [NSString stringWithFormat:@"%f",[self.goods_num doubleValue] - 1];
    NSString *price =notification.userInfo[@"price"];
    
    NSString *item = notification.userInfo[@"textFieldLenght"];
    
    NSLog(@"%@",notification.userInfo[@"textFieldLenght"]);
    
    if (item !=nil)
    {
        // 把之前的总价格清空
        self.sum = 0;
        
        // 个数 乘以单商品的价格
        self.sum = [price doubleValue] * [item doubleValue];
        
        // 总价格减单商品的价格
        self.sum = self.sum - [price doubleValue] ;
    }else
    {
        self.sum = self.sum - [price doubleValue];
    }
    
//    self.sum = self.sum - [price doubleValue];
    self.sumMoney.text = [NSString stringWithFormat:@"¥%.2f",self.sum];
    self.sumLabel.text = [NSString stringWithFormat:@"共%@件,总金额",self.count];
}
#pragma mark 数量增加
- (void)maxBtn:(NSNotification *)notification
{
    self.goods_num = [NSString stringWithFormat:@"%f",[self.goods_num doubleValue] + 1];
     NSString *price =notification.userInfo[@"price"];
    
    NSString *item = notification.userInfo[@"textFieldLenght"];
    
   // NSLog(@"%@",notification.userInfo[@"textFieldLenght"]);
    
    if (item !=nil)
    {
        self.sum = 0;
         self.sum = self.sum + ([price doubleValue] * ([item doubleValue] + 1));
    }else
    {
        self.sum = self.sum + [price doubleValue];
    }
    
    
     self.sumMoney.text = [NSString stringWithFormat:@"¥%.2f",self.sum];
     self.sumLabel.text = [NSString stringWithFormat:@"共%@件,总金额",self.count];
}


#pragma mark 模型数组懒加载
- (NSArray *)orderArr
{
    if (!_orderArr) {
    
        _orderArr = [NSArray array];
    }
    return _orderArr;
}

- (void)addScrollview
{
    UIScrollView *scrVc = [[UIScrollView alloc] init];

    self.scrollView = scrVc;
    scrVc.bounces = NO;
    scrVc.frame = CGRectMake(0,169, ScreenWidth, ScreenHeight - 230);
    scrVc.backgroundColor = [UIColor whiteColor];
    scrVc.userInteractionEnabled = YES;
    
    [self.view addSubview:scrVc];
    
}

#pragma mark 收货地址
- (void)addHeadView
{
    UITapGestureRecognizer *tpaClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cationLocation:)];
    
    UIView *locationView = [[UIView alloc] init];
    locationView.frame = CGRectMake(0,64,ScreenWidth, 100);
    locationView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self.view addSubview:locationView];
    [locationView addGestureRecognizer:tpaClick];
    
    UILabel *caotin = [[UILabel alloc] init];
    caotin.frame = CGRectMake(5, 5,60,25);
    caotin.font = [UIFont systemFontOfSize:15];
    caotin.text = @"收货人";
    [locationView addSubview:caotin];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.frame = CGRectMake(caotin.sh_right,5,60,25);
    self.nameLabel.text = @"";
    [locationView addSubview:self.nameLabel];
    
    self.number = [[UILabel alloc] init];
    self.number.font = [UIFont systemFontOfSize:15];
    self.number.frame = CGRectMake(ScreenWidth - 120 ,5,110,25);
    self.number.text = @"";
    [locationView addSubview:self.number];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(5,70,20,20);
    imageView.image = [UIImage imageNamed:@"positioningIcon"];
    [locationView addSubview:imageView];
    
    
    self.cargoLocationLabel = [[UILabel alloc] init];
    self.cargoLocationLabel.frame = CGRectMake(imageView.sh_right + 10,70,ScreenWidth *0.7, 20);
    self.cargoLocationLabel.font = [UIFont systemFontOfSize:11];
    self.cargoLocationLabel.text = @"你还未添加地址, 点击添加!";
    
    [locationView addSubview:self.cargoLocationLabel];
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.frame = CGRectMake(ScreenWidth - 30,70,20,20);
    rightLabel.font = [UIFont systemFontOfSize:17];
    rightLabel.text = @">";
    rightLabel.textAlignment = NSTextAlignmentCenter;
    
    [locationView addSubview:rightLabel];
    
    
}

#pragma mark 跳转地址管理
-(void)cationLocation:(UITapGestureRecognizer *)tap
{
    
    [self.navigationController pushViewController:[[AddressManagementController alloc] init] animated:YES];

    
}

#pragma mark 购买信息
- (void)addContentView
{
    
    
    if (![self.is_groupStr isEqualToString:@"1"])
    {
        
        for (int i = 0; i < self.orderArr.count;i++)
        {
            _contrntView = [[[NSBundle mainBundle] loadNibNamed:@"TheOrderContentView" owner:nil options:nil] firstObject];
            
            OrderModel *orderModel = self.orderArr[i];
            
            _contrntView.model = orderModel;
            _contrntView.is_group = self.is_groupStr;
            
            CGFloat height = [_contrntView returnHeight];
            CGFloat totalHeight  = (height *(i +1)) ;
            _contrntView.frame = CGRectMake(0,i*height, ScreenWidth,height);
            
            
            [self.scrollView addSubview:_contrntView];
            self.scrollView.contentSize = CGSizeMake(0,totalHeight);
        }
        
    }else
    {
        for (int i = 0; i < self.orderArr.count;i++)
        {
            GroupOrderView *groupTheOrderV = [[GroupOrderView alloc] init];
        
            
            OrderModel *orderModel = self.orderArr[i];
            
            groupTheOrderV.model = orderModel;
            groupTheOrderV.is_group = self.is_groupStr;
            
            CGFloat height = [groupTheOrderV returnHeight];
            CGFloat totalHeight  = (height *(i +1)) ;
            groupTheOrderV.frame = CGRectMake(0,i*height, ScreenWidth,height);
            
            [self.scrollView addSubview:groupTheOrderV];
            self.scrollView.contentSize = CGSizeMake(0,totalHeight);
            self.scrollView.backgroundColor = [UIColor whiteColor];
            
        }
    }
    
}
#pragma mark 底部
- (void)addBottomView
{
    
    for (int i = 0; i< self.orderArr.count; i++)
    {
        OrderModel *model = self.orderArr[i];
        
        self.sum = self.sum + ([model.num doubleValue] * [model.price doubleValue]);
        
       // NSLog(@"%f",self.sum);
        
        self.count = [NSString stringWithFormat:@"%d",i + 1];
    }
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.frame = CGRectMake(0, ScreenHeight - 50, ScreenWidth, 50);
    bottomView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    _sumLabel = [[UILabel alloc] init];
    _sumLabel.text = [NSString stringWithFormat:@"共%@件,总金额",self.count];
    _sumLabel.font = [UIFont systemFontOfSize:13];
    _sumLabel.frame = CGRectMake(ScreenWidth * 0.15, 10,90,30);
    [bottomView addSubview:_sumLabel];
    
    _sumMoney = [[UILabel alloc] init];
    _sumMoney.frame = CGRectMake(_sumLabel.sh_right,10,80,30);
    _sumMoney.text = [NSString stringWithFormat:@"¥%.2f",self.sum];
    _sumMoney.font = [UIFont systemFontOfSize:13];
    _sumMoney.textColor = [UIColor orangeColor];
    [bottomView addSubview:_sumMoney];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitOrderBtnClick) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    submitBtn.frame = CGRectMake(ScreenWidth - 80,0,80,50);
    [submitBtn setBackgroundColor:[UIColor orangeColor]];
    
    [bottomView addSubview:submitBtn];
    
    [self.view addSubview:bottomView];
}

#pragma mark 提交订单
- (void)submitOrderBtnClick
{
    if(self.nameLabel.text.length == 0)
    {
        [JKAlert alertText:@"请添加收获地址"];
        return;
    }
   self.patmentVc = [[PaymentCenterViewController alloc] init];
    
    // 判断是否为 立即购买 / 购物车购买
    
    if (self.goodsId.length > 0)
    { // 立即购买
        self.patmentVc.goodsId = self.goodsId;
        self.patmentVc.goods_num = self.goods_num;
        self.patmentVc.options = self.options;
        self.patmentVc.singleTotalPrice = self.sum;
        // 团购
        self.patmentVc.is_group = self.is_groupStr;
        self.patmentVc.groupModel = self.groupModel;
        
        [self judgeGoodsWhetherExists];
        
    }else
    { // 购物车购买
        
      //  NSLog(@"%@",self.shoppingCarGoodsId);
     //   self.patmentVc.GoodsIdArray = self.shoppingCarGoodsId;
        self.patmentVc.moreTotalPrice = self.sum;
        [self judgeGoodsWhetherExists];
    }
    
    //  跳转支付页面
   
}
// 判断商品是否存在
- (void)judgeGoodsWhetherExists
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr;
    
    if ([self.record isEqualToString:@"1"])
    {
        // 购物车购买
       completeStr = [NSString stringEncryptedAddress:@"/order/ordercartcreate"];
    }else
    {   // 立即购买
        completeStr = [NSString stringEncryptedAddress:@"/order/orderoncecreate"];
        
    }
    
    NSDictionary *dict = @{};
    if (self.goodsId)
    {
        if (self.options == nil)
        {
            self.options = @"1";
        }
        
        if ([self.is_groupStr isEqualToString:@"1"])
        {
        dict = @{@"goods_id":self.goodsId,@"goods_num":self.goods_num,@"equipment":@"ios",@"address_id":@"1",@"pay_way":@"1",@"back_type":self.options,@"is_group":self.is_groupStr};
            
        }else
        {
            
            dict = @{@"goods_id":self.goodsId,@"goods_num":@([self.goods_num integerValue]),@"equipment":@"ios",@"address_id":@"1",@"pay_way":@"1",@"back_type":self.options};
        }
        
    }else
    {
        NSString *goodsId = [self.shoppingCarGoodsId componentsJoinedByString:@","];
     //   NSLog(@"%@",goodsId);
        
        
        dict = @{@"cart_ids":goodsId,@"equipment":@"ios",@"address_id":@"1",@"pay_way":@"1"};
        
    }
    
  [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
      
      NSLog(@"%@",responseObject);
      
        NSDictionary *resultDict = responseObject[@"result"];
        
                NSString *resultMessage = resultDict[@"resultMessage"];
                NSString *codeStr = [NSString stringWithFormat:@"%@",resultDict[@"resultCode"]];
      
                if ([codeStr isEqualToString:@"0"])
                {
                    // 如果是购物车购买才会进入判断
                    if (self.shoppingCarGoodsId.count>0)
                    {
                        NSMutableArray *shopingCarOrderIdArr = [NSMutableArray array];
                        
                        [responseObject[@"list"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            NSString *shopCarOrderId = [NSString stringWithFormat:@"%@",obj[@"id"]];
                            
                            [shopingCarOrderIdArr addObject:shopCarOrderId];
                            
                        }];
                    
                        self.patmentVc.GoodsIdArray = shopingCarOrderIdArr;
                    }
                    
                    
                    [self.navigationController pushViewController:self.patmentVc animated:NO];
                    
                }else
                {
                   [JKAlert alertText:resultMessage];
        
                }

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
  
    
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
