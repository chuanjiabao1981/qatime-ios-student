//
//  ChargeView.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "ChargeView.h"

@interface ChargeView (){
    
    
}

@end

@implementation ChargeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //充值选项
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 5;
        layout.itemSize = CGSizeMake((self.width_sd-40)/3, 40);
        
        _chargeMenu = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width_sd, 200) collectionViewLayout:layout];
        _chargeMenu.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_chargeMenu];
        _chargeMenu.sd_layout
        .leftSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(150*ScrenScale);
        
        //充值提示
        _tips = [[UILabel alloc]init];
        [self addSubview:_tips];
        
        NSString *string =@"充值须知：\n1、由于苹果公司内购条款限制（收取30%作为内购费用),使用IOS客户端充值后账户实充金额与所选充值金额不一致。\n2、举例：选择充值100元并成功充值后账户实际收入70元。\n3、非IOS客户端不受内购条款限制。\n4、点击立即充值则表示用户认可以上内容。";
        
        NSMutableParagraphStyle*style = [[NSMutableParagraphStyle alloc]init];
        style.lineSpacing = 5;
        style.paragraphSpacing = 5;
        
        NSMutableAttributedString *mustring = [[NSMutableAttributedString alloc]initWithString:string];
        [mustring addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, 5)];
        [mustring addAttributes:@{NSForegroundColorAttributeName:TITLECOLOR} range:NSMakeRange(5, string.length-5)];
        [mustring addAttributes:@{NSParagraphStyleAttributeName:style} range:NSMakeRange(0, string.length-1)];
        [mustring addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14*ScrenScale]} range:NSMakeRange(0, string.length-1)];
        _tips.attributedText = mustring;
        _tips.isAttributedContent = YES;
        _tips.sd_layout
        .leftSpaceToView(self, 10)
        .rightSpaceToView(self, 10)
        .topSpaceToView(_chargeMenu, 10)
        .autoHeightRatio(0);
        
        //立即充值
        _chargeButton = [[UIButton alloc]init];
        _chargeButton.layer.borderColor = NAVIGATIONRED.CGColor;
        _chargeButton.layer.borderWidth = 1;
        [_chargeButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
        [_chargeButton setTitle:@"立即充值" forState:UIControlStateNormal];
        _chargeButton.sd_cornerRadius = @2;
        
        [self addSubview:_chargeButton];
        _chargeButton.sd_layout
        .topSpaceToView(_tips, 40)
        .leftSpaceToView(self, 10)
        .rightSpaceToView(self, 10)
        .heightIs(40);
        
        
        
    }
    return self;
}

@end
