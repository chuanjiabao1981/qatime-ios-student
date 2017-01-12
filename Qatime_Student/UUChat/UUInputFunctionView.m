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




@interface UUInputFunctionView ()<YYTextViewDelegate,Mp3RecorderDelegate,UITextViewDelegate>
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
//        self.btnSendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.btnSendMessage.frame = CGRectMake(Main_Screen_Width-40, 5, 30, 30);
//        self.isAbleToSendTextMessage = NO;
//        [self.btnSendMessage setTitle:@"发送" forState:UIControlStateNormal];
//        [self.btnSendMessage setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        self.btnSendMessage.enabled = NO;
//        self.btnSendMessage.frame = RECT_CHANGE_width(self.btnSendMessage,35);
//        UIImage *image = [UIImage imageNamed:@"chat_send_message"];
//        [self.btnSendMessage setBackgroundImage:image forState:UIControlStateNormal];
//        self.btnSendMessage.titleLabel.font = [UIFont systemFontOfSize:12];
//        [self.btnSendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:self.btnSendMessage];
        
        self.btnSendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.btnSendMessage.frame = CGRectMake(Main_Screen_Width-40, 5, 30, 30);
        
        self.isAbleToSendTextMessage = NO;
        [self.btnSendMessage setTitle:@"" forState:UIControlStateNormal];
        [self.btnSendMessage setBackgroundImage:[UIImage imageNamed:@"Chat_take_picture"] forState:UIControlStateNormal];
        self.btnSendMessage.titleLabel.font = [UIFont systemFontOfSize:12*ScrenScale];
        [self.btnSendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnSendMessage];
        self.btnSendMessage.sd_layout
        .rightSpaceToView(self,10)
        .topSpaceToView(self,5)
        .bottomSpaceToView(self,10)
        .widthEqualToHeight();
        
        //改变状态（语音、文字） 切换表情键盘
        self.btnChangeVoiceState = [UIButton buttonWithType:UIButtonTypeCustom];
        
        isbeginVoiceRecord = NO;
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
        self.btnChangeVoiceState.titleLabel.font = [UIFont systemFontOfSize:12*ScrenScale];
        
        [self addSubview:self.btnChangeVoiceState];
        self.btnChangeVoiceState.sd_layout
        .rightSpaceToView(self.btnSendMessage,5)
        .topSpaceToView(self,5)
        .bottomSpaceToView(self,10)
        .widthEqualToHeight();
        
        
        //输入框
        self.TextViewInput = [[UITextView alloc]init];
        self.TextViewInput.layer.cornerRadius = 4;
        self.TextViewInput.layer.masksToBounds = YES;
        self.TextViewInput.delegate = self;
        self.TextViewInput.layer.borderWidth = 1;
        self.TextViewInput.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        [self addSubview:self.TextViewInput];
         self.TextViewInput.sd_layout
        .leftSpaceToView(self,10)
        .rightSpaceToView(self.btnChangeVoiceState,10)
        .topSpaceToView(self,5)
        .bottomSpaceToView(self,10);
        
    
        //分割线
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        
        //添加通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidEndEditing:) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeSenderButton) name:@"ChatNone" object:nil] ;
        
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
    
    if (self.isAbleToSendTextMessage) {
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


#pragma mark - TextViewDelegate

- (void)textViewDidBeginEditing:(YYTextView *)textView{
    
    [self changeSendBtnWithPhoto:NO];
    
}

- (void)textViewDidChange:(YYTextView *)textView{
    [self changeSendBtnWithPhoto:textView.text.length>0?NO:YES];
    
}

/* 发送按钮变为图片*/
- (void)changeSendBtnWithPhoto:(BOOL)isPhoto{
   
    self.isAbleToSendTextMessage = !isPhoto;
    [self.btnSendMessage setTitle:isPhoto?@"":@"发送" forState:UIControlStateNormal];
    self.btnSendMessage.frame = RECT_CHANGE_width(self.btnSendMessage, isPhoto?30:35);
    UIImage *image = [UIImage imageNamed:isPhoto?@"Chat_take_picture":@"chat_send_message"];
    [self.btnSendMessage setBackgroundImage:image forState:UIControlStateNormal];

    
//    self.btnSendMessage.enabled = YES;
//    [self.btnSendMessage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
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
    [self.superVC dismissViewControllerAnimated:YES completion:nil];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
