//
//  YYTextView+YZEmotion.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/22.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "YYTextView+YZEmotion.h"

@implementation YYTextView (YZEmotion)
- (void)setYz_emotionKeyboard:(YZEmotionKeyboard *)yz_emotionKeyboard
{
    self.inputView = yz_emotionKeyboard;
    [self reloadInputViews];
    yz_emotionKeyboard.textView = self;
    
}
- (YZEmotionKeyboard *)yz_emotionKeyboard
{
    return (YZEmotionKeyboard *)self.inputView;
}

@end
