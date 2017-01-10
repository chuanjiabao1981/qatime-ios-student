//
//  EditGenderTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "EditGenderTableViewCell.h"

@interface EditGenderTableViewCell (){
    
    
}

@end

@implementation EditGenderTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /* 设置项*/
        _name = [[UILabel alloc]init];
        _name.font = TITLEFONTSIZE;
        _name.textColor = TITLECOLOR;
        _name.text = @"性别";
        
        /* 性别选择器*/
        _genderSegment = [[UISegmentedControl alloc]initWithItems:@[@"男",@"女"]];
        _genderSegment.tintColor = TITLERED;
        

        [self.contentView sd_addSubviews:@[_name,_genderSegment]];
        
        /* 布局*/
        _name.sd_layout
        .leftSpaceToView(self.contentView,20)
        .centerYEqualToView(self.contentView)
        .autoHeightRatio(0);
        [_name setSingleLineAutoResizeWithMaxWidth:200];
        
        _genderSegment.sd_layout
        .leftSpaceToView(_name,20)
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10)
        .widthIs(self.contentView.height_sd*2);
        
        
        
    }
    return self;
    
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
