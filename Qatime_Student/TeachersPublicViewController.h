//
//  TeachersPublicViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeachersPublicHeaderView.h"
#import "TeachersPublicCollectionView.h"


@interface TeachersPublicViewController : UIViewController

@property(nonatomic,strong) TeachersPublicHeaderView *teachersPublicHeaderView ;

@property(nonatomic,strong) TeachersPublicCollectionView *teachersPublicCollectionView ;


@property(nonatomic,strong) NSString *teacherID ;

- (instancetype)initWithTeacherID:(NSString *)teacherID;

@end
