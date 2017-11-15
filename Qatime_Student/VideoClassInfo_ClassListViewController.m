//
//  VideoClassInfo_ClassListViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/11/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClassInfo_ClassListViewController.h"
#import "VideoClassListTableViewCell.h"

/**
 顶部视图的折叠/展开状态
 
 - LeadingViewStateFold: 折叠
 - LeadingViewStateUnfold: 展开
 */
typedef NS_ENUM(NSUInteger, LeadingViewState) {
    LeadingViewStateFold,
    LeadingViewStateUnfold,
};

@interface VideoClassInfo_ClassListViewController (){
    
    NSArray *_classArray;
    LeadingViewState _leadingViewState;
    BOOL _isBought;
}

@end

@implementation VideoClassInfo_ClassListViewController

-(instancetype)initWithClasses:(__kindof NSArray<VideoClass *> *)classArray bought:(BOOL)bought{
    
    self = [super init];
    if (self) {
        _classArray = classArray;
        _isBought = bought;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _leadingViewState = LeadingViewStateUnfold;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeFold) name:@"ChangeFold" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeUnfold) name:@"ChangeUnfold" object:nil];
    
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _classArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellID";
    VideoClassListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[VideoClassListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
   
    if (_classArray.count>indexPath.row) {
        cell.model = _classArray[indexPath.row];
        if (_isBought == YES) {
            
            cell.status.hidden = YES;
        }else{
            
            if (cell.model.tastable == YES) {
                cell.status.hidden= NO;
            }else{
                cell.status .hidden = YES;
            }
            
        }
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.width_sd tableView:tableView];
}



@end
