//
//  AboutUsHead.m
//  Qatime_Student
//
//  Created by Shin on 2017/11/6.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "AboutUsHead.h"

@implementation AboutUsHead

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //logo
        _logo = [[UIImageView alloc]init];
        [_logo setImage:[UIImage imageNamed:@"logo_big"]];
        [self addSubview:_logo];
        _logo.sd_layout
        .topSpaceToView(self,40*ScrenScale)
        .leftSpaceToView(self,80*ScrenScale)
        .rightSpaceToView(self,80*ScrenScale)
        .autoHeightRatio(112/479.0f);
        
        //关于
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
        [self addSubview:_aboutUs];
        _aboutUs.sd_layout
        .topSpaceToView(_logo,40*ScrenScale)
        .leftSpaceToView(self,20*ScrenScale)
        .rightSpaceToView(self,20*ScrenScale)
        .autoHeightRatio(0);
        [_aboutUs updateLayout];
        
        [self setupAutoHeightWithBottomView:_aboutUs bottomMargin:40*ScrenScale];
        
    }
    return self;
}

@end
