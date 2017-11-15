//
//  VideoClassInfo_TeacherViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/11/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClassInfo_TeacherViewController.h"

/**
 顶部视图的折叠/展开状态
 
 - LeadingViewStateFold: 折叠
 - LeadingViewStateUnfold: 展开
 */
typedef NS_ENUM(NSUInteger, LeadingViewState) {
    LeadingViewStateFold,
    LeadingViewStateUnfold,
};

@interface VideoClassInfo_TeacherViewController ()<UIScrollViewDelegate>{
    
    Teacher *_teacher;
    
    LeadingViewState _leadingViewState;
}

@end

@implementation VideoClassInfo_TeacherViewController

-(instancetype)initWithTeacher:(Teacher *)teacher{
    self = [super init];
    if (self) {
        _teacher = teacher;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _leadingViewState = LeadingViewStateUnfold;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeFold) name:@"ChangeFold" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeUnfold) name:@"ChangeUnfold" object:nil];
    [self setupViews];
    
}

- (void)setupViews{
    
    _mainView = [[VideoClassInfo_TeacherView alloc]init];
    [self.view addSubview: _mainView];
    _mainView.delegate = self;
    _mainView.alwaysBounceVertical = YES;
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    _mainView.model = _teacher;
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    
    if (_leadingViewState == LeadingViewStateUnfold) {
        //在展开状态的时候
        if (point.y>scrollView.origin_sd.y+Navigation_Height/2) {
            //做成折叠
            [self makeFold];
            NSLog(@"往上滑");
        }else if (point.y<scrollView.origin_sd.y){
            NSLog(@"往下拉");
        }
    }else{
        //在折叠状态的时候
        if (point.y<scrollView.origin_sd.y-20) {
            [self makeUnfold];
            NSLog(@"往下拉2");
        }else if (point.y>scrollView.origin_sd.y){
            NSLog(@"往上滑2");
            
        }
    }
}

/** 做成折叠 */
- (void)makeFold{
    if (_leadingViewState == LeadingViewStateUnfold) {
        _leadingViewState = LeadingViewStateFold;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Fold" object:nil];
    }
}

/** 做成展开 */
- (void)makeUnfold{
    if (_leadingViewState == LeadingViewStateFold) {
        _leadingViewState = LeadingViewStateUnfold;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Unfold" object:nil];
    }
}

- (void)changeFold{
    if (_leadingViewState == LeadingViewStateUnfold) {
        _leadingViewState = LeadingViewStateFold;
    }
}

- (void)changeUnfold{
    if (_leadingViewState == LeadingViewStateFold) {
        _leadingViewState = LeadingViewStateUnfold;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
