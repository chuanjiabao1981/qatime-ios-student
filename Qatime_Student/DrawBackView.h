//
//  DrawBackView.h
//  Qatime_Student
//
//  Created by Shin on 2017/1/9.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawBackView : UIView

/* 交易号*/
@property(nonatomic,strong) UILabel *number ;

/* 课程名/商品名称*/
@property(nonatomic,strong) UILabel *className ;

/* 课程进度*/
@property(nonatomic,strong) UILabel *progress ;

/* 商品总价*/
@property(nonatomic,strong) UILabel *price ;

/* 已消费金额*/
@property(nonatomic,strong) UILabel *paidPrice ;

/* 退款方式*/
@property(nonatomic,strong) UILabel *drawBackWay ;

/* 可退金额*/
@property(nonatomic,strong) UILabel *enableDrawbackPrice ;

/* 退款原因*/
@property(nonatomic,strong) UITextView *reason ;

/* 提交按钮*/
@property(nonatomic,strong) UIButton *finishButton ;

@end
