//
//  UUMessageFrame.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-26.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#define ChatMargin 10      //间隔
#define ChatIconWH 44       //头像宽高height、width
#define ChatPicWH 100       //图片宽高
#define ChatContentW 160    //内容宽度

#define ChatTimeMarginW 15  //时间文本与边框间隔宽度方向
#define ChatTimeMarginH 10  //时间文本与边框间隔高度方向

#define ChatContentTop 10   //文本内容与按钮上边缘间隔
#define ChatContentLeft 15  //文本内容与按钮左边缘间隔
#define ChatContentBottom 10 //文本内容与按钮下边缘间隔
#define ChatContentRight 20 //文本内容与按钮右边缘间隔

#define ChatTimeFont [UIFont systemFontOfSize:11*ScrenScale]   //时间字体
#define ChatContentFont [UIFont systemFontOfSize:14*ScrenScale]//内容字体

#define ScrenScale [UIScreen mainScreen].bounds.size.width/414.0

#import <Foundation/Foundation.h>
@class UUMessage;

@interface UUMessageFrame : NSObject

/**
 姓名框尺寸
 */
@property (nonatomic, assign, readonly) CGRect nameF;


/**
 头像尺寸
 */
@property (nonatomic, assign, readonly) CGRect iconF;

/**
 时间戳位置
 */
@property (nonatomic, assign, readonly) CGRect timeF;


/**
 气泡尺寸
 */
@property (nonatomic, assign, readonly) CGRect contentF;


/**
 cell的高度
 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

/**
 uumessage对象
 */
@property (nonatomic, strong) UUMessage *message;


/**
 是否显示时间戳
 */
@property (nonatomic, assign) BOOL showTime;

@end
