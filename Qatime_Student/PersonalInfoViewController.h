//
//  PersonalInfoViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/12/5.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalInfoView.h"
#import "ChangeDescDelegate.h"


@interface PersonalInfoViewController : UIViewController

@property(nonatomic,strong) PersonalInfoView *personalInfoView ;



/**
 从注册页面传值跳转到个人详情页完善信息的初始化方法

 @param name 用户姓名
 @param grade 年级
 @param headImage 头像图片
 @return 初始化实例
 */
-(instancetype)initWithName:(nullable NSString *)name andGrade:(nullable NSString *)chosegrade andHeadImage:(nullable UIImage *)headImage  withImageChange:(BOOL)imageChange;

@end
