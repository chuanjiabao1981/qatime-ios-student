//
//  TeachersPublicInfo.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TeachersPublicInfo : NSObject

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

@property(nonatomic,strong) NSString *name ;
@property(nonatomic,strong) NSString *desc ;
@property(nonatomic,strong) NSString *teaching_years ;
@property(nonatomic,strong) NSString *gender ;
@property(nonatomic,strong) NSString *grade ;
@property(nonatomic,strong) NSString *subject ;
@property(nonatomic,strong) NSString *category;
@property(nonatomic,strong) NSString *province;
@property(nonatomic,strong) NSString *city;
@property(nonatomic,strong) NSString *avatar_url;
@property(nonatomic,strong) NSString *school ;
@property(nonatomic,strong) NSMutableArray *courses;

//正加一个富文本
@property (nonatomic, strong) NSMutableAttributedString *attributeDescription ;




@end
