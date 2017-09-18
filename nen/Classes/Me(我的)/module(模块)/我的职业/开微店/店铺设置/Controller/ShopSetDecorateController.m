//
//  ShopSetDecorateController.m
//  nen
//
//  Created by nenios101 on 2017/3/10.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ShopSetDecorateController.h"
#import "ShopSetView.h"
#import "ShopSetNameModel.h"
#import "shopSetModel.h"
#import "ShopSetCell.h"
#import "SetTheControllerViewController.h"
#import "UIImage+JKRImage.h"


@interface ShopSetDecorateController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

// 最外来层
@property (nonatomic,strong) NSArray *dataGroupArray;

@property(nonatomic,copy) NSString *titleStr;

// 编辑后的 组
@property(nonatomic,assign) NSInteger group;
// 编辑后的 行
@property(nonatomic,assign) NSInteger row;

// 店铺标志
@property(nonatomic,strong) UIImage *rightImage;

// 店铺名称
@property(nonatomic,copy) NSString *shopName;
// 发货地址
@property(nonatomic,copy) NSString *hairCargo;
// 退货地址
@property(nonatomic,copy) NSString *outCargo;
// 客服电话
@property(nonatomic,copy) NSString *customerServicePhone;

// 图片的存储的地址
@property(nonatomic,copy) NSString *imagePaths;

// 店铺的详情数据
@property(nonatomic,strong) NSMutableDictionary *shopDict;

// 即将显示时调整tableView 的高度

@property(nonatomic,copy) NSString *flag;

// 店铺介绍
@property(nonatomic,copy) NSString *introduce;

@end

@implementation ShopSetDecorateController

- (NSMutableDictionary *)shopDict
{
    if (!_shopDict) {
        
        _shopDict = [NSMutableDictionary dictionary];
    }
    return _shopDict;
}

// 数组懒加载
- (NSArray*)dataGroupArray
{
    if (!_dataGroupArray)
    {
        _dataGroupArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"shopSet" ofType:@"plist"]];
        
        //1. 定义可变数组
        NSMutableArray *nmArray = [NSMutableArray array];
        
        //2. 遍历字典数组
        for (NSDictionary *dict in _dataGroupArray) {
            //3. 字典转模型
            shopSetModel *setGroup = [shopSetModel shopSetGroupWithDict:dict];
            
            //4. 添加到可变数组中
            [nmArray addObject:setGroup];
        }
        //5. 将模型数组赋值给字典数组
        _dataGroupArray = nmArray;
        
    }
    return _dataGroupArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBar];
    UIButton *rightButton = [[UIButton alloc]init];
    rightButton.frame = CGRectMake(0, 0, 30, 25);
    [rightButton addTarget:self action:@selector(SetFinishAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
    UIBarButtonItem *rightBarButtonItems = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    nagetiveSpacer.width = -12;//这个值可以根据自己需要自己调整
    self.navigationItem.rightBarButtonItems = @[nagetiveSpacer, rightBarButtonItems];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adjustYClick:) name:@"adjustY" object:nil];
    
    if ([self.flag isEqualToString:@"1"])
    {
        self.tableView.sh_y = 0;
    }
    
}

#pragma 编辑完成后翻回调整tableView的Y值
- (void)adjustYClick:(NSNotification *)notifcation
{
    self.flag = notifcation.userInfo[@"flag"];
    
}


// 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 初始化组数 不让 默认图片 和文字 在cell中重复覆盖
    self.group = 10000;
    self.row = 10000;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self loadData];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setContentLabel:) name:@"contentLabel" object:nil];
}



// 添加tableView
- (void)addTabelView
{
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView =tableView;
    tableView.frame = CGRectMake(0,64,ScreenWidth,ScreenHeight);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0,0, ScreenWidth,40);
    UILabel *headTitle = [[UILabel alloc] init];
    headTitle.text = @"店铺设置";
    headTitle.font = [UIFont systemFontOfSize:13];
    headTitle.frame = CGRectMake(10,5,100,30);
    [headView addSubview:headTitle];
    
    self.tableView.backgroundColor =[UIColor colorWithHexString:@"#F0F0F0"];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = headView;
    self.tableView.scrollEnabled = NO;
    
}

