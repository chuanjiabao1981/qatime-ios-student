//
//  UUInputFunctionView.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUInputFunctionView.h"
//#import "Mp3Recorder.h"
#import "UUProgressHUD.h"
#import "ACMacros.h"

#import "NSString+YYAdd.h"
#import "UIView+NIMKitToast.h"
#import <NIMSDK/NIMSDK.h>


@interface UUInputFunctionView ()<YYTextViewDelegate,UITextViewDelegate,NIMMediaManagerDelegate,NSCopying,NSMutableCopying>{
    
    BOOL isbeginVoiceRecord;
//    Mp3Recorder *MP3;
    CGFloat playTime;
    NSTimer *playTimer;
    
    ///辅助定时器///
    CGFloat assistPlayTime;
    NSTimer *assistPlayTimer;
    
    //    UILabel *placeHold;
}
@end

@implementation UUInputFunctionView

- (id)copyWithZone:(NSZone *)zone {
    id copyInstance = [[[self class] allocWithZone:zone] init];
    size_t instanceSize = class_getInstanceSize([self class]);
    memcpy((__bridge void *)(copyInstance), (__bridge const void *)(self), instanceSize);
    return copyInstance;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    return [self copyWithZone:zone]; 
}



- (id)initWithSuperVC:(UIViewController *)superVC
{
    self.superVC = superVC;
    CGRect frame = CGRectMake(0, Main_Screen_Height-40, Main_Screen_Width, 40);
    
    self = [super initWithFrame:frame];
    if (self) {
//        MP3 = [[Mp3Recorder alloc]initWithDelegate:self];
        self.backgroundColor = [UIColor whiteColor];
        self.btnSendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.isAbleToSendTextMessage = NO;
        [self.btnSendMessage setTitle:@"" forState:UIControlStateNormal];
        [self.btnSendMessage setBackgroundImage:[UIImage imageNamed:@"Chat_take_picture"] forState:UIControlStateNormal];
        self.btnSendMessage.titleLabel.font = [UIFont systemFontOfSize:12*ScrenScale];
        [self.btnSendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnSendMessage];
        self.btnSendMessage.sd_layout
        .rightSpaceToView(self,10)
        .topSpaceToView(self,10)
        .bottomSpaceToView(self,10)
        .widthEqualToHeight();
        
        //切换表情键盘
        self.btnChangeVoiceState = [UIButton buttonWithType:UIButtonTypeCustom];
        isbeginVoiceRecord = NO;
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
        self.btnChangeVoiceState.titleLabel.font = [UIFont systemFontOfSize:12*ScrenScale];
        
        [self addSubview:self.btnChangeVoiceState];
        self.btnChangeVoiceState.sd_layout
        .rightSpaceToView(self.btnSendMessage,10)
        .topSpaceToView(self,10)
        .bottomSpaceToView(self,10)
        .widthEqualToHeight();
        
        //切换语音和文字的按钮(输入框左侧的按钮)
        self.voiceSwitchTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.voiceSwitchTextButton setImage:[UIImage imageNamed:@"chat_voice_record"] forState:UIControlStateNormal];
        [self.voiceSwitchTextButton addTarget:self action:@selector(voiceRecord:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.voiceSwitchTextButton];
        self.voiceSwitchTextButton.sd_layout
        .leftSpaceToView(self,10)
        .topSpaceToView(self,10)
        .bottomSpaceToView(self,10)
        .widthEqualToHeight();
        
        //语音按钮
        //语音录入键
        self.btnVoiceRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.btnVoiceRecord];
        self.btnVoiceRecord.sd_layout
        .leftSpaceToView(self.voiceSwitchTextButton,10)
        .rightSpaceToView(self.btnChangeVoiceState,10)
        .topSpaceToView(self,10)
        .bottomSpaceToView(self,10);
        
        self.btnVoiceRecord.hidden = YES;
        [self.btnVoiceRecord setBackgroundImage:[UIImage imageNamed:@"chat_message_back"] forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [self.btnVoiceRecord setTitle:@"按住说话" forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitle:@"松开发送" forState:UIControlStateHighlighted];
        [self.btnVoiceRecord addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [self.btnVoiceRecord addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnVoiceRecord addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        
        
        //输入框
        self.TextViewInput = [[UITextView alloc]init];
        self.TextViewInput.layer.cornerRadius = 4;
        self.TextViewInput.layer.masksToBounds = YES;
        self.TextViewInput.delegate = self;
        self.TextViewInput.layer.borderWidth = 1;
        self.TextViewInput.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        [self addSubview:self.TextViewInput];
        self.TextViewInput.sd_layout
        .leftSpaceToView(self.voiceSwitchTextButton,10)
        .rightSpaceToView(self.btnChangeVoiceState,10)
        .topSpaceToView(self,10)
        .bottomSpaceToView(self,10);
        
        
        //分割线
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        
        //添加通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidEndEditing:) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeSenderButton) name:@"ChatNone" object:nil] ;
        
        [[NIMSDK sharedSDK].mediaManager addDelegate:self];
        
    }
    return self;
}


//语音/文字输入切换
- (void)voiceRecord:(UIButton *)sender{

    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"CanSendVoice"]) {
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"CanSendVoice"]==NO) {
            //不能发送语音
            [self nimkit_makeToast:@"互动中不能发送语音消息" duration:2 position:NIMKitToastPositionBottom];
        }else{
            //可以发送语音
            self.btnVoiceRecord.hidden = !self.btnVoiceRecord.hidden;
            self.TextViewInput.hidden  = !self.TextViewInput.hidden;
            isbeginVoiceRecord = !isbeginVoiceRecord;
            if (isbeginVoiceRecord) {
                [self.voiceSwitchTextButton setImage:[UIImage imageNamed:@"chat_ipunt_message"] forState:UIControlStateNormal];
                [self.TextViewInput resignFirstResponder];
                [self changeSendBtnWithPhoto:YES];
            }else{
                [self.voiceSwitchTextButton setImage:[UIImage imageNamed:@"chat_voice_record"] forState:UIControlStateNormal];
                [self.TextViewInput becomeFirstResponder];
                [self changeSendBtnWithPhoto:NO];
            }

        }
    }else{
        
        //可以发送语音
        self.btnVoiceRecord.hidden = !self.btnVoiceRecord.hidden;
        self.TextViewInput.hidden  = !self.TextViewInput.hidden;
        isbeginVoiceRecord = !isbeginVoiceRecord;
        if (isbeginVoiceRecord) {
            [self.voiceSwitchTextButton setImage:[UIImage imageNamed:@"chat_ipunt_message"] forState:UIControlStateNormal];
            [self.TextViewInput resignFirstResponder];
            [self changeSendBtnWithPhoto:YES];
        }else{
            [self.voiceSwitchTextButton setImage:[UIImage imageNamed:@"chat_voice_record"] forState:UIControlStateNormal];
            [self.TextViewInput becomeFirstResponder];
            [self changeSendBtnWithPhoto:NO];
        }
    }
    
}

