//
//  SearchViewController.h
//  Qatime_Student
//
//  Created by Shin on 2017/6/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchView.h"
@interface SearchViewController : UIViewController

@property (nonatomic, strong) SearchView *mainView ;


/**
 初始化方法

 @param searchKey 搜索关键字
 @return 实例
 */
-(instancetype)initWithSearchKey:(NSString *)searchKey;



@end
