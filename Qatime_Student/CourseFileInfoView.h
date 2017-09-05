//
//  CourseFileInfoView.h
//  Qatime_Student
//
//  Created by Shin on 2017/9/5.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M13ProgressViewBar.h"
#import "CourseFile.h"

@interface CourseFileInfoView : UIView

/** 缩略图 */
@property (nonatomic, strong) UIImageView *fileImage ;
/** 文件名,如果有的话 */
@property (nonatomic, strong) UILabel *fileName ;
/** 文件大小 */
@property (nonatomic, strong) UILabel *fileSize ;

@property (nonatomic, strong) UIButton *downloadBtn ;

@property (nonatomic, strong) UILabel *created_at ;

@property (nonatomic, strong) UILabel *downloadProgress ;

@property (nonatomic, strong) M13ProgressViewBar *progressBar ;

@property (nonatomic, strong) CourseFile *model ;

@end
