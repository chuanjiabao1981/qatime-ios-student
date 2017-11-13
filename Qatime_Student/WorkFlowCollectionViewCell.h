//
//  WorkFlowCollectionViewCell.h
//  Qatime_Student
//
//  Created by Shin on 2017/11/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkFlowCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *image ;
@property (nonatomic, strong) UILabel *title ;
@property (nonatomic, strong) UILabel *subTitle ;

- (void)makeWorkFlow:(NSDictionary *)workFlow ;

@end
