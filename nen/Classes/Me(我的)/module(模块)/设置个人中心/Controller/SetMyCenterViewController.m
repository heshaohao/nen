//
//  SetMyCenterViewController.m
//  nen
//
//  Created by nenios101 on 2017/4/18.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "SetMyCenterViewController.h"
#import "SetModel.h"
#import "SetGroupModel.h"
#import "MyTheAccountViewController.h"
#import "UIImage+JKRImage.h"
#import "SetUserNameController.h"
#import "UMSocialWechatHandler.h"
#import <UMSocialCore/UMSocialCore.h>
#import "AddressManagementController.h"
#import "TheProblemOfFeedbackController.h"
#import "AboutUsController.h"
#import "LoginAndRegisterViewController.h"

#import "SHTabBarViewController.h"

// 环信
#import "EMError.h"
#import "AppDelegate+EaseMob.h"

@interface SetMyCenterViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong) NSArray *setArray;

@property(nonatomic,strong) UIImageView *iconImage;


@property(nonatomic,copy) NSString *userNameStr;

@property(nonatomic,strong) NSUserDefaults * defaults;

@end

@implementation SetMyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.bounces = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0,0,100,0);
    
    // 偏好设置
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    self.defaults = def;
    
    // 提醒设置头像文字
    UIView *headVew = [[UIView alloc] init];
    headVew.frame = CGRectMake(0,0,ScreenWidth,150);
    headVew.backgroundColor = [UIColor orangeColor];
    UILabel *modifyLabel = [[UILabel alloc] init];
    modifyLabel.frame = CGRectMake(ScreenWidth *0.1,(headVew.sh_height *0.5) - 15,80,30);
    modifyLabel.text = @"修改头像>";
    modifyLabel.textColor = [UIColor whiteColor];
    modifyLabel.font = [UIFont systemFontOfSize:16];
    [headVew addSubview:modifyLabel];
    
    // 用户头像
    UIImageView *headImage = [[UIImageView alloc] init];
    self.iconImage = headImage;
    headImage.userInteractionEnabled = YES;
    headImage.frame = CGRectMake(ScreenWidth *0.4,(headVew.sh_height *0.5) - 30,80,80);
    [headImage sd_setImageWithURL:[NSURL URLWithString:self.iconStr]];
    headImage.layer.cornerRadius = 40;
    headImage.clipsToBounds = YES;
    [headVew addSubview:headImage];
    self.tableView.tableHeaderView = headVew;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIconImage)];
    [headImage addGestureRecognizer:tap];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.navigationItem.title = @"个人中心";
    UIButton *leftButton = [[UIButton alloc]init];
    leftButton.frame = CGRectMake(0, 0,KNavBarBackBtnW, KNavBarBackBtnH);
    [leftButton setBackgroundImage:KNavBarBackIconColor forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItems = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    nagetiveSpacer.width = KNavBarSpacing;   //这个值可以根据自己需要自己调整
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer,leftBarButtonItems];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:KNavBarTittleFont],
       
       NSForegroundColorAttributeName:KNavBarTitlesColor }];
    
    self.navigationController.navigationBar.barTintColor = KNavBarBarTintsColor;
    
    
    __weak typeof(self) weakself = self;
    
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userName:) name:@"setUserName" object:nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/mine/baseinfo"];
    
    [manager GET:completeStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
       //NSLog(@"%@",responseObject);
        weakself.userNameStr = [NSString stringWithFormat:@"%@",responseObject[@"obj"][@"nickname"]];
        
        [weakself.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       
        NSLog(@"%@",error);
    }];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)userName:(NSNotification *)notification
{
    NSString *contentStr = [NSString stringWithFormat:@"%@",notification.userInfo[@"title"]];
    self.userNameStr = contentStr;
    
    [self.tableView reloadData];
    
}


- (void)clickIconImage
{
    [self alertController];
    
}

