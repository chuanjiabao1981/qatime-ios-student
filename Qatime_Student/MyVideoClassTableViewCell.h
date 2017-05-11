//
//  MyVideoClassTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/21.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoClassInfo.h"
#import "MyVideoClassList.h"
@interface MyVideoClassTableViewCell : UITableViewCell

/**课程图片*/
@property(nonatomic,strong) UIImageView *classImage ;

/**课程名称*/
@property(nonatomic,strong) UILabel *className ;

/**课程信息*/
@property (nonatomic, strong) UILabel *infos ;

/* 状态*/
@property(nonatomic,strong) UILabel *status ;

/* 外框content*/
@property(nonatomic,strong) UIView *content;

/* 进入按钮*/
@property(nonatomic,strong) UIButton *enterButton ;

/**model*/
@property (nonatomic, strong) VideoClassInfo *model ;

/**改为新接口后的model*/
@property (nonatomic, strong) MyVideoClassList *myVideoClassListModel ;

@end
