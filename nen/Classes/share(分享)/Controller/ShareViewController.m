//
//  ShareViewController.m
//  nen
//
//  Created by nenios101 on 2017/3/1.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ShareViewController.h"
#import "MyLinkView.h"
#import "MyTwoDimensionalCode.h"
#import "ShareCollectionViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage+JKRImage.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import "UseHelpViewController.h"
#import "RegisterViewController.h"
#import "LoginAndRegisterViewController.h"


@interface ShareViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SDCycleScrollViewDelegate>
// 图片轮播器
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
// 我的瞬间分享
@property(nonatomic,strong) UIView *postShareView;
// 我的链接
@property(nonatomic,strong) MyLinkView *linkView;
// 我的二维码
@property(nonatomic,strong) MyTwoDimensionalCode *twoDimesnsionalView;

@property(nonatomic,weak) UIScrollView *scrollV;

// 图片轮播器数组
@property(nonatomic,strong) NSArray *shuffingMoldelArray;

// 文本内容
@property(nonatomic,strong) UITextView *contentTextView;
//
@property(nonatomic,strong) UIImagePickerController *imagePickerController;

// 选中的图片数组
@property(nonatomic,strong) NSMutableArray *imageArray;

@property(nonatomic,strong) UICollectionView  *collectionView;

@property(nonatomic,assign) CGFloat collectionW;

@property(nonatomic,strong) UIView *contrenView;

@property(nonatomic,strong) UIAlertController *alertController;
// 可输入的字的数量
@property(nonatomic,strong) UILabel *rightLabel;
// 底部的文字
@property(nonatomic,strong) UILabel *bottomLeftLabel;
// 底部的view
@property(nonatomic,strong) UIView *bottomView;
// 最底部的文字
@property(nonatomic,strong) UILabel *bottomTitle;
// 二维码
@property(nonatomic,copy) NSString *qrCode;
// 发帖并分享
@property(nonatomic,copy) NSString *shareUrl;
// 分享图片
@property(nonatomic,copy) NSString *imgUrl;

// 没有登录View
@property (nonatomic,strong) UIView *notLoginHeadView;
// 标记没有登录界面
@property (nonatomic,copy) NSString *flag;
// 有登录界面
@property (nonatomic,copy) NSString *flag1;


@property (nonatomic,strong) UIView *headView;



@property (nonatomic,strong) NSUserDefaults *defaluts;

@property (nonatomic,copy) NSString *recordStr;

@end

@implementation ShareViewController

static NSString *Id = @"cell";



#pragma mark 图片轮播器数组
- (NSArray *)shuffingMoldelArray{
    if (!_shuffingMoldelArray) {
        _shuffingMoldelArray = [NSArray array];
    }
    return _shuffingMoldelArray;
}

- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //[self shareNotLonginStateBackgroundView];
    
    UIScrollView *scrollV = [[UIScrollView alloc] init];
    self.scrollV = scrollV;
    scrollV.showsVerticalScrollIndicator = NO;
    scrollV.showsHorizontalScrollIndicator = NO;
    scrollV.bounces = NO;
    scrollV.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight + 20);
    
    
    scrollV.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self.view addSubview:scrollV];
    
    self.flag = @"0";
    
    self.flag1 = @"0";
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavBar];
    
    // 登录成功后调整高度
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareLink) name:@"shareMyTheLink" object:nil];

        _defaluts = [NSUserDefaults standardUserDefaults];
        self.recordStr = [_defaluts objectForKey:@"is_login"];
        
        if ([self.recordStr isEqualToString:@"1"])
        {
            self.notLoginHeadView.hidden = YES;
            self.scrollV.hidden = NO;
            
            // 轮播器加载图片
            [ShufflingFigureModel shufflingFigureLocation:@"6" Success:^(NSArray<ShufflingFigureModel *> *shufflingFigure) {
                
                self.shuffingMoldelArray = shufflingFigure;
                
                
                
                [self qrCodeData];
                
                
            } error:^{
                NSLog(@"失败");
            }];
            

            
            
        }else
        {
            self.scrollV.hidden = YES;
            self.notLoginHeadView.hidden = NO;
            
            if ([self.flag isEqualToString:@"0"])
            {
                [self shareNotLonginStateBackgroundView];
            }
            
        }
    
 
    
}


