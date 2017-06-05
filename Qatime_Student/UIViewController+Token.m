//
//  UIViewController+Token.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "UIViewController+Token.h"


static const void *TokenKey = &TokenKey;

static const void *StudentIDKey = &StudentIDKey;


@implementation UIViewController (Token)


-(void)setToken:(NSString *)token{
    
    objc_setAssociatedObject(self, TokenKey, token, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(NSString *)token{
    
    return objc_getAssociatedObject(self, TokenKey);
}

-(void)setStudentID:(NSString *)studentID{
    
    objc_setAssociatedObject(self, StudentIDKey, studentID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(NSString *)studentID{
    
    return objc_getAssociatedObject(self, StudentIDKey);
    
}


/**获取token方法*/

-(NSString *)getToken{
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        self.token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }else{
        self.token = [SAMKeychain passwordForService:@"Qatime_Student" account:@"Remember-Token"];
    }
    return self.token;
}




/**获取id方法*/

-(NSString *)getStudentID{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        self.studentID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }else{
        
        self.studentID = [SAMKeychain passwordForService:@"Qatime_Student" account:@"id"];
    }
    return self.studentID;
}





@end
