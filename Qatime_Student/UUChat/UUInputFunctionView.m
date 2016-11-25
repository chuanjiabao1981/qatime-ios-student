//
//  UUInputFunctionView.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUInputFunctionView.h"
#import "Mp3Recorder.h"
#import "UUProgressHUD.h"
#import "ACMacros.h"




@interface UUInputFunctionView ()<YYTextViewDelegate,Mp3RecorderDelegate>
{
    BOOL isbeginVoiceRecord;
    Mp3Recorder *MP3;
    NSInteger playTime;
    NSTimer *playTimer;
    
    //    UILabel *placeHold;
}
@end

@implementation UUInputFunctionView

- (id)initWithSuperVC:(UIViewController *)superVC
{
    self.superVC = superVC;
    CGRect frame = CGRectMake(0, Main_Screen_Height-40, Main_Screen_Width, 40);
    
    self = [super initWithFrame:frame];
    if (self) {
        MP3 = [[Mp3Recorder alloc]initWithDelegate:self];
        self.backgroundColor = [UIColor whiteColor];
        //发送消息
        self.btnSendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnSendMessage.frame = CGRectMake(Main_Screen_Width-40, 5, 30, 30);
        self.isAbleToSendTextMessage = NO;
        [self.btnSendMessage setTitle:@"发送" forState:UIControlStateNormal];
        [self.btnSendMessage setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.btnSendMessage.enabled = NO;
        self.btnSendMessage.frame = RECT_CHANGE_width(self.btnSendMessage,35);
        UIImage *image = [UIImage imageNamed:@"chat_send_message"];
        [self.btnSendMessage setBackgroundImage:image forState:UIControlStateNormal];
        self.btnSendMessage.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnSendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnSendMessage];
        
        //改变状态（语音、文字） 切换表情键盘
        self.btnChangeVoiceState = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnChangeVoiceState.frame = CGRectMake(5, 5, 30, 30);
        isbeginVoiceRecord = NO;
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
        self.btnChangeVoiceState.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [self addSubview:self.btnChangeVoiceState];
        
        
        
        //输入框
        self.TextViewInput = [[UITextView alloc]initWithFrame:CGRectMake(45, 5, Main_Screen_Width-2*45, 30)];
        self.TextViewInput.layer.cornerRadius = 4;
        self.TextViewInput.layer.masksToBounds = YES;
        self.TextViewInput.delegate = self;
        self.TextViewInput.layer.borderWidth = 1;
        self.TextViewInput.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        [self addSubview:self.TextViewInput];
    
        //分割线
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        
        //添加通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidEndEditing:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}





//改变输入与录音状态
- (void)voiceRecord:(UIButton *)sender
{
    
    [self.TextViewInput becomeFirstResponder];
    
    
}

//发送消息（文字图片）
- (void)sendMessage:(UIButton *)sender{
    
    
    NSLog(@"%@",[self.TextViewInput attributedText ]);
    
    
    
    NSString *resultStr = [self.TextViewInput.text stringByReplacingOccurrencesOfString:@"   " withString:@""];
    [self.delegate UUInputFunctionView:self sendMessage:resultStr];
    
}


#pragma mark - TextViewDelegate

- (void)textViewDidBeginEditing:(YYTextView *)textView
{
    
}

- (void)textViewDidChange:(YYTextView *)textView
{
    [self changeSendBtnWithPhoto:textView.text.length>0?NO:YES];
    
}

- (void)changeSendBtnWithPhoto:(BOOL)isPhoto
{
    self.btnSendMessage.enabled = YES;
    [self.btnSendMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (void)textViewDidEndEditing:(YYTextView *)textView
{
    
}


#pragma mark - Add Picture


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
