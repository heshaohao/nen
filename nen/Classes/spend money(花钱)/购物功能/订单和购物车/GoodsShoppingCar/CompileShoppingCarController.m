//
//  CompileShoppingCarController.m
//  GoodsShoppingCar
//
//  Created by nenios101 on 2017/3/16.
//  Copyright © 2017年 nen. All rights reserved.
//编辑页面



#import "CompileShoppingCarController.h"
#import "ShoppingCarModel.h"
#import "ShoppingCarCell.h"
#import "RecommendCell.h"
#import "EditShoppingCarCell.h"
#import "editShoppingCarModel.h"
@interface CompileShoppingCarController ()<UITableViewDelegate,UITableViewDataSource>
{
    // BOOL _isHiddenNavigationBarWhenDisappear;//记录当页面消失时是否需要隐藏系统导航
    BOOL _isHasTabBarController;//是否含有tabbar
    BOOL _isHasNavitationController;//是否含有导航
    
   
}
// 数据数组
// @property (strong,nonatomic)NSMutableArray *dataArray;
// 按钮选择数组
@property (strong,nonatomic)NSMutableArray *selectedArray;
@property (strong,nonatomic)UITableView *myTableView;
// 全选按钮
@property (strong,nonatomic)UIButton *allSellectedButton;
// 合算价格
@property (strong,nonatomic)UILabel *totlePriceLabel;

@property(nonatomic,strong) NSMutableArray *editShoppingCarModelArray;

@property(nonatomic,strong) NSMutableArray *editSelectGoodsIdArray;

@property(nonatomic,strong) NSMutableArray *Array;
@end

@implementation CompileShoppingCarController

#pragma mark - viewController life cicle
- (void)viewWillAppear:(BOOL)animated {
    
    
    //当进入购物车的时候判断是否有已选择的商品,有就清空
    //主要是提交订单后再返回到购物车,如果不清空,还会显示
//    if (self.selectedArray.count > 0) {
//        for (editShoppingCarModel *model in self.selectedArray) {
//            model.select = NO;//这个其实有点多余,提交订单后的数据源不会包含这些,保险起见,加上了
//        }
//        [self.selectedArray removeAllObjects];
//    }
    
    self.navigationItem.title = @"编辑购物车";
    
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
    
    
    
    //初始化显示状态
    _allSellectedButton.selected = NO;
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    _isHasTabBarController = self.tabBarController?YES:NO;
    _isHasNavitationController = self.navigationController?YES:NO;
    
    [editShoppingCarModel shoppingModelsucces:^(NSMutableArray<editShoppingCarModel *> *ShoppingCarArray) {
        self.editShoppingCarModelArray = ShoppingCarArray;
        [self changeView];
        
    } error:^{
      //  NSLog(@"失败");
    }];    
    // 判断是否有商品
    if (self.editShoppingCarModelArray.count > 0) {
        
        [self setupCartView];
    } else {
       //  [self setupCartEmptyView];
    }
    
    
}

//#pragma mark - 初始化数组
//- (NSMutableArray *)dataArray {
//    if (_dataArray == nil) {
//        _dataArray = [NSMutableArray arrayWithCapacity:0];
//    }
//    
//    return _dataArray;
//}

- (NSMutableArray *)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _selectedArray;
}

- (NSMutableArray *)editShoppingCarModelArray {
    if (_editShoppingCarModelArray == nil) {
        _editShoppingCarModelArray = [NSMutableArray array];
    }
    
    return _editShoppingCarModelArray;
}

- (NSMutableArray *)editSelectGoodsIdArray {
    if (_editSelectGoodsIdArray == nil) {
        _editSelectGoodsIdArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _editSelectGoodsIdArray;
}

#pragma mark -- 自定义底部视图
- (void)setupCustomBottomView {
    
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = LZColorFromRGB(245, 245, 245);
    backgroundView.tag = TAG_CartEmptyView + 1;
    [self.view addSubview:backgroundView];
    
    //当有tabBarController时,在tabBar的上面
    if (_isHasTabBarController == YES) {
        backgroundView.frame = CGRectMake(0, ScreenHeight - SHTabBarHeight, ScreenWidth, SHTabBarHeight);
    } else {
        backgroundView.frame = CGRectMake(0, ScreenHeight - 2*SHTabBarHeight, ScreenWidth, SHTabBarHeight);
    }
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, ScreenWidth, 1);
    lineView.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:lineView];
    
    //全选按钮
    UIButton *selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:16];
    selectAll.frame = CGRectMake(10, 5, 80, SHTabBarHeight - 10);
    [selectAll setTitle:@" 全选" forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:sh_Bottom_UnSelectButtonString] forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:sh_Bottom_SelectButtonString] forState:UIControlStateSelected];
    [selectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(editSelectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:selectAll];
    self.allSellectedButton = selectAll;
    
    //删除按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = BASECOLOR_RED;
    btn.frame = CGRectMake(ScreenWidth - 80, 0, 80, SHTabBarHeight);
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:btn];

}

#pragma mark -- 购物车为空时的默认视图