#pragma mark 没有登录时显示界面

- (void)shareNotLonginStateBackgroundView
{
      //  self.navigationController.navigationBarHidden = NO;
        //   [self.scrollView removeFromSuperview];
        //    [self.headView removeFromSuperview];
        
//        self.scrollV.hidden = YES;
//        self.headView.hidden = NO;
        UIView *headView = [[UIView alloc] init];
        self.notLoginHeadView = headView;
        headView.backgroundColor =[UIColor colorWithHexString:@"#F0F0F0"];
        
        // 没有登录时显示
        self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
        UIImageView *headImage = [[UIImageView alloc] init];
        headImage.frame = CGRectMake(0,64,ScreenWidth,150);
        headImage.image = [UIImage imageNamed:@"notLonginStateBackgroundImage"];
        [headView addSubview:headImage];
        
        UILabel *promptLabel = [[UILabel alloc] init];
        promptLabel.frame = CGRectMake(0,headImage.sh_bottom + 50,ScreenWidth,60);
        promptLabel.textAlignment = NSTextAlignmentCenter;
        promptLabel.font = [UIFont systemFontOfSize:13];
        promptLabel.numberOfLines = 0;
        promptLabel.textColor = [UIColor lightGrayColor];
        promptLabel.text = @"登录后，你可以把你喜欢的商品分享给其他人\n\n购买商品时候还有现金红包等你拿，赶快注册^ - ^";
        [headView addSubview:promptLabel];
        
        UIButton *registeredBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        registeredBtn.frame = CGRectMake(ScreenWidth *0.15,promptLabel.sh_bottom + 60,ScreenWidth *0.3,40);
        [registeredBtn setTitle:@"注册" forState:UIControlStateNormal];
        [registeredBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        registeredBtn.layer.borderWidth = 1.0f;
        registeredBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [registeredBtn addTarget:self action:@selector(sharePushRegosterdVc) forControlEvents:UIControlEventTouchUpInside];
        registeredBtn.layer.cornerRadius = 5;
        registeredBtn.clipsToBounds = YES;
        [headView addSubview:registeredBtn];
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.frame = CGRectMake(ScreenWidth *0.55,promptLabel.sh_bottom + 60,ScreenWidth *0.3,40);
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(sharePushLoginVc) forControlEvents:UIControlEventTouchUpInside];
        loginBtn.layer.borderWidth = 1.0f;
        loginBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        loginBtn.layer.cornerRadius = 5;
        loginBtn.clipsToBounds = YES;
        [headView addSubview:loginBtn];
        
        headView.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight);
        [self.view addSubview:headView];
    
     self.flag = @"1";
}

#pragma mark 跳转注册页面
- (void)sharePushRegosterdVc
{
    [self.navigationController pushViewController:[[RegisterViewController alloc] init] animated:YES];
    
}
#pragma mark 跳转登录页面
-(void)sharePushLoginVc
{
//    LoginAndRegisterViewController *loginVc = [[LoginAndRegisterViewController alloc] init];
//    loginVc.flag = @"2";
    [self.navigationController pushViewController:[LoginAndRegisterViewController sharedManager] animated:YES];
}

#pragma mark 设置导航栏
- (void)setNavBar
{
    
    self.recordStr = [_defaluts objectForKey:@"is_login"];
    
    if ([self.recordStr isEqualToString:@"1"])
    {
        self.navigationItem.title = @"爱心分享";
        
        [self.navigationController.navigationBar setTitleTextAttributes:
         @{NSFontAttributeName:[UIFont systemFontOfSize:KNavBarTittleFont],
           NSForegroundColorAttributeName:KNavBarTitleColor }];
        self.navigationController.navigationBar.barTintColor = KNavBarBarTintColor;
        
    }
    else
    {
        self.navigationItem.title = @"我";
        self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#F0F0F0"];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(pushAboutVC)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
        
    }
    
}

