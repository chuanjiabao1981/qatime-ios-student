//
//  ClassFeaturesCollectionViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassFeaturesCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIView *circle ;

@property (nonatomic, strong) UILabel *title ;

@property (nonatomic, strong) UILabel *subTitle ;

- (void)makeFeatures:(NSDictionary *)features;

@end
