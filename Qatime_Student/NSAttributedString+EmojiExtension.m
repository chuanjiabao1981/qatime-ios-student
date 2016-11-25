//
//  NSAttributedString+EmojiExtension.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/23.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "NSAttributedString+EmojiExtension.h"
#import "YZTextAttachment.h"

@implementation NSAttributedString (EmojiExtension)

- (NSString *)getPlainString {
    
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    
    __block NSUInteger base = 0;
    
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        
        if (value && [value isKindOfClass:[YZTextAttachment class]]) {
            
            [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:((YZTextAttachment *) value).emotionStr];
            
            base += ((YZTextAttachment *) value).emotionStr.length - 1;
            
        }
        
    }];
    
    return plainString;
}


@end
