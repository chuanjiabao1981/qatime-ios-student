//
//  AboutUsTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/30.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "AboutUsTableViewCell.h"

@interface AboutUsTableViewCell (){
    
    UIView *line;
    UIView *line2;
    
}

@end

@implementation AboutUsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _name = [[UILabel alloc]init];
        _name.textColor = [UIColor blackColor];
        
        _context = [[UILabel alloc]init];
        _context.textColor = [UIColor blackColor];
        
        line = [[UIView alloc]init];
        line.backgroundColor = [UIColor grayColor];
        line2 = [[UIView alloc]init];
        line2.backgroundColor = [UIColor grayColor];
        
        [self.contentView sd_addSubviews:@[_name,_context,line,line2]];
        
        
        
        _name.sd_layout
        .leftSpaceToView (self.contentView,20)
        .topSpaceToView(self.contentView,15)
        .bottomSpaceToView(self.contentView,15);
        [_name setSingleLineAutoResizeWithMaxWidth:500];
        
        _context.sd_layout
        .rightSpaceToView (self.contentView,20)
        .topSpaceToView(self.contentView,15)
        .bottomSpaceToView(self.contentView,15);
        [_context setSingleLineAutoResizeWithMaxWidth:500];
        
        line.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .bottomEqualToView(self.contentView)
        .heightIs(0.4);
        
    

        

        
        
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
