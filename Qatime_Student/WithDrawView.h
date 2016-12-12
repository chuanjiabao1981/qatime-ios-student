//
//  WithDrawView.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/11.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithDrawView : UIView

/**
 转账金额
 */
@property(nonatomic,strong) UITextField *moneyText ;



/**
 选择支付宝
 */
@property(nonatomic,strong) UIButton *alipayButton ;


/**
 转账
 */
@property(nonatomic,strong) UIButton *transferButton ;

/**
 下一步按钮
 */
@property(nonatomic,strong) UIButton *nextStepButton ;

@end
