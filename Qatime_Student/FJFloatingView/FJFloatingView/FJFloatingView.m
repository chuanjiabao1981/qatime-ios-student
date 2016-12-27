//
//  DJFloatingVoiceView.m
//  DeJiaIM
//
//  Created by fjf on 16/5/16.
//  Copyright © 2016年 tsningning. All rights reserved.
//

#import "FJFloatingView.h"
#import "UIGestureRecognizer+Block.h"


////获取当前屏幕的宽高
#define  SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define  SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

// 十六进制RGB颜色 格式为（0xffffff）
#define FJColorFromRGBA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]


@interface FJFloatingView()
{
    CGPoint beganPoint; //开始的坐标
    CGPoint _curPoint;
}
@property (nonatomic, strong) UIView *tmpView;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation FJFloatingView
-(instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initTmpView];
      
        _canMove = NO;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        
        [self addGestureRecognizer:_pan];
        
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


#pragma mark --- 初始操作
//初始化tmpView(用于计算位置)
- (void)initTmpView{
    self.tmpView = [[UIView alloc] init];
    self.tmpView.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topEqualToView(self)
    .bottomEqualToView(self);
    [self.tmpView updateLayout];
}

////初始化图片
//- (void)initImageView{
//    self.userInteractionEnabled = YES;
//    self.backgroundColor = [UIColor clearColor];
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    imageView.image = [UIImage imageNamed:@"zb_bg"];
//    [self addSubview:imageView];
//    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(23, 15, 22, 22)];
//    imageView1.image = [UIImage imageNamed:@"icon_zb"];
//    [self addSubview:imageView1];
//}

////初始化tipLabel
//- (void)initTipLabel{
//    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 36, self.frame.size.width, 32)];
//    self.tipLabel.text = @"呼叫中";
//    self.tipLabel.font = [UIFont systemFontOfSize:10.0f];
//    self.tipLabel.textAlignment = NSTextAlignmentCenter;
//    self.tipLabel.textColor = [UIColor whiteColor];
//    [self addSubview:self.tipLabel];
//}


#pragma mark --- 手势事件
-(void)pan:(UIPanGestureRecognizer *)sender{
    
    if (_canMove==YES) {
        
        switch (sender.state) {
            case UIGestureRecognizerStateBegan:
            {
                beganPoint = [sender locationInView:self.superview];
                _curPoint = self.center;
            }
                break;
            case UIGestureRecognizerStateChanged:
            {
                CGPoint point = [sender locationInView:self.superview];
                
                NSInteger x_offset = point.x - beganPoint.x;
                NSInteger y_offset = point.y - beganPoint.y;
                self.tmpView.center = self.center;
                self.tmpView.center = CGPointMake(_curPoint.x + x_offset, _curPoint.y + y_offset);
                if (CGRectGetMinX(self.tmpView.frame) < 0){
                    x_offset -= CGRectGetMinX(self.tmpView.frame);
                }
                if (CGRectGetMaxX(self.tmpView.frame) > SCREEN_WIDTH) {
                    x_offset += SCREEN_WIDTH - CGRectGetMaxX(self.tmpView.frame);
                }
                if (CGRectGetMinY(self.tmpView.frame) < 0) {
                    y_offset -= CGRectGetMinY(self.tmpView.frame);
                }
                if (CGRectGetMaxY(self.tmpView.frame) > SCREEN_HEIGHT) {
                    y_offset += SCREEN_HEIGHT - CGRectGetMaxY(self.tmpView.frame);
                }
                self.center = CGPointMake(_curPoint.x + x_offset, _curPoint.y + y_offset);
            }
                break;
                
            case UIGestureRecognizerStateEnded:
                break;
            default:
                break;
        }
    }else{
        
    }
    
}


- (void)dealloc{

}
@end
