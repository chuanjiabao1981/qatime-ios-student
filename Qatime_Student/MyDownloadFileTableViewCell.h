//
//  MyDownloadFileTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/9/5.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyDownloadFile.h"

@interface MyDownloadFileTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImagV;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIButton *sendBtn;
@property (nonatomic,copy) void (^Clickblock)(MyDownloadFile *model,UIButton *btn);

@property (nonatomic, strong) MyDownloadFile *model ;

- (void)enterEditMode;

- (void)exitEditeMode;

- (void)clickBtn:(UIButton *)btn;

@end
