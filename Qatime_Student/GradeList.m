//
//  GradeList.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/1.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "GradeList.h"
#import "MBProgressHUD.h"

@interface GradeList (){
    
    MBProgressHUD *hud;
    
    
}

@end

@implementation GradeList
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager GET:@"http://testing.qatime.cn/api/v1/app_constant/grades" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            _grade = [[NSArray alloc]initWithArray:[[[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil] valueForKey:@"data"]valueForKey:@"grades"]];
            
            /* 年级信息归档*/
            [[NSUserDefaults standardUserDefaults]setObject:_grade forKey:@"grade"];
            
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"LoadGradeOver" object:nil];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
    }
    return self;
}
@end