- (void)alertController
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
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark 相册
- (void)pictureBtnClick
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.view.backgroundColor = [UIColor orangeColor];
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
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    image = [image jkr_compressWithWidth:200];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    self.iconImage.image = image;
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/mine/setheadimg"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        UIImage *iconImage = image;
        NSData *Data = UIImagePNGRepresentation(iconImage);
        
        [formData appendPartWithFileData:Data name:@"head_img" fileName:@"S70609-141910.jpg" mimeType:@"image/png"];
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
      //  NSLog(@"%@",responseObject);
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}

- (NSArray *)setArray{
    
    //1.判断是否为nil
    if (_setArray == nil) {
        //2.加载数据
        _setArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"setMyCenten" ofType:@"plist"]];
        
        //1. 定义可变数组
        NSMutableArray *nmArray = [NSMutableArray array];
        
        //2. 遍历字典数组
        for (NSDictionary *dict in _setArray) {
            //3. 字典转模型
            SetGroupModel *setGroup = [SetGroupModel carGroupWithDict:dict];
            
            //4. 添加到可变数组中
            [nmArray addObject:setGroup];
        }
        //5. 将模型数组赋值给字典数组
        _setArray = nmArray;
        
    }
    
    //3. 返回数据
    return _setArray;
    
}

#pragma mark 解绑微信

- (void)unbundlingWechat
{
    __weak typeof(self)weakself =self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否解除微信绑定!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    // 暂不
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       // NSLog(@"暂不");
    }];
    [alert addAction:cancelAction];
    [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    
    
    // 解除绑定
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"解除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/site/removewx"];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
        
        [manager POST:splitCompleteStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
         //  NSLog(@"%@",responseObject);
            NSString *codeStr = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
            NSString *resultMessage = responseObject[@"result"][@"resultMessage"];
            
            if ([codeStr isEqualToString:@"0"])
            {
                [JKAlert alertText:@"解除微信绑定成功"];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@"0" forKey:@"is_wx"];
                [defaults synchronize];
                
                
            }else
            {
                [JKAlert alertText:resultMessage];
            }
    
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            NSLog(@"%@",error);
            
            
        }];

     
        
        
    }];
    
    [defaultAction setValue:[UIColor orangeColor] forKey:@"_titleTextColor"];
    [alert addAction:defaultAction];
    
    
    [self presentViewController:alert animated:NO completion:nil];

    
    
}

#pragma mark 绑定微信
- (void)getAuthWithUserInfoFromWechat
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            
            UMSocialUserInfoResponse *resp = result;
            //
            //            //            // 授权信息
            //            NSLog(@"Wechat uid: %@", resp.uid);
            //            NSLog(@"Wechat openid: %@", resp.openid);
            //            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            //            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            //            NSLog(@"Wechat expiration: %@", resp.expiration);
            //
            //            // 用户信息
            //            NSLog(@"Wechat name: %@", resp.name);
            //            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            //            NSLog(@"Wechat gender: %@", resp.gender);
            //            //
            //              // 第三方平台SDK源数据
            //       NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            
            //
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
            //  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            NSString *loginCompleteStr = [NSString stringEncryptedAddress:@"/site/wxlogin"];
            
            NSInteger sex = 0;
            
            if ([resp.gender isEqualToString:@"m"])
            {
                sex = 1;
            }else if([resp.gender isEqualToString:@"2"])
            {
                sex = 2;
            }
            
            NSString * provinceStr = resp.originalResponse[@"province"];
            NSString * cityStr = resp.originalResponse[@"city"];
            NSString * countryStr = resp.originalResponse[@"country"];
            
            NSDictionary *dict = @{@"openid":resp.openid,@"nickname":resp.name,@"headimgurl":resp.iconurl,@"city":cityStr,@"country":countryStr,@"province":provinceStr,@"unionid":resp.uid,@"sex":@(sex)};

            
            NSLog(@"%@",dict);
            
            [manager POST:loginCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
                
              //  NSLog(@"返回参数%@",responseObject);
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@"1" forKey:@"is_wx"];
                
                [defaults synchronize];
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                NSLog(@"%@",error);
                
            }];
            
        }
    }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.setArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    SetGroupModel *setGroup = self.setArray[section];
    return setGroup.setArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * Id = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Id];
    }
    
    SetGroupModel *setGroup = self.setArray[indexPath.section];
    
   
    SetModel  *model = setGroup.setArray[indexPath.row];

    if (indexPath.section == 3 && indexPath.row == 2) {
        
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 2000);
    }
    
    cell.textLabel.text = model.titleLabel;
    cell.detailTextLabel.text = model.dextTitle;
  
    if (indexPath.section == 0 && indexPath.row == 2)
    {
        NSString * isWX = [self.defaults objectForKey:@"is_wx"];
        //  判断是否绑定微信号
        if ([isWX isEqualToString:@"0"])
        {
            cell.detailTextLabel.text = @"点击绑定微信";
        }else
        {
            cell.detailTextLabel.text = @"已绑定微信";
        }
    }
    
    // 已绑定手机号
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        cell.detailTextLabel.text = [self.defaults objectForKey:@"userNumber"];
    }
    
    // 修改用户名
    if (indexPath.section == 0 &&  indexPath.row == 0)
    {
        if (self.userNameStr.length == 0 || [self.userNameStr isEqualToString:@"<null>"])
        {
            cell.detailTextLabel.text = @"可以修改用户名";
        }else
        {
            cell.detailTextLabel.text = self.userNameStr;
        }
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];

    return cell;
}

