//
//  NSString+ChangeYearsToChinese.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/11.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "NSString+ChangeYearsToChinese.h"

@implementation NSString (ChangeYearsToChinese)

-(NSString *)changeEnglishYearsToChinese{
    
    BOOL morethan;
    NSInteger years = 0;
    
    NSArray *letterArr = @[@"three",@"five",@"ten",@"twenty"];
    
    NSString *resultStr = nil;
    
    if([self rangeOfString:@"within"].location !=NSNotFound){
        /* 包含within字段,少于多少年的教龄*/
        morethan = NO;
    }else{
        /* 不包含within字段,那就是多少年以上*/
        morethan = YES;
    }
    
    for (NSString *num in letterArr) {
        if ([self rangeOfString:num].location !=NSNotFound) {
            
            switch ([letterArr indexOfObject:num]) {
                case 0:
                    years = 3;
                    break;
                case 1:
                    years = 5;
                    break;
                case 2:
                    years = 10;
                    break;
                case 3:
                    years = 20;
                    break;
            }
        }else{
//            years = 0;
        }
    }
    
    if (morethan == YES&&years == 20) {
        resultStr = [NSString stringWithFormat:@"20年以上教龄"];
    }else if(morethan == YES&&years == 10){
        
        resultStr = [NSString stringWithFormat:@"10-20年教龄"];
    }else if (morethan==YES&&years==3){
        resultStr = [NSString stringWithFormat:@"3-10年教龄"];
    }else if (morethan==NO&&years==20){
        resultStr = [NSString stringWithFormat:@"10-20年教龄"];
        
    }else if (morethan==NO&&years==10){
        resultStr = [NSString stringWithFormat:@"3-10年教龄"];
    }else if (morethan==NO&&years==3){
        resultStr = [NSString stringWithFormat:@"3年以内教龄"];
    }
    
    return resultStr;
    
}

@end
