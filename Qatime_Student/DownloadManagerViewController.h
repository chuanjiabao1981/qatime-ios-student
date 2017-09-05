//
//  DownloadManagerViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/8/21.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDownloadFile.h"
@protocol FileSelectVcDelegate <NSObject>
@required
//点击发送的事件
- (void)fileViewControlerSelected:(NSArray <MyDownloadFile *> *)fileModels;
@end

@interface DownloadManagerViewController : UIViewController
@property (nonatomic,weak) id<FileSelectVcDelegate> fileSelectVcDelegate;
@end
