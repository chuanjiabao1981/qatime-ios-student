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
        
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView.backgroundColor = NAVIGATIONRED;
        
        UIView *lanView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width_sd, 20)];
        lanView.backgroundColor = [UIColor blackColor];
        
//        [self addSubview:lanView];
    
    }
    return self;
}
/* 
 
 导航栏可以在页面推出来的时候，选择使用左右按钮和标题栏，使用get方法加载。
 
 */


- (UIView *)contentView{
    
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:self.bounds];
        [self addSubview:_contentView];
        
    }
    
    return _contentView;
}


/* 懒加载左右按钮和标题栏*/

- (UIButton *)leftButton{
    
    if (!_leftButton) {
        
        _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(10*ScrenScale, 25, 30*ScrenScale, 30*ScrenScale)];
        _leftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //    [_leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [self.contentView addSubview:_leftButton];
        
        [_leftButton setEnlargeEdge:20];
    }
    
    return _leftButton;
}

-(UIButton *)rightButton{
    
    if (!_rightButton) {
        
        _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width_sd-50*ScrenScale, 25, 30*ScrenScale, 30*ScrenScale)];
        [self.contentView addSubview:_rightButton];
        [_rightButton setEnlargeEdge:20];
    }
    
    return _rightButton;
    
}

-(UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 20, self.width_sd -240, 40)];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont systemFontOfSize:20*ScrenScale]];
        
    }
    
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
