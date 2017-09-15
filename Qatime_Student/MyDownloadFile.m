//
//  MyDownloadFile.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/5.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MyDownloadFile.h"
//#import "UIImage+TYHSetting.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

//图片的各种类型
static const UInt8 IMAGES_TYPES_COUNT = 8;
static const NSString *IMAGES_TYPES[IMAGES_TYPES_COUNT] = {@"png", @"PNG", @"jpg",@",JPG", @"jpeg", @"JPEG" ,@"gif", @"GIF"};
//文档的各种类型
static const UInt8 TEXT_TYPES_COUNT = 7;
static const NSString *TEXT_TYPES[TEXT_TYPES_COUNT] = {@"doc", @"docx", @"xls",@"xlsx", @"ppt", @"pptx" ,@"pdf"};
//视频的各种类型
static const UInt8 VIDEO_TYPES_COUNT = 1;
static const NSString *VIDEO_TYPES[VIDEO_TYPES_COUNT] = {@"mp4"};


@implementation MyDownloadFile{
    
    NSFileManager *fileMgr;
}
-(instancetype)init {
    if(self = [super init]) {
        fileMgr = [NSFileManager defaultManager];
    }
    return self;
}

-(instancetype)initWithFilePath:(NSString *)filePath {
    if(self = [self init]){
        self.filePath = filePath;
    }
    return self;
}


-(void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    
    self.name = [filePath lastPathComponent];
    
    BOOL isDirectory = true;
    [fileMgr fileExistsAtPath: filePath isDirectory: &isDirectory];
    self.image = [UIImage imageNamed: @"fielIcon"];
    self.fileType = OtherType;
    
    if(isDirectory){
        self.image = [UIImage imageNamed: @"dirIcon"];
        self.fileType = OtherType;
    }else{
        
        NSArray *imageTypesArray = [NSArray arrayWithObjects: IMAGES_TYPES count: IMAGES_TYPES_COUNT];
        NSArray *videoTypesArray = [NSArray arrayWithObjects:VIDEO_TYPES count:VIDEO_TYPES_COUNT];
        NSArray *textTypeArray = [NSArray arrayWithObjects:TEXT_TYPES count:TEXT_TYPES_COUNT];
        
        
        if([imageTypesArray containsObject: [filePath pathExtension]]){
            self.image = [UIImage imageWithContentsOfFile: filePath];
            self.fileType = ImageType;
        }
        
        if ([videoTypesArray containsObject:[[filePath pathExtension]lowercaseString]]) {
            
            self.image = [self getThumbnailImage:self.filePath];
            self.fileType = VideoType;

        }
        if ([textTypeArray containsObject:[[filePath pathExtension]lowercaseString]]) {
            if ([[[filePath pathExtension]lowercaseString]isEqualToString:@"doc"]||[[[filePath pathExtension]lowercaseString]isEqualToString:@"docx"]) {
                self.image = [UIImage imageNamed:@"word"];
                self.fileType = TextType;
            }else if ([[[filePath pathExtension]lowercaseString]isEqualToString:@"xls"]||[[[filePath pathExtension]lowercaseString]isEqualToString:@"xlsx"]){
                self.image = [UIImage imageNamed:@"excel"];
                self.fileType = TextType;
            }else if ([[[filePath pathExtension]lowercaseString]isEqualToString:@"ppt"]||[[[filePath pathExtension]lowercaseString]isEqualToString:@"pptx"]){
                self.image = [UIImage imageNamed:@"ppt"];
                self.fileType = TextType;
            }else if ([[[filePath pathExtension]lowercaseString]isEqualToString:@"pdf"]){
                self.image = [UIImage imageNamed:@"pdf"];
                self.fileType = TextType;
            }
        }
        
        if (![textTypeArray containsObject:[[filePath pathExtension]lowercaseString]]&&![videoTypesArray containsObject:[[filePath pathExtension]lowercaseString]]&&![imageTypesArray containsObject: [filePath pathExtension]]) {
            self.image = [UIImage imageNamed:@"未知"];
            self.fileType = OtherType;
        }
        
        NSError *error = nil;
        NSDictionary *fileAttributes = [fileMgr attributesOfItemAtPath:filePath error:&error];
        
        if (fileAttributes != nil) {
            NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
            NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
            NSDate *fileCreateDate = [fileAttributes objectForKey:NSFileCreationDate];
            if (fileSize) {
                CGFloat size = [fileSize unsignedLongLongValue];
                self.fileSizefloat = size;
                NSString *sizestr = [NSString stringWithFormat:@"%qi",[fileSize unsignedLongLongValue]];
                //            NSLog(@"File size: %@\n",fileSize);
                if (sizestr.length <=3) {
                    self.size = [NSString stringWithFormat:@"%.1f B",size];
                } else if(sizestr.length>3 && sizestr.length<7){
                    self.size = [NSString stringWithFormat:@"%.1f KB",size/1000.0];
                }else{
                    self.size = [NSString stringWithFormat:@"%.1f M",size/(1000.0 * 1000)];
                }
            }
            
            if (fileModDate) {
                //用于格式化NSDate对象
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //设置格式：zzz表示时区
                [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
                //NSDate转NSString
                self.created_at = [dateFormatter stringFromDate:fileModDate];
            }
            if (fileCreateDate) {
                //            NSLog(@"create date:%@\n", fileModDate);
            }
        }
        else {
            //        NSLog(@"Path (%@) is invalid.", filePath);
        }
    }
}

- (UIImage *)getThumbnailImage:(NSString *)videoURL{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;//按正确方向对视频进行截图,关键点是将AVAssetImageGrnerator对象的appliesPreferredTrackTransform属性设置为YES。
    
    CMTime time = CMTimeMakeWithSeconds(5, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
}


@end
