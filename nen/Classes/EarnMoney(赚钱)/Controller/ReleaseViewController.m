//
//  ReleaseViewController.m
//  nen
//
//  Created by apple on 17/5/16.
//  Copyright © 2017年 nen. All rights reserved.
// 帖子发布

#import "ReleaseViewController.h"

@interface ReleaseViewController ()<UIScrollViewDelegate,UITextViewDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) UITextView *titleTextViews;

@property(nonatomic,strong) UITextView *contentTextViews;

@property(nonatomic,strong) UIView *contentViews;

@property(nonatomic,strong) CADisplayLink *displayLink;

@end

@implementation ReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavBar];
    UIScrollView *scr = [[UIScrollView alloc] init];
    self.scrollView = scr;
    scr.delegate = self;
    scr.frame = CGRectMake(0, 0,ScreenWidth,ScreenHeight - 30);
    scr.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    [self.view addSubview:scr];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(10,10,ScreenWidth - 20, 20);
    titleLabel.text = @"帖子标题:";
    titleLabel.font = [UIFont systemFontOfSize:13];
    [scr addSubview:titleLabel];
    
    UITextView *titleTextViews = [[UITextView alloc] init];
    self.titleTextViews = titleTextViews;
    titleTextViews.delegate = self;
    titleTextViews.contentInset = UIEdgeInsetsMake(-2,0,0,0);
    titleTextViews.textColor = [UIColor lightGrayColor];
    titleTextViews.frame = CGRectMake(10,titleLabel.sh_bottom + 5,ScreenWidth - 20,25);
    titleTextViews.text = @"输入您想说的话";
    titleTextViews.backgroundColor = [UIColor gainsboroColor];
    titleTextViews.layer.borderWidth = 1.0f;
    titleTextViews.font = [UIFont systemFontOfSize:11];
    titleTextViews.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [scr addSubview:titleTextViews];
    
    UILabel *contreLabel = [[UILabel alloc] init];
    contreLabel.frame = CGRectMake(10,titleTextViews.sh_bottom + 20,ScreenWidth - 20, 20);
    contreLabel.text = @"帖子内容:";
    contreLabel.font = [UIFont systemFontOfSize:13];
    [scr addSubview:contreLabel];
    
    UIView *contentView = [[UIView alloc] init];
    self.contentViews = contentView;
    contentView.frame = CGRectMake(2,contreLabel.sh_bottom + 5,ScreenWidth - 4,200);
    contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    contentView.layer.borderWidth = 1.0f;
    [scr addSubview:contentView];
    
    UITextView *contentTextViews = [[UITextView alloc] init];
    self.contentTextViews = contentTextViews;
    contentTextViews.delegate = self;
    contentTextViews.contentInset = UIEdgeInsetsMake(-4,0,0,0);
    contentTextViews.textColor = [UIColor lightGrayColor];
    contentTextViews.frame = CGRectMake(8,contentView.sh_y + 5,ScreenWidth - 20,25);
    contentTextViews.text = @"输入您想说的话";
    contentTextViews.font = [UIFont systemFontOfSize:14];
    [scr addSubview:contentTextViews];

    [self initPickerView];
    self.maxCount = 9;
    
    [self updatePickerViewFrameY:contentTextViews.sh_bottom + 65];
    
    CGRect pickerViewFrame = [self getPickerViewFrame];
    
    contentView.sh_height = pickerViewFrame.origin.y;
    
    UIButton *releaseBtn= [[UIButton alloc] init];
    releaseBtn.frame = CGRectMake(0,ScreenHeight - 30,ScreenWidth,30);
    [releaseBtn setBackgroundColor:[UIColor orangeColor]];
    [releaseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [releaseBtn setTitle:@"发布帖子" forState:UIControlStateNormal];
    [releaseBtn addTarget:self action:@selector(releasePost) forControlEvents:UIControlEventTouchUpInside];
    releaseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:releaseBtn];
    
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(action) userInfo:nil repeats:YES];
     [[NSRunLoop mainRunLoop] addTimer:timer forMode: UITrackingRunLoopMode];
    
}


