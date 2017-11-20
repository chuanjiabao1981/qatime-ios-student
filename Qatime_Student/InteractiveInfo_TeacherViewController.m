//
//  InteractiveInfo_TeacherViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/11/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "InteractiveInfo_TeacherViewController.h"
#import "TeachersPublicViewController.h"

/**
 顶部视图的折叠/展开状态
 
 - LeadingViewStateFold: 折叠
 - LeadingViewStateUnfold: 展开
 */
typedef NS_ENUM(NSUInteger, LeadingViewState) {
    LeadingViewStateFold,
    LeadingViewStateUnfold,
};

@interface InteractiveInfo_TeacherViewController ()<OneOnOneTeacherTableViewCellDelegate>{
    
    LeadingViewState _leadingViewState;
}

@end

@implementation InteractiveInfo_TeacherViewController

-(instancetype)initWithTeachers:(__kindof NSArray *)teachers{
    self = [super init];
    if (self) {
        _teachersArray = teachers;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //默认是展开状态
    _leadingViewState = LeadingViewStateUnfold;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeFold) name:@"ChangeFold" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeUnfold) name:@"ChangeUnfold" object:nil];
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.tableFooterView = [UIView new];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _teachersArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    OneOnOneTeacherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[OneOnOneTeacherTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (_teachersArray.count>indexPath.row) {
        cell.model = _teachersArray[indexPath.row];
        cell.delegate = self;
    }
    
    return  cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.width_sd tableView:tableView];
}


- (void)selectedTeacher:(NSString *)teacherID{
    
    TeachersPublicViewController *controller = [[TeachersPublicViewController alloc]initWithTeacherID:teacherID];
    [self.navigationController pushViewController:controller animated:YES];
    
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