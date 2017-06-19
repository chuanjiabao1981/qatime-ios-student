//
//  AllteachersFilterView.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllteachersFilterView : UIView

@property (nonatomic, strong) UIButton *allTeachersBtn ;

@property (nonatomic, strong) UIButton *highSchoolBtn ;

@property (nonatomic, strong) UIButton *middleSchoolBtn ;

@property (nonatomic, strong) UIButton *primarySchoolBtn ;

@property (nonatomic, strong) UIControl *subjectBtn ;
@property (nonatomic, strong) UILabel *subjectLabel ;


@property (nonatomic, strong) NSMutableArray *allBtnsArr ;

@end
