//
//  CancelOrderTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "CancelOrderTableViewCell.h"

@implementation CancelOrderTableViewCell


-(void)setCanceldModel:(Canceld *)canceldModel{
    
    _canceldModel = canceldModel;
    self.classTime .text = canceldModel.preset_lesson_count ;
    self.name.text = canceldModel.name;
    self.subject.text = canceldModel.subject;
    self.grade.text = canceldModel.grade;
    self.teacherName.text = canceldModel.teacher_name;
    
    self.price.text = [NSString stringWithFormat:@"¥%@",canceldModel.price];
    
    if ([canceldModel.status isEqualToString:@"unpaid"]) {
        self.status.text = @"待付款";
    }else if ([canceldModel.status isEqualToString:@"shipped"]){
        self.status.text = @"交易完成";
    }else if ([canceldModel.status isEqualToString:@"canceled"]){
        self.status.text = @"已取消";
    }

    
    
}

@end
