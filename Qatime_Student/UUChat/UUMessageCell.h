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
@class UUMessageFrame;
@class UUMessageCell;


@protocol UUMessageCellDelegate <NSObject>
@optional

- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId;
- (void)cellContentDidClick:(UUMessageCell *)cell image:(UIImage *)contentImage;
- (void)cellContentLongPress:(UUMessageCell *)cell voice:(NSData *)voice;

@end


@interface UUMessageCell : UITableViewCell

/* 时间戳*/
@property (nonatomic, retain)UILabel *labelTime;

@property (nonatomic, retain)UILabel *labelNum;
@property (nonatomic, retain)UIButton *btnHeadImage;

@property (nonatomic, retain)UUMessageContentButton *btnContent;

@property (nonatomic, retain)UUMessageFrame *messageFrame;

@property (nonatomic, assign)id<UUMessageCellDelegate>delegate;

@property(nonatomic,strong) YYLabel *title ;

@end

