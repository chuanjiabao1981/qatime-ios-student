//
//  CheckOrderView.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/13.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckOrderView : UIView
/* 充值状态图标*/
@property(nonatomic,strong) UIImageView *statusImage ;

/* 充值是否成功*/
@property(nonatomic,strong) UILabel *status ;

/* 当前余额*/
@property(nonatomic,strong) UILabel *balance ;

/* 编号*/
@property(nonatomic,strong) UILabel *number;
/* 充值金额*/
@property(nonatomic,strong) UILabel *chargeMoney ;

/* 完成按钮*/

@property(nonatomic,strong) UIButton *finishButton ;

/* 未找到充值结果的覆盖view*/

@property(nonatomic,strong) UILabel *explain ;

@end
