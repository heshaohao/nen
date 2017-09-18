//
//  OrderToEvaluateViewController.m
//  nen
//
//  Created by nenios101 on 2017/5/24.
//  Copyright © 2017年 nen. All rights reserved.
// 商品评价

#import "OrderToEvaluateViewController.h"
#import "XHStarView.h"
@interface OrderToEvaluateViewController ()<UITextViewDelegate>

@property (nonatomic,strong) XHStarView *starView;

@property(nonatomic,strong) UITextView *contentTextViews;

@property(nonatomic,strong) NSNumber *starsCount;

@end

@implementation OrderToEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor whiteColor];
    
    XHStarView *starView = [XHStarView loadStarView];
    self.starView = starView;
    starView.sh_x = ScreenWidth *0.5 - 78;
    starView.sh_width = 158;
    starView.sh_y = 150;
    [self.view addSubview:starView];
    
    
    UITextView *contentTextView = [[UITextView alloc] init];
    self.contentTextViews = contentTextView;
    contentTextView.delegate = self;
    contentTextView.textColor = [UIColor lightGrayColor];
    contentTextView.frame = CGRectMake(10,starView.sh_bottom + 20,ScreenWidth - 20,70);
    contentTextView.text = @"写下购买体会和视同感受来帮助其他小伙伴评价大于50余的商品和超过10的字数有机会获得网币";
    contentTextView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    contentTextView.font = [UIFont systemFontOfSize:15];
    
    [self.view addSubview:contentTextView];
    
    
    
    UIButton *anonymityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [anonymityBtn setTitle:@"匿名评价" forState:UIControlStateNormal];
    [anonymityBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    anonymityBtn.frame = CGRectMake(10 ,contentTextView.sh_bottom + 50,120,30);
    [anonymityBtn setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateNormal];
    anonymityBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [anonymityBtn horizontalCenterImageAndTitle:20];
    [self.view addSubview:anonymityBtn];
    
    
    UIButton *synchronousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [synchronousBtn setTitle:@"同步发布到社区" forState:UIControlStateNormal];
    [synchronousBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    synchronousBtn.frame = CGRectMake(anonymityBtn.sh_right + 20,contentTextView.sh_bottom + 50,120,30);
    [synchronousBtn setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    synchronousBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [synchronousBtn horizontalCenterImageAndTitle:20];
    [self.view addSubview:synchronousBtn];

    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, synchronousBtn.sh_bottom, ScreenWidth,1);
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
    
    
}

// 文本开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    if([textView.text isEqualToString:@"写下购买体会和视同感受来帮助其他小伙伴评价大于50余的商品和超过10的字数有机会获得网币"]){
        textView.text=@" ";
        textView.textColor=[UIColor blackColor];
    }
    
 }

//输入框编辑完成以后，将视图恢复到原始状态
#pragma mark
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.textColor = [UIColor grayColor];
        textView.text= @"写下购买体会和视同感受来帮助其他小伙伴评价大于50余的商品和超过10的字数有机会获得网币";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.contentTextViews resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.contentTextViews resignFirstResponder];
}

- (void)commitClick
{

    if ([self.contentTextViews.text isEqualToString:@"写下购买体会和视同感受来帮助其他小伙伴评价大于50余的商品和超过10的字数有机会获得网币"])
    {
        [JKAlert alertText:@"请输入评价内容"];
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/order/evaluate"];
    
    if (self.starsCount == nil)
    {
        self.starsCount = @0;
    }
    
    NSDictionary *dict = @{@"goods_id":self.goodsId,@"content":self.contentTextViews.text,@"is_anonymity":@"1",@"stars":self.starsCount,@"order_id":self.orderId,@"parent_id":@"0",@"shop_id":self.shopId};

   
    __block typeof(self)weakself = self;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
 
        
        NSString *success = responseObject[@"result"][@"resultMessage"];
       NSString *resultCode = responseObject[@"result"][@"resultCode"];
        
        if ([resultCode isEqualToString:@"0"])
        {
            [JKAlert alertText:@"评价成功"];
            [weakself.navigationController popViewControllerAnimated:YES];
            
            NSDictionary *dict = @{@"orderId":self.orderId};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"popOrderVc" object:self userInfo:dict];
            
        }else
        {
            [JKAlert alertText:success];
            
        }
        
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [JKAlert alertText:@"评价出错"];
        
    }];

}

- (void)scoreClick:(NSNotification *)notifcation
{
    NSString *scar = [NSString stringWithFormat:@"%@",notifcation.userInfo[@"score"]];
   
    CGFloat scarCount = round([scar doubleValue]);
    
    self.starsCount = @(scarCount);
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavBar];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scoreClick:) name:@"scoreCount" object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitClick)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
}

- (void)setNavBar
{
    self.navigationItem.title = @"商品评价";
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



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
