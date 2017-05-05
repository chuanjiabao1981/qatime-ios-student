//
//  TranslateViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/2/20.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "TranslateViewController.h"
#import "UIViewController+HUD.h"

#import "UIViewController+AFHTTP.h"

#import "NSData+YYAdd.h"
#import "NSString+YYAdd.h"

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
    
    [self loadingHUDStartLoadingWithTitle:@"正在转换"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.textView addGestureRecognizer:tap];
    
    
    _faildView = [[UIImageView alloc]init];
    
    
    [_faildView setImage:[UIImage imageNamed:@"sad"]];
    
    [self.view addSubview:_faildView];
    
    _faildView.sd_layout
    .centerYIs(self.view.centerY_sd-100)
    .centerXEqualToView(self.view)
    .widthIs(self.view.width_sd/3)
    .heightEqualToWidth();
    _faildView.hidden = YES;
    
    
    NSDictionary *dics = [[NSUserDefaults standardUserDefaults]valueForKey:@"Baidu_Token"];
    NSString *accToken = dics[@"access_token"];
    NSData *filedata = [NSData dataWithContentsOfFile:_option.filepath];
    NSString *speech = [filedata base64EncodedString];
    [self POSTSessionURL:[NSString stringWithFormat:@"http://vop.baidu.com/server_api?cuid=qatime_students&token=%@",accToken]  withHeaderInfo:@"audio/amr;rate=16000" andHeaderfield:@"Content-Type" parameters:
     @{
       @"format":@"amr",
       @"rate":[NSString stringWithFormat:@"%d",16000],
       @"channel":[NSString stringWithFormat:@"%d",1],
       @"token":accToken,
       @"cuid":@"qatime_students",
       @"speech":speech,
       @"len":[NSString stringWithFormat:@"%ld",filedata.length]
       } completeSuccess:^(id  _Nullable responds) {
           
           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
           NSLog(@"%@", dic);
           
           for (NSString *key  in dic) {
               if ([key isEqualToString:@"err_msg"]) {
                   
                   [self loadingHUDStopLoadingWithTitle:nil];
                   
                   _textView.hidden = YES;
                   _faildView.hidden = NO;
                   
                   return ;
               }else{
                   [self loadingHUDStopLoadingWithTitle:nil];
                  _textView.hidden = NO;
                    _faildView.hidden = YES;
               }
           }
           
           
       }];
    
    [_textView setEditable:NO];
    
}



- (void)show:(NSError *)error  text:(NSString *)text
{
    if (error) {
        
//        [self.loadingHUD hide:YES];
        [self stopHUD];
        
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