#pragma mark 跳转关于我们界面
- (void)pushAboutVC
{

    [self.navigationController  pushViewController:[[UseHelpViewController alloc] init] animated:YES];
    
}



#pragma mark 分享我的链接
- (void)shareLink
{
    [self linkShareClick];
}

#pragma mark ------------ 分享 --------------------
 
- (void)linkShareClick {
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatTimeLine)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        [self shareWebPageToPlatformType:platformType];
        
    }];
}


- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL;
    if (self.imgUrl.length >0)
    {
        thumbURL = self.imgUrl;
        
    }else
    {
        thumbURL = @"http://upload.neno2o.com/APP/imgs/applog.png";
    }
    
   // NSLog(@"%@",thumbURL);
    
    NSString *descrStr;
    
    if (self.contentTextView.text.length >0)
    {
        descrStr = self.contentTextView.text;
    }else
    {
        descrStr = @"";
    }
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"网一网·消费4.0,花钱就可以省钱!" descr:descrStr thumImage:thumbURL];
    //设置网页地址
    
    if (self.shareUrl.length > 0)
    {
        shareObject.webpageUrl = self.shareUrl;
    }else
    {
        
        shareObject.webpageUrl = self.qrCode;
    }
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                
                UMSocialLogInfo(@"response message is %@",resp.message);
                
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        [self alertWithError:error];
    }];
}


- (void)alertWithError:(NSError *)error {
    
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"分享成功"];
        
        self.contentTextView.text = nil;
         [self.collectionView reloadData];
        [self.imageArray removeAllObjects];
    }
    else{
        if (error) {
            result = [NSString stringWithFormat:@"取消分享"];
        }
        else{
            result = [NSString stringWithFormat:@"分享失败"];
            
            self.contentTextView.text = nil;
             [self.collectionView reloadData];
        }
        // result = [NSString stringWithFormat:@"分享失败"];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
}

#pragma mark 图片轮播器

- (void)pictureCarousel
{
    // 图片轮播器
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 150) delegate:self placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
    
    NSMutableArray *arrTemp = [NSMutableArray array];
    
    [self.shuffingMoldelArray enumerateObjectsUsingBlock:^(ShufflingFigureModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrTemp addObject:obj.img_url];
    }];
    
    _cycleScrollView.imageURLStringsGroup = arrTemp;
    
    
    [self.scrollV addSubview:_cycleScrollView];
}


