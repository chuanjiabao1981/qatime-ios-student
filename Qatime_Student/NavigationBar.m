//
//  NavigationBar.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "NavigationBar.h"

@implementation NavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(frame)-0.8, CGRectGetWidth(frame), 0.8)];
        [self addSubview:line];
        line.backgroundColor  =[UIColor lightGrayColor];
        
    
    }
    return self;
}
/* 
 
 导航栏可以在页面推出来的时候，选择使用左右按钮和标题栏，使用get方法加载。
 
 */


/* 懒加载左右按钮和标题栏*/

- (UIButton *)leftButton{
    
    _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 30, 30, 30)];
    [self addSubview:_leftButton];

    return _leftButton;
}

-(UIButton *)rightButton{
    
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-40), 20, 40, 40)];
    [self addSubview:_rightButton];

    return _rightButton;
    
    
}

-(UILabel *)titleLabel{
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, CGRectGetWidth(self.frame)-120, 40)];
    [self addSubview:_titleLabel];
    
    
    [_titleLabel setTextColor:[UIColor redColor]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setFont:[UIFont systemFontOfSize:20]];
    
    
    return  _titleLabel;
    
}


/* 创建导航栏的类方法*/
+(instancetype)navigationBarWithFrame:(CGRect)frame title:(NSString *)title backgroundColor:(BackgroundColorType)colortype {
    
    NavigationBar *bar=[[NavigationBar alloc]initWithFrame:frame];
    [bar.titleLabel setText:title];
    if (colortype == DefaultColor) {
        bar.backgroundColor = USERGREEN;
    }
    if (colortype == RedColor) {
        
        bar.backgroundColor = [UIColor redColor];
    }
    
    return bar;
    
}


@end
