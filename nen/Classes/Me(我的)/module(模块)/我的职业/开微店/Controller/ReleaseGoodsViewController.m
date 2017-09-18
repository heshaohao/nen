//
//  ReleaseGoodsViewController.m
//  nen
//
//  Created by apple on 17/6/1.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ReleaseGoodsViewController.h"
#import "UIImage+JKRImage.h"
#import "CJCalendarViewController.h"
#import "GoodsClassPickerController.h"
#import "GoodsClassPickerView.h"

// 编辑
#import "ReleaseGoodsViewModel.h"


@interface ReleaseGoodsViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate,CalendarViewControllerDelegate>

@property(nonatomic,strong) UIScrollView *scrollViews;
@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) UIButton *uploadThumbnailBtn;
@property(nonatomic,strong) UIButton *uploadThumbnailImageView;
@property (nonatomic,copy) NSString *uploadThumbnailImageFlag;

@property(nonatomic,strong) UIButton *goodsDetailBtn;
@property(nonatomic,strong) UIButton *goodsDetailImageView1;
@property(nonatomic,strong) UIButton *goodsDetailImageView2;
@property(nonatomic,strong) UIButton *goodsDetailImageView3;
@property(nonatomic,strong) UIButton *goodsDetailImageView4;
// 商品缩咯图片
@property(nonatomic,strong) UIImage *uploadImage;

// 标记如果是 1 是商品缩咯图 2是商品详情图
@property(nonatomic,assign) NSInteger sign;

@property(nonatomic,strong) UIView *headView;

@property(nonatomic,strong) UIView *middView;

@property(nonatomic,strong) UIButton *invoiceHaveBtn;
@property(nonatomic,strong) UIButton *invoiceNoBtn;

@property(nonatomic,strong) UIButton *warrantyHaveBtn;
@property(nonatomic,strong) UIButton *warrantyNoBtn;
@property(nonatomic,assign) NSInteger flag;

@property(nonatomic,strong) NSMutableArray *imageArray;


// 商品名称
@property(nonatomic,strong) UITextField *goodsTextField;
// 商品描述
@property(nonatomic,strong) UITextView *goodsDescriptionTextView;
// 商品规格
@property(nonatomic,strong) UITextField *goodsSpecificationsTextField;
// 发货地址
@property(nonatomic,strong) UITextField *theDeliveryTextField;
// 商品库存
@property(nonatomic,strong) UITextField *stockTextField;
// 初始价格
@property(nonatomic,strong) UITextField *initialrPiceTextField;
// 销售价格
@property(nonatomic,strong) UITextField *salesPiceTextField;
// 运费价格
@property(nonatomic,strong) UITextField *freightTextField;
// 促销费用
@property(nonatomic,strong) UITextField *salesCostTextField;
// 促销开始
@property(nonatomic,strong) UITextField *starTimeTextField;
// 促销结束
@property(nonatomic,strong) UITextField *endTimeTextField;
// 营业收入
@property(nonatomic,strong) UIButton *operatingIncomebtn;
// 商品分类
@property(nonatomic,strong) UITextField *goodsClassTextField;

// 商品详情数据
@property (nonatomic,strong) ReleaseGoodsViewModel *goodsReleaseModelData;

// 发票标记
@property(nonatomic,copy) NSString* invoiceSing;
// 保修标记
@property(nonatomic,copy) NSString* warrantySing;

@property(nonatomic,copy) NSString *classeId;

// 自定义裁剪
@property (nonatomic,strong) CropImageViewController *cropImageVc;

@end

@implementation ReleaseGoodsViewController