- (void)changeView {
    if (self.editShoppingCarModelArray.count > 0) {
        UIView *view = [self.view viewWithTag:TAG_CartEmptyView];
        if (view != nil) {
            [view removeFromSuperview];
        }
        
        [self setupCartView];
    } else {
        UIView *bottomView = [self.view viewWithTag:TAG_CartEmptyView + 1];
        [bottomView removeFromSuperview];
        
        [self.myTableView removeFromSuperview];
        self.myTableView = nil;
        //[self setupCartEmptyView];
    }
}
#pragma mark -- 购物车有商品时的视图
- (void)setupCartView {
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    
    table.rowHeight = sh_CartRowHeight;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = LZColorFromRGB(245, 246, 248);
    [self.view addSubview:table];
    self.myTableView = table;
    [self.view addSubview:table];
    
    //创建底部视图
    [self setupCustomBottomView];
    
    if (_isHasTabBarController) {
        table.frame = CGRectMake(0, SHNaigationBarHeight, ScreenWidth,ScreenHeight - 110);
    } else {
        table.frame = CGRectMake(0, SHNaigationBarHeight, ScreenWidth,ScreenHeight);
    }
    
  
}

#pragma mark --- UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.editShoppingCarModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZCartReusableCell"];
    if (cell == nil) {
        cell = [[EditShoppingCarCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LZCartReusableCell"];
    }
    editShoppingCarModel *model = self.editShoppingCarModelArray[indexPath.row];
    cell.model = model;
    
    [cell cellSelectedWithBlock:^(BOOL select) {
        
        model.select = select;
        if (select) {
            [self.selectedArray addObject:model];
            [self.editSelectGoodsIdArray addObject:model.id];
        } else {
            [self.selectedArray removeObject:model];
            [self.editSelectGoodsIdArray removeObject:model.id];
        }
        
        if (self.selectedArray.count == self.editShoppingCarModelArray.count) {
            _allSellectedButton.selected = YES;
        } else {
            _allSellectedButton.selected = NO;
        }
   }];
    
    
      return cell;
}

#pragma mark -- 页面按钮点击事件
#pragma mark --- 返回按钮点击事件
- (void)backButtonClick:(UIButton*)button {
    if (_isHasNavitationController == NO) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark --- 全选按钮点击事件
- (void)editSelectAllBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    //点击全选时,把之前已选择的全部删除
    for (editShoppingCarModel *model in self.selectedArray) {
        model.select = NO;
    }
    
    [self.selectedArray removeAllObjects];
    [self.editSelectGoodsIdArray removeAllObjects];
    
    if (button.selected) {
        
        for (editShoppingCarModel *model in self.editShoppingCarModelArray) {
            model.select = YES;
            [self.selectedArray addObject:model];
            [self.editSelectGoodsIdArray addObject:model.id];
         
        }
    }
    
    [self.myTableView reloadData];
}

 - (void)reloadTable
{
    
[self.myTableView reloadData];
    
}


#pragma mark --- 确认选择,删除按钮点击事件
- (void)editButtonClick:(UIButton*)button {
    if (self.selectedArray.count > 0)
    {
     //   NSLog(@"%@",self.editSelectGoodsIdArray);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    

                    if (self.selectedArray.count == self.editShoppingCarModelArray.count) {
                        
                      _allSellectedButton.selected = YES;
                     
                       // NSLog(@"%@",self.editShoppingCarModelArray);
                        
                        
                        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                        
                        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
                        
                        NSString *completeStr = [NSString stringEncryptedAddress:@"/order/deletegoodscart"];
                       // NSLog(@"%@",self.editSelectGoodsIdArray);
                        NSString *Str = [self.editSelectGoodsIdArray componentsJoinedByString:@","];
                        
                         NSDictionary *dict = @{@"id":Str};
                        
                     [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
                         
                        // NSLog(@"%@",self.editSelectGoodsIdArray);
                       
                        [self.editSelectGoodsIdArray removeAllObjects];
                         
                         
                        // [_shoppingCarModelArray removeAllObjects];
                         self.editShoppingCarModelArray = nil;
                         
                       //  NSLog(@"%@",self.editShoppingCarModelArray);
                         [self.myTableView reloadData];
                         self.allSellectedButton.selected = NO;
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            
                         //   NSLog(@"%@",error);
                       
                        }];
                       
                    } else {
                        // 根据选中数组 进行比较删除
                        NSMutableArray *array = [NSMutableArray array];
                        
                        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                        
                        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
                        
                        NSString *completeStr = [NSString stringEncryptedAddress:@"/order/deletegoodscart"];
                     //   NSLog(@"%@",self.editSelectGoodsIdArray);
                        NSString *Str = [self.editSelectGoodsIdArray componentsJoinedByString:@","];
                        
                        NSDictionary *dict = @{@"id":Str};
                        
                        [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
                      
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            
                          //  NSLog(@"%@",error);
                            
                        }];
                            // 遍历原始数组，每个元素 拿去选择数组里匹配
                            // 匹配不到证明是没选择的元素，加入到array里
                            [self.editShoppingCarModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                
                                if([self.selectedArray indexOfObject:obj]==NSNotFound)
                                {
                                    [array addObject:obj];
                                    
                                }
                                
                            }];
                            
                            self.editShoppingCarModelArray = array;
                        
                          //  NSLog(@"%@",self.editShoppingCarModelArray);
                        
                        
                    }
                    
                    if (self.editShoppingCarModelArray.count == 0) {
                        [self changeView];
                    }
        
        
                    //如果删除的时候数据紊乱,可延迟0.5s刷新一下
                     [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.3];
                    
                    [self.selectedArray removeAllObjects];
//
                    
                }];
        
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                
                [alert addAction:okAction];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];

    }
else {
      //  NSLog(@"你还没有选择任何商品");
    }
    
}



@end
