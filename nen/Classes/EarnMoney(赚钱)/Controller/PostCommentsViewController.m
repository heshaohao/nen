//
//  PostCommentsViewController.m
//  nen
//
//  Created by nenios101 on 2017/5/12.
//  Copyright © 2017年 nen. All rights reserved.
// 帖子评论

#import "PostCommentsViewController.h"
#import "CommentsViewMode.h"
#import "CommentsTableViewCell.h"

@interface PostCommentsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) CommentsViewMode *commentDataModel;

// 回帖人数
@property(nonatomic,strong) NSMutableArray *replyDataArrsy;

@property(nonatomic,strong) CommentsTableViewCell *commentsCell;

@property(nonatomic,strong) UIView *bottomViews;

@property(nonatomic,strong) UITextView *contentTextViews;

@property(nonatomic,strong) UIButton *collectionBtns;

@property(nonatomic,copy) NSString *page;

@end

@implementation PostCommentsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    
    UITableView *tableV = [[UITableView alloc] init];
    self.tableView =tableV;
    tableV.frame = CGRectMake(0,0,ScreenWidth,ScreenHeight - 40);
    tableV.delegate = self;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableV.tableFooterView=[[UIView alloc]init];
    tableV.dataSource = self;
    [self.view addSubview:tableV];
    
    [self setNavBar];
    
    [self pulldownNews];

    [self addBottomView];
    
    
}


#pragma mark 设置导航栏
- (void)setNavBar
{
    self.navigationItem.title = @"帖子评论";
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
    
    UIButton *rightButton = [[UIButton alloc]init];
    self.collectionBtns = rightButton;
    rightButton.frame = CGRectMake(0, 0,KNavBarBackBtnW, KNavBarBackBtnH);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"SHOUCHANG1"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"SHOUCANG"] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(collectionBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItems = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    //解决按钮不靠左 靠右的问题.
    UIBarButtonItem *rightNagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    rightNagetiveSpacer.width = 5;   //这个值可以根据自己需要自己调整
    self.navigationItem.rightBarButtonItems = @[rightNagetiveSpacer,rightBarButtonItems];

    
    
    
    self.navigationController.navigationBar.barTintColor = KNavBarBarTintColor;

}

- (void)goBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 收藏按钮
- (void)collectionBtnClcik:(UIButton *)btn
{
    if (!btn.selected)
    {
        btn.selected = YES;
        
        [self collectAndCancelPostId:self.postId AddressStr:@"/post/collection"];
        
        
    }else
    {
        btn.selected = NO;
        [self collectAndCancelPostId:self.postId AddressStr:@"/post/cancel"];
    }
    
}

#pragma mark 收藏帖子和取消
- (void)collectAndCancelPostId:(NSString *)postId AddressStr:(NSString *)addresStr
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:addresStr];
    
   
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSDictionary *dict;
    
    if ([addresStr isEqualToString:@"/post/collection"])
    {
        dict = @{@"post_id":postId};
        [JKAlert alertText:@"帖子收藏成功"];
        
    }else
    {
        dict = @{@"id":postId};
        [JKAlert alertText:@"帖子取消收藏成功"];

    }
   
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
               
    
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];

    
}


#pragma mark 底部输入View
- (void)addBottomView
{
    UIView *bottomView = [[UIView alloc] init];
    self.bottomViews = bottomView;
    bottomView.frame = CGRectMake(0,ScreenHeight - 40,ScreenWidth,40);
    [self.view addSubview:bottomView];
    UIView *topLineView = [[UIView alloc] init];
    topLineView.frame = CGRectMake(0, 0, ScreenWidth, 1);
    [bottomView addSubview:topLineView];
    
    UITextView *contentTextView = [[UITextView alloc] init];
    self.contentTextViews = contentTextView;
    contentTextView.delegate = self;
    contentTextView.textColor = [UIColor colorWithHexString:@"#aaaaaa"];
    contentTextView.frame = CGRectMake(5,5,ScreenWidth *0.8,29);
    contentTextView.text = @"输入您想说的话";
    contentTextView.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    contentTextView.layer.borderWidth = 1.0f;
    contentTextView.font = [UIFont systemFontOfSize:13];
    contentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [bottomView addSubview:contentTextView];
    
    UIButton *sendBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(contentTextView.sh_right,0,ScreenWidth *0.2,40);
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    sendBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [bottomView addSubview:sendBtn];
    
}

#pragma mark 发送按钮点击事件

