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
        
        
        
        _badge = ({
            M13BadgeView *_=[[M13BadgeView alloc]init];
        
            _.hidden = YES;
            [self.contentView addSubview:_];
            _.sd_layout
            .topSpaceToView(self.contentView,10)
            .bottomSpaceToView(self.contentView,10)
            .rightSpaceToView(self.contentView,10)
            .widthIs(40);
            _;
        
        });
        
        _className = ({
            
            UILabel *_= [[UILabel alloc]init];
            _.textColor = TITLECOLOR;
            _.font = [UIFont systemFontOfSize:15*ScrenScale];
            
            [self.contentView addSubview:_];
            
            _.sd_layout
            .leftSpaceToView(self.contentView,20)
            .topSpaceToView(self.contentView,10)
            .bottomSpaceToView(self.contentView,10)
            .rightSpaceToView(_badge,20);
            
//            [_ setSingleLineAutoResizeWithMaxWidth:];
            
            _;
        });

        
        [self setupAutoHeightWithBottomView:_className bottomMargin:10];
        
        
    }
    return self;
    
}

-(void)setModel:(ChatList *)model{
    
    _model = model;
    _className.text = model.name;
    
    if (model.badge>0) {
        _badge.hidden = NO;
        _badge.text = [NSString stringWithFormat:@"%ld",model.badge];
    }else{
        _badge.hidden = YES;
    }
    
    
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
