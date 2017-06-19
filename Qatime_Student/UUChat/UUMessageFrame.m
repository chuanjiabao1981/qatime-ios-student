//
//  UUMessageFrame.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUMessageFrame.h"
#import "UUMessage.h"
#import "YZTextAttachment.h"
#import "NSMutableAttributedString+Extention.h"
#import "NSString+FindFace.h"
#import "Define.h"
#import "YYTextLayout.h"


@implementation UUMessageFrame

- (void)setMessage:(UUMessage *)message{
    
    _message = message;
    
    //屏幕宽
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    // 1、计算时间的位置
    if (_showTime){
        CGFloat timeY = ChatMargin;
        CGSize timeSize = [_message.strTime sizeWithFont:ChatTimeFont maxSize:CGSizeMake(300, 100)];
        CGFloat timeX = (screenW - timeSize.width) / 2;
        _timeF = CGRectMake(timeX, timeY, timeSize.width + ChatTimeMarginW, timeSize.height + ChatTimeMarginH);
    }
    
    // 2、计算头像位置
    
    CGFloat iconX = ChatMargin;
    if (_message.from == UUMessageFromMe) {
        iconX = screenW - ChatMargin - ChatIconWH;
    }
    //头像位置y
    CGFloat iconY = CGRectGetMaxY(_timeF) + ChatMargin;
    
    //头像的frame
    _iconF = CGRectMake(iconX, iconY, ChatIconWH, ChatIconWH);
    
    // 3、计算ID位置
    _nameF = CGRectMake(iconX+5, iconY+ChatIconWH, ChatIconWH, 20);
    if (_message.from == UUMessageFromMe) {
        _nameF = CGRectMake(iconX-10, iconY+ChatIconWH, ChatIconWH, 20);
    }
    
    // 4、计算内容位置
    //label的内容位置
    CGFloat contentX = CGRectGetMaxX(_iconF)+ChatMargin;
    CGFloat contentY = iconY;
    
    //根据种类分
    //文字/图片内容的contentsize
    CGSize contentSize;
    switch (_message.type) {
        case UUMessageTypeText:{
            
            CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width/2, CGFLOAT_MAX);
            
            YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:[[NSAttributedString alloc]initWithString:_message.strContent]];
            
            // 显示文本排版结果
            contentSize = layout.textBoundingSize;
            if (_message.from == UUMessageFromMe) {
                
                if (_message.isRichText == YES) {
                    
                    contentSize.height+=10;
                    
                    NSInteger letterNum = _message.richNum;
                    //气泡尺寸修正
                    if (letterNum==2) {
                        contentSize.width+=letterNum*5;
                    }else if (letterNum>=3&&letterNum<6){
                        contentSize.width+=6*letterNum;
                    }else if (letterNum>=6&&letterNum<8){
                        contentSize.width+=8*letterNum;
                    }else if (letterNum==8){
                        contentSize.width-=20*letterNum/8;
                        contentSize.height+=20;
                    }else if (letterNum>8){
                        contentSize.width+=5*letterNum/7;
                        contentSize.height+=letterNum/8*15;
                    }
                    
                }else{
                }
                
            }else if (_message.from == UUMessageFromOther){
                if (_message.isRichText == YES) {
                    
                    contentSize.height+=10;
                    NSInteger letterNum = _message.richNum;
                    
                    //气泡尺寸修正
                    if (letterNum<3) {
                        contentSize.width-=letterNum*20;
                    }else if (letterNum>=3&&letterNum<7){
                        contentSize.width-=15*letterNum;
                    }else if (letterNum==7){
                        contentSize.width -= 5*(letterNum%7+1);
                        contentSize.height -= 10;
                    }else if (letterNum==8){
                        contentSize.width -= 5*letterNum%8;
                        contentSize.height -= 10;
                    }else if (letterNum>=8){
                        contentSize.width+=8*letterNum/8;
                        contentSize.height+=5*letterNum/8;
                    }
                    
                    
                }else{
                    
                    
                }
                
            }
            
        }
            break;
        case UUMessageTypePicture:
            contentSize = CGSizeMake(ChatPicWH*ScrenScale, ChatPicWH*ScrenScale);
            break;
        case UUMessageTypeVoice:
            //要修该语音气泡的长度.
            contentSize = CGSizeMake(100, 20);
            break;
        case UUMessagetypeNotice:
            
            break;
    }
    
    if (_message.from == UUMessageFromMe) {
        contentX = iconX - contentSize.width - ChatContentLeft - ChatContentRight - ChatMargin;
        _contentF = CGRectMake(contentX, contentY, contentSize.width + ChatContentLeft + ChatContentRight, contentSize.height + ChatContentTop + ChatContentBottom);
        
        _cellHeight = CGRectGetMaxY(_contentF) + 40;
    }else if(_message.from == UUMessageFromOther){
        _contentF = CGRectMake(contentX, contentY, contentSize.width + ChatContentLeft + ChatContentRight, contentSize.height + ChatContentTop + ChatContentBottom);
        
        _cellHeight = CGRectGetMaxY(_contentF) + 40;
        
    }else if (message.from == UUMessageFromeSystem){
        _contentF = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width ,30 );
        
        _cellHeight = 40;
        
    }
    
    
    
    
}

@end
