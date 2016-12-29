//
//  PersonalDescViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/6.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "PersonalDescViewController.h"
#import "NavigationBar.h"
#import "UIViewController+HUD.h"

@interface PersonalDescViewController ()<YYTextViewDelegate>{
    
    NavigationBar *_navigationBar;
    
    UILabel *_letters;
    
    BOOL outOfLength;
    
}

@end

@implementation PersonalDescViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [self.view addSubview:_navigationBar];
    _navigationBar.titleLabel.text = @"编辑简介";
    
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    _textView = [[YYTextView alloc]init];
    [self.view addSubview: _textView];
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _textView.layer.borderWidth = 0.6;
    
    _textView.sd_layout
    .leftSpaceToView(self.view,20)
    .rightSpaceToView(self.view,20)
    .topSpaceToView(_navigationBar,20)
    .heightRatioToView(self.view,0.1);
    _textView.sd_cornerRadius = [NSNumber numberWithFloat:M_PI *2];
    
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:18*ScrenScale];
    
    UILabel *limit = [[UILabel alloc]init];
    limit.text = @"30";
    [self.view addSubview:limit];
    limit.sd_layout
    .topSpaceToView(_textView,20)
    .rightEqualToView(_textView)
    .autoHeightRatio(0);
    [limit setSingleLineAutoResizeWithMaxWidth:100];
    
    
    UILabel *line = [[UILabel alloc]init];
    line.textAlignment = NSTextAlignmentRight;
    line.text = @"/";
    [self.view addSubview:line];
   
    line.sd_layout
    .rightSpaceToView(limit,0)
    .topEqualToView(limit)
    .bottomEqualToView(limit)
    .widthIs(10);

    
    _letters = [[UILabel alloc]init];
    _letters.text = @"0";
    _letters.font = [UIFont systemFontOfSize:20*ScrenScale];
    [self.view addSubview:_letters];
    _letters.sd_layout
    .rightSpaceToView(line,0)
    .autoHeightRatio(0)
    .centerYEqualToView(line);
    
    [_letters setSingleLineAutoResizeWithMaxWidth:100];
    
    
    
    
    
}


/* 编辑字符的回调*/
- (void)textViewDidChange:(YYTextView *)textView{
    
    
    NSInteger leng = [self unicodeLengthOfString:textView.text];
    
    _letters .text = [NSString stringWithFormat:@"%ld",leng];
    
    if (leng>30) {
        
        outOfLength =YES;
        _letters.textColor = [UIColor redColor];
    }else{
        
        outOfLength = NO;
        _letters.textColor = [UIColor blackColor];
    }
    
    
}

/* unicode和ascii混合文本长度*/

-(NSUInteger) unicodeLengthOfString: (NSString *) text

{
    
    NSUInteger asciiLength = 0;
    
    
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        unichar uc = [text characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
        
    }
    
    
    
    NSUInteger unicodeLength = asciiLength / 2;
    
    
    
    if(asciiLength % 2) {
        
        unicodeLength++;
        
    }
    
    return unicodeLength;
    
}




- (void)returnLastPage{
    
    
    if (outOfLength == YES) {
        /* 超出范围了*/
        
        [self loadingHUDStopLoadingWithTitle:@"超过30个字!请重新输入!"];
        
        
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否保存修改?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }] ;
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [_delegate changeUserDesc:_textView.text];
            [self.navigationController popViewControllerAnimated:YES];
        }] ;
        
        [alert addAction:cancel];
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    

    
    
    
    
    
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
