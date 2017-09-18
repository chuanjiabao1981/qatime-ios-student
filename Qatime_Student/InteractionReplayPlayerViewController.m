//
//  InteractionReplayPlayerViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/22.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "InteractionReplayPlayerViewController.h"
#import "YYModel.h"

@interface InteractionReplayPlayerViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    BOOL _listShow;
    
    NSIndexPath *_playingIndexPath;
    
}

@end

@implementation InteractionReplayPlayerViewController

-(id)initWithURL:(NSURL *)url andTitle:(NSString *)title andReplayArray:(NSArray *)replaysArray andPlayingIndex:(NSIndexPath *)indexPath{
    
    self = [self initWithNibName:@"NELivePlayerViewController" bundle:nil];
    if (self) {
        self.url = url;
        self.decodeType = @"software";
        self.mediaType = @"videoOnDemand";
        self.videoTitle = [NSString stringWithFormat:@"%@",title];
        self.replayArray = replaysArray.mutableCopy;
        self->_playingIndexPath = indexPath;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //各种初始化
    _replayLessonsArray = @[].mutableCopy;
    
    //加个按钮
    _lessonListBtn = [[UIButton alloc]init];
    [self.topControlView addSubview:_lessonListBtn];
    [_lessonListBtn setImage:[UIImage imageNamed:@"class"] forState:UIControlStateNormal];
    _lessonListBtn.sd_layout
    .rightSpaceToView(self.topControlView, 0)
    .topSpaceToView(self.topControlView, 0)
    .bottomSpaceToView(self.topControlView, 0)
    .widthEqualToHeight();
    [_lessonListBtn addTarget:self action:@selector(showLessonsList:) forControlEvents:UIControlEventTouchUpInside];
    
    //列表
    _lessonList = [[UITableView alloc]init];
    _lessonList.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
    [self.controlOverlay addSubview:_lessonList];
    _lessonList.sd_layout
    .topSpaceToView(self.topControlView, 0)
    .bottomSpaceToView(self.topControlView, 0)
    .rightSpaceToView(self.controlOverlay, -self.view.width_sd*0.3f)
    .widthRatioToView(self.view, 0.3f);
    _lessonList.delegate = self;
    _lessonList.dataSource = self;
    
    
    //加工数据
    for (NSDictionary *lesson in _replayArray) {
        
        InteractionReplayLesson *mod = [InteractionReplayLesson yy_modelWithJSON:lesson];
        
        [_replayLessonsArray addObject:mod];
        
    }
    
    
}

- (void)showLessonsList:(UIButton *)sender{
    
    if (_listShow) {
        
        [self listHideAnimated];
    }else{
        [self listShowAnimated];
    }
    
    _listShow = !_listShow;
}


- (void)listShowAnimated{
    
    [UIView animateWithDuration:0.3 animations:^{
        _lessonList.sd_layout
        .rightSpaceToView(self.controlOverlay, 0);
        [_lessonList updateLayout];
    }];
}

- (void)listHideAnimated{
    
    [UIView animateWithDuration:0.3 animations:^{
        _lessonList.sd_layout
        .rightSpaceToView(self.controlOverlay, self.view.width_sd*0.3f);
        [_lessonList updateLayout];
    }];
}

-(void)controlOverlayHide{
    [super controlOverlayHide];
    
    [self listHideAnimated];
    _listShow = NO;
}


#pragma mark- UITableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _replayLessonsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    InteractionReplayLessonsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[InteractionReplayLessonsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if ([indexPath isEqual:_playingIndexPath]) {
        cell.name.textColor = BUTTONRED;
    }
    
    cell.model = _replayLessonsArray[indexPath.row];
    
    return  cell;
    
}

#pragma mark- UITableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView cellHeightForIndexPath:indexPath model:_replayArray[indexPath.row] keyPath:@"model" cellClass:[InteractionReplayLessonsTableViewCell class] contentViewWidth:self.view.width_sd*0.3f];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (InteractionReplayLessonsTableViewCell *cell in tableView.visibleCells) {
        cell.name.textColor = [UIColor whiteColor];
    }
    for (InteractionReplayLesson *lesson in _replayLessonsArray) {
        lesson.isSelected = NO;
    }
    
    InteractionReplayLessonsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.model.isSelected = YES;
    cell.name.textColor = BUTTONRED;
    
    //切换播放源
    
    InteractionReplayLesson *mod = _replayLessonsArray[indexPath.row];
    //    mod.shd_url
    
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