- (void)baseContVcClick
{
    [self.pickerCollectionView reloadData];
}

#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"发帖";
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

#pragma mark 发布按钮事件
- (void)releasePost
{
  
    if ([self.titleTextViews.text isEqualToString:@"输入您想说的话"])
    {
        [JKAlert alertText:@"请输入发表标题"];
        return;
    }
    
    if ([self.contentTextViews.text isEqualToString:@"输入您想说的话"])
    {
        [JKAlert alertText:@"请输入发表内容"];
        return;
    }
    
    
    NSArray *imgarArray = [self getSmallImageArray];
   AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   
   manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
   NSString *completeStr = [NSString stringEncryptedAddress:@"/post/new"];
    
    NSDictionary *dict = @{@"title":self.titleTextViews.text,@"content":self.contentTextViews.text,@"img_total":@(imgarArray.count),@"type":self.type};
    
    //上传的参数(上传图片，以文件流的格式)
    
    [manager POST:completeStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
      
        
        for (int i = 0;i < imgarArray.count; i++)
        {
            UIImage *image = imgarArray[i];
            
            NSData *data = UIImagePNGRepresentation(image);
            
            //上传的参数(上传图片，以文件流的格式)
            
            [formData appendPartWithFileData:data
             
                                        name:[NSString stringWithFormat:@"img%d",i+1]
             
                                   // 文件夹名称要根据安卓端一样 否者报错或者上传图片失败
                                    fileName:@"note.jpg"
             
                                    mimeType:@"image/png"];
            
        }
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
       // NSLog(@"%@",responseObject);
        
        [JKAlert alertText:@"发布成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark 定时每一秒获取PickerView的高度
- (void)action
{
    NSArray *imageArray = [self getALAssetArray];
    
    
    if (imageArray.count >= 1 && imageArray.count < 3)
    {
        self.contentViews.sh_height = 125 + self.contentTextViews.sh_height;
        self.scrollView.contentSize = CGSizeMake(0,self.contentViews.sh_bottom);
    }
    if (imageArray.count >= 3 && imageArray.count < 6 )
    {
        self.contentViews.sh_height = 250 + self.contentTextViews.sh_height;
        self.scrollView.contentSize = CGSizeMake(0,self.contentViews.sh_bottom);
    }
    if (imageArray.count >= 6) {
       self.contentViews.sh_height = 370 + self.contentTextViews.sh_height;
        self.scrollView.contentSize = CGSizeMake(0,self.contentViews.sh_bottom);
    }

}


// 文本开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    if([textView.text isEqualToString:@"输入您想说的话"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
    
    
}

//输入框编辑完成以后，将视图恢复到原始状态
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"输入您想说的话";
        textView.textColor = [UIColor grayColor];
    }
    
 }

// UITextView 每此输入字符都会走该方法
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self.titleTextViews resignFirstResponder];
        [self.contentTextViews resignFirstResponder];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    if (textView == self.contentTextViews)
    {
        CGRect frame = textView.frame;
        float  height = [self heightForTextView:textView WithText:textView.text];
        frame.size.height = height;
        [UIView animateWithDuration:0.1 animations:^{
            
            textView.frame = frame;
            [self updatePickerViewFrameY:textView.sh_bottom + 65];
            
            CGRect pickerViewFrame = [self getPickerViewFrame];
            self.contentViews.sh_height = pickerViewFrame.origin.y;
            
        } completion:nil];
        
    }

    
    return YES;
}

// 根据textView中的文字返回动态显示高度
- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(ScreenWidth - 20 , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height + 15.0;
    return textHeight;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.titleTextViews resignFirstResponder];
    [self.contentTextViews resignFirstResponder];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(baseContVcClick) name:@"baseContVc" object:nil];
    self.navigationController.navigationBarHidden = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
