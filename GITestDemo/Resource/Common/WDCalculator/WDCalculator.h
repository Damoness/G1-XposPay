//
//  WDCalculator.h
//  GITestDemo
//
//  Created by 吴狄 on 15/6/26.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import <UIKit/UIKit.h>



@class WDCalculator;
@protocol WDCalculatorDelegate <NSObject>
-(void)WDCalculatorDidClick:(WDCalculator *)WDCalculator;

@end
@interface WDCalculator : UIView


@property (nonatomic) double totalNum; //计算出的总金额
@property (nonatomic) NSMutableString *str; //字符串




@property (nonatomic, weak) id <WDCalculatorDelegate>delegate;
@end
