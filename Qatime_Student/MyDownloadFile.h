//
//  MyDownloadFile.h
//  Qatime_Student
//
//  Created by Shin on 2017/9/5.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FileType) {
    ImageType,
    VideoType,
    TextType,
    OtherType,
};

@interface MyDownloadFile : NSObject

@property (nonatomic, strong) UIImage *image ;

@property (nonatomic, strong) NSString *name ;

@property (nonatomic, strong) NSString *size ;
@property (nonatomic, assign) CGFloat fileSizefloat;

@property (nonatomic, strong) NSString *created_at ;

@property (nonatomic, strong) NSString *filePath ;

@property (nonatomic, assign) FileType fileType ;

@property (nonatomic, assign) BOOL select ;

@property (nonatomic, assign) BOOL onEdit ;

-(instancetype)initWithFilePath:(NSString *)filePath;

@end
