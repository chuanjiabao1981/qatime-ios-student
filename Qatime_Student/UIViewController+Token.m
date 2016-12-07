//
//  UIViewController+Token.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "UIViewController+Token.h"

@implementation UIViewController (Token)



-(NSString *)idNumber{
   
    NSString *idNum = [NSString string];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        idNum =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }else{
        
        idNum = @"";
        
    }
    
    return idNum;
    
}

- (NSString *)token{
    
     NSString *token = [NSString string];
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }else{
        
        token = @"";
    }

    
    return token;
}


@end
