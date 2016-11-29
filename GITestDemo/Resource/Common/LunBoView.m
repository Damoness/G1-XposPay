//
//  LunBoView.m
//  03-图片轮播器
//
//  Created by 周双双 on 15/11/3.
//  Copyright © 2015年 itheima. All rights reserved.
//

#import "LunBoView.h"
#define WIDTH self.scrollView.frame.size.width
#define HEIGHT self.scrollView.frame.size.height
//定时器时间
#define TIME 2.0f

@implementation LunBoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"123"]];
       
    }
    return self;
}
-(void)setViewWithArray:(NSArray *)imageArray type:(NSString *)type{
    self.count = imageArray.count;
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    //设置偏移量
    self.scrollView.contentSize = CGSizeMake(WIDTH * (self.count + 2), HEIGHT);
    //设置正页滑动
    self.scrollView.pagingEnabled = YES;
    //关闭弹簧效果
    self.scrollView.bounces = NO;
    //取消水平滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //设置代理
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    if ([type isEqualToString:@"url"]) {
       
        if (self.count != 0) {
            for (int i = 0; i < self.count; i++) {

                UIImageView *imageV = [[UIImageView alloc] init];
                //[imageV sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:[UIImage imageNamed:@"123"] options:(SDWebImageRetryFailed)];
                imageV.frame = CGRectMake(WIDTH * (i + 1), 0, WIDTH, HEIGHT);
                [self.scrollView addSubview:imageV];
            }
            
            UIImageView *imageV1 = [[UIImageView alloc] init];
            imageV1.backgroundColor = [UIColor blueColor];

            //[imageV1 sd_setImageWithURL:[NSURL URLWithString:[imageArray lastObject]] placeholderImage:[UIImage imageNamed:@"123"] options:(SDWebImageRetryFailed)];
            
            imageV1.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
            [self.scrollView addSubview:imageV1];

            UIImageView *imageV2 = [[UIImageView alloc] init];
            
           // [imageV2 sd_setImageWithURL:[NSURL URLWithString:[imageArray firstObject]] placeholderImage:[UIImage imageNamed:@"123"] options:(SDWebImageRetryFailed)];

            imageV2.frame = CGRectMake(WIDTH * (imageArray.count + 1), 0, WIDTH, HEIGHT);
            [self.scrollView addSubview:imageV2];
        }
    }else {
       if (self.count != 0) {
            for (int i = 0; i < self.count; i++) {
              NSString *imageName = imageArray[i];
              UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
              imageV.frame = CGRectMake(WIDTH * (i + 1), 0, WIDTH, HEIGHT);
              [self.scrollView addSubview:imageV];
        }
        UIImageView *imageV1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[imageArray lastObject]]];
        imageV1.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        [self.scrollView addSubview:imageV1];
        
        UIImageView *imageV2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageArray[0]]];
        imageV2.frame = CGRectMake(WIDTH * (imageArray.count + 1), 0, WIDTH, HEIGHT);
        [self.scrollView addSubview:imageV2];
    }
}
    //显示当前图片
    self.scrollView.contentOffset = CGPointMake(WIDTH, 0);
/**
 pageControl
 */
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(WIDTH / 2 - 20, HEIGHT - 20, 0, 0)];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    //当前选中的颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    self.pageControl.numberOfPages = imageArray.count;
    [self addSubview:self.pageControl];

    //定时器
    [self startTimer];
}

-(void)startTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIME target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    //多线程在进行其他操作时, 定时器正常工作
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)nextPage {
    NSInteger page = self.pageControl.currentPage;
    if (page == self.count - 1) {
        page = 0;
    }else {
        page++;
    }
    self.scrollView.contentOffset = CGPointMake((page + 1) * WIDTH, 0);
    self.pageControl.currentPage = page;
}

#pragma mark - 代理方法

//滚动中
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
   
    if (scrollView.contentOffset.x == WIDTH * (self.count + 1)) {
        scrollView.contentOffset = CGPointMake(WIDTH, 0);
    }
    
    if (scrollView.contentOffset.x == 0) {
        scrollView.contentOffset = CGPointMake(WIDTH * (self.count), 0);
    }
    
    if (scrollView.contentOffset.x > 0 && scrollView.contentOffset.x < [UIScreen mainScreen].bounds.size.width * (self.count)) {
        CGFloat page = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
        self.pageControl.currentPage = (int)(page - 0.5);
    }

}

//开始拖拽时调用
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //关闭定时器
    [self.timer invalidate];
}
//停止拖拽
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}

-(void)lunBoAction {
    
    
    
}

@end
