//
//  ChatListTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/17.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ChatListTableViewCell.h"

@implementation ChatListTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _className = ({
        
            UILabel *_= [[UILabel alloc]init];
            _.textColor = TITLECOLOR;
            _.font = [UIFont systemFontOfSize:15];
            
            [self.contentView addSubview:_];
            
            _.sd_layout
            .leftSpaceToView(self.contentView,20)
            .topSpaceToView(self.contentView,10)
            .bottomSpaceToView(self.contentView,10);
            
            [_ setSingleLineAutoResizeWithMaxWidth:self.contentView.width_sd-20-40];
            
            _;
        });
        
        
        _badge = ({
            M13BadgeView *_=[[M13BadgeView alloc]init];
        
            [self.contentView addSubview:_];
            _.sd_layout
            .topSpaceToView(self.contentView,10)
            .bottomSpaceToView(self.contentView,10)
            .rightSpaceToView(self.contentView,10)
            .widthIs(40);
            _;
        
        });
        
        [self setupAutoHeightWithBottomView:_className bottomMargin:10];
        
        
    }
    return self;
    
}

-(void)setModel:(TutoriumListInfo *)model{
    
    _model = model;
    _className.text = model.name;
    
    
    
    
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