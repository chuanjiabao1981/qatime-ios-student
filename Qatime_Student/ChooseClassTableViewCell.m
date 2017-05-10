//
//  ChooseClassTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/16.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ChooseClassTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@interface ChooseClassTableViewCell (){
    
    UIView *_content;  //背景框
    
//    UIImageView *_teacherImage;
    
    //图片缓存管理器
    SDWebImageManager *manager;
    
    UIImageView *_studentImage;

}

@property (nonatomic, strong) UILabel *buyCount ;


@end

@implementation ChooseClassTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //背景content
        _content = [[UIView alloc]init];
        [self.contentView addSubview:_content];
        _content.sd_layout
        .leftSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10);
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
        
    
        //课程名
        _className = [[UILabel alloc]init];
        _className.font = [UIFont systemFontOfSize:15*ScrenScale];
        _className.textColor = [UIColor blackColor];
        [_content addSubview:_className];
        _className.sd_layout
        .topSpaceToView(_content,10)
        .leftSpaceToView(_classImage,10)
        .rightSpaceToView(_content,10)
        .autoHeightRatio(0);
        
        [_className setMaxNumberOfLinesToShow:1];
        
//        //教师图片
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
        .bottomSpaceToView(_content, 10)
        .autoHeightRatio(0);
        [_teacherName setSingleLineAutoResizeWithMaxWidth:150];
       
        
        //年级科目label
        _price = [[UILabel alloc]init];
        _price.font = [UIFont systemFontOfSize:12*ScrenScale];
        _price.textColor = BUTTONRED;
        [_content addSubview:_price];
        _price.sd_layout
        .leftEqualToView(_teacherName)
        .bottomSpaceToView(_teacherName,10)
        .autoHeightRatio(0);
        [_price setSingleLineAutoResizeWithMaxWidth:200];
        
        
        //购买人数
        _buyCount = [[UILabel alloc]init];
        _buyCount.textColor = TITLECOLOR;
        _buyCount.font = [UIFont systemFontOfSize:12*ScrenScale];
        [_content addSubview:_buyCount];
        _buyCount.sd_layout
        .rightSpaceToView(_content, 10)
        .bottomEqualToView(_teacherName)
        .autoHeightRatio(0);
        [_buyCount setSingleLineAutoResizeWithMaxWidth:200];
        
        _studentImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"老师"]];
        [_content addSubview:_studentImage];
        _studentImage.sd_layout
        .topEqualToView(_buyCount)
        .bottomEqualToView(_buyCount)
        .rightSpaceToView(_buyCount, 5)
        .widthEqualToHeight();
        
        
    }
    return self;
}


-(void)setModel:(TutoriumListInfo *)model{
    
    _model = model;
    
    /* 如果本地已经保留了图片缓存*/
    [_classImage sd_setImageWithURL:[NSURL URLWithString:model.publicize] placeholderImage:[UIImage imageNamed:@"school"] options:SDWebImageRefreshCached completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        [manager diskImageExistsForURL:[NSURL URLWithString:model.publicize] completion:^(BOOL isInCache) {
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
    _className.text = model.name;
    
    //价格
    _price.text = [NSString stringWithFormat:@"¥%@",model.price];

    //老师名字
    _teacherName.text = model.teacher_name;
    
    //购买人数
    _buyCount.text = model.buy_tickets_count;
    
}

-(void)setInteractionModel:(OneOnOneClass *)interactionModel{
    
    _interactionModel = interactionModel;
    
    /* 如果本地已经保留了图片缓存*/
    [_classImage sd_setImageWithURL:[NSURL URLWithString:interactionModel.publicize_app_url] placeholderImage:[UIImage imageNamed:@"school"] options:SDWebImageRefreshCached completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        [manager diskImageExistsForURL:[NSURL URLWithString:interactionModel.publicize_app_url] completion:^(BOOL isInCache) {
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
    _className.text = interactionModel.name;
    
    //价格
    _price.text = [NSString stringWithFormat:@"¥%@",interactionModel.price];
    
    //老师名字
    _teacherName.text = [interactionModel.teacherNameString substringToIndex:interactionModel.teacherNameString.length-1];
    //购买人数
//    _buyCount.text = interactionModel.buy_tickets_count;

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
