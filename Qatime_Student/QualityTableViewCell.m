//
//  QualityTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "QualityTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"


@interface QualityTableViewCell (){
    
    UIView *_content;  //背景框
    
    UIImageView *_subjectImage;
    
    UIImageView *_teacherImage;
    
    //图片缓存管理器
    SDWebImageManager *manager;
    
}

@end

@implementation QualityTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //背景content
        _content = [[UIView alloc]init];
        [self.contentView addSubview:_content];
        _content.sd_layout
        .leftSpaceToView(self.contentView,10*ScrenScale)
        .topSpaceToView(self.contentView,10*ScrenScale)
        .rightSpaceToView(self.contentView,10*ScrenScale)
        .bottomSpaceToView(self.contentView,10*ScrenScale);
        _content.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        _content.layer.borderWidth = 0.8;
        [_content updateLayout];
        
        //课程图
        _classImage = [[UIImageView alloc]init];
        [_content addSubview:_classImage];
        _classImage.sd_layout
        .leftSpaceToView(_content,0)
        .topSpaceToView(_content,0)
        .bottomSpaceToView(_content,0)
        .autoWidthRatio(1.6);
        
        
        //两个状态标签
        _left_StateLabel = [[UILabel alloc]init];
        _left_StateLabel.textColor = [UIColor whiteColor];
        _left_StateLabel.backgroundColor = [UIColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:1.0];
        _left_StateLabel.font = [UIFont systemFontOfSize:12*ScrenScale];
        [_classImage addSubview:_left_StateLabel];
        _left_StateLabel.sd_layout
        .leftSpaceToView(_classImage,0)
        .bottomSpaceToView(_classImage,0)
        .autoHeightRatio(0);
        [_left_StateLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        _right_StateLabel = [[UILabel alloc]init];
        _right_StateLabel.textColor = [UIColor whiteColor];
        _right_StateLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0.4 blue:0.0 alpha:1.0];
        [_classImage addSubview:_right_StateLabel];
        _right_StateLabel.font = [UIFont systemFontOfSize:12*ScrenScale];
        _right_StateLabel.sd_layout
        .leftSpaceToView(_left_StateLabel,0)
        .bottomSpaceToView(_classImage,0)
        .autoHeightRatio(0);
        [_right_StateLabel setSingleLineAutoResizeWithMaxWidth:100];
        
        
        //课程名
        _className = [[UILabel alloc]init];
        _className.font = [UIFont systemFontOfSize:15*ScrenScale];
        _className.textColor = [UIColor blackColor];
        [_content addSubview:_className];
        _className.sd_layout
        .topSpaceToView(_content,10*ScrenScale)
        .leftSpaceToView(_classImage,10*ScrenScale)
        .rightSpaceToView(_content, 10*ScrenScale)
        .autoHeightRatio(0);
        [_className setMaxNumberOfLinesToShow:1];
        
        //教师图片
//        _teacherImage = [[UIImageView alloc]init];
//        [_teacherImage setImage:[UIImage imageNamed:@"老师"]];
//        [_content addSubview:_teacherImage];
//        _teacherImage.sd_layout
//        .leftEqualToView(_className)
//        .bottomSpaceToView(_content,10)
//        .heightIs(12)
//        .widthEqualToHeight();
        
        
        //教师姓名
        _teacherName = [[UILabel alloc]init];
        _teacherName.textColor = TITLECOLOR;
        _teacherName.font = [UIFont systemFontOfSize:12*ScrenScale];
        [_content addSubview:_teacherName];
        _teacherName.sd_layout
        .leftEqualToView(_className)
        .bottomSpaceToView(_content,10*ScrenScale)
        .autoHeightRatio(0);
        [_teacherName setSingleLineAutoResizeWithMaxWidth:100];
        
//        //年级科目图片
//        _subjectImage = [[UIImageView alloc]init];
//        [_subjectImage setImage:[UIImage imageNamed:@"book"]];
//        [_content addSubview:_subjectImage];
//        _subjectImage.sd_layout
//        .leftEqualToView(_className)
//        .bottomSpaceToView(_teacherImage,10)
//        .heightIs(12)
//        .widthEqualToHeight();
        
        //年级科目label
        _gradeAndSubject = [[UILabel alloc]init];
        _gradeAndSubject.font = [UIFont systemFontOfSize:12*ScrenScale];
        _gradeAndSubject.textColor = TITLECOLOR;
        [_content addSubview:_gradeAndSubject];
        _gradeAndSubject.sd_layout
        .leftEqualToView(_className)
        .bottomSpaceToView(_teacherName,10*ScrenScale)
        .autoHeightRatio(0);

        [_gradeAndSubject setSingleLineAutoResizeWithMaxWidth:200];
        
    
    }
    return self;
}

