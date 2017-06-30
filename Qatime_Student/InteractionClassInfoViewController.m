//
//  InteractionClassInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/6/1.
//  Copyright © 2017年 WWTD. All rights reserved.
//  一对一课程详情子控制器

#import "InteractionClassInfoViewController.h"
#import "UIViewController+AFHTTP.h"
#import "OneOnOneTeacherTableViewCell.h"
#import "ClassesListTableViewCell.h"
#import "UIViewController+Token.h"
#import "MJRefresh.h"
#import "CYLTableViewPlaceHolder.h"
#import "HaveNoClassView.h"
#import "OneOnOneClass.h"
#import "YYModel.h"
#import "Teacher.h"
#import "OneOnOneLessonTableViewCell.h"
#import "InteractionLesson.h"
#import "InteractionTeacherListTableViewCell.h"
#import "TeachersPublicViewController.h"

@interface InteractionClassInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,InteractionTeacherListProtocal>{
    
    NSString *_classID;
    
    NSMutableArray *_lessonsArr;
    
    NSMutableArray *_teachersArr;
    
    BOOL showAllTeachers;
    
    
}

@end

@implementation InteractionClassInfoViewController

-(instancetype)initWithClassID:(NSString *)classID{
    
    self = [super init];
    if (self) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
    }
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载视图
    [self setupMainView];
    
    //请求数据
//    [self requestData];
    
}

/**加载主视图*/
- (void)setupMainView{
   
    _headView = [[InteractionInfoHeadView alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 200)];
    [_headView updateLayout];
    
    _mainView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
    _mainView.delegate = self;
    _mainView.dataSource = self;
    
    _mainView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        _teachersArr = @[].mutableCopy;
        _lessonsArr = @[].mutableCopy;
        
        [self requestData];
    }];
    [_mainView.mj_header beginRefreshing];
    
    _mainView.tableHeaderView = _headView;
    _mainView.tableHeaderView.size = CGSizeMake(self.view.width_sd, _headView.autoHeight);
    
    [_mainView updateLayout];
    self.view.bounds = _mainView.bounds;
    self.view.userInteractionEnabled = YES;
    
    showAllTeachers = NO;
    
}


/**请求数据*/
- (void)requestData{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/interactive_courses/%@/detail",Request_Header,_classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            //头视图赋值
            OneOnOneClass *info = [OneOnOneClass yy_modelWithJSON:dic[@"data"][@"interactive_course"]];
            info.descriptions =dic[@"data"][@"interactive_course"][@"description"];
            _headView.classModel = info;
            
            //加载教师和课程数据
            
            //测试数据,先弄出4条教师数据
            
//            for (int i=0; i<4; i++) {
            
                for (NSDictionary *teacher in dic[@"data"][@"interactive_course"][@"teachers"]) {
                    
                    Teacher *mod = [Teacher yy_modelWithJSON:teacher];
                    mod.teacherID = teacher[@"id"];
                    [_teachersArr addObject:mod];
                    
                }
//            }
            
            for (NSDictionary *lesson in dic[@"data"][@"interactive_course"][@"interactive_lessons"]) {
                
                InteractionLesson *mod = [InteractionLesson yy_modelWithJSON:lesson];
                mod.classID = lesson[@"id"];
                
                [_lessonsArr addObject:mod];
                
            }
            
            [_mainView cyl_reloadData];
            [_mainView.mj_header endRefreshing];
            
        }else{
            //数据不行啊
            
            [_mainView cyl_reloadData];
            [_mainView.mj_header endRefreshing];
            
        }
        
    } failure:^(id  _Nullable erros) {
        //网不行啊
        [_mainView cyl_reloadData];
        [_mainView.mj_header endRefreshing];
        
    }];
    
}



