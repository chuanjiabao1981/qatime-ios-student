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
            
            _.font = [UIFont systemFontOfSize:13];
            
            [self.contentView addSubview:_];
            
            _.sd_layout
            .leftSpaceToView(self.contentView,20)
            .topSpaceToView(self.contentView,10)
            .autoHeightRatio(0);
            [_ setSingleLineAutoResizeWithMaxWidth:1000];
            _;
        });
        
        _content = ({UILabel *_=[[UILabel alloc]init];
            
            _.font = [UIFont systemFontOfSize:15];
            
            [self.contentView addSubview:_];
            _.sd_layout
            .leftSpaceToView(self.contentView,20)
            .rightSpaceToView(self.contentView,20)
            .topSpaceToView(self.contentView,10)
            .autoHeightRatio(0);
            _;
        });
        
        
        
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