- (void)sendBtnClick
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/post/reply"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    NSDictionary *dict = @{@"content":self.contentTextViews.text,@"id":self.postId};
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
       // NSLog(@"%@",responseObject);
        
        [self.contentTextViews resignFirstResponder];
        
        self.contentTextViews.text = @"";
        
        [self pulldownNews];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
    
}

#pragma mark 返回tableView头部

- (UIView *)addHeadView
{
    // 计算帖子标题和内容文本最大的宽度和高度
    CGSize maxSize = CGSizeMake(ScreenWidth - 20, MAXFLOAT);
    
    UIView *headerView = [[UIView alloc] init];
    // 帖子标题
    UILabel  *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.font = [UIFont systemFontOfSize:13];
    NSString *titleStr = self.commentDataModel.title;
    titleLabel.text = titleStr;
    // 根据字体返回高度和宽度
    NSDictionary *titleAttrs = @{NSFontAttributeName : titleLabel.font};
    CGSize titleSize = [titleStr boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading attributes:titleAttrs context:nil].size;
    titleLabel.frame = CGRectMake(10,15,titleSize.width,titleSize.height);
    [headerView addSubview:titleLabel];
    // 判断标题的宽度进行居中
    if (titleLabel.sh_width < ScreenWidth - 20)
    {
        titleLabel.sh_width = ScreenWidth - 20;
        titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    // 帖子内容
    UILabel  *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.textColor = [UIColor lightGrayColor];
     // 根据字体返回高度和宽度
    NSString *contentStr = self.commentDataModel.content;
    contentLabel.text = contentStr;
    NSDictionary *contentAttrs = @{NSFontAttributeName : contentLabel.font};
    CGSize contrntSize = [contentStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:contentAttrs context:nil].size;
    contentLabel.frame = CGRectMake(10,titleLabel.sh_bottom + 10,contrntSize.width,contrntSize.height);
    [headerView addSubview:contentLabel];
    
    // 判断是否有图片
    UIView *imageView= [[UIView alloc] init];
    [headerView addSubview:imageView];
    
    // imageView图片容器的高度
    if (self.commentDataModel.post_img.count > 6)
    {
        imageView.frame = CGRectMake(0,contentLabel.sh_bottom + 10,ScreenWidth,310);
    }if (self.commentDataModel.post_img.count > 3 && self.commentDataModel.post_img.count <= 6 )
    {
        imageView.frame = CGRectMake(0,contentLabel.sh_bottom + 10,ScreenWidth,220);
    }if (self.commentDataModel.post_img.count > 0 && self.commentDataModel.post_img.count <= 3 )
    {
        imageView.frame = CGRectMake(0,contentLabel.sh_bottom + 10,ScreenWidth,130);
    }
    
     // imageView图片容器的高度
    if (self.commentDataModel.post_img.count >0 ) {
        
        if (self.commentDataModel.post_img.count < 3)
        {
            imageView.sh_height = 130;
        }
        
        [self.commentDataModel.post_img enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //控制总列数
        
            int totalColumns = 3;
            CGFloat Y = 10;
            CGFloat W = (ScreenWidth - 20) / 3;
            CGFloat H = 130;
            CGFloat X = (ScreenWidth - totalColumns * W) / (totalColumns + 1);
        
            NSString *imageStr = [NSString stringWithFormat:@"img%@",@1];
            
            UIImageView *iconImage = [[UIImageView alloc] init];
            [iconImage sd_setImageWithURL:[NSURL URLWithString:obj[imageStr]]];
            //行号
            CGFloat row = idx / totalColumns;
            int col = idx % totalColumns;
            CGFloat viewX = X + col * (W + X);
            CGFloat viewY =  row * (H + Y);
           
            iconImage.frame = CGRectMake(viewX, viewY, W,H);
            
            [imageView addSubview:iconImage];
            
        }];
    
    }else
    {
        imageView.sh_height = 0;
        imageView.hidden = YES;
    }
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.sh_x = ScreenWidth *0.6;
    timeLabel.sh_width = 80;
    timeLabel.sh_height =20;

    timeLabel.sh_y = imageView.sh_height<= 0 ?  contentLabel.sh_bottom + 20 : imageView.sh_bottom + 20;
    timeLabel.font = [UIFont systemFontOfSize:11];
    timeLabel.textColor = [UIColor lightGrayColor];
    NSString *timeStr = self.commentDataModel.create_time;
    timeLabel.text = [timeStr substringWithRange:NSMakeRange(0, 10)];
    [headerView addSubview:timeLabel];
    
    
    UILabel *userLabel = [[UILabel alloc] init];
    userLabel.sh_x = timeLabel.sh_right + 10;
    userLabel.sh_width = 40;
    userLabel.sh_height =20;
    userLabel.sh_y = timeLabel.sh_y;
    userLabel.font = [UIFont systemFontOfSize:11];
    userLabel.textColor = [UIColor lightGrayColor];
    userLabel.text = self.commentDataModel.user_name;
    [headerView addSubview:userLabel];

    
    UILabel *commentsLabel = [[UILabel alloc] init];
    commentsLabel.sh_x = 10;
    commentsLabel.sh_width = ScreenWidth *0.8;
    commentsLabel.sh_height =20;
    commentsLabel.sh_y = userLabel.sh_bottom + 10;
    commentsLabel.font = [UIFont systemFontOfSize:13];
    commentsLabel.textColor = [UIColor blackColor];
    
    if (self.commentDataModel.reply.count >0 )
    {
        commentsLabel.text = @"评论区 (看看都有哪些评论吧)";
        
    }else
    {
        commentsLabel.text = @"暂无评论,去评论第一个";
    }
    
    [headerView addSubview:commentsLabel];
    
    headerView.sh_x = 0;
    headerView.sh_y = - 99;
    headerView.sh_width = ScreenWidth;
    headerView.sh_height = commentsLabel.sh_bottom + 10;
    
    return headerView;
    
    
}