// 获取店铺数据数据
- (void)loadData
{
    __weak typeof(self) weakself = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/shopmanage/index"];
    
    [manager GET:completeStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
      //  NSLog(@"%@",responseObject);
        
        NSString *shopLogoStr = responseObject[@"obj"][@"shop_logo"];
        NSString *shopNameStr = responseObject[@"obj"][@"shop_name"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *hairCargoStr = [defaults objectForKey:@"hairCargo"];
        NSString *outCargoStr = [defaults objectForKey:@"outCargo"];
        NSString *servicesStr = [defaults objectForKey:@"services"];
        
        if (hairCargoStr.length == 0)
        {
            hairCargoStr = @" ";
        }
        
        if(outCargoStr.length == 0)
        {
            outCargoStr = @" ";
            
        }
        
        if(servicesStr.length == 0)
        {
            servicesStr = @" ";
            
        }
        if (shopLogoStr.length == 0)
        {
            shopLogoStr = @" ";
        }
        
        if (shopNameStr.length == 0)
        {
            shopNameStr = @" ";
        }
       
       NSMutableDictionary *dict = [NSMutableDictionary dictionary];
       
          [dict  setObject:hairCargoStr forKey:@"hair"];
          [dict  setObject:outCargoStr forKey:@"refund"];
          [dict  setObject:servicesStr forKey:@"services"];
          [dict setObject:shopLogoStr forKey:@"shop_logo"];
          [dict setObject:shopNameStr forKey:@"shop_name"];
        
        weakself.shopDict = dict;
        
        [self addTabelView];

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}

#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"店铺设置";
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
    
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    
    self.navigationController.navigationBar.barTintColor = KNavBarBarTintColor;
    
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 保存设置店铺

- (void)SetFinishAction
{
   // __weak typeof(self) weakself = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/shopmanage/shopupdate"];
    NSString *shopNameStr = self.shopName.length == 0 ? self.shopDict[@"shop_name"] : self.shopName;
    NSString *hairStr = self.hairCargo.length == 0 ? self.shopDict[@"hair"] : self.hairCargo;
    NSString *introduceStr = self.introduce == 0 ? @" " : self.introduce;
    
    NSDictionary *dict = @{@"shop_name":shopNameStr,@"address":hairStr,@"is_see":@"1",@"introduce":introduceStr};
    
    [manager POST:completeStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (self.rightImage != nil)
        {
            UIImage *image = self.rightImage;
            
            NSData *data = UIImagePNGRepresentation(image);
            
            //上传的参数(上传图片，以文件流的格式)
            
            [formData appendPartWithFileData:data
             
                                        name:@"img"
             
                                    fileName:@"gauge.png"
             
                                    mimeType:@"image/png"];
        }
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [JKAlert alertText:@"设置成功"];
        
        
        [self.navigationController popViewControllerAnimated:YES];
    
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    
    
}


#pragma mark 设置完成后传递内容
- (void)setContentLabel:(NSNotification *)notification
{
    
    
    NSString *groupStr = [NSString stringWithFormat:@"%@",notification.userInfo[@"group"]];
    self.group = [groupStr integerValue];
    
    NSString *rowStr = [NSString stringWithFormat:@"%@",notification.userInfo[@"row"]];
    self.row = [rowStr integerValue];
    
    NSString *contentStr = [NSString stringWithFormat:@"%@",notification.userInfo[@"title"]];
    
    if (self.group == 1 && self.row == 1)
    {
        self.introduce = contentStr;
    }else
    {
        self.titleStr = contentStr;
        
    }
    
    if (self.group == 1 && self.row == 0)
    {
        self.shopName = contentStr;
    }else if (self.group == 2 && self.row == 0)
    {
        self.hairCargo = contentStr;
    }else if (self.group == 2 && self.row == 1)
    {
        self.outCargo = contentStr;
    }else if (self.group == 3)
    {
        self.customerServicePhone = contentStr;
    }

    
    // 重新刷新tableView某一行
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.row inSection:self.group];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    
    
}

#pragma mark 选择相片
- (void)addAlertController
{
    __weak typeof(self) weakself = self;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakself pictureBtnClick];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [weakself cameraBtnClick];
        
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    self.flag = @"1";
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

#pragma mark 相册
- (void)pictureBtnClick
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    // picker.view.backgroundColor = [UIColor orangeColor];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark 相机
-(void)cameraBtnClick
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}


// 选中图片后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    image = [image jkr_compressWithWidth:200];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.rightImage = image;
//    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.row inSection:self.group];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    
//    NSString *paths = [path stringByAppendingString:@"/image.png"];
//    
//    [UIImagePNGRepresentation(image) writeToFile:paths atomically:YES];
//    
//   self.imagePaths = paths;
   
}


#pragma mark tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataGroupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    shopSetModel *setModel = self.dataGroupArray[section];
    return setModel.nameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *Id = @"cell";
    
    ShopSetCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    if (!cell) {
        cell = [[ShopSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    // 开始加载完毕后传值
    
    cell .accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.section = indexPath.section + 1;
    cell.line = indexPath.row + 1;
    shopSetModel *model = self.dataGroupArray[indexPath.section];
    ShopSetNameModel *nameModel = model.nameArray[indexPath.row];
    cell.mode = nameModel;
    cell.dict = self.shopDict;
   
    // 设置完毕后传值
    cell.row = self.row;
    cell.grops = self.group;
    cell.rightImage = self.rightImage;
    cell.titleContent = self.titleStr;
  
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }else
    {
        return 10;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        self.group = indexPath.section;
        self.row = indexPath.row;
        [self addAlertController];
        
    }else
    {
     
        SetTheControllerViewController *setVc =[[SetTheControllerViewController alloc] init];
        setVc.group = [NSString stringWithFormat:@"%d",indexPath.section];
        setVc.row = [NSString stringWithFormat:@"%d",indexPath.row];
        [self.navigationController pushViewController:setVc animated:YES];
    }
    
}


#pragma mark cell 分割线 两端封头 
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}
//cell 分割线 两端封头 实现这个两个方法 1
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
