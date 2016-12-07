//
//  Personal_HeadTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/5.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "Personal_HeadTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation Personal_HeadTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _name = [[UILabel alloc]init];
        _name.font = TITLEFONTSIZE;
        _name.textColor = TITLECOLOR;
        
        
        _image = [[UIImageView alloc]init];
        
        
        [self.contentView sd_addSubviews:@[_name,_image]];

        
        _name.sd_layout
        .topSpaceToView(self.contentView,10)
        .bottomSpaceToView(self.contentView,10)
        .leftSpaceToView(self.contentView,20);
        
        [_name setSingleLineAutoResizeWithMaxWidth:500];
        
        _image.sd_layout
        .rightSpaceToView(self.contentView,10)
        .topSpaceToView(self.contentView,15)
        .bottomSpaceToView(self.contentView,15)
        .widthEqualToHeight();
        
        _image.sd_cornerRadiusFromWidthRatio = [NSNumber numberWithFloat:0.5];
        
        
        
        
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