#pragma mark -----------------------分享模块-------------------------
- (void)sharePost
{

    UIView *postShareView = [[UIView alloc] init];
    self.postShareView = postShareView;
    postShareView.frame = CGRectMake(0,_cycleScrollView.sh_bottom,ScreenWidth,300);
    postShareView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    UILabel *leftTitle = [[UILabel alloc] init];
    leftTitle.frame = CGRectMake(10,25,60,25);
    leftTitle.text = @"我的瞬间";
    leftTitle.textColor = [UIColor blackColor];
    leftTitle.font = [UIFont systemFontOfSize:13];
    [postShareView addSubview:leftTitle];
    
    UIButton *pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pictureBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [pictureBtn setBackgroundImage:[UIImage imageNamed:@"xiangce"] forState:UIControlStateNormal];
    [pictureBtn addTarget:self action:@selector(pictureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    pictureBtn.frame = CGRectMake(leftTitle.sh_right + 15,20,30,30);
    [postShareView addSubview:pictureBtn];
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cameraBtn addTarget:self action:@selector(cameraBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [cameraBtn setBackgroundImage:[UIImage imageNamed:@"fenxiangxiangji"] forState:UIControlStateNormal];
    cameraBtn.frame = CGRectMake(pictureBtn.sh_right + 15,20,30,30);
    [postShareView addSubview:cameraBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"发帖并分享" forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(ScreenWidth - 100,20,80,30);
    [shareBtn setBackgroundColor:[UIColor orangeColor]];
    [shareBtn addTarget:self action:@selector(postAndShare) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.layer.cornerRadius = 5;
    shareBtn.clipsToBounds = YES;
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [postShareView addSubview:shareBtn];
    
    
    UIView *contrenView = [[UIView alloc] init];
    self.contrenView = contrenView;
    contrenView.frame = CGRectMake(10,shareBtn.sh_bottom +20 ,ScreenWidth - 20,200);
    contrenView.layer.borderWidth = 1.0f;
    contrenView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [postShareView addSubview:contrenView];
    
    
    
    UITextView *textView = [[UITextView alloc] init];
    self.contentTextView = textView;;
    textView.frame = CGRectMake(5,10,contrenView.sh_width - 10,100);
    textView.font = [UIFont systemFontOfSize:15];
    textView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    textView.delegate = self;
    
    
    [contrenView addSubview:textView];
    
    CGFloat W = (contrenView.sh_width - 30) / 3;
    self.collectionW = W;
    
    //创建一个layout布局类
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(W,W);
    flowLayout.minimumLineSpacing = 5;
    //创建collectionView 通过一个布局策略layout来创建
    UICollectionView *colletionView = [[UICollectionView alloc] initWithFrame:CGRectMake(5,textView.sh_bottom,contrenView.sh_width - 10, 1 * W) collectionViewLayout:flowLayout];
    self.collectionView = colletionView;
    //隐藏水平滚动条
    colletionView.showsHorizontalScrollIndicator = NO;
    //取消弹簧效果
    colletionView.bounces = NO;
    //代理设置
    colletionView.dataSource = self;
    colletionView.delegate = self;
    colletionView.scrollEnabled = NO;
    colletionView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    //注册item类型
    
    [colletionView registerClass:[ShareCollectionViewCell class] forCellWithReuseIdentifier:Id];
    
    
    UILabel *rightLabel = [[UILabel alloc] init];
    self.rightLabel = rightLabel;
    rightLabel.frame= CGRectMake(ScreenWidth - 160,contrenView.sh_bottom + 20,150,20);
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.font = [UIFont systemFontOfSize:12];
    rightLabel.text = @"还可以输入200个字";
    rightLabel.textColor = [UIColor orangeColor];
    [postShareView addSubview:rightLabel];
    
    
    UILabel *bottomLeftLabel = [[UILabel alloc] init];
    self.bottomLeftLabel = bottomLeftLabel;
    bottomLeftLabel.frame= CGRectMake(10,rightLabel.sh_bottom,ScreenWidth *0.8,20);
    bottomLeftLabel.font = [UIFont systemFontOfSize:13];
    bottomLeftLabel.text = @"分享您的瞬间, 去招聘您的公司成员吧!";
    bottomLeftLabel.textColor = [UIColor lightGrayColor];
    [postShareView addSubview:bottomLeftLabel];
    
    
    UIView *bottomView = [[UIView alloc] init];
    self.bottomView = bottomView;
    bottomView.frame = CGRectMake(10,bottomLeftLabel.sh_bottom + 5,ScreenWidth - 20, 2);
    bottomView.backgroundColor = [UIColor lightGrayColor];
    [postShareView addSubview:bottomView];
    
    
    UILabel *bottomTitle = [[UILabel alloc] init];
    self.bottomTitle = bottomTitle;
    bottomTitle.frame= CGRectMake(10,bottomLeftLabel.sh_bottom + 10,ScreenWidth - 20,70);
    bottomTitle.font = [UIFont systemFontOfSize:13];
    bottomTitle.text = @"     当有人链接你的分享,他就成为您公司的部门经理: 其他人员链接您的部门经理, 其他人员就成为您公司的支援啦,部门经理与职员产生的销售服务等业绩,您都有收益。";
    bottomTitle.textColor = [UIColor lightGrayColor];
    bottomTitle.numberOfLines = 0;
    bottomTitle.lineBreakMode = NSLineBreakByCharWrapping;
    [postShareView addSubview:bottomTitle];
    
    [contrenView addSubview:colletionView];
    contrenView.sh_height = colletionView.sh_bottom;
    postShareView.sh_height = bottomTitle.sh_bottom;
    [self.scrollV addSubview:postShareView];
    
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


#pragma mark 发帖并分享
- (void)postAndShare
{
    if (self.contentTextView.text.length == 0)
    {
        [JKAlert alertText:@"请输入分享内容"];
        return;
    }
    
    if (self.imageArray.count == 0)
    {
        [JKAlert alertText:@"请添加分享图片"];
         return;
    }
     __weak typeof(self) weakself = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
        
        NSString *completeStr = [NSString stringEncryptedAddress:@"/mine/topicshare"];

        NSDictionary *dict = @{@"content":self.contentTextView.text,@"img_total":[NSString stringWithFormat:@"%d",self.imageArray.count]};
    
        
        [manager POST:completeStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (int i = 0;i < weakself.imageArray.count; i++)
            {
                UIImage *image = weakself.imageArray[i];
                NSData *Data = UIImagePNGRepresentation(image);
                
                [formData appendPartWithFileData:Data name:[NSString stringWithFormat:@"img%d",i + 1] fileName:[NSString stringWithFormat:@"share%d.jpg",i+1] mimeType:@"image/jpg"];
            }
            
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            
           // NSLog(@"%@",responseObject);
            
            self.shareUrl = responseObject[@"obj"][@"share_url"];
            self.imgUrl = responseObject[@"obj"][@"imgUrl"];
            
            [weakself.imageArray  removeAllObjects];
            weakself.rightLabel.text = @"还可以输入200个字";
            
            [weakself linkShareClick];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
        }];

   
}

#pragma mark  相机 相册 选中图片后调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
   UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    image = [image jkr_compressWithWidth:200];
    
    [self.imageArray addObject:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.collectionView reloadData];
    
    CGFloat collectionViewHeight = 0.0;
    
    if (self.imageArray.count <= 3)
    {
      collectionViewHeight =  1 * self.collectionW;
    }
    
    if (self.imageArray.count > 3 && self.imageArray.count <= 6)
    {
        collectionViewHeight = 2 * self.collectionW;
    }
    if (self.imageArray.count > 6)
    {
        collectionViewHeight = 3 * self.collectionW;
    }
    
    self.collectionView.sh_height = collectionViewHeight;
    self.contrenView.sh_height = self.collectionView.sh_bottom;
    self.postShareView.sh_height = self.collectionView.sh_bottom +170;
    self.linkView.sh_y = self.postShareView.sh_bottom + 5;
    self.twoDimesnsionalView.sh_y = self.linkView.sh_bottom + 5;
    self.scrollV.contentSize = CGSizeMake(0,self.twoDimesnsionalView.sh_bottom + 5);
    self.rightLabel.sh_y = self.contrenView.sh_bottom + 10;
    self.bottomLeftLabel.sh_y = self.rightLabel.sh_bottom;
    self.bottomView.sh_y = self.bottomLeftLabel.sh_bottom + 5;
    self.bottomTitle.sh_y = self.bottomView.sh_bottom + 10;
    
}





#pragma mark --------------------------collectionViewDelegate---------------------------

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Id forIndexPath:indexPath];

    cell.backgroundColor = [UIColor seaGreen];
    cell.image = self.imageArray[indexPath.row];
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    __weak typeof(self) weakself = self;
    // 标题
    self.alertController = [UIAlertController alertControllerWithTitle:@"是否删除图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    // 暂不
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
       // NSLog(@"暂不");
        
    }];
    [self.alertController addAction:cancelAction];
    [cancelAction setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    // 删除
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakself.imageArray removeObjectAtIndex:indexPath.row];
        [weakself.collectionView reloadData];
        
        
        CGFloat collectionViewHeight = 0.0;
        
        if (weakself.imageArray.count <= 3)
        {
            collectionViewHeight =  1 * weakself.collectionW;
        }
        
        if (weakself.imageArray.count > 3 && weakself.imageArray.count <= 6)
        {
            collectionViewHeight = 2 * weakself.collectionW;
        }
        
        if (weakself.imageArray.count > 6)
        {
            collectionViewHeight = 3 * weakself.collectionW;
        }

        weakself.collectionView.sh_height = collectionViewHeight;
        weakself.contrenView.sh_height = weakself.collectionView.sh_bottom;
        weakself.postShareView.sh_height = weakself.collectionView.sh_bottom +170;
        weakself.linkView.sh_y = weakself.postShareView.sh_bottom + 5;
        weakself.twoDimesnsionalView.sh_y = weakself.linkView.sh_bottom + 5;
        weakself.scrollV.contentSize = CGSizeMake(0,weakself.twoDimesnsionalView.sh_bottom + 5);
        weakself.rightLabel.sh_y = weakself.contrenView.sh_bottom + 10;
        weakself.bottomLeftLabel.sh_y = weakself.rightLabel.sh_bottom;
        weakself.bottomView.sh_y = weakself.bottomLeftLabel.sh_bottom + 5;
        weakself.bottomTitle.sh_y = weakself.bottomView.sh_bottom + 10;
        
        
    }];
    
    [defaultAction setValue:[UIColor orangeColor] forKey:@"_titleTextColor"];
    
    [self.alertController addAction:defaultAction];
    
    [self presentViewController:self.alertController animated:NO completion:nil];
    
}