- (NSMutableArray*)imageArray
{
    if (!_imageArray)
    {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.uploadThumbnailImageFlag = @"0";
//    if (self.goodsId.length > 0)
//    {
//        [ReleaseGoodsViewModel releaseGoodsViewModelGoodsId:self.goodsId success:^(ReleaseGoodsViewModel *goodsModel) {
//            
//            self.goodsReleaseModelData = goodsModel;
//            
//            [self addScrollView];
//            [self addBottomView];
//            
//            [self addScrollHeadView];
//            [self addScrollMiddleView];
//            [self addScrollBottomView];
//            
//        } error:^{
//            NSLog(@"失败");
//        }];
//        
//    }else
//    {
    
        [self addScrollView];
        [self addBottomView];
        
        [self addScrollHeadView];
        [self addScrollMiddleView];
        [self addScrollBottomView];

    //}
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelCalendarCilck) name:@"cancelCalendar" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodsClassificationClick:) name:@"goodsClassification" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPhotoClick:) name:@"getPhoto" object:nil];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavBar];
    
}
#pragma mark 设置导航栏
- (void)setNavBar
{
//    if (self.goodsId.length > 0)
//    {
//        self.navigationItem.title = @"编辑商品";
//    }else
//    {
        self.navigationItem.title = @"发布商品";
        
  //  }
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



#pragma mark 添加头部
- (void)addScrollHeadView
{
    UIView *headView = [[UIView alloc] init];
    self.headView = headView;
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *goodsName = [[UILabel alloc] init];
    goodsName.frame = CGRectMake(10,10,ScreenWidth *0.2,30);
    goodsName.font = [UIFont systemFontOfSize:13];
    
    goodsName.text = @"商品名称:";
        

    [headView addSubview:goodsName];
    
    UITextField *goodsTextField = [[UITextField alloc] init];
    self.goodsTextField = goodsTextField;
    goodsTextField.delegate = self;
    goodsTextField.font = [UIFont systemFontOfSize:13];
    goodsTextField.frame = CGRectMake(goodsName.sh_right,10,ScreenWidth *0.75,30);
   
//    if (self.goodsReleaseModelData.goods_name.length > 0)
//    {
//        goodsTextField.text = self.goodsReleaseModelData.goods_name;
//    }else
//    {
         goodsTextField.placeholder = @"请输入商品名称";
   // }
    goodsTextField.textColor = [UIColor lightGrayColor];
    goodsTextField.layer.borderWidth = 1.0f;
    goodsTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [headView addSubview:goodsTextField];
    
    UILabel *goodstThumbnail = [[UILabel alloc] init];
    goodstThumbnail.frame = CGRectMake(10,goodsName.sh_bottom + 10,80,30);
    goodstThumbnail.font = [UIFont systemFontOfSize:13];
    goodstThumbnail.text = @"商品缩略图:";
    [headView addSubview:goodstThumbnail];
    
    UILabel *goodstUploadThumbnail = [[UILabel alloc] init];
    goodstUploadThumbnail.frame = CGRectMake(goodstThumbnail.sh_right,goodsName.sh_bottom + 10,ScreenWidth *0.5,30);
    goodstUploadThumbnail.font = [UIFont systemFontOfSize:13];
    goodstUploadThumbnail.text = @"请上传1张商品缩略图(1:1)";
    goodstUploadThumbnail.textColor = [UIColor lightGrayColor];
    [headView addSubview:goodstUploadThumbnail];
    
    UIButton *uploadThumbnailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.uploadThumbnailBtn = uploadThumbnailBtn;
    uploadThumbnailBtn.frame = CGRectMake(10,goodstThumbnail.sh_bottom + 10, 40, 40);
    [uploadThumbnailBtn setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [uploadThumbnailBtn addTarget:self action:@selector(ThumbnailBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:uploadThumbnailBtn];
    
    UIButton *uploadThumbnailImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.uploadThumbnailImageView = uploadThumbnailImageView;
    uploadThumbnailImageView.tag = 10;
    [uploadThumbnailImageView addTarget:self action:@selector(editorImage:) forControlEvents:UIControlEventTouchDown];
    uploadThumbnailImageView.frame = CGRectMake(uploadThumbnailBtn.sh_right + 10, uploadThumbnailBtn.sh_y,40,40);
    [headView addSubview:uploadThumbnailImageView];
    
    UILabel *uploadLabelOne = [[UILabel alloc] init];
    uploadLabelOne.frame = CGRectMake(10,uploadThumbnailBtn.sh_bottom,80,30);
    uploadLabelOne.font = [UIFont systemFontOfSize:13];
    uploadLabelOne.text = @"上传图片";
    uploadLabelOne.textColor = [UIColor lightGrayColor];
    [headView addSubview:uploadLabelOne];
    
    UILabel *goodsDetailLabel = [[UILabel alloc] init];
    goodsDetailLabel.frame = CGRectMake(10,uploadLabelOne.sh_bottom,80,30);
    goodsDetailLabel.font = [UIFont systemFontOfSize:13];
    goodsDetailLabel.text = @"商品详情图";
    [headView addSubview:goodsDetailLabel];
    
    UILabel *uploadGoodsDetailLabel = [[UILabel alloc] init];
    uploadGoodsDetailLabel.frame = CGRectMake(goodsDetailLabel.sh_right,uploadLabelOne.sh_bottom ,ScreenWidth *0.5,30);
    uploadGoodsDetailLabel.font = [UIFont systemFontOfSize:13];
    uploadGoodsDetailLabel.text = @"请上传1张商品详情图(5:3)";
    uploadGoodsDetailLabel.textColor = [UIColor lightGrayColor];
    [headView addSubview:uploadGoodsDetailLabel];
    
    
    UIButton *goodsDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goodsDetailBtn = goodsDetailBtn;
    goodsDetailBtn.frame = CGRectMake(10,uploadGoodsDetailLabel.sh_bottom + 10, 40, 40);
    [goodsDetailBtn setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [goodsDetailBtn addTarget:self action:@selector(goodsDetailBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:goodsDetailBtn];
    
    
    UIButton *goodsDetailImageView1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goodsDetailImageView1 = goodsDetailImageView1;
    goodsDetailImageView1.tag = 0;
    goodsDetailImageView1.frame = CGRectMake(goodsDetailBtn.sh_right + 10, goodsDetailBtn.sh_y,40,40);
    [goodsDetailImageView1 addTarget:self action:@selector(editorImage:) forControlEvents:UIControlEventTouchDown];
    [headView addSubview:goodsDetailImageView1];
    
    
    UIButton *goodsDetailImageView2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [goodsDetailImageView2 addTarget:self action:@selector(editorImage:) forControlEvents:UIControlEventTouchDown];
    goodsDetailImageView2.tag = 1;
    self.goodsDetailImageView2 = goodsDetailImageView2;
    goodsDetailImageView2.frame = CGRectMake(goodsDetailImageView1.sh_right + 10, goodsDetailBtn.sh_y,40,40);
    [headView addSubview:goodsDetailImageView2];

    UIButton *goodsDetailImageView3 = [UIButton buttonWithType:UIButtonTypeCustom];
    goodsDetailImageView3.tag = 2;
    
    [goodsDetailImageView3 addTarget:self action:@selector(editorImage:) forControlEvents:UIControlEventTouchDown];
    
    self.goodsDetailImageView3 = goodsDetailImageView3;
    goodsDetailImageView3.frame = CGRectMake(goodsDetailImageView2.sh_right + 10, goodsDetailBtn.sh_y,40,40);
    [headView addSubview:goodsDetailImageView3];

    
    UIButton *goodsDetailImageView4 = [UIButton buttonWithType:UIButtonTypeCustom];
    goodsDetailImageView4.tag = 3;
    
    [goodsDetailImageView4 addTarget:self action:@selector(editorImage:) forControlEvents:UIControlEventTouchDown];
    
    self.goodsDetailImageView4 = goodsDetailImageView4;
    goodsDetailImageView4.frame = CGRectMake(goodsDetailImageView3.sh_right + 10, goodsDetailBtn.sh_y,40,40);
    [headView addSubview:goodsDetailImageView4];

    
 
    
    UILabel *uploadLabelTwo = [[UILabel alloc] init];
    uploadLabelTwo.frame = CGRectMake(10,goodsDetailBtn.sh_bottom,80,30);
    uploadLabelTwo.font = [UIFont systemFontOfSize:13];
    uploadLabelTwo.text = @"上传图片";
    uploadLabelTwo.textColor = [UIColor lightGrayColor];
    [headView addSubview:uploadLabelTwo];
    
    headView.frame = CGRectMake(0,0,ScreenWidth,uploadLabelTwo.sh_bottom + 5);
    [self.scrollViews addSubview:headView];
}

#pragma mark 编辑商品详情图片
- (void)editorImage:(UIButton *)btn
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该图片?删除后无法恢复!" preferredStyle:1];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (btn.tag !=10)
        {
            [self.goodsDetailImageView1 setImage: nil forState:UIControlStateNormal];
            [self.goodsDetailImageView2 setImage: nil forState:UIControlStateNormal];
            [self.goodsDetailImageView3 setImage: nil forState:UIControlStateNormal];
            [self.goodsDetailImageView4 setImage: nil forState:UIControlStateNormal];
            
            [self.imageArray removeObjectAtIndex:btn.tag];
            [self addImageView];
            
        }else
        {
            self.uploadThumbnailImageFlag = @"0";
            [self.uploadThumbnailImageView setImage:nil forState:UIControlStateNormal];
        }
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}




#pragma mark 添加中部
- (void)addScrollMiddleView
{
    UIView *middView = [[UIView alloc] init];
    self.middView = middView;
    middView.backgroundColor = [UIColor whiteColor];

    
    UILabel *goodsDescriptionLabel = [[UILabel alloc] init];
    goodsDescriptionLabel.frame = CGRectMake(10,0,80,30);
    goodsDescriptionLabel.font = [UIFont systemFontOfSize:13];
    goodsDescriptionLabel.text = @"商品描述:";
    [middView addSubview:goodsDescriptionLabel];
    
    UILabel *inputGoodsDescriptionLabel = [[UILabel alloc] init];
    inputGoodsDescriptionLabel.frame = CGRectMake(goodsDescriptionLabel.sh_right,0,ScreenWidth *0.5,30);
    inputGoodsDescriptionLabel.font = [UIFont systemFontOfSize:13];
    inputGoodsDescriptionLabel.text = @"请上输入商品描述";
    inputGoodsDescriptionLabel.textColor = [UIColor lightGrayColor];
    [middView addSubview:inputGoodsDescriptionLabel];
    
    UITextView *goodsDescriptionTextView = [[UITextView alloc] init];
    
    if (self.goodsReleaseModelData.descriptionTitle.length > 0)
    {
        goodsDescriptionTextView.text = self.goodsReleaseModelData.descriptionTitle;
    }
    self.goodsDescriptionTextView = goodsDescriptionTextView;
    goodsDescriptionTextView.frame = CGRectMake(10,goodsDescriptionLabel.sh_bottom,ScreenWidth - 20,100);
    goodsDescriptionTextView.delegate = self;
    goodsDescriptionTextView.layer.borderWidth = 1.0f;
    goodsDescriptionTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    goodsDescriptionTextView.font = [UIFont systemFontOfSize:13];
    [middView addSubview:goodsDescriptionTextView];
    
    UILabel *goodsSpecificationsLabel = [[UILabel alloc] init];
    goodsSpecificationsLabel.frame = CGRectMake(10,goodsDescriptionTextView.sh_bottom + 10,60,20);
    goodsSpecificationsLabel.font = [UIFont systemFontOfSize:13];
    goodsSpecificationsLabel.text = @"商品规格:";
    [middView addSubview:goodsSpecificationsLabel];
    
    UITextField *goodsSpecificationsTextField = [[UITextField alloc] init];
    self.goodsSpecificationsTextField =goodsSpecificationsTextField;
    goodsSpecificationsTextField.delegate = self;
    goodsSpecificationsTextField.font = [UIFont systemFontOfSize:13];
    goodsSpecificationsTextField.frame = CGRectMake(goodsSpecificationsLabel.sh_right,goodsDescriptionTextView.sh_bottom + 10,ScreenWidth *0.75,20);
    goodsSpecificationsTextField.placeholder = @"请输入商品规格";
    goodsSpecificationsTextField.textColor = [UIColor lightGrayColor];
    goodsSpecificationsTextField.layer.borderWidth = 1.0f;
    goodsSpecificationsTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [middView addSubview:goodsSpecificationsTextField];
    
    
    UILabel *theDeliveryLeftLabel = [[UILabel alloc] init];
    theDeliveryLeftLabel.frame = CGRectMake(10,goodsSpecificationsLabel.sh_bottom + 10,60,20);
    theDeliveryLeftLabel.font = [UIFont systemFontOfSize:13];
    theDeliveryLeftLabel.text = @"发货地址:";
    [middView addSubview:theDeliveryLeftLabel];
    
    UITextField *theDeliveryTextField = [[UITextField alloc] init];
    theDeliveryTextField.delegate = self;
    self.theDeliveryTextField = theDeliveryTextField;
    theDeliveryTextField.font = [UIFont systemFontOfSize:13];
    theDeliveryTextField.frame = CGRectMake(theDeliveryLeftLabel.sh_right,goodsSpecificationsTextField.sh_bottom + 10,ScreenWidth *0.3,20);
    theDeliveryTextField.textColor = [UIColor lightGrayColor];
    theDeliveryTextField.layer.borderWidth = 1.0f;
    theDeliveryTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [middView addSubview:theDeliveryTextField];
    
    UILabel *theDeliveryRightLabel = [[UILabel alloc] init];
    theDeliveryRightLabel.frame = CGRectMake(theDeliveryTextField.sh_right + 10,goodsSpecificationsLabel.sh_bottom + 10,150,20);
    theDeliveryRightLabel.font = [UIFont systemFontOfSize:13];
    theDeliveryRightLabel.text = @"发货所在市级名称";
    theDeliveryRightLabel.textColor = [UIColor lightGrayColor];
    [middView addSubview:theDeliveryRightLabel];
    
    
    
    UILabel *stockLeftLabel = [[UILabel alloc] init];
    stockLeftLabel.frame = CGRectMake(10,theDeliveryLeftLabel.sh_bottom + 10,60,20);
    stockLeftLabel.font = [UIFont systemFontOfSize:13];
    stockLeftLabel.text = @"商品库存:";
    [middView addSubview:stockLeftLabel];
    
    UITextField *stockTextField = [[UITextField alloc] init];
    self.stockTextField = stockTextField;
    stockTextField.delegate = self;
    
    if (self.goodsReleaseModelData.inventory.length > 0) {
        
        stockTextField.text = self.goodsReleaseModelData.inventory;
    }
    stockTextField.font = [UIFont systemFontOfSize:13];
    stockTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    stockTextField.frame = CGRectMake(stockLeftLabel.sh_right,theDeliveryTextField.sh_bottom + 10,ScreenWidth *0.3,20);
    stockTextField.textColor = [UIColor lightGrayColor];
    stockTextField.layer.borderWidth = 1.0f;
    stockTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [middView addSubview:stockTextField];
    
    UILabel *stockRightLabel = [[UILabel alloc] init];
    stockRightLabel.frame = CGRectMake(stockTextField.sh_right  +10,theDeliveryRightLabel.sh_bottom + 10,150,20);
    stockRightLabel.font = [UIFont systemFontOfSize:13];
    stockRightLabel.text = @"件";
    stockRightLabel.textColor = [UIColor lightGrayColor];
    [middView addSubview:stockRightLabel];
    
    
    UILabel *initialrPiceLeftLabel = [[UILabel alloc] init];
    initialrPiceLeftLabel.frame = CGRectMake(10,stockLeftLabel.sh_bottom + 10,60,20);
    initialrPiceLeftLabel.font = [UIFont systemFontOfSize:13];
    initialrPiceLeftLabel.text = @"初始价格:";
    [middView addSubview:initialrPiceLeftLabel];
    
    UITextField *initialrPiceTextField = [[UITextField alloc] init];
    self.initialrPiceTextField = initialrPiceTextField;
    initialrPiceTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    initialrPiceTextField.delegate = self;
    initialrPiceTextField.font = [UIFont systemFontOfSize:13];
    initialrPiceTextField.frame = CGRectMake(stockLeftLabel.sh_right,stockTextField.sh_bottom + 10,ScreenWidth *0.3,20);
    initialrPiceTextField.textColor = [UIColor lightGrayColor];
    initialrPiceTextField.layer.borderWidth = 1.0f;
    initialrPiceTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [middView addSubview:initialrPiceTextField];
    
    
    UILabel *initialrPiceRightLabel = [[UILabel alloc] init];
    initialrPiceRightLabel.frame = CGRectMake(stockTextField.sh_right  +10,stockRightLabel.sh_bottom + 10,150,20);
    initialrPiceRightLabel.font = [UIFont systemFontOfSize:13];
    initialrPiceRightLabel.text = @"";
    initialrPiceRightLabel.textColor = [UIColor lightGrayColor];
    [middView addSubview:initialrPiceRightLabel];

    

    
    UILabel *salesPiceLeftLabel = [[UILabel alloc] init];
    salesPiceLeftLabel.frame = CGRectMake(10,initialrPiceLeftLabel.sh_bottom + 10,60,20);
    salesPiceLeftLabel.font = [UIFont systemFontOfSize:13];
    salesPiceLeftLabel.text = @"销售价格:";
    [middView addSubview:salesPiceLeftLabel];
    
    UITextField *salesPiceTextField = [[UITextField alloc] init];
    self.salesPiceTextField = salesPiceTextField;
    salesPiceTextField.keyboardType =UIKeyboardTypeNumbersAndPunctuation;
    salesPiceTextField.delegate = self;
    if (self.goodsReleaseModelData.price.length > 0)
    {
        salesPiceTextField.text = self.goodsReleaseModelData.price;
    }
    
    salesPiceTextField.font = [UIFont systemFontOfSize:13];
    salesPiceTextField.frame = CGRectMake(salesPiceLeftLabel.sh_right,initialrPiceTextField.sh_bottom + 10,ScreenWidth *0.3,20);
    salesPiceTextField.textColor = [UIColor lightGrayColor];
    salesPiceTextField.layer.borderWidth = 1.0f;
    salesPiceTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [middView addSubview:salesPiceTextField];
    
    
    UILabel *salesPiceRightLabel = [[UILabel alloc] init];
    salesPiceRightLabel.frame = CGRectMake(salesPiceTextField.sh_right  +10,initialrPiceTextField.sh_bottom + 10,150,20);
    salesPiceRightLabel.font = [UIFont systemFontOfSize:13];
    salesPiceRightLabel.text = @"买家购买时所支付的价格";
    salesPiceRightLabel.textColor = [UIColor lightGrayColor];
    [middView addSubview:salesPiceRightLabel];

    
    
    UILabel *freightLeftLabel = [[UILabel alloc] init];
    freightLeftLabel.frame = CGRectMake(10,salesPiceLeftLabel.sh_bottom + 10,60,20);
    freightLeftLabel.font = [UIFont systemFontOfSize:13];
    freightLeftLabel.text = @"运费价格:";
    [middView addSubview:freightLeftLabel];
    
    UITextField *freightTextField = [[UITextField alloc] init];
    self.freightTextField= freightTextField;
     freightTextField.keyboardType =UIKeyboardTypeNumbersAndPunctuation;
    if (self.goodsReleaseModelData.carriage.length > 0)
    {
        self.freightTextField.text = self.goodsReleaseModelData.carriage;
    }
    
    freightTextField.delegate = self;
    freightTextField.font = [UIFont systemFontOfSize:13];
    freightTextField.frame = CGRectMake(freightLeftLabel.sh_right,salesPiceTextField.sh_bottom + 10,ScreenWidth *0.3,20);
    freightTextField.textColor = [UIColor lightGrayColor];
    freightTextField.layer.borderWidth = 1.0f;
    freightTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [middView addSubview:freightTextField];
    
    
    UILabel *freightRightLabel = [[UILabel alloc] init];
    freightRightLabel.frame = CGRectMake(freightTextField.sh_right  +10,salesPiceRightLabel.sh_bottom + 10,150,20);
    freightRightLabel.font = [UIFont systemFontOfSize:13];
    freightRightLabel.text = @"";
    freightRightLabel.textColor = [UIColor lightGrayColor];
    [middView addSubview:freightRightLabel];

    
    UIView *lineOne = [[UIView alloc] init];
    lineOne.frame = CGRectMake(0,freightTextField.sh_bottom + 5,ScreenWidth, 1);
    lineOne.backgroundColor = [UIColor lightGrayColor];
    [middView addSubview:lineOne];
    
    
    UILabel *salesCostLeftLabel = [[UILabel alloc] init];
    salesCostLeftLabel.frame = CGRectMake(10,lineOne.sh_bottom + 10,60,20);
    salesCostLeftLabel.font = [UIFont systemFontOfSize:13];
    salesCostLeftLabel.text = @"促销费用";
    [middView addSubview:salesCostLeftLabel];
    
    UITextField *salesCostTextField = [[UITextField alloc] init];
    self.salesCostTextField = salesCostTextField;
    salesCostTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    salesCostTextField.delegate = self;
    salesCostTextField.font = [UIFont systemFontOfSize:13];
    salesCostTextField.frame = CGRectMake(salesCostLeftLabel.sh_right,lineOne.sh_bottom + 10,ScreenWidth *0.3,20);
    salesCostTextField.textColor = [UIColor lightGrayColor];
    salesCostTextField.placeholder = @"不参加则填0";
    if (self.goodsReleaseModelData.promotion_money.length > 0)
    {
        salesCostTextField.text = self.goodsReleaseModelData.promotion_money;
    }
    salesCostTextField.layer.borderWidth = 1.0f;
    salesCostTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [middView addSubview:salesCostTextField];
    
    UILabel *salesCostRightLabel = [[UILabel alloc] init];
    salesCostRightLabel.frame = CGRectMake(salesCostTextField.sh_right  +10,lineOne.sh_bottom + 10,150,20);
    salesCostRightLabel.font = [UIFont systemFontOfSize:13];
    salesCostRightLabel.text = @"商家让利促销费用";
    salesCostRightLabel.textColor = [UIColor lightGrayColor];
    [middView addSubview:salesCostRightLabel];
    
    
    
    UILabel *starTimeLeftLabel = [[UILabel alloc] init];
    starTimeLeftLabel.frame = CGRectMake(10,salesCostLeftLabel.sh_bottom + 10,60,20);
    starTimeLeftLabel.font = [UIFont systemFontOfSize:13];
    starTimeLeftLabel.text = @"促销开始:";
    [middView addSubview:starTimeLeftLabel];
    
    UITextField *starTimeTextField = [[UITextField alloc] init];
    self.starTimeTextField = starTimeTextField;
    starTimeTextField.delegate = self;
    starTimeTextField.font = [UIFont systemFontOfSize:13];
    starTimeTextField.frame = CGRectMake(starTimeLeftLabel.sh_right,salesCostTextField.sh_bottom + 10,ScreenWidth *0.3,20);
   // [starTimeTextField addTarget:self action:@selector(straTimeOutTheKeyboard) forControlEvents:UIControlEventEditingDidBegin];
    starTimeTextField.textColor = [UIColor lightGrayColor];
    starTimeTextField.layer.borderWidth = 1.0f;
    starTimeTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [middView addSubview:starTimeTextField];
    
    UILabel *starTimeRightLabel = [[UILabel alloc] init];
    starTimeRightLabel.frame = CGRectMake(starTimeTextField.sh_right  +10,salesCostRightLabel.sh_bottom + 10,150,20);
    starTimeRightLabel.font = [UIFont systemFontOfSize:13];
    starTimeRightLabel.text = @"活动开始时间";
    starTimeRightLabel.textColor = [UIColor lightGrayColor];
    [middView addSubview:starTimeRightLabel];
    
    
    
    
    UILabel *endTimeLeftLabel = [[UILabel alloc] init];
    endTimeLeftLabel.frame = CGRectMake(10,starTimeLeftLabel.sh_bottom + 10,60,20);
    endTimeLeftLabel.font = [UIFont systemFontOfSize:13];
    endTimeLeftLabel.text = @"促销结束";
    [middView addSubview:endTimeLeftLabel];
    
    UITextField *endTimeTextField = [[UITextField alloc] init];
    self.endTimeTextField = endTimeTextField;
    endTimeTextField.delegate = self;
    endTimeTextField.font = [UIFont systemFontOfSize:13];
    endTimeTextField.frame = CGRectMake(endTimeLeftLabel.sh_right,starTimeTextField.sh_bottom + 10,ScreenWidth *0.3,20);
    //[endTimeTextField addTarget:self action:@selector(endTimeOutTheKeyboard) forControlEvents:UIControlEventEditingDidEndOnExit];
    endTimeTextField.textColor = [UIColor lightGrayColor];
    endTimeTextField.layer.borderWidth = 1.0f;
    endTimeTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [middView addSubview:endTimeTextField];
    
    UILabel *endTimeRightLabel = [[UILabel alloc] init];
    endTimeRightLabel.frame = CGRectMake(starTimeTextField.sh_right  +10,starTimeRightLabel.sh_bottom + 10,150,20);
    endTimeRightLabel.font = [UIFont systemFontOfSize:13];
    endTimeRightLabel.text = @"活动结束时间";
    endTimeRightLabel.textColor = [UIColor lightGrayColor];
    [middView addSubview:endTimeRightLabel];

    UIView *lineTwo = [[UIView alloc] init];
    lineTwo.frame = CGRectMake(0,endTimeTextField.sh_bottom + 5,ScreenWidth, 1);
    lineTwo.backgroundColor = [UIColor lightGrayColor];
    [middView addSubview:lineTwo];
    
    
    UILabel *operatingIncomeLeftLabel = [[UILabel alloc] init];
    operatingIncomeLeftLabel.frame = CGRectMake(10,lineTwo.sh_bottom + 10,60,20);
    operatingIncomeLeftLabel.font = [UIFont systemFontOfSize:13];
    operatingIncomeLeftLabel.text = @"营业收入";
    [middView addSubview:operatingIncomeLeftLabel];
    
    UIButton *operatingIncomebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.operatingIncomebtn = operatingIncomebtn;
    [operatingIncomebtn addTarget:self action:@selector(operatingBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    [operatingIncomebtn setTitle:@"点击查看" forState:UIControlStateNormal];
    operatingIncomebtn.titleLabel.font = [UIFont systemFontOfSize:13];
    operatingIncomebtn.frame = CGRectMake(operatingIncomeLeftLabel.sh_right,lineTwo.sh_bottom + 10,ScreenWidth *0.3,20);
    [operatingIncomebtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    operatingIncomebtn.layer.borderWidth = 1.0f;
    operatingIncomebtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [middView addSubview:operatingIncomebtn];
    
    UILabel *operatingIncomeRightLabel = [[UILabel alloc] init];
    operatingIncomeRightLabel.frame = CGRectMake(operatingIncomebtn.sh_right  +10,lineTwo.sh_bottom + 10,150,20);
    operatingIncomeRightLabel.font = [UIFont systemFontOfSize:13];
    operatingIncomeRightLabel.text = @"商品价格-促销费用";
    operatingIncomeRightLabel.textColor = [UIColor lightGrayColor];
    [middView addSubview:operatingIncomeRightLabel];
    
    
    UILabel *invoiceLabel = [[UILabel alloc] init];
    invoiceLabel.frame = CGRectMake(10,operatingIncomeLeftLabel.sh_bottom + 10,40,20);
    invoiceLabel.font = [UIFont systemFontOfSize:13];
    invoiceLabel.text = @"发   票";
    [middView addSubview:invoiceLabel];
    
    UIButton * invoiceHaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.invoiceHaveBtn = invoiceHaveBtn;
    invoiceHaveBtn.frame = CGRectMake(operatingIncomebtn.sh_x,invoiceLabel.sh_y,40,20);
    [invoiceHaveBtn setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [invoiceHaveBtn setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateSelected];
//    if (self.goodsId ==nil)
//    {
//    }
    invoiceHaveBtn.selected = YES;
    self.invoiceSing = @"1";
    [invoiceHaveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [invoiceHaveBtn addTarget:self action:@selector(invoiceHave) forControlEvents:UIControlEventTouchUpInside];
    [invoiceHaveBtn horizontalCenterImageAndTitle:15];
    [invoiceHaveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [invoiceHaveBtn setTitle:@"有" forState:UIControlStateNormal];
    [invoiceHaveBtn setTitle:@"有" forState:UIControlStateSelected];
    invoiceHaveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
//    if ([self.goodsReleaseModelData.invoice isEqualToString:@"1"])
//    {
//        self.invoiceSing = @"1";
//        self.invoiceHaveBtn.selected = YES;
//    }else
//    {
//        self.invoiceNoBtn.selected = NO;
//    }
//    
    
    [middView addSubview:invoiceHaveBtn];

    UIButton * invoiceNoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.invoiceNoBtn = invoiceNoBtn;
    invoiceNoBtn.frame = CGRectMake(invoiceHaveBtn.sh_right + 10,invoiceLabel.sh_y,40,20);
    [invoiceNoBtn addTarget:self action:@selector(invoiceNo) forControlEvents:UIControlEventTouchUpInside];
    [invoiceNoBtn setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [invoiceNoBtn setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateSelected];
    [invoiceNoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [invoiceNoBtn horizontalCenterImageAndTitle:15];
    [invoiceNoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [invoiceNoBtn setTitle:@"无" forState:UIControlStateNormal];
    [invoiceNoBtn setTitle:@"无" forState:UIControlStateSelected];
    invoiceNoBtn.titleLabel.font = [UIFont systemFontOfSize:13];

    [middView addSubview:invoiceNoBtn];
    
    
    UILabel *warrantyLabel = [[UILabel alloc] init];
    warrantyLabel.frame = CGRectMake(10,invoiceLabel.sh_bottom + 10,40,20);
    warrantyLabel.font = [UIFont systemFontOfSize:13];
    warrantyLabel.text = @"保   修";
    [middView addSubview:warrantyLabel];
    
    UIButton * warrantyHaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.warrantyHaveBtn = warrantyHaveBtn;
    warrantyHaveBtn.frame = CGRectMake(operatingIncomebtn.sh_x,warrantyLabel.sh_y,40,20);
    [warrantyHaveBtn addTarget:self action:@selector(warrantyHave) forControlEvents:UIControlEventTouchUpInside];
    [warrantyHaveBtn setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [warrantyHaveBtn setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateSelected];
    
//    if (self.goodsId ==nil)
//    {
    
        warrantyHaveBtn.selected = YES;
//    }
    
    [warrantyHaveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [warrantyHaveBtn horizontalCenterImageAndTitle:15];
    [warrantyHaveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [warrantyHaveBtn setTitle:@"有" forState:UIControlStateNormal];
    [warrantyHaveBtn setTitle:@"有" forState:UIControlStateSelected];
    warrantyHaveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.warrantySing = @"1";
    
//    NSLog(@"%@",self.goodsReleaseModelData.repair);
//    
//    if ([self.goodsReleaseModelData.repair isEqualToString:@"1"])
//    {
//        self.warrantyHaveBtn.selected = YES;
//        self.warrantySing = @"1";
//    }else
//    {
//        self.warrantyNoBtn.selected = NO;
//    }

    
    [middView addSubview:warrantyHaveBtn];
    
    UIButton * warrantyNoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.warrantyNoBtn = warrantyNoBtn;
    warrantyNoBtn.frame = CGRectMake(warrantyHaveBtn.sh_right + 10,warrantyLabel.sh_y,40,20);
    [warrantyNoBtn addTarget:self action:@selector(warrantyNo) forControlEvents:UIControlEventTouchUpInside];
    [warrantyNoBtn setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [warrantyNoBtn setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateSelected];
    [warrantyNoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [warrantyNoBtn horizontalCenterImageAndTitle:15];
    [warrantyNoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [warrantyNoBtn setTitle:@"无" forState:UIControlStateNormal];
    [warrantyNoBtn setTitle:@"无" forState:UIControlStateSelected];
    warrantyNoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [middView addSubview:warrantyNoBtn];

    middView.frame = CGRectMake(0,self.headView.sh_bottom  +10, ScreenWidth,warrantyNoBtn.sh_bottom + 10);
        [self.scrollViews addSubview:middView];

}

#pragma mark 活动开始时间弹出日历退出键盘
- (void)straTimeOutTheKeyboard
{
    [self outOfTheKeyboard];
}

#pragma mark 活动结束时间弹出日历退出键盘
- (void)endTimeOutTheKeyboard
{
    [self outOfTheKeyboard];
}


#pragma mark 添加底部
- (void)addScrollBottomView
{
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.frame = CGRectMake(0,self.middView.sh_bottom + 10,ScreenWidth,170);
    [self.scrollViews addSubview:bottomView];
    
    UILabel *goodsClassLabel = [[UILabel alloc] init];
    goodsClassLabel.frame = CGRectMake(10,10,100,20);
    goodsClassLabel.font = [UIFont systemFontOfSize:13];
    goodsClassLabel.text = @"商品分类";
    [bottomView addSubview:goodsClassLabel];
    
    UITextField *goodsClassTextField = [[UITextField alloc] init];
    self.goodsClassTextField = goodsClassTextField;
    goodsClassTextField.delegate = self;
    goodsClassTextField.font = [UIFont systemFontOfSize:13];
    goodsClassTextField.frame = CGRectMake(10,goodsClassLabel.sh_bottom + 10,ScreenWidth *0.7,20);
    goodsClassTextField.textColor = [UIColor lightGrayColor];
    goodsClassTextField.layer.borderWidth = 1.0f;
    goodsClassTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [bottomView addSubview:goodsClassTextField];

    UIButton *classBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    classBtn.frame = CGRectMake(goodsClassTextField.sh_right + 10,goodsClassTextField.sh_y,ScreenWidth *0.2,20);
    [classBtn setTitle:@"选择分类" forState:UIControlStateNormal];
    classBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [classBtn setBackgroundColor:[UIColor orangeColor]];
    [classBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    classBtn.layer.cornerRadius = 5;
    classBtn.clipsToBounds = YES;
    [classBtn addTarget:self action:@selector(classBtnClcik) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:classBtn];
    
    UILabel *returnsGoodsLabel = [[UILabel alloc] init];
    returnsGoodsLabel.font = [UIFont systemFontOfSize:13];
    returnsGoodsLabel.textColor = [UIColor lightGrayColor];
    returnsGoodsLabel.frame = CGRectMake(10,goodsClassTextField.sh_bottom + 10,ScreenWidth - 20,40);
    returnsGoodsLabel.text = @"退货款承诺: 凡购买本店商品.若存在质量问题与描述不符,本店将提供 货款服务并担来回运费";
    returnsGoodsLabel.numberOfLines = 0;
    returnsGoodsLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [bottomView addSubview:returnsGoodsLabel];
    
    UILabel *serviceLabel = [[UILabel alloc] init];
    serviceLabel.font = [UIFont systemFontOfSize:13];
    serviceLabel.textColor = [UIColor lightGrayColor];
    serviceLabel.frame = CGRectMake(10,returnsGoodsLabel.sh_bottom + 10,ScreenWidth - 20,40);
    serviceLabel.text = @"服务保障: ”该商品支持七天退货”服务,承诺更好的服务可根据交易合约设置";
    serviceLabel.numberOfLines = 0;
    serviceLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [bottomView addSubview:serviceLabel];

    self.scrollViews.contentSize = CGSizeMake(0,bottomView.sh_bottom);
    
    
}

#pragma mark 商品分类选择按钮
- (void)classBtnClcik
{

    [GoodsClassPickerController showPickerInViewController:self selectBlock:nil];
}


#pragma mark 分类参数翻回
- (void)goodsClassificationClick:(NSNotification *)notification
{
    
    self.classeId = notification.userInfo[@"oneClasseId"];
    self.goodsClassTextField.text = [NSString stringWithFormat:@" %@ %@ %@ ",notification.userInfo[@"oneClasse"],notification.userInfo[@"twoClasse"],notification.userInfo[@"threeClasse"]];
    
}



#pragma 发票按钮
- (void)invoiceHave
{
    if (!self.invoiceHaveBtn.selected)
    {
        self.invoiceSing = @"2";
        self.invoiceHaveBtn.selected = YES;
        self.invoiceNoBtn.selected  = NO;
    }

}

- (void)invoiceNo
{
    if (!self.invoiceNoBtn.selected)
    {
        self.invoiceNoBtn.selected  = YES;
        self.invoiceHaveBtn.selected = NO;
    }

}
#pragma mark 保修按钮
- (void)warrantyHave
{
    if (!self.warrantyHaveBtn.selected) {
        
        self.warrantySing = @"2";
        self.warrantyHaveBtn.selected = YES;
        self.warrantyNoBtn.selected = NO;
    }
}

- (void)warrantyNo
{
    if (!self.warrantyNoBtn.selected) {
        
        self.warrantyNoBtn.selected = YES;
        self.warrantyHaveBtn.selected = NO;
    }
}

#pragma mark 营业收入
- (void)operatingBtnClcik
{
    
    if (self.salesPiceTextField.text.length == 0)
    {
        [JKAlert alertText:@"请输入商品价格"];
        return;
    }
    
    if (self.salesCostTextField.text.length == 0) {
        [JKAlert alertText:@"请输入促销价格"];
        return;
    }
    
    NSInteger salesPice = [self.salesPiceTextField.text integerValue];
    NSInteger costPice=   [self.salesCostTextField.text integerValue];
    [self.operatingIncomebtn setTitle:[NSString stringWithFormat:@"%d",salesPice - costPice] forState:UIControlStateNormal];
}


#pragma mark 1:1缩略图
- (void)ThumbnailBtnClcik
{
    if ([self.uploadThumbnailImageFlag isEqualToString:@"1"])
    {
        [JKAlert alertText:@"最多上传一张图片"];
        return;

    }
    
    self.sign = 1;
    [self alertController];
}

#pragma mark 5:3商品详情图
- (void)goodsDetailBtnClcik
{
    
    
    if ([self.uploadThumbnailImageFlag isEqualToString:@"0"])
    {
        [JKAlert alertText:@"请先上传商品缩略图"];
        return;
    }
    
    if (self.imageArray.count == 4)
    {
        [JKAlert alertText:@"只能上传1张缩略图4张详情图片"];
        return;
    }
    
    
    self.sign = 2;
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


#pragma mark 获取裁剪后的图片
- (void)getPhotoClick:(NSNotification *)notification
{
    NSInteger flag = [[NSString stringWithFormat:@"%@",notification.userInfo[@"sign"]] integerValue];
    
    UIImage *image = notification.userInfo[@"image"];
    
    switch (flag){
        case 1:
            self.uploadImage = image;
            self.uploadThumbnailImageFlag = @"1";
             [self.uploadThumbnailImageView setImage:image forState:UIControlStateNormal];

//            [picker dismissViewControllerAnimated:YES completion:nil];
            break;
        case 2:
            
              [self.imageArray addObject:image];
           // [self dismissViewControllerAnimated:YES completion:nil];
            [self addImageView];
            
            break;
    }

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
   // UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    UIImage *toCropImage = info[UIImagePickerControllerOriginalImage];
    
    switch (self.sign){
        case 1:
           // self.uploadImage = image;
           // self.uploadThumbnailImageView.image = image;
            [self cropImage: toCropImage];
            [picker dismissViewControllerAnimated:YES completion:nil];
            break;
        case 2:
           // [self.imageArray addObject:image];
            [self cropImage:toCropImage];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            break;
    }
    
}

- (void)cropImage: (UIImage *)image {

    CropImageViewController *cropImageViewController = [[CropImageViewController alloc]initWithNibName:@"CropImageViewController" bundle:nil];
    self.cropImageVc = cropImageViewController;
    cropImageViewController.sing = self.sign;
    cropImageViewController.image = image;
    [self.navigationController pushViewController: cropImageViewController animated: YES];
}


#pragma mark 商品详情
- (void)addImageView
{
    for (int i = 0; i < self.imageArray.count;i++)
    {
        switch (i + 1){
            case 1:
                [self.goodsDetailImageView1 setImage: self.imageArray[i] forState:UIControlStateNormal];
                break;
            case 2:
                [self.goodsDetailImageView2 setImage: self.imageArray[i] forState:UIControlStateNormal];
                break;
            case 3:
               [self.goodsDetailImageView3 setImage: self.imageArray[i] forState:UIControlStateNormal];
                break;
            case 4:
                [self.goodsDetailImageView4 setImage: self.imageArray[i] forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
    }
   
}

#pragma mark textViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
       
        [self.goodsDescriptionTextView resignFirstResponder];
        
    }
    
    return YES;
}


#pragma mark  TextFieldDetegate

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [self outOfTheKeyboard];
    return YES;
}


#pragma mark 退出键盘
- (void)outOfTheKeyboard
{
    
    [self.goodsTextField resignFirstResponder];
    
    [self.goodsSpecificationsTextField resignFirstResponder];
    
    [self.theDeliveryTextField resignFirstResponder];
    
    [self.stockTextField resignFirstResponder];
    
    [self.goodsSpecificationsTextField resignFirstResponder];
    
    [self.theDeliveryTextField resignFirstResponder];
    
    [self.initialrPiceTextField resignFirstResponder];
    
    [self.salesPiceTextField resignFirstResponder];
    
    [self.freightTextField resignFirstResponder];
    
    [self.salesCostTextField resignFirstResponder];
    [self.goodsClassTextField resignFirstResponder];
    
    [self.starTimeTextField resignFirstResponder];
    
    [self.endTimeTextField resignFirstResponder];
    
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSInteger count =  [self.salesCostTextField.text integerValue];
    

    
    if (textField == self.starTimeTextField || textField == self.endTimeTextField)
    {
         [self outOfTheKeyboard];
        if (count >= 1)
        {
            if (textField == self.starTimeTextField)
            {
                self.flag = 1;
            }else
            {
                self.flag = 2;
            }
            
           
            
            CJCalendarViewController *calendarController = [[CJCalendarViewController alloc] init];
            calendarController.view.frame = self.view.frame;
            calendarController.delegate = self;

            [self presentViewController:calendarController animated:YES completion:nil];
            
        }else
        {
            [JKAlert alertText:@"请填写促销费用,参加促销活动"];
            
        }
        return NO;
        
    }
    
    return YES;
}

#pragma mark 日历代理方法
-(void)CalendarViewController:(CJCalendarViewController *)controller didSelectActionYear:(NSString *)year month:(NSString *)month day:(NSString *)day{
    
    if (self.flag == 1)
    {
        self.starTimeTextField.text = [NSString stringWithFormat:@"%@-%@-%@", year, month,day];
        [self.starTimeTextField  resignFirstResponder];
    }else
    {
        self.endTimeTextField.text = [NSString stringWithFormat:@"%@-%@-%@", year, month,day];
        [self.endTimeTextField resignFirstResponder];
        
    }
    
}

#pragma mark 日历取消按钮

- (void)cancelCalendarCilck
{
    [self.starTimeTextField resignFirstResponder];
    [self.endTimeTextField resignFirstResponder];
}



- (void)addScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollViews = scrollView;
    scrollView.bounces = NO;
    
//    if (self.goodsId.length > 0)
//    {
//        scrollView.frame = CGRectMake(0,64,ScreenWidth,ScreenHeight - 64);
//    }else
//    {
        scrollView.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight - 50);
        
    //}
    
    scrollView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];;
    [self.view addSubview:scrollView];
}

#pragma mark 添加上架按钮
- (void)addBottomView
{
    UIView *bottomView = [[UIView alloc] init];
    self.bottomView = bottomView;
    bottomView.frame = CGRectMake(0,ScreenHeight - 50,ScreenWidth,50);
    bottomView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self.view addSubview:bottomView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10,10,ScreenWidth - 20,30);
    [btn setBackgroundColor:[UIColor orangeColor]];
    
    [btn setTitle:@"立即上架" forState:UIControlStateNormal];
  
    [btn addTarget:self action:@selector(shelvesClick) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.clipsToBounds = YES;
    btn.layer.cornerRadius=5;
    [bottomView addSubview:btn];

}

- (void)shelvesClick
{
  
    if (self.goodsTextField.text.length == 0)
    {
        [JKAlert alertText:@"请输入商品名称"];
        return ;
    }
    
    if (self.uploadImage == nil || self.imageArray.count <4)
    {
        [JKAlert alertText:@"请上传一张缩略图和四张详情图"];
        return ;
    }
    if (self.goodsDescriptionTextView.text.length == 0)
    {
        [JKAlert alertText:@"请输入商品描述"];
        return;
    }
    if (self.goodsSpecificationsTextField.text.length == 0)
    {
        [JKAlert alertText:@"请输入商品规格"];
        return;
    }
    if (self.stockTextField.text.length == 0)
    {
        [JKAlert alertText:@"请输入库存"];
        return;
    }
    if (self.freightTextField.text.length == 0)
    {
        [JKAlert alertText:@"请输入运费"];
        return;
    }
    if (self.theDeliveryTextField.text.length == 0)
    {
        [JKAlert alertText:@"请输入发货地址"];
        return;
    }
    if (self.salesCostTextField.text.length == 0)
    {
        [JKAlert alertText:@"请输入促销费用"];
        return;
    }
    
    if (self.classeId.length == 0)
    {
        [JKAlert alertText:@"请选择分类"];
    }
  
        __weak typeof(self) weakself = self;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
        
        NSString *completeStr = [NSString stringEncryptedAddress:@"/shop/goodscreate"];
        
        NSDictionary *dict;
        if ([self.salesCostTextField.text isEqualToString:@"0"])
        {
            
            dict =@{@"goods_name":self.goodsTextField.text,@"description":self.goodsDescriptionTextView.text,@"img_total":@(weakself.imageArray.count + 1),@"price":self.salesPiceTextField.text,@"spec":self.goodsSpecificationsTextField.text,@"inventory":self.stockTextField.text,@"category_id":self.classeId,@"is_top":@"1",@"is_recommend":@"1",@"is_shelf":@"1",@"carriage":self.freightTextField.text,@"promotion_money":self.salesCostTextField.text,@"start_time":@" ",@"end_time":@" ",@"invoice":self.invoiceSing,@"repair":self.warrantySing,@"primeval_price":self.initialrPiceTextField.text,@"delivesress":self.theDeliveryTextField.text};
            
        }else
        {
            dict =@{@"goods_name":self.goodsTextField.text,@"description":self.goodsDescriptionTextView.text,@"img_total":@(weakself.imageArray.count + 1),@"price":self.salesPiceTextField.text,@"spec":self.goodsSpecificationsTextField.text,@"inventory":self.stockTextField.text,@"category_id":self.classeId,@"is_top":@"1",@"is_recommend":@"1",@"is_shelf":@"1",@"carriage":self.freightTextField.text,@"promotion_money":self.salesCostTextField.text,@"start_time":self.starTimeTextField.text,@"end_time":self.endTimeTextField.text,@"invoice":self.invoiceSing,@"repair":self.warrantySing,@"primeval_price":self.initialrPiceTextField.text,@"delivesress":self.theDeliveryTextField.text};
        }
        
        
        [manager POST:completeStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            UIImage *image = weakself.uploadImage;
            NSData *Data = UIImagePNGRepresentation(image);
            
            [formData appendPartWithFileData:Data name:[NSString stringWithFormat:@"img%d",1] fileName:[NSString stringWithFormat:@"goods%d.jpg",1] mimeType:@"image/jpg"];
            
            for (int i = 0;i < weakself.imageArray.count; i++)
            {
                UIImage *image = weakself.imageArray[i];
                NSData *Data = UIImagePNGRepresentation(image);
                
                [formData appendPartWithFileData:Data name:[NSString stringWithFormat:@"img%d",i + 2] fileName:[NSString stringWithFormat:@"goods%d.jpg",i + 2] mimeType:@"image/jpg"];
                
                [weakself.imageArray writeToFile:[NSString stringWithFormat:@"/Users/nenios/Desktop/%@.png%d",weakself.imageArray[i],i] atomically:YES];
            
            }
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSString *resultCode = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultCode"]];
            
            if ([resultCode isEqualToString:@"0"])
            {
                [JKAlert alertText:@"发布成功"];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else
            {
                [JKAlert alertText:[NSString stringWithFormat:@"%@",responseObject[@"result"][@"resultMessage"]]];
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
