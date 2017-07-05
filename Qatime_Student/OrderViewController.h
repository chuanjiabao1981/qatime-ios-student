//
//  OrderViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/12.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderView.h"

typedef enum : NSUInteger {
    LiveClassType,
    InteractionType,
    VideoClassType
} ClassOrderType;


@interface OrderViewController : UIViewController


@property(nonatomic,strong) NSString *classID ;

@property(nonatomic,strong) OrderView *orderView ;


/**
 订单信息页面

 @param classID 辅导班编号
 @return 实例
 */
-(instancetype)initWithClassID:(NSString *)classID andClassType:(ClassOrderType)type andProductName:(NSString *)productName ;


/**
 订单信息页

 @param classID 辅导班编号
 @param promotionCode 优惠码
 @return 实例
 */
-(instancetype)initWithClassID:(NSString *)classID andPromotionCode:(NSString *)promotionCode  andClassType:(ClassOrderType)type andProductName:(NSString *)productName ;

@end