#pragma mark ------------------底部模块--------------------


#pragma mark 我的链接
- (void)MyLink
{
    _linkView = [[[NSBundle mainBundle] loadNibNamed:@"MyLinkView" owner:nil options:nil] lastObject];
    _linkView.sh_x = 0;
    _linkView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    _linkView.myTheLink = self.qrCode;
    _linkView.sh_y = self.postShareView.sh_bottom + 5;
    _linkView.sh_width = ScreenWidth;
    _linkView.sh_height = 110;
    
    [self.scrollV addSubview:_linkView];
}

#pragma mark 二维码
- (void)MyTwoDimensionalCodeView
{
    _twoDimesnsionalView = [[[NSBundle mainBundle] loadNibNamed:@"MyTwoDimensionalCode" owner:nil options:nil] lastObject];
    _twoDimesnsionalView.sh_x = 0;
    _twoDimesnsionalView.backgroundColor = [UIColor colorWithHexString:@"#e0e0e0"];
    _twoDimesnsionalView.myTheLink = self.qrCode;
    _twoDimesnsionalView.sh_y = _linkView.sh_bottom + 5;
    _twoDimesnsionalView.sh_width = ScreenWidth;
    _twoDimesnsionalView.sh_height = 85;
    
    [self.scrollV addSubview:_twoDimesnsionalView];
    
    self.scrollV.contentSize = CGSizeMake(0,_twoDimesnsionalView.sh_bottom + 20);

}

