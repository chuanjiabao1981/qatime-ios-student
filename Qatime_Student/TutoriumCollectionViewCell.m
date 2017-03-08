//
//  TutoriumCollectionViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/2.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "TutoriumCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@interface TutoriumCollectionViewCell (){
  
    SDWebImageManager *manager;
}

@end

@implementation TutoriumCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 白色背景*/
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        /* 课程图布局*/
        
        _classImage = [[UIImageView alloc]init];
        [self.contentView addSubview:_classImage];
        _classImage.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).heightRatioToView(self.contentView,0.7);
        
        
        /* 课程名*/
        _className = [[UILabel alloc]init];
        _className.font = [UIFont systemFontOfSize:15*ScrenScale];
        [self.contentView addSubview:_className];
        _className.sd_layout
        .leftEqualToView(_classImage)
        .rightEqualToView(_classImage)
        .topSpaceToView(_classImage,5)
        .heightIs(20);
        

        /* 教师姓名label*/
        /**** 预留label的宽度和教师姓名model源 ***/
        _teacherName = [[UILabel alloc]init];
        [self.contentView addSubview:_teacherName];
        _teacherName.textColor = [UIColor blackColor];
        _teacherName.sd_layout
        .rightSpaceToView(self.contentView,0)
        .topSpaceToView(_className,5)
        .autoHeightRatio(0);
        [_teacherName setSingleLineAutoResizeWithMaxWidth:200];
        
        [_teacherName setText:NSLocalizedString(@"老师姓名", nil)];
        _teacherName.font = [UIFont systemFontOfSize:14*ScrenScale];

        
        /* 价格label */
        /* 价格信息  预留接口model*/
        _price = [[UILabel alloc]init];
        [self.contentView addSubview:_price];
        _price.textColor = [UIColor redColor];
        _price.text = [NSString stringWithFormat:@"¥0.00"];
        _price.sd_layout
        .leftSpaceToView(self.contentView,0)
        .topSpaceToView(_className,5)
        .rightSpaceToView(_teacherName,0)
        .autoHeightRatio(0);
        _price.font = [UIFont systemFontOfSize:14*ScrenScale];
        _price.textAlignment = NSTextAlignmentLeft;
        
        //先隐藏
        _price.hidden = YES;
        
        manager = [[SDWebImageManager alloc]init];
        
        
    }
    return self;
}


-(void)setModel:(TutoriumListInfo *)model{
    
    _model = model;
    
    /* 如果本地已经保留了图片缓存*/
    if ([self diskImageExistsForURL:[NSURL URLWithString:model.publicize]]==YES) {
        [_classImage sd_setImageWithURL:[NSURL URLWithString:model.publicize]];
    }else{
    
        [_classImage sd_setImageWithURL:[NSURL URLWithString:model.publicize] placeholderImage:[UIImage imageNamed:@"school"] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            _classImage.alpha = 0.0;
            [UIView transitionWithView:_classImage duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                if (image) {
                
                    [_classImage setImage:image];
                }else{
                    [_classImage setImage:[UIImage imageNamed:@"school"]];
                }
                _classImage.alpha = 1.0;
            } completion:NULL];
            
        }];
    }
    
    
    /* cell 教师姓名 赋值*/
    [_teacherName setText:model.teacher_name];
    
    /* cell 科目赋值*/
    
    [_subjectName setText:NSLocalizedString(model.subject, nil)];
    
    /* cell 年级赋值*/
    [_grade setText:NSLocalizedString(model.grade, nil)];
    
    /* cell 价格赋值*/
    [_price setText:[NSString stringWithFormat:@"¥%@.00",model.price]];
    
    /* cell 已购买的用户 赋值*/
    [_saleNumber setText:model.buy_tickets_count];
    
    /* cell 的课程id属性*/
    _classID = model.classID ;
    
    [_className setText: model.name];

    
}



- (BOOL)diskImageExistsForURL:(NSURL *)url {
    NSString *key = [manager cacheKeyForURL:url];
    return [manager.imageCache diskImageExistsWithKey:key];
}


@end
