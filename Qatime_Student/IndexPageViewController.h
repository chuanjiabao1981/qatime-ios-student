//
//  IndexPageViewController.h
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"
#import "IndexPageView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface IndexPageViewController : UIViewController

@property(nonatomic,strong) NavigationBar *navigationBar ;

@property(nonatomic,strong) IndexPageView *indexPageView ;
    
@property(nonatomic,strong) IndexHeaderPageView *headerView ;



    
@end
