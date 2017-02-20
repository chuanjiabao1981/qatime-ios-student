//
//  TranslateViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/2/20.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "TranslateViewController.h"
#import "UIViewController+HUD.h"

@interface TranslateViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NIMAudioToTextOption *option;
@property (strong, nonatomic) NIMMessage *message;

@end

@implementation TranslateViewController

- (instancetype)initWithMessage:(NIMMessage *)message
{
    if (self = [super initWithNibName:@"NTESAudio2TextViewController"
                               bundle:nil])
    {
        NIMAudioToTextOption *option = [[NIMAudioToTextOption alloc] init];
        option.url                   = [(NIMAudioObject *)message.messageObject url];
        option.filepath              = [(NIMAudioObject *)message.messageObject path];
        _option = option;
        _message = message;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [SVProgressHUD showWithStatus:@"正在转换"];
    [self loadingHUDStartLoadingWithTitle:@"正在转换"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.textView addGestureRecognizer:tap];
    __weak typeof(self) weakSelf = self;
    
        
    [[[NIMSDK sharedSDK]mediaManager]transAudioToText:_option result:^(NSError * _Nullable error, NSString * _Nullable text) {
        
        [self loadingHUDStopLoadingWithTitle:nil];
        weakSelf.cancelBtn.hidden = YES;
        [weakSelf show:error text:text];
        if (!error) {
            weakSelf.message.isPlayed = YES;
        }else{
            [weakSelf.textView removeFromSuperview];
            [weakSelf.view addSubview:weakSelf.errorTipView];
        }
    }];
    [_textView setEditable:NO];
    
}

- (void)viewDidLayoutSubviews{
    CGRect rect = CGRectApplyAffineTransform(self.view.frame, self.view.transform);
    self.errorTipView.top = rect.size.height * .33f;
    self.errorTipView.centerX = rect.size.width * .5f;
}


- (void)show:(NSError *)error  text:(NSString *)text
{
    if (error) {
//        [self.view makeToast:NSLocalizedString(@"转换失败", nil)
//                    duration:2
//                    position:CSToastPositionCenter];
        
    }
    else
    {
        _textView.text = text;
        [_textView sizeToFit];
        if (self.textView.height + self.textView.top > self.view.height) {
            self.textView.height = self.view.height - self.textView.top;
            self.textView.scrollEnabled = YES;
        }else{
            self.textView.scrollEnabled = NO;
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self hide];
}

- (void)hide{
//    [SVProgressHUD dismiss];
    void (^handler)(void)  = self.completeHandler;
    [self dismissViewControllerAnimated:NO
                             completion:^{
                                 if (handler) {
                                     handler();
                                 }
                             }];
}

- (IBAction)cancelTrans:(id)sender{
//    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:NO
                             completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
