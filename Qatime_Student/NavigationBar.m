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
        
//        [self.contentView updateLayout];
//        [self updateLayout];
    
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
        _leftButton = [[UIButton alloc]init];
        _leftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_leftButton];
//        [self.contentView updateLayout];
        _leftButton.sd_layout
        .leftSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(self.contentView, [UIApplication sharedApplication].statusBarFrame.size.height+5)
        .widthIs(30*ScrenScale)
        .heightEqualToWidth();
        [_leftButton setEnlargeEdge:20];
    }
    
    return _leftButton;
}

-(UIButton *)rightButton{
    
    if (!_rightButton) {
        _rightButton = [[UIButton alloc]init];
        [self.contentView addSubview:_rightButton];
        _rightButton.sd_layout
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(self.contentView, [UIApplication sharedApplication].statusBarFrame.size.height+5)
        .widthIs(30*ScrenScale)
        .heightEqualToWidth();
        [_rightButton setEnlargeEdge:20];
    }
    
    return _rightButton;
    
}

-(UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 20, self.width_sd -240, 40)];
        [self.contentView addSubview:_titleLabel];
        [self updateLayout];
        _titleLabel.sd_layout
        .leftSpaceToView(self.contentView, 120)
        .topSpaceToView(self.contentView, [UIApplication sharedApplication].statusBarFrame.size.height)
        .widthIs(self.width_sd-240)
        .heightIs(40);
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
