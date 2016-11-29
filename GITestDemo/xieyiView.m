//
//  xieyiView.m
//  GITestDemo
//
//  Created by WS on 15/10/11.
//  Copyright © 2015年 Kyson. All rights reserved.
//

#import "xieyiView.h"


@interface xieyiView ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation xieyiView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"xieyiView" owner:nil options:nil];
        self  =  [arr objectAtIndex:0];
  //修改
        NSString* path = [[NSBundle mainBundle] pathForResource:@"agreementt1" ofType:@"html"];
       // NSString* path = [[NSBundle mainBundle] pathForResource:@"agreementt" ofType:@"html"];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [self.webView loadRequest:request];
        
    }
    return self;
}


- (IBAction)cancleBtn:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(xieyiViewCancleBtnChick)]) {
        [self.delegate xieyiViewCancleBtnChick];
    }
}

@end