//发送消息（文字图片）
- (void)sendMessage:(UIButton *)sender{
    
    if (_shutUp) {
        [_TextViewInput becomeFirstResponder];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ShowShutUp" object:nil];
        return;
    }
    
    if (self.isAbleToSendTextMessage) {
        if ([_TextViewInput.text isEqualToString:@""]||_TextViewInput.text ==nil) {
            return;
        }
        NSLog(@"%@",[self.TextViewInput attributedText ]);
        NSString *resultStr = [self.TextViewInput.text stringByReplacingOccurrencesOfString:@"   " withString:@""];
        [self.delegate UUInputFunctionView:self sendMessage:resultStr];
    }
    else{
        [self.TextViewInput resignFirstResponder];
        UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"来自相机",@"来自相册",nil];
        [actionSheet showInView:self.window];
    }
}



#pragma mark- 所有的有关录音的方法

- (void)beginRecordVoice:(UIButton *)button{
    if (_shutUp) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ShowShutUp" object:nil];
        return;
    }
    [[NIMSDK sharedSDK].mediaManager record:NIMAudioTypeAMR duration:60];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RecordStart" object:nil];
    playTime = 0.0;
    playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    [UUProgressHUD show];
    
    //同时启动辅助定时器.
    assistPlayTime = 0.0;
    assistPlayTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(assistCountVoiceTime) userInfo:nil repeats:YES];
    
}

- (void)endRecordVoice:(UIButton *)button{
    
    if (playTimer) {
        if (playTime <1.0) {
            [self failRecord];
             [[NSNotificationCenter defaultCenter]postNotificationName:@"RecordCancel" object:nil];
        }else{
            [[NIMSDK sharedSDK].mediaManager setDeactivateAudioSessionAfterComplete:NO];
            [[NIMSDK sharedSDK].mediaManager stopRecord];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RecordEnd" object:nil];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 处理耗时操作的代码块...
                //通知主线程刷新
                dispatch_async(dispatch_get_main_queue(), ^{
                    //回调或者说是通知主线程刷新，
                    [UUProgressHUD dismissWithSuccess:@"发送成功"];
                    [self layoutSubviews];
                });
            });
        }
        [playTimer invalidate];
        playTimer = nil;
        
        ///同时结束辅助定时器
        [assistPlayTimer invalidate];
        assistPlayTimer =nil;
    }
}

