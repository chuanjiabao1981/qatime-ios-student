//
//  UIViewController+Login.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/10.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "UIViewController+Login.h"
#import "UIAlertController+Blocks.h"

static const void *loginAlertShowKey = &loginAlertShowKey;


@implementation UIViewController (Login)

- (void)loginAgain{
    
    LoginAgainViewController *_ = [[LoginAgainViewController alloc]init];
    _.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:_ animated:YES];
    
}

/* 判断登录超时*/
- (void)loginStates:(NSDictionary *)dataDic{
    
    if ([dataDic[@"status"]isEqualToNumber:@0]) {
        if (dataDic[@"error"]) {
            if ([dataDic[@"error"][@"code"]isEqualToNumber:@1002]) {
                
                if (self.loginAlertShow == YES) {
                    
                }else{
                    
                    [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"登录超时!\n是否重新登录?" cancelButtonTitle:@"取消" destructiveButtonTitle:@"重新登录" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                        if (buttonIndex!=0) {
                            
                            [self loginAgain];
                            self.loginAlertShow = NO;
                            
                        }
                        
                    }];
                    self.loginAlertShow = YES;
                    
                }
                
            }
        }
    }
    
    
    
}


- (BOOL)isLogin{
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Login"]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Login"]==YES) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}



-(BOOL)loginAlertShow{
    
    
    NSNumber *num =objc_getAssociatedObject(self, &loginAlertShowKey);
    
    return [num boolValue];
    
}

- (void)setLoginAlertShow:(BOOL)loginAlertShow {
    
    NSNumber *num = [NSNumber numberWithBool:loginAlertShow];
    
    objc_setAssociatedObject(self, loginAlertShowKey, num, OBJC_ASSOCIATION_ASSIGN);
    
    
}

@end
