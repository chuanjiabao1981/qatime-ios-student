//
//  PaidOrderTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "MyOrderTableViewCell.h"
#import "Paid.h"

@interface PaidOrderTableViewCell : UITableViewCell

/* 课程名*/
@property(nonatomic,strong) UILabel  *name ;
/**订单课程信息*/
@property (nonatomic, strong) UILabel *orderInfos ;

/* 价格*/
@property(nonatomic,strong) UILabel *price ;
/* 交易状态*/
@property(nonatomic,strong) UILabel *status ;

/* 右侧按钮*/
@property(nonatomic,strong) UIButton *rightButton ;

/**不支持退款的提示视图*/
@property (nonatomic, strong) UILabel *unTips ;
@property (nonatomic, strong) UIImageView *unTipsImage ;



@property(nonatomic,strong) Paid *paidModel;

@end
