//
//  AboutUsView.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/30.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "AboutUsView.h"

@implementation AboutUsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        /* logo*/
        _logo = [[UIImageView alloc]init];
        [_logo setImage:[UIImage imageNamed:@"logo_big"]];
        
        /* 关于*/
        
        _aboutUs = ({
            
            UILabel *_=[[UILabel alloc]init];
            _.textColor = [UIColor grayColor];
            _.font = TITLEFONTSIZE;
        
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
            style.lineSpacing = 5.0;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"    北京维幄通达网络科技有限公司，成立于2012年初，主要从事教育科研产品的销售以及教育网络推广。公司实力优越，拥有一批科研技术专业能力强大的研发团队。目前，教育信息化改革的背景下，公司紧紧围绕互联网技术与教育产生信息化这一特点，重点着力于建立 独具特色的现代信息化教育模式，公司的研发成果为优化教育资源，推进教育信息改革起到了很大的促进作用。现阶段公司正积极面向全国开展销售推广业务，具有强大的发展潜力和良好的发展前景。现诚邀有志之士加入我们，与我们携手共同实现理想。" attributes:@{NSParagraphStyleAttributeName:style,
                                                                                                                                                                                                                                                                                                                                                            NSFontAttributeName:TEXT_FONTSIZE,
                                                                                                                                                                                                                                                                                                                                                            NSForegroundColorAttributeName:TITLECOLOR}];
            
            _.attributedText = str;
            _.isAttributedContent = YES;
            _;
        });
        
        
        
        _menuTableView = [[UITableView alloc]init];
        [self addSubview:_menuTableView];
        _menuTableView.bounces = NO;
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self sd_addSubviews:@[_logo,_aboutUs,_menuTableView]];
        
        /* 布局*/
        _logo.sd_layout
        .topSpaceToView(self,60*ScrenScale)
        .leftSpaceToView(self,60*ScrenScale)
        .rightSpaceToView(self,60*ScrenScale)
        .autoHeightRatio(112/479.0f);
        
        _aboutUs.sd_layout
        .topSpaceToView(_logo,50*ScrenScale)
        .leftSpaceToView(self,20*ScrenScale)
        .rightSpaceToView(self,20*ScrenScale)
        .autoHeightRatio(0);
        
        _menuTableView.sd_layout
        .topSpaceToView(_aboutUs,40*ScrenScale)
        .leftSpaceToView(self,0)
        .rightSpaceToView(self,0)
        .heightIs(200*ScrenScale);
        
        [_menuTableView updateLayout];
        
        if (_menuTableView.bottom_sd>self.bottom_sd) {
            
            self.contentSize = CGSizeMake(self.width_sd, _menuTableView.bottom_sd);
        }
        
    }
    return self;
}


@end
