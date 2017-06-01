//
//  UIViewController+Token.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "UIViewController+Token.h"


static const void *TokenKey = &TokenKey;

static const void *TeacherIDKey = &TeacherIDKey;


@implementation UIViewController (Token)


-(void)setToken:(NSString *)token{
    
    objc_setAssociatedObject(self, TokenKey, token, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(NSString *)token{
    
    return objc_getAssociatedObject(self, TokenKey);
}

-(void)setTeacherID:(NSString *)teacherID{
    
    objc_setAssociatedObject(self, TeacherIDKey, teacherID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)teacherID{
    
    return objc_getAssociatedObject(self, TeacherIDKey);
}


/**获取token方法*/

-(NSString *)getToken{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        self.token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }else{
        self.token = @"";
    }
    return self.token;
    
}

/**获取id方法*/

-(NSString *)getTeacherID{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        self.teacherID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }else{
        
        self.teacherID = @"";
    }
    return self.teacherID;
}

@end
