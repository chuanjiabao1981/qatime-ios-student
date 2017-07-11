//
//  Notice.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notice : NSObject

@property(nonatomic,strong) NSString *announcement ;
@property(nonatomic,strong) NSString *edit_at ;
@property (nonatomic, strong) NSString *content ;
@property (nonatomic, assign) BOOL lastest ;
@property (nonatomic, strong) NSString *created_at ;

@end
