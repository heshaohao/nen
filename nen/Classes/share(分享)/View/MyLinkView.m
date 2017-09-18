//
//  MyLinkView.m
//  nen
//
//  Created by apple on 17/3/1.
//  Copyright © 2017年 nen. All rights reserved.
//

#import "MyLinkView.h"

@interface MyLinkView()
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;



@end
@implementation MyLinkView

- (void)setMyTheLink:(NSString *)myTheLink
{
    _myTheLink = myTheLink;
    
    NSLog(@"%@",myTheLink);
    
    self.linkLabel.text = myTheLink;
}


- (IBAction)duplicateBtn:(UIButton *)sender
{
    [JKAlert alertText:@"复制成功"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.linkLabel.text;
    
}
- (IBAction)sharBtn:(UIButton *)sender
{
    
   [[NSNotificationCenter defaultCenter] postNotificationName:@"shareMyTheLink" object:self];
    
}

@end
