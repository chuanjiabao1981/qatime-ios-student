//
//  RecommandClassCollectionViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "RecommandClassCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@interface RecommandClassCollectionViewCell (){
    
    SDWebImageManager *manager;
}

@end

@implementation RecommandClassCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /* 白色背景*/
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        /* 课程图布局*/
        
        _classImage = [[UIImageView alloc]init];
        //        [_classImage setImage:[UIImage imageNamed:@"school"]];
        [self.contentView addSubview:_classImage];
        _classImage.sd_layout.topSpaceToView(self.contentView,0).leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).heightRatioToView(self.contentView,0.7);
        
        /* 教师姓名label*/
        /**** 预留label的宽度和教师姓名model源 ***/
        _className = [[UILabel alloc]init];
        [self.contentView addSubview:_className];
        _className.textColor = [UIColor blackColor];
        _className.sd_layout
        .leftSpaceToView(self.contentView,0)
        .topSpaceToView(_classImage,5)
        .rightEqualToView(self.contentView)
        .heightIs(20);
        [_className setText:NSLocalizedString(@"课程名称", nil)];
        _className.textAlignment = NSTextAlignmentLeft;
        
        _className.font = [UIFont systemFontOfSize:15];
        
        /* 年级 label*/
        _grade = [[UILabel alloc]init];
        [self.contentView addSubview:_grade];
        [_grade setText:NSLocalizedString(@"年级", nil)];
        _grade.textColor =[UIColor grayColor];
        _grade.sd_layout.leftEqualToView(_className).topSpaceToView(_className,0).autoHeightRatio(0);
        [_grade setSingleLineAutoResizeWithMaxWidth:200];
        _grade.textAlignment = NSTextAlignmentRight;
        [_grade setFont:[UIFont systemFontOfSize:12*ScrenScale]];
        
        /* 科目 label*/
        /* 科目名称  预留名称的接口model*/
        _subjectName = [[UILabel alloc]init];
        [self.contentView addSubview:_subjectName];
        [_subjectName setText:NSLocalizedString(@"科目名称", nil)];
        _subjectName.textColor =[UIColor grayColor];
        _subjectName.sd_layout.leftSpaceToView(_grade,0).topSpaceToView(_className,0).autoHeightRatio(0);
        [_subjectName setSingleLineAutoResizeWithMaxWidth:80];
        _subjectName.textAlignment = NSTextAlignmentRight;
        [_subjectName setFont:[UIFont systemFontOfSize:12*ScrenScale]];
        
        /* **人已购的label*/
        _saledLabel =[[UILabel alloc]init];
        [self.contentView addSubview:_saledLabel];
        [_saledLabel setText:NSLocalizedString(@"人报名", nil)];
        _saledLabel.sd_layout.rightEqualToView(self.contentView).topSpaceToView(_className,0).autoHeightRatio(0);
        [_saledLabel setSingleLineAutoResizeWithMaxWidth:100];
        [_saledLabel setFont:[UIFont systemFontOfSize:12*ScrenScale]];
        
                
        /* 已购买的用户数量*/
        _saleNumber = [[UILabel alloc]init];
        [self.contentView addSubview:_saleNumber];
        _saleNumber.textColor = [UIColor lightGrayColor];
//        _saleNumber.text = @"10";
        _saleNumber.sd_layout.rightSpaceToView(_saledLabel,0).topEqualToView(_saledLabel).autoHeightRatio(0);
        [_saleNumber setSingleLineAutoResizeWithMaxWidth:80];
        _saleNumber.textAlignment = NSTextAlignmentRight;
        [_saleNumber setFont:[UIFont systemFontOfSize:12*ScrenScale]];
        
        
        /* 推荐原因*/
        _reason = [[UILabel alloc]init];
        [self.contentView addSubview:_reason];
        _reason.textColor = [UIColor whiteColor];
        _reason.font = [UIFont systemFontOfSize:15*ScrenScale];
        _reason.sd_layout
        .topEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .autoHeightRatio(0);
        [_reason setSingleLineAutoResizeWithMaxWidth:200];
        
        manager = [[SDWebImageManager alloc]init];
        
        
        
    }
    return self;
}

-(void)setModel:(RecommandClasses *)model{
    
    _model = model;
    
    _className.text = NSLocalizedString(model.name, nil);
    _grade.text = NSLocalizedString(model.grade, nil);
    _subjectName.text = NSLocalizedString(model.subject, nil);
    _teacherName.text = NSLocalizedString(model.teacher_name, nil);
    _saleNumber.text = NSLocalizedString(model.buy_tickets_count, nil);
    
//    [_classImage sd_setImageWithURL:[NSURL URLWithString:model.publicize] placeholderImage:[UIImage imageNamed:@"school"]];
    
    /* 如果本地已经保留了图片缓存*/
    if ([self diskImageExistsForURL:[NSURL URLWithString:model.publicize]]==YES) {
        [_classImage sd_setImageWithURL:[NSURL URLWithString:model.publicize]];
    }else{
        /* 如果本地没有缓存,加载网络图片,渐变动画*/
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
    
    
    if ([model.reason isEqualToString:@"newest"]) {
        self.reason.hidden = NO;
        self.reason.text = NSLocalizedString(@" 最新 ", nil);
        self.reason.backgroundColor = [UIColor colorWithRed:0.4 green:0.8 blue:1.0 alpha:1.0];
        
    }else if ([model.reason isEqualToString:@"hottest"]){
        self.reason.hidden = NO;
        self.reason.text = NSLocalizedString(@" 最热 ", nil);
        self.reason.backgroundColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.6 alpha:1.0];
    }else if([model.reason isEqualToString:@""]){
        self.reason.hidden = YES;
    }
    
    
}
- (BOOL)diskImageExistsForURL:(NSURL *)url {
    NSString *key = [manager cacheKeyForURL:url];
    return [manager.imageCache diskImageExistsWithKey:key];
}

@end
