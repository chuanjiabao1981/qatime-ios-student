//
//  VideoClassInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/11.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClassInfoViewController.h"
#import "NavigationBar.h"
#import "VideoClassListTableViewCell.h"
#import "VideoClassInfo.h"
#import "CYLTableViewPlaceHolder.h"
#import "HaveNoClassView.h"
#import "VideoClassBuyBar.h"
#import "UIViewController+AFHTTP.h"
#import "YYModel.h"
#import "UIControl+RemoveTarget.h"
#import "VideoClass.h"
#import "YYModel.h"
<<<<<<< HEAD
=======
#import "VideoClassPlayerViewController.h"
#import "OrderViewController.h"
>>>>>>> 视频课功能

typedef enum : NSUInteger {
    PullToRefresh,
    PushToLoadMore,
    
} RefreshType;

@interface VideoClassInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CYLTableViewPlaceHolderDelegate,VideoClassBuyBarDelegate>{
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    
    
    /**数据源*/
    NSMutableArray <VideoClass *>*_classArray;
    
    /**课程ID*/
    NSString *_classID;
    
    /**model*/
    VideoClassInfo *_classInfo;
    
    /**教师详情*/
    Teacher *_teacher;
    
}
/**主视图*/
@property (nonatomic, strong) VideoClassInfoView *videoClassInfoView ;

/**购买栏*/
@property (nonatomic, strong) VideoClassBuyBar *buyBar ;

@end

@implementation VideoClassInfoViewController


- (instancetype)initWithClassID:(NSString *)classID{
    
    self = [super init];
    if (self) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
    }
    return self;
    
}



/**导航栏*/
- (void)setupNavigation{
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview: _navigationBar];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
}
/**token方法*/
- (void)getToken{
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
}

/**加载主视图*/
- (void)setupMainView{
    
    _videoClassInfoView = [[VideoClassInfoView alloc]initWithFrame:CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd - Navigation_Height - TabBar_Height)];
    [self.view addSubview:_videoClassInfoView];
    
    _videoClassInfoView.classesListTableView.delegate = self;
    _videoClassInfoView.classesListTableView.dataSource = self;
    _videoClassInfoView.classesListTableView.tag = 1;
    
    _videoClassInfoView.scrollView.delegate = self;
    _videoClassInfoView.scrollView.tag = 2;
    _videoClassInfoView.classesListTableView.estimatedRowHeight = 100;
    _videoClassInfoView.classesListTableView.rowHeight = UITableViewAutomaticDimension;
    
    typeof(self) __weak weakSelf = self;
    [_videoClassInfoView.segmentControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.videoClassInfoView.scrollView scrollRectToVisible:CGRectMake(weakSelf.view.width_sd*index, 0, weakSelf.view.width_sd, weakSelf.videoClassInfoView.scrollView.height_sd) animated:YES];
    }];
    
}

/**加载购买栏*/
- (void)setupBuyBar{
    _buyBar = [[VideoClassBuyBar alloc]initWithFrame: CGRectMake(0, self.view.height_sd-TabBar_Height, self.view.width_sd, TabBar_Height)];
    [self.view addSubview:_buyBar];
    
    _buyBar.delegate = self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化
    _classArray = @[].mutableCopy;
    
    //加载token
    [self getToken];
    
    //加载导航栏
    [self setupNavigation];
    
    //请求数据
    [self requestData];
    
}

