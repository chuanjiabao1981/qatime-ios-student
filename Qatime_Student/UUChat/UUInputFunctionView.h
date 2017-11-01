//
//  UUInputFunctionView.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTextView.h"

@class UUInputFunctionView;

@protocol UUInputFunctionViewDelegate <NSObject>

// text
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message;

// image
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image;


@end


@protocol UUInputFunctionViewRecordDelegate <NSObject>

// audio
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView voicePath:(NSString *)path time:(NSInteger)second;

@end



@interface UUInputFunctionView : UIView <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


/**
 发送消息按钮
 */
@property (nonatomic, retain) UIButton *btnSendMessage;
@property(nonatomic,assign) BOOL canNotSendImage ;

@property (nonatomic, retain) UIButton *btnChangeVoiceState;
@property (nonatomic, retain) UIButton *btnVoiceRecord;
@property (nonatomic, retain) UITextView *TextViewInput;

//添加一个,切换语音和键盘的按钮
@property(nonatomic,strong) UIButton *voiceSwitchTextButton ;

@property (nonatomic, assign) BOOL isAbleToSendTextMessage;

@property (nonatomic, assign) UIViewController *superVC;

@property (nonatomic, assign) id<UUInputFunctionViewDelegate>delegate;

@property (nonatomic, assign) id<UUInputFunctionViewRecordDelegate> recordDelegate ;

- (id)initWithSuperVC:(UIViewController *)superVC;

- (void)changeSendBtnWithPhoto:(BOOL)isPhoto;

/**切换语音/文字输入*/
- (void)voiceRecord:(UIButton *)sender;

@end
