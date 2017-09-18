//
//  ReplyTheBuyerViewController.m
//  nen
//
//  Created by nenios101 on 2017/7/6.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "ReplyTheBuyerViewController.h"
#import "ShopGoodsCommentsModel.h"

@interface ReplyTheBuyerViewController ()<UITextViewDelegate>

@property (nonatomic,strong) UITextView *textViews;
@end

@implementation ReplyTheBuyerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F0F0F0"];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = self.model.goods_name;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.frame = CGRectMake(10,84,ScreenWidth - 10,25);
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:titleLabel];
    
    UILabel *detaileLabel = [[UILabel alloc] init];
    detaileLabel.text = self.model.content;
    detaileLabel.font = [UIFont systemFontOfSize:15];
    detaileLabel.frame = CGRectMake(10,titleLabel.sh_bottom,ScreenWidth - 10,60);
    detaileLabel.numberOfLines = 0;
    detaileLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:detaileLabel];
    
    UILabel *shoprelpLabel = [[UILabel alloc] init];
    shoprelpLabel.frame = CGRectMake(10,detaileLabel.sh_bottom + 30,100,30);
    shoprelpLabel.font = [UIFont systemFontOfSize:17];
    shoprelpLabel.text = @"商家回复";
    [self.view addSubview:shoprelpLabel];
    
    
    UITextView *textView = [[UITextView alloc] init];
    self.textViews = textView;
    [textView setAutocorrectionType:UITextAutocorrectionTypeNo];
    textView.font = [UIFont systemFontOfSize:15];
    [textView setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    textView.frame = CGRectMake(10,shoprelpLabel.sh_bottom + 10,ScreenWidth - 20,60);
    textView.text = @"商家回复内容:";
    textView.textColor = [UIColor grayColor];
    textView.layer.borderWidth = 2;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.clipsToBounds = YES;
    textView.layer.cornerRadius = 5;
    textView.delegate = self;
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:textView];

    
    UIButton *submitBtn = [[UIButton alloc] init];
    submitBtn.frame = CGRectMake(10, textView.sh_bottom + 30, ScreenWidth - 20 , 35);
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.layer.cornerRadius = 5;
    submitBtn.clipsToBounds = YES;
    [submitBtn setBackgroundColor:[UIColor colorWithHexString:@"#FF5001"]];
    [submitBtn addTarget:self action:@selector(replySubmitClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:submitBtn];

    
}

#pragma mark 提交回复
- (void)replySubmitClick
{
    if ([self.textViews.text isEqualToString:@"商家回复内容:"])
    {
        [JKAlert alertText:@"请输入回复内容"];
        return;
        
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    NSString *splitCompleteStr = [NSString stringEncryptedAddress:@"/order/evaluate"];
    
    NSDictionary *dict = @{@"goods_id":self.model.goods_id,@"content":self.textViews.text,@"is_anonymity":@"1",@"stars":self.model.star,@"order_id":self.model.order_id,@"parent_id":self.model.id,@"shop_id":self.model.shop_id};
    
    
    __block typeof(self)weakself = self;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html",@"text/javascript", nil];
    
    [manager POST:splitCompleteStr parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
    
        
        NSString *success = responseObject[@"result"][@"resultMessage"];
        if ([success isEqualToString:@"SUCCESS"])
        {
            [JKAlert alertText:@"评价成功"];
            [weakself.navigationController popViewControllerAnimated:YES];
            
            
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [JKAlert alertText:@"评价错误"];
        
    }];
 
    
    
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textViews resignFirstResponder];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"商家回复内容:";
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"商家回复内容:"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