/**请求数据*/
- (void)requestData{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/video_courses/%@",Request_Header,_classID] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            _classInfo = [VideoClassInfo yy_modelWithJSON:dic[@"data"]];
            _classInfo.classID = dic[@"data"][@"id"];
            //加载主页
            [self setupMainView];
            _videoClassInfoView.model = _classInfo;
            
<<<<<<< HEAD
            //课程列表
            for (NSDictionary *dics in _classInfo.video_lessons) {
                VideoClass *mod = [VideoClass yy_modelWithJSON:dics];
                mod.video = [Video yy_modelWithJSON:dics[@"video"]];
               
                [_classArray addObject:mod];
            }
            [_videoClassInfoView.classesListTableView reloadData];
            
            //加载购买栏
            [self setupBuyBar];
            
            //按钮显示部分
            if (_classInfo.is_bought == YES) {
                _buyBar.leftButton.hidden = YES;
                _buyBar.rightButton.layer.borderColor = [UIColor greenColor].CGColor;
                _buyBar.rightButton.backgroundColor = [UIColor greenColor];
                [_buyBar.rightButton setTitle:@"观看" forState:UIControlStateNormal];
                [_buyBar.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                _buyBar.rightButton.sd_resetLayout
                .leftSpaceToView(_buyBar, 10)
                .rightSpaceToView(_buyBar, 10)
                .topSpaceToView(_buyBar, 10)
                .bottomSpaceToView(_buyBar, 10);
                [_buyBar.rightButton updateLayout];
            }else{
                if (/**能试听*/_classInfo.taste_count.integerValue!=0) {
                    
                    _buyBar.leftButton.layer.borderColor = [UIColor greenColor].CGColor;
                    _buyBar.leftButton.backgroundColor = [UIColor greenColor];
                    [_buyBar.leftButton setTitle:@"进入试听" forState:UIControlStateNormal];
                    [_buyBar.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }else{
                    _buyBar.leftButton.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
                    _buyBar.leftButton.backgroundColor = SEPERATELINECOLOR_2;
                    [_buyBar.leftButton setTitle:@"试听结束" forState:UIControlStateNormal];
                    [_buyBar.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
                    
                }
                
                
            }
=======
            
            _teacher = [Teacher yy_modelWithJSON:_classInfo.teacher];
            _teacher.teacherID = _classInfo.teacher[@"id"];
            
            //课程列表
            for (NSDictionary *dics in _classInfo.video_lessons) {
                VideoClass *mod = [VideoClass yy_modelWithJSON:dics];
                mod.video = [Video yy_modelWithJSON:dics[@"video"]];
               
                [_classArray addObject:mod];
            }
            [_videoClassInfoView.classesListTableView reloadData];
>>>>>>> 视频课功能
            
            //加载购买栏
            [self setupBuyBar];
            
            //按钮显示部分
            
            //已购买
            if (_classInfo.is_bought == YES) {
                _buyBar.leftButton.hidden = YES;
                _buyBar.rightButton.layer.borderColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0].CGColor;
                _buyBar.rightButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0];
                [_buyBar.rightButton setTitle:@"观看" forState:UIControlStateNormal];
                [_buyBar.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                _buyBar.rightButton.sd_resetLayout
                .leftSpaceToView(_buyBar, 10)
                .rightSpaceToView(_buyBar, 10)
                .topSpaceToView(_buyBar, 10)
                .bottomSpaceToView(_buyBar, 10);
                [_buyBar.rightButton updateLayout];
                
                [_buyBar.rightButton removeAllTargets];
                [_buyBar.rightButton addTarget:self action:@selector(enterStudy:) forControlEvents:UIControlEventTouchUpInside];
                
                //未购买
            }else{
                //能试听
                if (_classInfo.is_tasting == YES) {
                    _buyBar.leftButton.layer.borderColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0].CGColor;
                    _buyBar.leftButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0];
                    [_buyBar.leftButton setTitle:@"进入试听" forState:UIControlStateNormal];
                    [_buyBar.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }else{
                    //不能试听
                    _buyBar.leftButton.layer.borderColor = SEPERATELINECOLOR_2.CGColor;
                    _buyBar.leftButton.backgroundColor = SEPERATELINECOLOR_2;
                    [_buyBar.leftButton setTitle:@"试听结束" forState:UIControlStateNormal];
                    [_buyBar.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
                }
            }
        }else{
            
        }
        
    }];
    
}


/**
 回调方法 试听

 @param sender 购买栏左侧按钮
 */
- (void)enterTaste:(UIButton *)sender{
   
    //如果可以试听就试听,不能试听没反应
<<<<<<< HEAD
    if (_classInfo.taste_count!=0) {
        
        //进入试听
        
=======
    if (_classInfo.is_tasting==YES) {
        //进入试听
        
        //测试代码  ->暂时缺少试听接口
        VideoClassPlayerViewController *controller = [[VideoClassPlayerViewController alloc]initWithClasses:_classArray andTeacher:_teacher andVideoClassInfos:_classInfo];
        [self.navigationController pushViewController:controller animated:YES];

        
>>>>>>> 视频课功能
    }else{
       //按钮不能用
        
    }
    
}

/**
 回调方法  进入学习

 @param sender 购买栏右侧方法
 */
- (void)enterStudy:(UIButton *)sender{
    
    if (_classInfo.is_bought == YES) {
        //进入学习
        
<<<<<<< HEAD
=======
        //测试代码
            VideoClassPlayerViewController *controller = [[VideoClassPlayerViewController alloc]initWithClasses:_classArray andTeacher:_teacher andVideoClassInfos:_classInfo];
            [self.navigationController pushViewController:controller animated:YES];
>>>>>>> 视频课功能
        
    }else{
     //购买下单
        
<<<<<<< HEAD
    }
=======
        OrderViewController *controller = [[OrderViewController alloc]initWithClassID:_classID andClassType:VideoClassType];
        [self.navigationController pushViewController:controller animated:YES];
        
    }

    
    
>>>>>>> 视频课功能
}



#pragma mark- UITableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _classArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
     VideoClassListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[VideoClassListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (_classArray.count>indexPath.row) {
        
        cell.model = _classArray[indexPath.row];
    }
    
    return  cell;

}


#pragma mark- UITableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:self.view.width_sd tableView:tableView];
}


#pragma mark- UIScrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 2) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger pages = scrollView.contentOffset.x / pageWidth;
        
        [_videoClassInfoView.segmentControl setSelectedSegmentIndex:pages animated:YES];
    }
}

/**无课程占位图*/
- (UIView *)makePlaceHolderView{
    HaveNoClassView *view = [[HaveNoClassView alloc]init];
    view.titleLabel.text = @"当前无课程";
    return view;
}



- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
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