- (void)setFreeModel:(FreeCourse *)freeModel{
    
    _freeModel = freeModel;
    
    /**加载缓存图片*/
    [_classImage sd_setImageWithURL:[NSURL URLWithString:freeModel.publicizes[@"list"][@"url"]] placeholderImage:[UIImage imageNamed:@"school"] options:SDWebImageRefreshCached completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        [manager diskImageExistsForURL:[NSURL URLWithString:freeModel.publicizes[@"list"][@"url"]] completion:^(BOOL isInCache) {
            if (isInCache == YES) {
                
            }else{
                _classImage.alpha = 0.0;
                [UIView transitionWithView:_classImage duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    if (image) {
                        
                        [_classImage setImage:image];
                    }else{
                        [_classImage setImage:[UIImage imageNamed:@"school"]];
                    }
                    _classImage.alpha = 1.0;
                } completion:NULL];
                
            }
            
        }];
        
    }];
    
    //课程名
    _className.text = freeModel.name;
    
    //年级和科目
    _gradeAndSubject.text = [NSString stringWithFormat:@"%@%@",freeModel.grade,freeModel.subject];
    //教师名
    _teacherName.text = freeModel.teacher_name;

}

-(void)setClassModel:(TutoriumListInfo *)classModel{
    
    _classModel = classModel;
    
    /**加载缓存图片*/
    [_classImage sd_setImageWithURL:[NSURL URLWithString:classModel.publicize] placeholderImage:[UIImage imageNamed:@"school"] options:SDWebImageRefreshCached completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        [manager diskImageExistsForURL:[NSURL URLWithString:classModel.publicize] completion:^(BOOL isInCache) {
            if (isInCache == YES) {
                
            }else{
                _classImage.alpha = 0.0;
                [UIView transitionWithView:_classImage duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    if (image) {
                        
                        [_classImage setImage:image];
                    }else{
                        [_classImage setImage:[UIImage imageNamed:@"school"]];
                    }
                    _classImage.alpha = 1.0;
                } completion:NULL];
                
            }
            
        }];
        
    }];

    //课程名
    _className.text = classModel.name;
    
    //年级和科目
    _gradeAndSubject.text = [NSString stringWithFormat:@"%@%@",classModel.grade,classModel.subject];
    //教师名
    _teacherName.text = classModel.teacher_name;

}

-(void)setRecommandModel:(RecommandClasses *)recommandModel{
    
    _recommandModel = recommandModel;
    
    /**加载缓存图片*/
    [_classImage sd_setImageWithURL:[NSURL URLWithString:recommandModel.publicize] placeholderImage:[UIImage imageNamed:@"school"] options:SDWebImageRefreshCached completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        [manager diskImageExistsForURL:[NSURL URLWithString:recommandModel.publicize] completion:^(BOOL isInCache) {
            if (isInCache == YES) {
                
            }else{
                _classImage.alpha = 0.0;
                [UIView transitionWithView:_classImage duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    if (image) {
                        
                        [_classImage setImage:image];
                    }else{
                        [_classImage setImage:[UIImage imageNamed:@"school"]];
                    }
                    _classImage.alpha = 1.0;
                } completion:NULL];
                
            }
            
        }];
        
    }];
    
    
    //课程名
    _className.text = recommandModel.name;
    
    //年级和科目
    _gradeAndSubject.text = [NSString stringWithFormat:@"%@%@",recommandModel.grade,recommandModel.subject];
    //教师名
    _teacherName.text = recommandModel.teacher_name;
    
    
    //标签
    _left_StateLabel.text = [self transStateTag:recommandModel.tag_one];
    _right_StateLabel.text =[self transStateTag:recommandModel.tag_two];
    
    
}


-(void)setNewestModel:(NewestClass *)newestModel{
    
    _newestModel = newestModel;
    
    NSURL *pubURL ;
    if (newestModel.publicizes) {
        pubURL = [NSURL URLWithString:newestModel.publicizes[@"list"][@"url"]];
    }
    /**加载缓存图片*/
    [_classImage sd_setImageWithURL:pubURL placeholderImage:[UIImage imageNamed:@"school"] options:SDWebImageRefreshCached completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        [manager diskImageExistsForURL:pubURL completion:^(BOOL isInCache) {
            if (isInCache == YES) {
                
            }else{
                _classImage.alpha = 0.0;
                [UIView transitionWithView:_classImage duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    if (image) {
                        
                        [_classImage setImage:image];
                    }else{
                        [_classImage setImage:[UIImage imageNamed:@"school"]];
                    }
                    _classImage.alpha = 1.0;
                } completion:NULL];
                
            }
            
        }];
        
    }];
    
    //课程名
    _className.text = newestModel.name;
    
    //年级和科目
    _gradeAndSubject.text = [NSString stringWithFormat:@"%@%@",newestModel.grade,newestModel.subject];
    //教师名
    _teacherName.text = newestModel.teacher_name;
    
    
    //标签
//    _left_StateLabel.text = [self transStateTag:newestModel.tag_one];
//    _right_StateLabel.text =[self transStateTag:newestModel.tag_two];
    
}


- (NSString *)transStateTag:(NSString *)state{
    
    NSString *str = @"".mutableCopy;
    if ([state isEqual:[NSNull null]]) {
        
    }else{
        
        if ([state isEqualToString:@"star_teacher"]) {
            str = @" 名师 ";
        }else if ([state isEqualToString:@"best_seller"]){
            str = @" 畅销 ";
        }else if ([state isEqualToString:@"free_tastes"]){
            str = @" 试听 ";
        }else if ([state isEqualToString:@"join_cheap"]){
            str = @" 优惠 ";
        }
    }
    
    
    return str;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end





