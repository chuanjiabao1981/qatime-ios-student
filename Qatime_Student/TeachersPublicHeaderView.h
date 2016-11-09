//
//  TeachersPublicHeaderView.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeachersPublicHeaderView : UICollectionReusableView

//
//"name": "高守华",
//"desc": "",
//"teaching_years": "within_twenty_years",
//"gender": "female",
//"grade": null,
//"subject": "数学",
//"category": "小学",
//"province": "山西",
//"city": "阳泉",
//"avatar_url": "http://qatime-testing.oss-cn-beijing.aliyuncs.com/avatars/c149f03ba8dd4c3391b1815a4caac685.jpg",
//"school": "西南舁联校",


/* 头像背景图*/
@property(nonatomic,strong) UIImageView *bakcgroudImage ;

/* 教师头像*/

@property(nonatomic,strong) UIImageView *teacherHeadImage ;

/* 老师姓名*/
@property(nonatomic,strong) UILabel *teacherNameLabel ;

/* 性别*/
@property(nonatomic,strong) UIImageView *genderImage ;

/* 学龄阶段*/
@property(nonatomic,strong) UILabel *category ;


/* 科目*/

@property(nonatomic,strong) UILabel *subject ;

/* 教龄*/
@property(nonatomic,strong) UILabel *teaching_year ;

/* 地址*/
@property(nonatomic,strong) UILabel *province ;

@property(nonatomic,strong) UILabel *city ;

/* 学校*/
@property(nonatomic,strong) UILabel *workPlace ;

/* 自我介绍*/
@property(nonatomic,strong) UILabel *selfInterview ;



@end
