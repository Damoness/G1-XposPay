//
//  xieyiView.h
//  GITestDemo
//
//  Created by WS on 15/10/11.
//  Copyright © 2015年 Kyson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol xieyiViewDelegate <NSObject>

@optional
- (void)xieyiViewCancleBtnChick;

@end

@interface xieyiView : UIView

@property (nonatomic, weak) id<xieyiViewDelegate> delegate;

@end
