//
//  FileViewCell.m
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import "KsFileViewCell.h"
#import "Masonry.h"
#import "KsFileObjModel.h"
#import "UIColor+CJColorCategory.h"
@interface KsFileViewCell (){
    
}

@end
@implementation KsFileViewCell
CGFloat margin = 12;
CGFloat w = 48;
CGFloat h = 48;
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImagV = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = TEXT_FONTSIZE;
        _titleLabel.lineBreakMode=NSLineBreakByTruncatingMiddle;

        _titleLabel.numberOfLines = 1;
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.numberOfLines = 1;
        _detailLabel.lineBreakMode=NSLineBreakByTruncatingMiddle;
        
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setImage:[UIImage imageNamed:@"未选-10"] forState:UIControlStateNormal];
        [_sendBtn setImage:[UIImage imageNamed:@"选中-10"] forState:UIControlStateSelected];

        [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_sendBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _detailLabel.textColor = [UIColor colorWithHexString:@"999999"];
        [self.contentView addSubview:_headImagV];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_detailLabel];
        [self.contentView addSubview:_sendBtn];
        
    }
    return self;
}
- (void)setModel:(KsFileObjModel *)model
{
    _model = model;
    self.headImagV.image = model.image;
    self.titleLabel.text = model.name;
    self.detailLabel.text = [model.fileSize stringByAppendingString:[NSString stringWithFormat:@"   %@",model.creatTime]];
    self.sendBtn.selected = model.select;
    
    if (model.onEdit == YES) {
        [self enterEditMode];
    }else{
        [self exitEditeMode];
    }
    
}
- (void)clickBtn:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    self.model.select = btn.selected;
    if (_Clickblock) {
        _Clickblock(_model,btn);
    }

}
- (void)layoutSubviews{
    [super layoutSubviews];

    _sendBtn.sd_layout
    .leftSpaceToView(self.contentView, -40)
    .centerYEqualToView(self.contentView)
    .heightIs(40.f)
    .widthEqualToHeight();
    
    if (_model.onEdit) {
        [self enterEditMode];
    }else{
        [self exitEditeMode];
    }

    _headImagV.sd_layout
    .leftSpaceToView(_sendBtn, margin)
    .centerYEqualToView(self.contentView)
    .widthIs(w)
    .heightIs(h);

    _titleLabel.sd_layout
    .leftSpaceToView(_headImagV, 10)
    .topEqualToView(_headImagV)
    .autoHeightRatio(0)
    .rightSpaceToView(self.contentView, 10);
    [_titleLabel setMaxNumberOfLinesToShow:1];
    _detailLabel.sd_layout
    .leftEqualToView(_titleLabel)
    .bottomEqualToView(_headImagV)
    .autoHeightRatio(0)
    .rightSpaceToView(self.contentView, 10);
    [_detailLabel setMaxNumberOfLinesToShow:1];
}

- (void)enterEditMode{
    
    [UIView animateWithDuration:0.3 animations:^{
        _sendBtn.sd_layout
        .leftSpaceToView(self.contentView, margin);
        [_sendBtn updateLayout];
    }];
}

- (void)exitEditeMode{
    
    [UIView animateWithDuration:0.3 animations:^{
        _sendBtn.sd_layout
        .leftSpaceToView(self.contentView, -40);
        [_sendBtn updateLayout];
    }];
}

@end