- (void)cancelRecordVoice:(UIButton *)button
{
    [UUProgressHUD dismissWithError:@"取消发送"];
    if (playTimer) {
//        [MP3 cancelRecord];
        [[NIMSDK sharedSDK].mediaManager cancelRecord];
        [playTimer invalidate];
        playTimer = nil;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"RecordCancel" object:nil];
    }
    
    //取消辅助定时器
    if (assistPlayTimer) {
        [assistPlayTimer invalidate];
        assistPlayTimer = nil;
    }
    
}

- (void)RemindDragExit:(UIButton *)button{
    
    [UUProgressHUD changeSubTitle:@"松开手指,取消发送"];
    
}

- (void)RemindDragEnter:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"上滑手指,取消发送"];
}
- (void)countVoiceTime
{
    playTime ++;
    if (playTime>=60.0) {
        [self endRecordVoice:nil];
    }
    if (playTime<1.0) {
        [self failRecord];
    }
    
}

- (void)assistCountVoiceTime{
    
    assistPlayTime +=0.1;
}


#pragma mark- 云信录音回调
/** 初始化工作完成，准备开始录制的时候会触发 **/
- (void)recordAudio:(NSString *)filePath didBeganWithError:(NSError *)error{
    
    
}

/**  录制音频完成后的回调 **/
- (void)recordAudio:(NSString *)filePath didCompletedWithError:(NSError *)error{
    
    [self.recordDelegate UUInputFunctionView:self voicePath:filePath  time:(NSInteger)roundf(assistPlayTime)];//用辅助计时器的时间来发送语音消息,更准确,而且不用考虑UI和功能启停. 四舍五入.
    
    //音频消息发送方法
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@",filePath);
        //缓冲消失时间 (最好有block回调消失完成)
        self.voiceSwitchTextButton.enabled = NO;
        self.voiceSwitchTextButton.enabled = YES;
    });
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RecordFinished" object:nil];
}

/** 音频录制进度更新回调 **/
- (void)recordAudioProgress:(NSTimeInterval)currentTime{
    
    //录音触发间隔
    NSLog(@"%f",currentTime);
    
}

-(void)playAudio:(NSString *)filePath didBeganWithError:(NSError *)error{
    
    
}

-(void)playAudio:(NSString *)filePath didCompletedWithError:(NSError *)error{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"StopPlayVoice" object:nil];
}

#pragma mark - Mp3RecorderDelegate

- (void)failRecord{
    
    [UUProgressHUD dismissWithSuccess:@"录音时间太短"];
    [[NIMSDK sharedSDK].mediaManager cancelRecord];
    //缓冲消失时间 (最好有block回调消失完成)
    self.voiceSwitchTextButton.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.voiceSwitchTextButton.enabled = YES;
    });
}


#pragma mark - TextViewDelegate

- (void)textViewDidBeginEditing:(YYTextView *)textView{
    
    [self changeSendBtnWithPhoto:NO];
    
}

- (void)textViewDidChange:(YYTextView *)textView{
    [self changeSendBtnWithPhoto:textView.text.length>0?NO:YES];
    
}

/* 发送按钮变为图片*/
- (void)changeSendBtnWithPhoto:(BOOL)isPhoto{
    
    if (_canNotSendImage == NO) {
        self.isAbleToSendTextMessage = !isPhoto;
        [self.btnSendMessage setTitle:isPhoto?@"":@"发送" forState:UIControlStateNormal];
        self.btnSendMessage.frame = RECT_CHANGE_width(self.btnSendMessage, isPhoto?30:35);
        UIImage *image = [UIImage imageNamed:isPhoto?@"Chat_take_picture":@"chat_send_message"];
        [self.btnSendMessage setBackgroundImage:image forState:UIControlStateNormal];
        
        //    self.btnSendMessage.enabled = YES;
        //    [self.btnSendMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        
    }
    
}

- (void)textViewDidEndEditing:(YYTextView *)textView{
    
    
    //        [self changeSendBtnWithPhoto:YES];
    
}

- (void)changeSenderButton{
    
    [self changeSendBtnWithPhoto:YES];
}



#pragma mark - Add Picture

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self addCarema];
    }else if (buttonIndex == 1){
        [self openPicLibrary];
    }
}
-(void)addCarema{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self.superVC presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Your device don't have camera" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)openPicLibrary{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self.superVC presentViewController:picker animated:YES completion:^{
        }];
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.superVC dismissViewControllerAnimated:YES completion:^{
        [self.delegate UUInputFunctionView:self sendPicture:editImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
