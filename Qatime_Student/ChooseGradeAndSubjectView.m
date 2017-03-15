//
//  ChooseGradeAndSubjectView.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ChooseGradeAndSubjectView.h"
#import "ChooseClassViewController.h"

@implementation ChooseGradeAndSubjectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //左侧 年级列表
        _gradeView = ({
            UIView *_ = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width_sd/3, self.height_sd)];
            [self addSubview:_];
            _.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.95];
            _;
        
        });
        
        //右侧 科目列表
        _subjectView =({
            UIView *_ = [[UIView alloc]initWithFrame:CGRectMake(self.width_sd/3, 0, self.width_sd/3*2, self.height_sd)];
            [self addSubview:_];
            _.backgroundColor = [UIColor whiteColor];
            _;
            
        });
        
        //左侧按钮
        _gradeButtons = @[].mutableCopy;
        NSArray *gradeArr=@[@"高三",@"高二",@"高一",@"初三",@"初二",@"初一",@"六年级",@"五年级",@"四年级",@"三年级",@"二年级",@"一年级"];
        
        NSInteger index = 0;
        for (NSString *grade in gradeArr) {
            UIButton *btn = [[UIButton alloc]init];
            [_gradeView addSubview:btn];
            [btn setTitle:grade forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:UIControlStateNormal];
            btn.tag = index;
            btn.sd_layout
            .leftSpaceToView(_gradeView,0)
            .rightSpaceToView(_gradeView,0)
            .heightIs(self.height_sd/15)
            .topSpaceToView(_gradeView,20+index*self.height_sd/15);
            [btn addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
            [_gradeButtons addObject:btn];

            index++;
            
        }
        
        //右边按钮
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(self.width_sd*2/3/2-30, (self.width_sd*2/3/2-30)*0.3);
        
        _subjectCollection = ({
            UICollectionView *_ = [[UICollectionView alloc]initWithFrame:_subjectView.bounds collectionViewLayout:layout];
            _.backgroundColor = [UIColor whiteColor];
            [_subjectView addSubview:_];
            _.hidden = YES;
            _;
        });
    }
    return self;
}

//点击按钮
- (void)selected:(UIButton *)sender{
    
    _subjectCollection.hidden = NO;
    
    for (UIButton *btn in _gradeButtons) {
        btn.selected = NO;
        [btn setTitleColor:[UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1.00] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor clearColor]];
    }
    sender.selected = YES;
    [sender setTitleColor:BUTTONRED forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor whiteColor]];
    
    //年级信息代理出去
    [_delegate chooseGrade:sender.titleLabel.text];

}

@end
