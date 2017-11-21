//
//  ExclusiveInfo_ClassListViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/11/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ExclusiveInfo_ClassListViewController.h"
#import "ExclusiveOfflineClassTableViewCell.h"
/**
 顶部视图的折叠/展开状态
 
 - LeadingViewStateFold: 折叠
 - LeadingViewStateUnfold: 展开
 */
typedef NS_ENUM(NSUInteger, LeadingViewState) {
    LeadingViewStateFold,
    LeadingViewStateUnfold,
};
@interface ExclusiveInfo_ClassListViewController (){
    
    NSMutableArray *_onlineClassArray;//线上课程
    NSMutableArray *_offlineClassArray;//线下课程
    
    LeadingViewState _leadingViewState;
    BOOL _isBought;
}

@end

@implementation ExclusiveInfo_ClassListViewController

//初始化器
-(instancetype)initWithOnlineClass:(__kindof NSArray *)onlineClasses andOfflineClass:(__kindof NSArray *)offlineClasses bought:(BOOL)bought{
    self = [super init];
    if (self) {
        _onlineClassArray = onlineClasses;
        _offlineClassArray = offlineClasses;
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


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0 ) {
        return _onlineClassArray.count;
    }else{
        return  _offlineClassArray.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    if (indexPath.section == 0) {
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"cells";
        ClassesListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[ClassesListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cells"];
        }
        if (_onlineClassArray.count>indexPath.row) {
            cell.exclusiveModel = _onlineClassArray[indexPath.row];
            
            if ([cell.exclusiveModel.status isEqualToString:@"closed"]||[cell.exclusiveModel.status isEqualToString:@"billing"]||[cell.exclusiveModel.status isEqualToString:@"finished"]||[cell.exclusiveModel.status isEqualToString:@"completed"]) {
                if (_isBought == YES) {
                    if (cell.exclusiveModel.replayable == YES) {
                        cell.status.text = @"观看回放";
                        cell.status.textColor = BUTTONRED;
                    }else{
                        [cell switchStatus:cell.exclusiveModel];
                        cell.status.textColor = TITLECOLOR;
                    }
                }else{
                    [cell switchStatus:cell.exclusiveModel];
                    cell.status.textColor = TITLECOLOR;
                }
            }else{
                cell.status.textColor = TITLECOLOR;
            }
        }
        return cell;
    }else{
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"cell";
        ExclusiveOfflineClassTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[ExclusiveOfflineClassTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        if (_offlineClassArray.count>indexPath.row) {
            cell.model = _offlineClassArray[indexPath.row];
            
        }
        
        return cell;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (_offlineClassArray.count>0) {
        return 2;
    }else{
        return 1;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0){
        return @"线上直播";
    }else{
        return @"线下讲课";
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat height = 0;
    
    if (indexPath.section == 0) {
        if (_onlineClassArray.count>indexPath.row) {
            
            height = [tableView cellHeightForIndexPath:indexPath model:_onlineClassArray[indexPath.row] keyPath:@"exclusiveModel" cellClass:[ClassesListTableViewCell class] contentViewWidth:self.view.width_sd];
        }
    }else{
        if (_offlineClassArray.count>indexPath.row) {
            height = [tableView cellHeightForIndexPath:indexPath model:_offlineClassArray[indexPath.row] keyPath:@"model" cellClass:[ExclusiveOfflineClassTableViewCell class] contentViewWidth:self.view.width_sd];
        }
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_replayBlock) {
        self.replayBlock(tableView, indexPath);
    }
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
