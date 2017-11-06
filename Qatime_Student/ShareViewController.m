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
    
    /** 自己写一个字段封装.
     键值:
     type:  text . link
     类型    文本    链接
     
     content: text类型传一个字符串就行了.
     content: link类型传title.description.link
     
     实例:
     //文本类型
     @{
     "type" : "text",
     "content" : "分享的文字内容balabala..."
     }
     
     //链接类型
     @{
     "type" : "link",
     "content" "{
         "title" : "标题是啥啥啥",
         "description" : "具体内容是啥啥啥",
         "link" : "www.qatime.cn"
         }
     }
     */
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
    req.scene = WXSceneSession;
    if ([sharedDic[@"type"]isEqualToString:@"text"]) {
        req.text = sharedDic[@"content"];
        req.bText = YES;
    }else if ([sharedDic[@"type"]isEqualToString:@"link"]){
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = sharedDic[@"content"][@"title"];
        message.description = sharedDic[@"content"][@"description"];
        [message setThumbImage:[UIImage imageNamed:@"AppIcon"]];
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = sharedDic[@"content"][@"link"];
        message.mediaObject = webpageObject;
        req.bText = NO;
        req.message = message;
    }
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
