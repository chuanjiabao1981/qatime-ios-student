//
//  NoticeListTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/17.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "NoticeListTableViewCell.h"

@implementation NoticeListTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _time = ({
            UILabel *_=[[UILabel alloc]init];
            
            _.font = [UIFont systemFontOfSize:13*ScrenScale];
            
            [self.contentView addSubview:_];
            
            _;
        });
        
        _content = ({UILabel *_=[[UILabel alloc]init];
            
            _.font = [UIFont systemFontOfSize:16*ScrenScale];
            _.numberOfLines = 0;
            
            [self.contentView addSubview:_];
          
            _;
        });
        
        [self.contentView sd_addSubviews:@[_time,_content]];
        
        
        _time.sd_layout
        .leftSpaceToView(self.contentView,20)
        .rightSpaceToView(self.contentView,20)
        .topSpaceToView(self.contentView,10)
        .autoHeightRatio(0);
        
        _content.sd_layout
        .leftSpaceToView(self.contentView,20)
        .rightSpaceToView(self.contentView,20)
        .topSpaceToView(_time,10)
        .autoHeightRatio(0);
        
        
        [self setupAutoHeightWithBottomView:_content bottomMargin:10.0];
        
        
    }
    return self;

}

-(void)setModel:(SystemNotice *)model{
    _model = model;
    _time.text = model.created_at;
    _content.text = model.notice_content;
    
    
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
