//
//  SearchTipsViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTGTextTagCollectionView.h"

@interface SearchTipsViewController : UIViewController

@property (nonatomic, strong) TTGTextTagCollectionView *mainView ;
- (void)cancelSearchAction;
@end