#pragma mark tableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 1)
    {
        [self.navigationController pushViewController:[[MyTheAccountViewController alloc] init] animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 0)
    {
        SetUserNameController *setNameVc = [[SetUserNameController alloc] init];
        setNameVc.group = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
        setNameVc.row = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        
        [self.navigationController pushViewController:setNameVc animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 2)
    {
        NSString *is_wxStr = [self.defaults objectForKey:@"is_wx"];
        if ([is_wxStr isEqualToString:@"0"])
        {
            [self getAuthWithUserInfoFromWechat];
        }else
        {
            [self unbundlingWechat];
        }
    }else if(indexPath.section == 2 && indexPath.row == 0)
    {
        [self.navigationController pushViewController:[[AddressManagementController alloc] init] animated:YES];
    }else if (indexPath.section == 3 && indexPath.row == 0)
    {
        [self.navigationController pushViewController:[[TheProblemOfFeedbackController alloc] init] animated:YES];
        
    }else if (indexPath.section == 3 && indexPath.row == 1)
    {
        
     [self.navigationController pushViewController:[[AboutUsController alloc] init] animated:YES];
        
    }else if (indexPath.section == 3 && indexPath.row == 2)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要退出" preferredStyle:1];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self exitRootControll];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [cancel setValue:[UIColor orangeColor] forKey:@"_titleTextColor"];
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  
    if (section == 0) {
        return 0;
    }else
    {
       return 20;
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

#pragma mark 退出根本控制器
- (void)exitRootControll
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/site/logout"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
      //  NSLog(@"%@",responseObject);
        
        NSString *resultMessageStr = responseObject[@"result"][@"resultMessage"];
        NSString *resultCodeStr = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
        
        if ([resultCodeStr isEqualToString:@"0"])
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:@"0" forKey:@"is_login"];
            
            [defaults synchronize];
            
          [self.navigationController popViewControllerAnimated:NO];
            
            [self logoutAction];
          
            // 切换登录控制器
            // 切换底部控制器
//            SHTabBarViewController *tabVc = [SHTabBarViewController sharedManager];
//            [UIApplication sharedApplication].keyWindow.rootViewController = tabVc;
            
            
//
//            [self presentViewController:logVc animated:YES completion:^{
//                
//                
////                [self removeFromParentViewController];
//                
//            }];
            
        }else
        {
            [JKAlert alertText:resultMessageStr];
        }
        
        

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

#pragma mark 退出环信
- (void)logoutAction
{
 
    [self showHudInView:self.view hint:NSLocalizedString(@"setting.logoutOngoing", @"loging out...")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = [[EMClient sharedClient] logout:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideHud];
            if (error != nil) {
                [self showHint:error.errorDescription];
            }
            else{
                
                [[ApplyViewController shareController] clear];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
                
                SHTabBarViewController *tabVc = [SHTabBarViewController sharedManager];
                [UIApplication sharedApplication].keyWindow.rootViewController = tabVc;
                
            }
        });
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
