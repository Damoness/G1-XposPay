//
//  LunBoView.h
//  03-图片轮播器
//
//  Created by 周双双 on 15/11/3.
//  Copyright © 2015年 itheima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LunBoView : UIView<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;

-(void)setViewWithArray:(NSArray *)imageArray type:(NSString *)type;
-(void)lunBoAction;
@end
