//
//  ProvinceHeaderView.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/6.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ProvinceHeaderView.h"

@interface ProvinceHeaderView (){
    
    UILabel *_currentLocation;
    
    UIImageView *_locationImage;
    
}

@end

@implementation ProvinceHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //当前定位
        _currentLocation = [[UILabel alloc]init];
        [self addSubview:_currentLocation];
        _currentLocation.text = @"当前定位";
        _currentLocation.textColor = [UIColor blackColor];
        _currentLocation.font = TITLEFONTSIZE;
        _currentLocation.sd_layout
        .leftSpaceToView(self,20)
        .centerYEqualToView(self)
        .autoHeightRatio(0);
        [_currentLocation setSingleLineAutoResizeWithMaxWidth:100];
        
        //定位图片
        _locationImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location_red"]];
        [self addSubview:_locationImage];
        _locationImage.sd_layout
        .leftSpaceToView(_currentLocation,20)
        .topEqualToView(_currentLocation)
        .bottomEqualToView(_currentLocation)
        .widthEqualToHeight();
        
        //当前省份
        _currentProvince = [[UILabel alloc]init];
        [self addSubview:_currentProvince];
        _currentProvince.textColor = TITLECOLOR;
        _currentProvince.font = TITLEFONTSIZE;
        _currentProvince.sd_layout
        .leftSpaceToView(_locationImage,10)
        .topEqualToView(_currentLocation)
        .bottomEqualToView(_currentLocation);
        [_currentProvince setSingleLineAutoResizeWithMaxWidth:100];
        
        //当前城市
        _currentCity = [[UILabel alloc]init];
        [self addSubview:_currentCity];
        _currentCity.textColor = TITLECOLOR;
        _currentCity.font = TITLEFONTSIZE;
        _currentCity.sd_layout
        .leftSpaceToView(_currentProvince,20)
        .topEqualToView(_currentProvince)
        .bottomEqualToView(_currentProvince);
        [_currentProvince setSingleLineAutoResizeWithMaxWidth:100];

        
        UIView *lien2 = [[UIView alloc]init];
        [self addSubview:lien2];
        lien2.backgroundColor = SEPERATELINECOLOR;
        lien2.sd_layout
        .leftEqualToView(self)
        .bottomEqualToView(self)
        .rightEqualToView(self)
        .heightIs(0.5);
        
        
    }
    return self;
}


@end
