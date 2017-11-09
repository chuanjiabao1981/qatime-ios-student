//
//  ChargeCollectionViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ChargeCollectionViewCell.h"

@implementation ChargeCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.layer.borderColor = TITLECOLOR.CGColor;
        self.contentView.layer.borderWidth =1;
        
        _title = [[UILabel alloc]init];
        _title.font = TEXT_FONTSIZE;
        _title.textColor = [UIColor blackColor];
        _title.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_title];
        _title.sd_layout
        .topSpaceToView(self.contentView, 10)
        .autoHeightRatio(0)
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0);
        
        _subTitle = [[UILabel alloc]init];
        _subTitle.textColor = TITLECOLOR;
        _subTitle.textAlignment = NSTextAlignmentCenter;
        _subTitle.font = [UIFont systemFontOfSize:14*ScrenScale];
        [self.contentView addSubview:_subTitle];
        
        _subTitle.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(_title, 10)
        .autoHeightRatio(0);
        
        _chosenImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"对勾_绿"]];
        [self.contentView addSubview:_chosenImage];
        _chosenImage.sd_layout
        .rightSpaceToView(self.contentView, 2*ScrenScale)
        .bottomSpaceToView(self.contentView, 2*ScrenScale)
        .heightIs(15*ScrenScale)
        .widthEqualToHeight();
        
        _chosenImage.hidden = YES;
        
    }
    return self;
}

-(void)setModel:(ItunesProduct *)model{

    _model = model;
    _title.text = [NSString stringWithFormat:@"%ld元",model.price.integerValue];
    _subTitle.text = [NSString stringWithFormat:@"实到账%.2f学币",model.amount.floatValue];
    
}

@end
