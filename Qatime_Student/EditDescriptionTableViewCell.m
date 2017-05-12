//
//  EditDescriptionTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/5/5.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "EditDescriptionTableViewCell.h"
#import "UITextView+Placeholder.h"

@interface EditDescriptionTableViewCell (){
    
    UIImageView *_arrow;
}

@end

@implementation EditDescriptionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /* 设置项*/
        _name = [[UILabel alloc]init];
        _name.font = TITLEFONTSIZE;
        _name.textColor = TITLECOLOR;
        _name.text = @"姓名";
        
        /* 姓名输入框*/
        _nameText = [[UITextView alloc]init];
        _nameText.font = TITLEFONTSIZE;
        _nameText.textColor = TITLECOLOR;
        _nameText.editable = YES;
        _nameText.placeholder = @"一句话介绍自己";
        
        /**字数*/
        _letterNumber = [[UILabel alloc]init];
        _letterNumber.font = TEXT_FONTSIZE_MIN;
        _letterNumber.textColor = TITLECOLOR;
        
        /* 箭头*/
        //        _arrow = [[UIImageView alloc]init];
        //        [_arrow setImage:[UIImage imageNamed:@"rightArrow"]];
        //
        [self.contentView sd_addSubviews:@[_name,_nameText,_letterNumber]];
        
        /* 布局*/
        _name.sd_layout
        .leftSpaceToView(self.contentView,20)
        .centerYEqualToView(self.contentView)
        .autoHeightRatio(0);
        [_name setSingleLineAutoResizeWithMaxWidth:200];
        
        _nameText.sd_layout
        .leftSpaceToView(_name,20)
        .topSpaceToView(self.contentView,10)
        .rightSpaceToView(self.contentView,20)
        .bottomSpaceToView(self.contentView, 20);
        
        _letterNumber.sd_layout
        .rightEqualToView(_nameText)
        .bottomSpaceToView(self.contentView, 10*ScrenScale)
        .autoHeightRatio(0);
        [_letterNumber setSingleLineAutoResizeWithMaxWidth:40];
        
        [self setupAutoHeightWithBottomView:_nameText bottomMargin:10];
        
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
