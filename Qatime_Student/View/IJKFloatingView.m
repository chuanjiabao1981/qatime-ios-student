//
//  IJKFloatingView.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/30.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "IJKFloatingView.h"
#import "UIGestureRecognizer+Block.h"


////获取当前屏幕的宽高
#define  SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define  SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

// 十六进制RGB颜色 格式为（0xffffff）
#define FJColorFromRGBA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

@interface IJKFloatingView ()<NSCopying,NSMutableCopying,NSCoding>
{
    CGPoint beganPoint; //开始的坐标
    CGPoint _curPoint;
}
@property (nonatomic, strong) UIView *tmpView;
@property (nonatomic, strong) UILabel *tipLabel;
@end

@implementation IJKFloatingView

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
                
            case UIGestureRecognizerStateEnded:{
                if (self.origin_sd.x<0) {
                    
                    
                    /* 移动到屏幕边缘的时候回弹*/
                    [UIView animateWithDuration:0.3 animations:^{
                        self.frame = CGRectMake(0, self.origin_sd.y, self.width_sd, self.height_sd);
                        
                    }];
                    
                }
                
                if (self.origin_sd.x+self.width_sd>SCREEN_WIDTH) {
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        self.frame = CGRectMake(SCREEN_WIDTH-self.width_sd, self.origin_sd.y, self.width_sd, self.height_sd);
                        
                    }];
                    
                }
                if (self.origin_sd.y<0) {
                    [UIView animateWithDuration:0.3 animations:^{
                        self.frame = CGRectMake(self.origin_sd.x, 0, self.width_sd, self.height_sd);
                        
                    }];
                    
                }
                
                if (self.origin_sd.y+self.height_sd>SCREEN_HEIGHT) {
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        self.frame = CGRectMake(self.origin_sd.x, SCREEN_HEIGHT-self.height_sd, self.width_sd, self.height_sd);
                        
                    }];
                    
                }
                
                
                
            }
                break;
            default:
                break;
        }
    }else{
        
    }
    
}

- (id)copyWithZone:(NSZone *)zone {
    id copyInstance = [[[self class] allocWithZone:zone] init];
    size_t instanceSize = class_getInstanceSize([self class]);
    memcpy((__bridge void *)(copyInstance), (__bridge const void *)(self), instanceSize);
    return copyInstance;
    
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return [self copyWithZone:zone];
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned  int  count;
    Ivar * vars =   class_copyIvarList([self class], &count);
    for (int i = 0 ; i < count; i ++) {
        Ivar var = vars[i];
        char * s  =  (char*)ivar_getName(var);
        NSString * key =[NSString stringWithUTF8String:s];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
    free(vars);
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    unsigned int count = 0;
    Ivar * vars = class_copyIvarList([self class], &count);
    for (int i = 0 ; i < count;  i ++) {
        Ivar var = vars [i];
        const char * name = ivar_getName(var);
        NSString * key = [NSString stringWithUTF8String:name];
        id object = [aDecoder decodeObjectForKey:key];
        [self setValue:object forKey:key];
    }
    free(vars);
    return self;
}



- (void)dealloc{
    
    
    
}


@end