#pragma mark 下拉刷新
- (void)pulldownNews
{
    
    // 点击进入立即刷新
    self.tableView.mj_header = [SHRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}
#pragma mark 下来刷新
- (void)loadNewData
{
    [self pullUpNews];
    self.page = @"1";
    __weak UITableView *tableView = self.tableView;

    [CommentsViewMode CommentsModelPostsID:self.postId PageSize:@"8" Page:self.page success:^(CommentsViewMode *commentsMolde) {
            
        self.commentDataModel = commentsMolde;

        self.replyDataArrsy = self.commentDataModel.reply;
        
        // 帖子是否收藏
        self.collectionBtns.selected = [self.commentDataModel.is_collection isEqualToString:@"1"] ? YES : NO;
        
        // 帖子回复人数
        if (self.replyDataArrsy.count)
        {
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            
        }
        tableView.tableHeaderView = [self addHeadView];
        
        [tableView reloadData];
            
            [tableView.mj_header endRefreshing];
        } error:^{
            
            [tableView.mj_header endRefreshing];
            
        }];
        
   }
#pragma mark 上啦刷新
- (void)pullUpNews
{
    // 设置回调
    self.tableView.mj_footer = [SHRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
}
#pragma mark 上啦刷新
- (void)loadMoreData
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 每次下拉页数加1
    self.page = [NSString stringWithFormat:@"%d",[self.page integerValue] + 1];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    __weak UITableView *tableView = self.tableView;
    [CommentsViewMode CommentsModelPostsID:self.postId PageSize:@"12" Page:self.page success:^(CommentsViewMode *commentsMolde) {
        
        [self.replyDataArrsy arrayByAddingObjectsFromArray:commentsMolde.reply];
        
        [tableView reloadData];
        [tableView.mj_footer endRefreshing];
        
    } error:^{
        NSLog(@"失败");
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentDataModel.reply.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"cell";
    CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    if (!cell) {
        cell = [[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    
    cell.replyDataDict = self.commentDataModel.reply[indexPath.row];
    self.commentsCell = cell;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.commentsCell returnHight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.contentTextViews resignFirstResponder];
}


#pragma mark - UITextViewDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];

    return YES;
}
// 文本开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    if([textView.text isEqualToString:@"输入您想说的话"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
    
    
    int offset = self.view.frame.origin.y - 280;//iPhone键盘高
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.transform = CGAffineTransformMakeTranslation(0, offset);
        self.bottomViews.transform =CGAffineTransformMakeTranslation(0, offset);
        // self.identityBtn.transform =CGAffineTransformMakeTranslation(0, offset);
    }];
}

//输入框编辑完成以后，将视图恢复到原始状态
#pragma mark
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
    textView.textColor = [UIColor grayColor];
    }
    
    
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.transform = CGAffineTransformIdentity;
        self.bottomViews.transform = CGAffineTransformIdentity;
    }];
    
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



@end
