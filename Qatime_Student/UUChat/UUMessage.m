//
//  UUMessage.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUMessage.h"
#import "NSDate+Utils.h"
#import "NSString+TimeStamp.h"

@implementation UUMessage

/* 使用数据字典,制作出一条消息*/
- (void)setWithDict:(NSDictionary *)dic{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if (dic[@"strIcon"]) {
        
        self.strIcon = dict[@"strIcon"];
    }
    
    if (dict[@"strName"] ==nil) {
        dict[@"strName"] =@"";
    }
    self.strName = dict[@"strName"];
    self.strId = dict[@"strId"];
    self.strTime = [dict[@"strTime"]substringFromIndex:5];
    self.from = [dict[@"from"] intValue];
    self.messageID = dict[@"messageID"];
    
    self.sendFaild = NO;    //默认是发送成功状态,所以发送失败的bool为NO;
    
    self.message = dict[@"message"];
    
    switch ([dict[@"type"] integerValue]) {
        
        case 0:
            self.type = UUMessageTypeText;
            if (dict[@"strContent"]==nil) {
                [dict setValue:@"空消息" forKey:@"strContent"];
            }
            self.strContent = dict[@"strContent"];
            if (dict[@"isRichText"]&&dict[@"richNum"]) {
                self.from = UUMessageFromMe;
                self.isRichText = [dict[@"isRichText"]boolValue];
                self.richNum = [dict[@"richNum"]integerValue];
            }else{
                self.from = UUMessageFromOther;
                /* 在这里进行一次判断,是否包含富文本 */
                //创建一个可变的属性字符串
                NSMutableAttributedString *text = [NSMutableAttributedString new];
                [text appendAttributedString:[[NSAttributedString alloc] initWithString:dict[@"strContent"] attributes:nil]];
                
                /* 正则匹配*/
                NSString * pattern = @"\\[em_\\d{1,2}\\]";
                NSError *error = nil;
                NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
                
                //通过正则表达式来匹配字符串,加载表情的同时判断是否存在富文本
                NSArray *resultArray = [re matchesInString:dict[@"strContent"] options:0 range:NSMakeRange(0, [dict[@"strContent"] length])];
                if (resultArray.count!=0) {
                    
                    self.isRichText = YES;
                    self.richNum = resultArray.count;
                }else{
                    self.isRichText = NO;
                    self.richNum = 0;
                }
            }
            break;
        
        case 1:
            self.type = UUMessageTypePicture;
            self.picture = dict[@"picture"];
            self.imagePath = dict[@"imagePath"];
            self.thumbPath = dict[@"thumbImagePath"];
            
            break;
        
        case 2:
            self.type = UUMessageTypeVoice;
            self.voice = dict[@"voice"];
            self.strVoiceTime = dict[@"strVoiceTime"];
            break;
            
        case 5:
            self.type = UUMessagetypeNotice;
            self.strContent = dict[@"message"];
            break;
    }
}

//"08-10 晚上08:09:41.0" ->
//"昨天 上午10:09"或者"2012-08-10 凌晨07:09"

/**
 时间转换

 @param Str 时间string
 @return 时间格式转换结果
 */
- (NSString *)changeTheDateString:(NSString *)Str
{
//    Str = [Str timeStampToDate];
    
    NSString *subString = [Str substringWithRange:NSMakeRange(0, 19)];
    NSDate *lastDate = [NSDate dateFromString:subString withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateStr;  //年月日
    NSString *period;   //时间段
    NSString *hour;     //时
    
    if ([lastDate year]==[[NSDate date] year]) {
        NSInteger days = [NSDate daysOffsetBetweenStartDate:lastDate endDate:[NSDate date]];
        if (days <= 2) {
            dateStr = [lastDate stringYearMonthDayCompareToday];
        }else{
            dateStr = [lastDate stringMonthDay];
        }
    }else{
        dateStr = [lastDate stringYearMonthDay];
    }
    
    
    if ([lastDate hour]>=5 && [lastDate hour]<12) {
        period = @"上午";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    }else if ([lastDate hour]>=12 && [lastDate hour]<=18){
        period = @"下午";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
    }else if ([lastDate hour]>18 && [lastDate hour]<=23){
        period = @"晚上";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
    }else{
        period = @"凌晨";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    }
    return [NSString stringWithFormat:@"%@ %@ %@:%02d",dateStr,period,hour,(int)[lastDate minute]];
}

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end
{
    if (!start) {
        self.showDateLabel = YES;
        return;
    }
    
    NSString *subStart = [start substringWithRange:NSMakeRange(0, 19)];
    NSDate *startDate = [NSDate dateFromString:subStart withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *subEnd = [end substringWithRange:NSMakeRange(0, 19)];
    NSDate *endDate = [NSDate dateFromString:subEnd withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //这个是相隔的秒数
    NSTimeInterval timeInterval = [startDate timeIntervalSinceDate:endDate];
    
    //相距5分钟显示时间Label
    if (fabs (timeInterval) > 5*60) {
        self.showDateLabel = YES;
    }else{
        self.showDateLabel = NO;
    }
    
}
@end
