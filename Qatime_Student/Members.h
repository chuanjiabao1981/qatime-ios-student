//
//  Members.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Members : NSObject
//
//"accid": "07b7c43a854ed44d36c2941f1fc5ad00",
//"name": "luke测试",
//"icon": "

@property(nonatomic,strong) NSString *accid ;
@property(nonatomic,strong) NSString *name ;
@property(nonatomic,strong) NSString *icon ;

@property (nonatomic, assign) BOOL isOwner ;


@end
