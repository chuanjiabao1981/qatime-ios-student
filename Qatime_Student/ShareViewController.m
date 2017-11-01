//
//  ShareViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/10/30.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ShareViewController.h"
#import "WXApi.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _sharedView = [[ShareView alloc]init];
    [self.view addSubview:_sharedView];
    _sharedView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
}


//分享实现
-(void)sharedWithContentDic:(NSDictionary *)sharedDic{
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.text = @"hellohellohellohellohello";
    req.bText = YES;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
    
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
