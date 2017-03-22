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
    
    UIImageView *_teacherImage;
    
    //图片缓存管理器
    SDWebImageManager *manager;

}

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
        
        //教师图片
        _teacherImage = [[UIImageView alloc]init];
        [_teacherImage setImage:[UIImage imageNamed:@"老师"]];
        [_content addSubview:_teacherImage];
        _teacherImage.sd_layout
        .leftEqualToView(_className)
        .bottomSpaceToView(_content,10)
        .heightIs(12)
        .widthEqualToHeight();
        
        //教师姓名
        _teacherName = [[UILabel alloc]init];
        _teacherName.textColor = TITLECOLOR;
        _teacherName.font = [UIFont systemFontOfSize:12*ScrenScale];
        [_content addSubview:_teacherName];
        _teacherName.sd_layout
        .leftSpaceToView(_teacherImage,5)
        .topEqualToView(_teacherImage)
        .bottomEqualToView(_teacherImage);
        [_teacherName setSingleLineAutoResizeWithMaxWidth:100];
       
        
        //年级科目label
        _price = [[UILabel alloc]init];
        _price.font = [UIFont systemFontOfSize:12*ScrenScale];
        _price.textColor = BUTTONRED;
        [_content addSubview:_price];
        _price.sd_layout
        .leftEqualToView(_teacherImage)
        .bottomSpaceToView(_teacherName,10)
        .autoHeightRatio(0);
        [_price setSingleLineAutoResizeWithMaxWidth:200];
        
        
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
    
    
    //课程名
    _className.text = model.name;
    
    //价格
    _price.text = [NSString stringWithFormat:@"¥%@",model.price];

    //老师名字
    _teacherName.text = model.teacher_name;
    
    
}

- (BOOL)diskImageExistsForURL:(NSURL *)url {
    NSString *key = [manager cacheKeyForURL:url];
    return [manager.imageCache diskImageExistsWithKey:key];
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