#pragma mark- UITableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows=0 ;
    if (section == 0) {
        if (_teachersArr.count>2) {
            
            if (showAllTeachers == NO) {
                rows = 2;
            }else{
                rows =_teachersArr.count;
            }
            
        }else{
            rows = _teachersArr.count;
        }
    }else if (section == 1){
        rows = _lessonsArr .count;
        
    }
    
    return rows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableCell;
    
    switch (indexPath.section) {
        case 0:{
         //教师组
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"teacherCell";
            InteractionTeacherListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[InteractionTeacherListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"teacherCell"];
            }
            
            if (_teachersArr.count>indexPath.row) {
                
                cell.model = _teachersArr[indexPath.row];
                cell.indexPath = indexPath;
                cell.delegate = self;
            }
            
            tableCell = cell;
            
        }
            break;
            
        case 1:{
            //课程列表
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"classCell";
            OneOnOneLessonTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[OneOnOneLessonTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"classCell"];
            }
            
            if (_lessonsArr.count>indexPath.row) {
                cell.model = _lessonsArr[indexPath.row];
            }
            
            tableCell = cell;
            
        }
            break;
    }
    
    return tableCell;
}


#pragma mark- UITableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0;
    
    if (indexPath.section == 0) {
        
        height = [tableView cellHeightForIndexPath:indexPath model:_teachersArr[indexPath.row] keyPath:@"model" cellClass:[InteractionTeacherListTableViewCell class] contentViewWidth:self.view.width_sd];
    }else if (indexPath.section == 1){
        
        height = [tableView cellHeightForIndexPath:indexPath model:_lessonsArr[indexPath.row] keyPath:@"model" cellClass:[OneOnOneLessonTableViewCell class] contentViewWidth:self.view.width_sd];
        
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    CGFloat height;
    
    if (self == 0) {
        height = 10;
    }else{
        
        height = 0.01;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    CGFloat height;
    if (section == 0) {
        
        if (_teachersArr.count<2) {
            
            height = 10;
        }else{
            
            if (showAllTeachers == NO) {
                
                height = 40;
                
            }else{
                
                height = 10;
            }
        }
        
        
    }else {
        
        height = 0.01;
    }
    
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIButton *footer;
    
    if (section == 0) {
        
        
        if (_teachersArr.count<2) {
            
        }else{
            
            if (showAllTeachers == NO) {
                //不显示所有教师
                footer = [[UIButton alloc]init];
                footer.backgroundColor = [UIColor whiteColor];
                [footer setTitle:@"显示全部教师" forState:UIControlStateNormal];
                [footer setTitleColor:BUTTONRED forState:UIControlStateNormal];
                footer.titleLabel.font = TEXT_FONTSIZE;
                [footer addTarget:self action:@selector(showAllTeachers) forControlEvents:UIControlEventTouchUpInside];
            }else{
                //显示所有教师
                
                
            }
        }
    }else{
        
    }
    
    return footer;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        InteractionTeacherListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        TeachersPublicViewController *controller = [[TeachersPublicViewController alloc]initWithTeacherID:cell.model.teacherID];
        [self.navigationController pushViewController:controller animated:YES];
        
    }

}

/** 点击选择教师的 替代方法 */
- (void)didSelectedCellAtIndexPath:(NSIndexPath *)indexPath{
    
    InteractionTeacherListTableViewCell *cell = [_mainView cellForRowAtIndexPath:indexPath];
    TeachersPublicViewController *controller = [[TeachersPublicViewController alloc]initWithTeacherID:cell.model.teacherID];
    [self.navigationController pushViewController:controller animated:YES];
    
}


/**显示所有教师*/
- (void)showAllTeachers{
    
    showAllTeachers = YES;
    
    [_mainView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
}


/** 旋转完了刷新页面 */
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    if (fromInterfaceOrientation!=UIInterfaceOrientationPortrait) {
        [self.view updateLayout];
        [_mainView updateLayout];
        [_mainView reloadData];
        
    }
    
}



- (UIView *)makePlaceHolderView{
    
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithTitle:@"加载失败"];
    
    return view;
}


- (BOOL)enableScrollWhenPlaceHolderViewShowing{
    
    return YES;
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
