//
//  AddressManagementController.m
//  nen
//
//  Created by nenios101 on 2017/3/28.
//  Copyright © 2017年 nen. All rights reserved.
//收货地址管理

#import "AddressManagementController.h"
#import "ShippingAddressCell.h"
#import "EditAddressManagementController.h"
#import "AddresslistModel.h"
@interface AddressManagementController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tabelView;

@property(nonatomic,strong) NSMutableArray<AddresslistModel *> *addressModelArray;

@property(nonatomic,copy) NSString * popTagStr;
@end

@implementation AddressManagementController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
   
       [AddresslistModel addressArrayModelNum:@"0" success:^(NSMutableArray<AddresslistModel *> *addressModelArray) {
        self.addressModelArray = addressModelArray;
        UITableView *tabVc = [[UITableView alloc] init];
        tabVc.delegate = self;
        tabVc.dataSource = self;
        tabVc.rowHeight = 110;
        tabVc.separatorStyle = UITableViewCellSeparatorStyleNone;
        tabVc.frame = CGRectMake(0,64,ScreenWidth, ScreenHeight - 64);
           tabVc.scrollEnabled = NO;
        self.tabelView = tabVc;
        [self.view addSubview:tabVc];
        
        
        
        [self addNeslocation];
        
        [self.tabelView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
  
        
        
    } error:^{
       // NSLog(@"失败");
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBtnClick:) name:@"delete" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedBtnClick:) name:@"selected" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editBtnClick:) name:@"edit" object:nil];
}

#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"收货地址管理";
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


#pragma mark 编辑按钮
- (void)editBtnClick:(NSNotification *)notification
{
    NSString *editIdStr = notification.userInfo[@"editId"];
    NSString *nameStr = notification.userInfo[@"name"];
    NSString *phoneStr = notification.userInfo[@"phone"];
    NSString *addressStr = notification.userInfo[@"address"];
    NSString *postcodeStr = notification.userInfo[@"postcode"];
    
    NSString *sexStr = @"1";
    
    EditAddressManagementController *editVc = [[EditAddressManagementController alloc] init];
    
    editVc.editId = editIdStr;
    editVc.postcode = postcodeStr;
    editVc.relation_name = nameStr;
    editVc.address = addressStr;
    editVc.sex = sexStr;
    editVc.phoneNumber = phoneStr;
    
    [self.navigationController pushViewController:editVc animated:YES];
    

}




#pragma mark 默认选中按钮
- (void)selectedBtnClick:(NSNotification *)notification
{
     NSString *selectedStr = notification.userInfo[@"selected"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/mine/setdefault"];
    NSInteger selected_id = [selectedStr integerValue];

    NSDictionary *dict = @{@"address_id":@(selected_id)};
    
    [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        //NSLog(@"成功");
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        // NSLog(@"%@",error);
    }];

}



#pragma mark 删除按钮

- (void)deleteBtnClick:(NSNotification *)notification
{
    NSString *deleteStr = notification.userInfo[@"delete"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/mine/deleteaddress"];
    NSInteger delete_id = [deleteStr integerValue];
    
    NSDictionary *dict = @{@"address_id":@(delete_id)};
    
    [manager POST:completeStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该地址?删除后无法恢复!" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteCompletion];
            
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
      //  NSLog(@"%@",error);
    }];
    
}

#pragma mark 点击删除按钮后调用
- (void)deleteCompletion
{
    
    [AddresslistModel addressArrayModelNum:@"0" success:^(NSMutableArray<AddresslistModel *> *addressModelArray) {
        self.addressModelArray = addressModelArray;
        [self.tabelView reloadData];
        
    } error:^{
        
    }];
    

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return self.addressModelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    NSString *Id = @"cell";
    
    ShippingAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    AddresslistModel *addresModel = self.addressModelArray[indexPath.row];
    
    cell.managerVC = self;
    
    cell.model = addresModel;
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShippingAddressCell" owner:nil options:nil] lastObject];
    }
    
    return cell;
    
}



#pragma mark 新建按钮
- (void)addNeslocation
{
    UIButton *nesBtn = [[UIButton alloc] init];
    nesBtn.frame = CGRectMake(ScreenWidth *0.1,ScreenHeight - 45,ScreenWidth *0.8,30);
    [nesBtn setTitle:@"十 新建地址" forState:UIControlStateNormal];
    [nesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nesBtn setBackgroundColor:[UIColor orangeColor]];
    [nesBtn addTarget:self action:@selector(addNewBtn) forControlEvents:UIControlEventTouchUpInside];
    nesBtn.layer.cornerRadius = 5;
    nesBtn.clipsToBounds = YES;
    
    [self.view addSubview:nesBtn];
}

- (void)addNewBtn
{
     self.popTagStr = @"1";
     // 最多设置4个地址
    if (self.addressModelArray.count < 4)
    {
        [self.navigationController pushViewController:[[EditAddressManagementController alloc] init] animated:YES];
        
    }else
    {
        UILabel *effectLabel = [[UILabel alloc] init];
        effectLabel.text = @"最多设置4个地址";
        effectLabel.frame = CGRectMake(ScreenWidth *0.4,ScreenHeight *0.8,120,30);
        effectLabel.layer.borderColor = [[UIColor grayColor]CGColor];
        effectLabel.font = [UIFont systemFontOfSize:11];
        effectLabel.layer.borderWidth = 0.5f;
        effectLabel.backgroundColor = [UIColor colorWithRed:248 green:248 blue:255 alpha:0.8];
        effectLabel.layer.masksToBounds = YES;
        [self.view addSubview:effectLabel];
        
        [UIView animateWithDuration:2 animations:^{
            effectLabel.alpha = 1;
        } completion:^(BOOL finished) {
            if (finished){
                [UIView animateWithDuration:2 animations:^{
                    effectLabel.alpha = 0;
                } completion:^(BOOL finished) {
                    
                    [effectLabel removeFromSuperview];
                }];
              
            }
            
        }];

}

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popVc:) name:@"popVc" object:nil];
    
}

#pragma mark 点击编辑后返回设置tableView的y值
-(void)popVc:(NSNotification *)notification
{
    self.tabelView.sh_y = 0;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self.tabelView reloadData];
    
    [AddresslistModel addressArrayModelNum:@"0" success:^(NSMutableArray<AddresslistModel *> *addressModelArray) {
        self.addressModelArray = addressModelArray;
        
       // NSLog(@"viewDidAppear%d",self.addressModelArray.count);
        
        // 判断返回tableView的高度
        if ([self.popTagStr isEqualToString:@"1"])
        {
            // 调用  点击删除按钮后调用
            [self deleteCompletion];
            self.tabelView.sh_y = 0;
            
        }
        
        [self.tabelView reloadData];
        
    } error:^{
        
    }];
    
    
    

}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