#pragma mark 二维码 请求数据
- (void)qrCodeData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/site/getqrcode"];
    
    [manager POST:completeStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        // NSLog(@"%@",responseObject);
        
        
        NSString *coder = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
        
        if ([coder isEqualToString:@"0"])
        {
            self.qrCode = responseObject[@"obj"][@"qr_code"];
         
            if ([self.flag1 isEqualToString:@"0"])
            {
                [self religiousData];
                
                [self pictureCarousel];
                
                [self sharePost];
                
                [self MyLink];
                
                [self MyTwoDimensionalCodeView];
                
                self.flag1 = @"1";
            }
            
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

#pragma mark 获取宗教发布活动分享 请求数据
- (void)religiousData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSString *completeStr = [NSString stringEncryptedAddress:@"/faith/shareurl"];
    
    [manager POST:completeStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}





#pragma mark --------------------------textViewDetegate-------------------------

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.contentTextView resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    //实时显示字数
    self.rightLabel.text = [NSString stringWithFormat:@"还可以输入%u个字",200 - textView.text.length];
    
    //字数限制操作
    if (textView.text.length >= 200) {
        
        textView.text = [textView.text substringToIndex:300];
        self.rightLabel.text = [NSString stringWithFormat:@"还可以输入%u个字",200 - textView.text.length];
        
    }
    
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.contentTextView resignFirstResponder];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
