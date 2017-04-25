//
//  MyAudioClassTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "MyAudioClassTableViewCell.h"

@interface MyAudioClassTableViewCell ()
/**课程名*/
@property (nonatomic, strong) UILabel *name ;
/**课程信息*/
@property (nonatomic, strong) UILabel *infos ;
/**课程状态*/
@property (nonatomic, strong) UILabel *status ;

@end

@implementation MyAudioClassTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //框
        UIView *_content  = [[UIView alloc]init];
        _content.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
        _content.layer.borderWidth = 1;
        [self.contentView addSubview:_content];
        _content.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 10)
        .bottomSpaceToView(self.contentView, 10);
        
        //课程名
        _name = [[UILabel alloc]init];
        [_content addSubview:_name];
        _name.textColor = [UIColor blackColor];
        _name.font = TITLEFONTSIZE;
        [_content addSubview:_name];
        _name.sd_layout
        .leftSpaceToView(_content, 10)
        .topSpaceToView(_content, 10)
        .rightSpaceToView(_content, 10)
        .autoHeightRatio(0);
        
        //详情
        _infos = [[UILabel alloc]init];
        [_content addSubview:_infos];
        _infos.textColor = TITLECOLOR;
        _infos.font = TEXT_FONTSIZE;
        [_content addSubview:_infos];
        _infos.sd_layout
        .topSpaceToView(_name, 10)
        .leftEqualToView(_name)
        .autoHeightRatio(0);
        [_infos setSingleLineAutoResizeWithMaxWidth:200];
        
        _status = [[UILabel alloc]init];
        [_content addSubview:_status];
        _status.textColor = TITLECOLOR;
        _status.font = TEXT_FONTSIZE;
        _status.sd_layout
        .topSpaceToView(_name, 10)
        .autoHeightRatio(0)
        .rightSpaceToView(_content, 10);
        [_status setSingleLineAutoResizeWithMaxWidth:200];
        
        
    }
    return self;
    
}

-(void)setModel:(MyAudioClass *)model{
    
    
    
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
