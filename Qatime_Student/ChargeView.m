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
        layout.itemSize = CGSizeMake((self.width_sd-40)/3, (self.width_sd-40)/3*3/5);
        
        _chargeMenu = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width_sd, 200) collectionViewLayout:layout];
        _chargeMenu.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_chargeMenu];
        _chargeMenu.sd_layout
        .leftSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs((self.width_sd-40)/3+(self.width_sd-40)/3*3/5+20);
        
        //充值提示
        _tips = [[UILabel alloc]init];
        [self addSubview:_tips];
        
        NSString *string =@"充值须知：\n1、请仔细核对充值与到账差异后再进行充值；\n2、仅限使用指定价格进行充值；\n3、充值的金额(学币)可在答疑时间平台任意客户端使用；\n4、点击立即充值则表示用户同意以上说明。";
        
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
