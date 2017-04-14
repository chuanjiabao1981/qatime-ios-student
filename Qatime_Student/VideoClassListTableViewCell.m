//
//  VideoClassListTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/11.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClassListTableViewCell.h"

@interface VideoClassListTableViewCell (){
    UIImageView *_tips;
}
/**课程名*/
@property (nonatomic, strong) UILabel *className ;

/**视频时长*/
@property (nonatomic, strong) UILabel *duringTime ;

/**状态*/
@property (nonatomic, strong) UILabel *status ;

@end


@implementation VideoClassListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //课程名
        _className = [[UILabel alloc]init];
        [self.contentView addSubview:_className];
        _className.font = TITLEFONTSIZE;
        _className.textColor = [UIColor blackColor];
        _className.textAlignment = NSTextAlignmentLeft;
        
        _className.sd_layout
        .topSpaceToView(self.contentView, 10)
        .leftSpaceToView(self.contentView, 30)
        .rightSpaceToView(self.contentView, 10)
        .autoHeightRatio(0);
        
        //菱形
        _tips = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"菱形"]];
        [self.contentView addSubview:_tips];
        _tips.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .centerYEqualToView(_className)
        .widthIs(10)
        .heightIs(10);
        
        //时长
        _duringTime = [[UILabel alloc]init];
        [self.contentView addSubview:_duringTime];
        _duringTime.font = TEXT_FONTSIZE;
        _duringTime.textColor = TITLECOLOR;
        
        _duringTime.sd_layout
        .leftEqualToView(_className)
        .topSpaceToView(_className, 10)
        .autoHeightRatio(0);
        
        [_duringTime setSingleLineAutoResizeWithMaxWidth:400];
        
        //课程状态
        _status = [[UILabel alloc]init];
        [self.contentView addSubview:_status];
        _status.font = TEXT_FONTSIZE;
        _status.sd_layout
        .rightSpaceToView(self.contentView, 10)
        .topEqualToView(_duringTime)
        .bottomEqualToView(_duringTime);
        [_status setSingleLineAutoResizeWithMaxWidth:200];
        
        [self setupAutoHeightWithBottomView:_duringTime bottomMargin:10];
        
    }
    return self;
}

- (void)setModel:(VideoClass *)model{
    
    _model = model;
    _className.text = model.name;
    _duringTime.text = [NSString stringWithFormat:@"时长:%@",model.video.format_tmp_duration];
    //判断课程状态
    
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
