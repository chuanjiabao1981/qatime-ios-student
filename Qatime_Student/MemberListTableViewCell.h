//
//  MemberListTableViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2016/11/22.
//  Copyright © 2016年 WWTD. All rights reserved.
//


/* 在线人数的cell*/
#import <UIKit/UIKit.h>
#import "Members.h"

@interface MemberListTableViewCell : UITableViewCell

/* 用户头像 */
@property(nonatomic,strong) UIImageView *memberIcon ;

/* 用户姓名*/
@property(nonatomic,strong) UILabel *name ;

/* 角色*/
@property(nonatomic,strong) UILabel *character;


/* model*/
@property(nonatomic,strong) Members *model ;



@end
