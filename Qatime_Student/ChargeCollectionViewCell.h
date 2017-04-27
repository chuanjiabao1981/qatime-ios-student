//
//  ChargeCollectionViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/4/25.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItunesProduct.h"

@interface ChargeCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *title ;

@property (nonatomic, strong) UILabel *subTitle ;

@property (nonatomic, strong) UIImageView *chosenImage ;

@property (nonatomic, strong) ItunesProduct *model ;

@end
