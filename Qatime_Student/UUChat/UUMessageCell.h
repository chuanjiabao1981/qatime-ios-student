//
//  UUMessageCell.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUMessageContentButton.h"
#import "YYLabel.h"
#import "YYTextView.h"
@class UUMessageFrame;
@class UUMessageCell;


@protocol UUMessageCellDelegate <NSObject>
@optional

- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId;
- (void)cellContentDidClick:(UUMessageCell *)cell image:(UIImage *)contentImage;
- (void)cellContentLongPress:(UUMessageCell *)cell voice:(NSData *)voice;

@end

@protocol PhotoBrowserDelegate <NSObject>

- (void)showImage:(UIImageView*)imageView andImage:(UIImage *)image;

@end


@interface UUMessageCell : UITableViewCell

/* 时间戳*/
@property (nonatomic, retain)UILabel *labelTime;

@property (nonatomic, retain)UILabel *labelNum;

@property (nonatomic, retain)UIButton *btnHeadImage;

//气泡内容
@property (nonatomic, retain)UUMessageContentButton *btnContent;

//系统公告内容
@property (nonatomic, strong) UIView *noticeContentView ;
@property (nonatomic, strong) UILabel *noticeLabel ;

@property (nonatomic, retain)UUMessageFrame *messageFrame;

@property (nonatomic, assign)id<UUMessageCellDelegate>delegate;

@property (nonatomic, strong) id<PhotoBrowserDelegate> photoDelegate ;

@property(nonatomic,strong) YYTextView *title ;

/* 增加一个 真正的时间label*/
@property(nonatomic,strong) UILabel *timeLabel ;

/* 增加发送失败标识图*/
@property(nonatomic,strong) UIButton *sendfaild ;


//////////////////////////////////
//作业 / 问答类型的内容

/** 底下那层view */
@property (nonatomic, strong) UIView *noticeTipsContentView;
/** 标题 */
@property (nonatomic, strong) UILabel *noticeTipsTitle ;
/** 内容 */
@property (nonatomic, strong) UILabel *noticeTipsBody ;
/** 左侧的分类条吧 */
@property (nonatomic, strong) UIView *noticeTipsCategoryContent ;
@property (nonatomic, strong) UILabel *noticeTipsCategory ;



@end

