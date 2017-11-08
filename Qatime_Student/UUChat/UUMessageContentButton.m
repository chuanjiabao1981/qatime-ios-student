//
//  UUMessageContentButton.m
//  BloodSugarForDoc
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 shake. All rights reserved.
//

#import "UUMessageContentButton.h"

@interface UUMessageContentButton ()

@property(nonatomic,strong) YYTextView  *tView ;

@end

@implementation UUMessageContentButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //图片
        self.backImageView = [[UIImageView alloc]init];
        self.backImageView.userInteractionEnabled = YES;
        self.backImageView.layer.cornerRadius = 5;
        self.backImageView.layer.masksToBounds  = YES;
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.backImageView];
        
        //语音
        self.voiceBackView = [[UIView alloc]init];
        [self addSubview:self.voiceBackView];
        self.second = [[UILabel alloc]init];
        self.second.frame =CGRectMake(5, self.voiceBackView.centerY_sd, 70, 30);
        self.second.textAlignment = NSTextAlignmentLeft;
        self.second.textColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1.00];
        self.second.font = [UIFont systemFontOfSize:13];
        self.voice = [[UIImageView alloc]initWithFrame:CGRectMake(80, 5, 20, 20)];
        self.voice.image = [UIImage imageNamed:@"chat_animation_white3"];
        self.voice.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"chat_animation_white1"],
                                      [UIImage imageNamed:@"chat_animation_white2"],
                                      [UIImage imageNamed:@"chat_animation_white3"],nil];
        self.voice.animationDuration = 1;
        self.voice.animationRepeatCount = 0;
        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.indicator.center=CGPointMake(80, 15);
        [self.voiceBackView addSubview:self.indicator];
        [self.voiceBackView addSubview:self.voice];
        [self.voiceBackView addSubview:self.second];
        
        self.backImageView.userInteractionEnabled = NO;
        self.voiceBackView.userInteractionEnabled = NO;
        self.second.userInteractionEnabled = NO;
        self.voice.userInteractionEnabled = NO;
        
        self.second.backgroundColor = [UIColor clearColor];
        self.voice.backgroundColor = [UIColor clearColor];
        self.voiceBackView.backgroundColor = [UIColor clearColor];
        
        /* 使用yytext改写*/
        /* 文字*/
        
        self.title = [[YYLabel alloc]init];
        [self addSubview:self.title];
        [self bringSubviewToFront:self.title];
        self.title.numberOfLines = 0;
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.userInteractionEnabled = YES;
        self.title.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        self.contentTextView = [[YYTextView alloc]init];
        
//        self.backImageView.userInteractionEnabled = YES;
        
        [self addSubview:_contentTextView];
        [self bringSubviewToFront:_contentTextView];
        self.contentTextView.textAlignment = NSTextAlignmentCenter;
        self.contentTextView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        self.contentTextView.hidden = NO;
        
    }
    return self;
}



- (void)benginLoadVoice
{
    self.voice.hidden = YES;
    [self.indicator startAnimating];
}
- (void)didLoadVoice
{
    self.voice.hidden = NO;
    [self.indicator stopAnimating];
    [self.voice startAnimating];
}
-(void)stopPlay{
    
    [self.voice stopAnimating];
    
}

- (void)setIsMyMessage:(BOOL)isMyMessage
{
    _isMyMessage = isMyMessage;
    
    if (isMyMessage) {
        self.backImageView.frame = CGRectMake(5, 5, 220, 220);
        self.voiceBackView.frame = CGRectMake(15,5 , 130, 35);
        self.second.textColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1.00];
    }else{
        self.backImageView.frame = CGRectMake(5, 5, 220, 220);
        self.voiceBackView.frame = CGRectMake(-10, 5, 130, 35);
        self.second.textColor = [UIColor colorWithRed:0.43 green:0.43 blue:0.43 alpha:1.00];
    }
}
//添加
- (BOOL)canBecomeFirstResponder{
    
        return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copy:));
//    return YES;
}

-(void)copy:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.titleLabel.text;
}


- (YYLabel *)title{
    
    YYLabel *label = [[YYLabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    return  label;
    
}






@end
