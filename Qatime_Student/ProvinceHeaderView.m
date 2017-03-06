//
//  ProvinceHeaderView.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/6.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ProvinceHeaderView.h"

@interface ProvinceHeaderView (){
    
    
    UILabel *_chosenLocation;
    
    UILabel *_currentLocation;
    
    UIImageView *_locationImage;
    
    
    UIView *sheet1;
    UIView *line;
    UIView *sheet2;
}

@end

@implementation ProvinceHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //栏1
        sheet1 = [[UIView alloc]init];
        [self addSubview:sheet1];
        sheet1.sd_layout
        .topEqualToView(self)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightIs((self.height_sd-10)/2.0);
        
        
        //已选地区
        _chosenLocation = [[UILabel alloc]init];
        [sheet1 addSubview:_chosenLocation];
        _chosenLocation.text = @"已选地区";
        _chosenLocation.textColor = [UIColor blackColor];
        _chosenLocation.sd_layout
        .leftSpaceToView(sheet1,12)
        .centerYEqualToView(sheet1)
        .autoHeightRatio(0);
        [_chosenLocation setSingleLineAutoResizeWithMaxWidth:100];
        
        //已选省份
        _chosenProvicne = [[UILabel alloc]init];
        [sheet1 addSubview:_chosenProvicne];
        _chosenProvicne.textColor = TITLECOLOR;
        _chosenProvicne.sd_layout
        .leftSpaceToView(_chosenLocation,20)
        .topEqualToView(_chosenLocation)
        .bottomEqualToView(_chosenLocation);
        [_chosenProvicne setSingleLineAutoResizeWithMaxWidth:100];
        
        //已选城市
        _chosenCity = [[UILabel alloc]init];
        [sheet1 addSubview:_chosenCity];
        _chosenCity.textColor = TITLECOLOR;
        _chosenCity.sd_layout
        .leftSpaceToView(_chosenProvicne,20)
        .topEqualToView(_chosenProvicne)
        .bottomEqualToView(_chosenProvicne);
        [_chosenCity setSingleLineAutoResizeWithMaxWidth:100];


        /* 分割线*/
        line = [[UIView alloc]init];
        [self addSubview:line];
        line.backgroundColor = SEPERATELINECOLOR;
        line.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .topSpaceToView(sheet1,0)
        .heightIs(10);
        
        //sheet2
        sheet2 = [[UIView alloc]init];
        [self addSubview:sheet2];
        sheet2.sd_layout
        .leftEqualToView(self)
        .rightEqualToView(self)
        .heightRatioToView(sheet1,1.0);
        
        //当前定位
        _currentLocation = [[UILabel alloc]init];
        [sheet2 addSubview:_chosenLocation];
        _currentLocation.text = @"当前定位";
        _currentLocation.textColor = [UIColor blackColor];
        _currentLocation.sd_layout
        .leftSpaceToView(sheet2,12)
        .centerYEqualToView(sheet2)
        .autoHeightRatio(0);
        [_currentLocation setSingleLineAutoResizeWithMaxWidth:100];
        
        //定位图片
        _locationImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location_red"]];
        [sheet2 addSubview:_locationImage];
        _locationImage.sd_layout
        .leftSpaceToView(_currentLocation,20)
        .topEqualToView(_currentLocation)
        .bottomEqualToView(_currentLocation)
        .widthEqualToHeight();
        
        //当前省份
        _currentProvince = [[UILabel alloc]init];
        [sheet2 addSubview:_currentProvince];
        _currentProvince.textColor = TITLECOLOR;
        _currentProvince.sd_layout
        .leftSpaceToView(_locationImage,10)
        .topEqualToView(_currentLocation)
        .bottomEqualToView(_currentLocation);
        [_currentProvince setSingleLineAutoResizeWithMaxWidth:100];
        
        //当前城市
        _currentCity = [[UILabel alloc]init];
        [sheet2 addSubview:_currentCity];
        _currentCity.textColor = TITLECOLOR;
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
