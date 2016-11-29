//
//  WDCalculator.m
//  GITestDemo
//
//  Created by 吴狄 on 15/6/26.
//  Copyright (c) 2015年 Kyson. All rights reserved.
//

#import "WDCalculator.h"
#define Interval 1
#define BtBackgroundColor rgb(255,255,255,1)
@interface WDCalculator (){
    
    float _btWidth;
    float _btHeight;
   
    double _num1;
    double _num2;
    //NSMutableString *_str;
    BOOL  _plus;
}

@end

@implementation WDCalculator

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _initData];
    }
    
    return self;
}

-(void)_initData{
    
    _btWidth = (self.frame.size.width - 3 * Interval)/4;
    _btHeight = (self.frame.size.height - 3 * Interval)/4;
    //self.backgroundColor = [UIColor redColor];
    
    _num1 = -1;
    _num2 = 0;
    _plus = false;
    self.str = [[NSMutableString alloc]init];
     self.totalNum = 0;
    [self _initSubViews];
}


-(void)_initSubViews{
    //1-9
    for (int i = 0; i< 3; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((Interval + _btWidth)*j,(Interval + _btHeight)*i,_btWidth, _btHeight);
            NSString *num = [NSString stringWithFormat:@"3-%d",i*3+j+1];
            button.backgroundColor = BtBackgroundColor;
            [button setImage:[UIImage imageNamed:num] forState:UIControlStateNormal];
            button.tag = i*3+j+1;
            [button addTarget:self action:@selector(btAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
    
    //.
    UIButton *pointBt = [UIButton buttonWithType:UIButtonTypeCustom];
    pointBt.frame = CGRectMake(0, (Interval + _btHeight)*3, _btWidth, _btHeight);
    pointBt.backgroundColor = BtBackgroundColor;
    pointBt.tag = 10;
    //[pointBt setTitle:@"." forState:UIControlStateNormal];
    [pointBt setImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
    //[pointBt setImage:[UIImage imageNamed:@"point"] forState:UIControlStateHighlighted];
    //pointBt.titleLabel.font = [UIFont systemFontOfSize:50];
    [pointBt addTarget:self action:@selector(btAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pointBt];

    
    //0
    UIButton *zeroBt = [UIButton buttonWithType:UIButtonTypeCustom];
    zeroBt.frame = CGRectMake((Interval + _btWidth), (Interval + _btHeight)*3, _btWidth, _btHeight);
    zeroBt.backgroundColor = BtBackgroundColor;
    [zeroBt setImage:[UIImage imageNamed:@"3-0"] forState:UIControlStateNormal];
    zeroBt.tag = 0;
    [zeroBt addTarget:self action:@selector(btAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:zeroBt];
    
    //+
    UIButton *plusBt = [UIButton buttonWithType:UIButtonTypeCustom];
    plusBt.frame = CGRectMake((Interval + _btWidth)*2, (Interval + _btHeight)*3, _btWidth, _btHeight);
    plusBt.backgroundColor = BtBackgroundColor;
    [plusBt setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    plusBt.tag = 11;
    [plusBt addTarget:self action:@selector(btPlus:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:plusBt];
    
    
    //退格
    UIButton *deleteBt = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBt.frame = CGRectMake((Interval + _btWidth)*3, 0, _btWidth, _btHeight);
    deleteBt.backgroundColor = [UIColor blueColor];
    //[deleteBt setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    //[deleteBt setTitle:@"退" forState:UIControlStateNormal];
    [deleteBt setImage:[UIImage imageNamed:@"sc"] forState:UIControlStateNormal];
    deleteBt.tag = 12;
    [deleteBt addTarget:self action:@selector(btBack:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBt];
    
    //清除
    UIButton *clearBt = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBt.frame = CGRectMake((Interval + _btWidth)*3,(Interval + _btHeight),  _btWidth, _btHeight);
    clearBt.backgroundColor = [UIColor blueColor];
    //[clearBt setImage:[UIImage imageNamed:@"c"] forState:UIControlStateNormal];
    //[clearBt setTitle:@"清除" forState:UIControlStateNormal];
    [clearBt setImage:[UIImage imageNamed:@"clear"] forState:UIControlStateNormal];
    clearBt.tag = 13;
    [clearBt addTarget:self action:@selector(btClean:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearBt];
    
    
    //完成
    UIButton *finishBt = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBt.frame = CGRectMake((Interval + _btWidth)*3, (Interval + _btHeight)*2, _btWidth, _btHeight*2 + Interval);
    finishBt.tag = 14;
    finishBt.backgroundColor = [UIColor blueColor];
    //[finishBt setTitle:@"完成" forState:UIControlStateNormal];
    [finishBt setImage:[UIImage imageNamed:@"complete"] forState:UIControlStateNormal];
    [finishBt addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:finishBt];
}

//清零
-(void)btClean:(UIButton *)button{
    _num1 = -1;
    _num2 = 0;
    self.totalNum = 0;
    [self.str setString:@""];;
    
    if ([self.delegate respondsToSelector:@selector(WDCalculatorDidClick:)]) {
        [self.delegate WDCalculatorDidClick:self];
    }
}

//退格
-(void)btBack:(UIButton *)button{
    
    
    if(![self.str isEqualToString:@""]){
        [self.str deleteCharactersInRange:NSMakeRange([self.str length] -1, 1)]; //删除最后一个字符
         _num1 = [self.str doubleValue];
    }
    
    
    if (!_plus) {
        self.totalNum = _num1;
    }
    
    if ([self.delegate respondsToSelector:@selector(WDCalculatorDidClick:)]) {
        [self.delegate WDCalculatorDidClick:self];
    }
}

//+;
-(void)btPlus:(UIButton *)button{

    _plus = true;
    _num1 = -1;
    
}

//完成
-(void)done:(UIButton *)button{
    
    if (_plus) {
        self.totalNum += _num1;
        [self.str setString:[NSString stringWithFormat:@"%.2lf",self.totalNum]];
        _num1 = -1;
        _plus = false;
    }
    
    if ([self.delegate respondsToSelector:@selector(WDCalculatorDidClick:)]) {
        [self.delegate WDCalculatorDidClick:self];
    }
    
}

//0-9
-(void)btAction:(UIButton *)button{
    
    if (!_plus) {
        
        if (button.tag !=10) {
            [self.str appendString:[NSString stringWithFormat:@"%ld",(long)button.tag]];
        }else{
            if (![self.str containsString:@"."] && ![self.str isEqualToString:@""]) {
                [self.str appendString:@"."];
            }
            
        }
        
        _num1 = [self.str doubleValue];
        self.totalNum = _num1;
    }else{
        
        
        if (_num1 == -1) {
            [self.str setString:@""];
       
        }
        
        
        if (button.tag !=10) {
            [self.str appendString:[NSString stringWithFormat:@"%ld",(long)button.tag]];
        }else{
            if (![self.str containsString:@"."] && ![self.str isEqualToString:@""]) {
                [self.str appendString:@"."];
            }
        }
        _num1 = [self.str doubleValue];
        
    }
    
    
    //[self.str appendString:[NSString stringWithFormat:@"%ld",(long)button.tag]];
    //[self.str appendString:]

    
    if ([self.delegate respondsToSelector:@selector(WDCalculatorDidClick:)]) {
        [self.delegate WDCalculatorDidClick:self];
    }
    
}
@end
