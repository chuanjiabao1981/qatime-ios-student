//
//  OrderView.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/12.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutoriumList.h"
#import "OneOnOneClass.h"

@interface OrderView : UIScrollView

/* 课程名称*/
@property(nonatomic,strong) UILabel *className ;

/* 科目*/
@property(nonatomic,strong) UILabel *subjectLabel ;
/* 年级*/
@property(nonatomic,strong) UILabel *gradeLabel ;
/* 授课老师*/
@property(nonatomic,strong) UILabel *teacheNameLabel ;
/* 总课时*/
@property(nonatomic,strong) UILabel *classTimeLabel ;

/* 价格*/
@property(nonatomic,strong) UILabel *priceLabel ;

/* 微信支付按钮*/
@property(nonatomic,strong) UIButton *wechatButton ;
/* 支付宝支付按钮*/
@property(nonatomic,strong) UIButton *alipayButton ;
/* 余额支付按钮*/
@property(nonatomic,strong) UIButton *balanceButton ;
@property(nonatomic,strong) UILabel *balance ;
@property(nonatomic,strong) UIImageView *balanceImage ;

/* 余额*/
@property(nonatomic,strong) UILabel *balanceLabel ;

/* 总金额*/
@property(nonatomic,strong) UILabel *totalMoneyLabel ;

/* 支付按钮*/
@property(nonatomic,strong) UIButton *applyButton ;

/* 优惠码按钮*/
@property(nonatomic,strong) UIButton *promotionButton ;

/* 优惠码输入框*/
@property(nonatomic,strong) UITextField *promotionText ;

/* 输入优惠码确定按钮*/
@property(nonatomic,strong) UIButton *sureButton ;

/* 优惠金额*/
@property(nonatomic,strong) UILabel *promotionNum ;


/*********辅助分割线***********/
@property(nonatomic,strong) UIView *subLine ;


/* 几块底视图*/
@property(nonatomic,strong) UIView *infoView;

/**
 直播课页面赋值方法

 @param tutorium id
 */
- (void)setupLiveClassData:(TutoriumListInfo *)tutorium;


/**
 互动课程页面赋值方法

 @param interaction id
 */
- (void)setupInteractionData:(OneOnOneClass *)interaction;

@end
