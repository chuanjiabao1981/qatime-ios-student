//
//  OneOnOneTutoriumInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/31.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "OneOnOneTutoriumInfoViewController.h"
#import "NavigationBar.h"
#import "UIViewController+AFHTTP.h"
#import "YYModel.h"
#import "InteractionLesson.h"
#import "UITableView+CYLTableViewPlaceHolder.h"
#import "Teacher.h"
#import "OneOnOneLessonTableViewCell.h"
#import "OneOnOneTeacherTableViewCell.h"
#import "UIViewController+HUD.h"
#import "OrderViewController.h"
#import "TeachersPublicViewController.h"
#import "InteractionViewController.h"
#import "Features.h"
#import "TeacherFeatureTagCollectionViewCell.h"
#import "WorkFlowTableViewCell.h"

@interface OneOnOneTutoriumInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,OneOnOneTeacherTableViewCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    
    NavigationBar *_navigationBar;
    NSString  *_token;
    NSString *_idNumber;
    
    /**购买按钮*/
    UIButton *_buyButton;
    
    /* 保存本页面数据*/
    NSMutableDictionary *_dataDic;
    
    /* 优惠码*/
    NSString *_promotionCode;
    
    /**教师组*/
    NSMutableArray <Teacher *>*_teachersArray;
    
    /**课程列表*/
    NSMutableArray <InteractionLesson *>*_classArray;
    
    /**课程model*/
//    OneOnOneClass *_classMod;
    
    /**课程特色数组*/
    NSMutableArray *_classFeaturesArray;
    
    /**学习流程所需的数据*/
    NSArray *_workFlowArr;

}

@end

@implementation OneOnOneTutoriumInfoViewController


- (instancetype)initWithClassID:(NSString *)classID
{
    self = [super init];
    if (self) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
    }
    return self;
}


- (instancetype)initWithClassID:(NSString *)classID andPromotionCode:(NSString *)promotionCode{
    
    self = [super init];
    if (self) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        
        _promotionCode =[NSString stringWithFormat:@"%@",promotionCode];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化数据
    _teachersArray = @[].mutableCopy;
    _classArray = @[].mutableCopy;
    
    _classFeaturesArray = @[].mutableCopy;
    
    _workFlowArr = @[@{@"image":@"work1",@"title":@"1.购买课程",@"subTitle":@"支持退款,放心购买"},
                     @{@"image":@"work2",@"title":@"2.准时上课",@"subTitle":@"提前预习,按时上课"},
                     @{@"image":@"work3",@"title":@"3.在线授课",@"subTitle":@"多人交流,生动直播"},
                     @{@"image":@"work4",@"title":@"4.上课结束",@"subTitle":@"视频回放,想看就看"}];
    //加载导航栏
    [self setupNavigation];
    
    //提取token
    [self getToken];
    
    //加载数据
    [self requestData];
    
    [self loadingHUDStartLoadingWithTitle:@"正在加载"];
    
    
}
/**请求一对一辅导班详情*/
- (void)requestData{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/interactive_courses/%@",Request_Header,_classID] withHeaderInfo:_token andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            _dataDic = [dic[@"data"] copy];
            //首页赋值
            OneOnOneClass *classMod = [OneOnOneClass yy_modelWithJSON:dic[@"data"]];
            classMod.classID = dic[@"data"][@"id"];
            classMod.descriptions = dic[@"data"][@"description"];
            classMod.attributeDescriptions = [[NSMutableAttributedString alloc]initWithData:[dic[@"data"][@"description"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            //标题
            _navigationBar.titleLabel.text = classMod.current_lesson_name;
            
            //特色
            for (NSString *key in _dataDic[@"icons"]) {
                
                if (![key isEqualToString:@"cheap_moment"]) {
                    if ([_dataDic[@"icons"][key]boolValue]==YES) {
                        Features *mod = [[Features alloc]init];
                        mod.include = [_dataDic[@"icons"][key] boolValue];
                        mod.content = key;
                        [_classFeaturesArray addObject:mod];
                    }
                }
                
            }
            [self.view addSubview:self.myView];
            
            //赋值
            self.myView.model = classMod;
            
            //教师
            if (classMod.teachers.count!=0) {
                
                for (NSDictionary *dics in classMod.teachers) {
                    Teacher *mod = [Teacher yy_modelWithJSON:dics];
                    mod.teacherID = dics[@"id"];
                    [_teachersArray addObject:mod];
                }
                [self.myView.teachersGroupTableView cyl_reloadData];
            }else{
                [self.myView.teachersGroupTableView cyl_reloadData];
            }
            
            //课程
            if (classMod.interactive_lessons.count!=0) {
                for (NSDictionary *dics in classMod.interactive_lessons) {
                    InteractionLesson *mod = [InteractionLesson yy_modelWithJSON:dics];
                    mod.classID = dics[@"id"];
                    [_classArray addObject:mod];
                }
                [self.myView.classListTableView cyl_reloadData];
            }else{
                [self.myView.classListTableView cyl_reloadData];
            }
            
            //判断购买状态
            if (classMod.is_bought == NO) {
                [_buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
                [_buyButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
                [_buyButton addTarget:self action:@selector(buyClass:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                
                [_buyButton setTitle:@"立即学习" forState:UIControlStateNormal];
                [_buyButton setTitleColor:NAVIGATIONRED forState:UIControlStateNormal];
                [_buyButton addTarget:self action:@selector(enterClass) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
            //
            
        }else{
            //数据错误
        }
        [self loadingHUDStopLoadingWithTitle:nil];
    }];
    
}

/**进入教师详情页*/
- (void)selectedTeacher:(NSString *)teacherID{
    
    TeachersPublicViewController *controller = [[TeachersPublicViewController alloc]initWithTeacherID:teacherID];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}

/**进入互动课程*/
- (void)enterClass{
    
    OneOnOneTutoriumInfoViewController *controller = [[OneOnOneTutoriumInfoViewController alloc]initWithClassID:_classID];
    [self.navigationController pushViewController:controller animated:YES];
    
}

/**购买课程*/
- (void)buyClass:(UIButton *)sender{
    
    OrderViewController *orderVC;
    
    if (_promotionCode) {
        
        orderVC = [[OrderViewController alloc]initWithClassID:_classID andPromotionCode:_promotionCode andClassType:InteractionType andProductName:_dataDic[@"name"]];
    }else{
        
        orderVC= [[OrderViewController alloc]initWithClassID:_classID andClassType:InteractionType andProductName:_dataDic[@"name"]];
    }
    
    
    [self.navigationController pushViewController:orderVC animated:YES];

    
}




/**加载主视图*/
- (void)setupMainViews{
    
    [self.view addSubview:self.myView];
    
}

-(OneOnOneTutorimInfoView *)myView{
    
    if (!_myView) {
        _myView =[[OneOnOneTutorimInfoView alloc]initWithFrame:CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd-Navigation_Height-TabBar_Height)];
        
        typeof(self) __weak weakSelf = self;
        _myView.segmentControl.indexChangeBlock = ^(NSInteger index) {
            [weakSelf.myView.scrollView scrollRectToVisible:CGRectMake(weakSelf.view.width_sd*index, 0, weakSelf.view.width_sd, weakSelf.myView.scrollView.height_sd) animated:YES];
        };
        
        //指定代理
        _myView.teachersGroupTableView.delegate = self;
        _myView.teachersGroupTableView.dataSource = self;
        _myView.teachersGroupTableView.tag = 1;
        _myView.classListTableView.delegate = self;
        _myView.classListTableView.dataSource = self;
        _myView.classListTableView.tag = 2;
        _myView.scrollView.delegate = self;
        
        _myView.workFlowView.delegate = self;
        _myView.workFlowView.dataSource = self;
        _myView.workFlowView.tag = 3;
        
        
        _myView.classFeature.dataSource = self;
        _myView.classFeature.delegate = self;
        
        [_myView.classFeature registerClass:[TeacherFeatureTagCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
        
        [self setupBuyBar];
    }
    return _myView;
}

/**获取token*/
- (void)getToken{
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }

}

/**加载导航栏和购买bar*/
- (void)setupNavigation{
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [self.view addSubview:_navigationBar];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastpage) forControlEvents:UIControlEventTouchUpInside];
    
}
/**购买按钮*/
- (void)setupBuyBar{
    
    /* 购买bar*/
    UIView *buyView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height_sd-TabBar_Height, self.view.width_sd, TabBar_Height)];
    buyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:buyView];
    UIView *lines = [[UIView alloc]init];
    lines.backgroundColor = SEPERATELINECOLOR_2;
    [buyView addSubview:lines];
    lines.sd_layout
    .leftSpaceToView(buyView, 0)
    .rightSpaceToView(buyView, 0)
    .topSpaceToView(buyView, 0)
    .heightIs(0.5);
    _buyButton = [[UIButton alloc]init];
    
    _buyButton.layer.borderColor = NAVIGATIONRED.CGColor;
    _buyButton.layer.borderWidth = 1;
    [buyView addSubview:_buyButton];
    _buyButton.sd_layout
    .leftSpaceToView(buyView, 10)
    .topSpaceToView(buyView, 10)
    .bottomSpaceToView(buyView, 10)
    .rightSpaceToView(buyView, 10);
    _buyButton.sd_cornerRadius = @2;
    
    
    if (![self isLogin]) {
        [_buyButton addTarget:self action:@selector(loginAgain) forControlEvents:UIControlEventTouchUpInside];
    }

}

#pragma mark- UITableView datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSInteger rows = 0;
    switch (tableView.tag) {
        case 1:{
            rows = _teachersArray.count;
        }
            break;
        case 2:{
            rows = _classArray.count;
        }
            break;
        case 3:{
            rows = _workFlowArr.count;
        }
    }
    return rows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableCell;
    switch (tableView.tag) {
        case 1:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            OneOnOneTeacherTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[OneOnOneTeacherTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            
            if (_teachersArray.count>indexPath.row) {
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                
                cell.model = _teachersArray[indexPath.row];
                cell.delegate = self;
            }
            
            tableCell = cell;
        }
            break;
            
        case 2:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cellID";
            OneOnOneLessonTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[OneOnOneLessonTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
            }
            if (_classArray.count>indexPath.row) {
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                cell.model = _classArray[indexPath.row];
            }
            
            tableCell = cell;
        }
            break;
            
        case 3:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"tablecell";
            WorkFlowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[WorkFlowTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"tablecell"];
            }
            if (_workFlowArr.count>indexPath.row) {
                
                [cell.image setImage:[UIImage imageNamed:_workFlowArr[indexPath.row][@"image"]]];
                cell.title.text = _workFlowArr[indexPath.row][@"title"];
                cell.subTitle.text = _workFlowArr[indexPath.row][@"subTitle"];
            }

            
            return  cell;
        
        }
    }
    
    return tableCell;
}

#pragma mark- UITableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger height = 0;
    switch (tableView.tag) {
        case 1:{
            height= [tableView cellHeightForIndexPath:indexPath model:_teachersArray[indexPath.row] keyPath:@"model" cellClass:[OneOnOneTeacherTableViewCell class] contentViewWidth:self.view.width_sd];
        }
            break;
            
        case 2:{
            height= [tableView cellHeightForIndexPath:indexPath model:_classArray[indexPath.row] keyPath:@"model" cellClass:[OneOnOneLessonTableViewCell class] contentViewWidth:self.view.width_sd];
        }
            break;
        case 3:{
            
            height = (self.view.width_sd-100*ScrenScale)/4.0;
        }
    }
    
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NIMChatroom *chatroom = [[NIMChatroom alloc]init];
//    chatroom.roomId = @"8130727";
//    chatroom.name = @"哈喽";
//    
//    //创建数据
//    NSMutableArray *noticeArr = @[].mutableCopy;
//    TutoriumListInfo *tutoium;
//    NSMutableArray <Teacher *> *teachers = @[].mutableCopy;
//    NSMutableArray *classArr = @[].mutableCopy;
//    NSMutableArray *membersArr = @[].mutableCopy;
//    
//    if (![_dataDic[@"chat_team"] isEqual:[NSNull null]]) {
//        
//        if (![_dataDic[@"chat_team"][@"announcement"] isEqual:[NSNull null]]) {
//            
//            for (NSDictionary *dic in _dataDic[@"chat_team"][@"announcement"]) {
//                
//                Notice *mod  = [Notice yy_modelWithJSON:dic];
//                [noticeArr addObject:mod];
//            }
//        }
//        
//        if (![_dataDic[@"chat_team"][@"accounts"] isEqual:[NSNull null]]) {
//            for (NSMutableDictionary *dic in _dataDic[@"chat_team"][@"accounts"]) {
//                Members *mod = [Members yy_modelWithJSON:dic];
//                [membersArr addObject:mod];
//            }
//        }
//    }
//    
//    tutoium = [TutoriumListInfo yy_modelWithJSON:_dataDic];
//    tutoium.describe = _dataDic[@"description"];
//    
//    if (![_dataDic[@"teachers"]isEqual:[NSNull null]]) {
//        for (NSDictionary *dic in _dataDic[@"teachers"]) {
//            Teacher *mod = [Teacher yy_modelWithJSON:dic];
//            mod.teacherID = dic[@"id"];
//            [teachers addObject:mod];
//        }
//    }
//    
//    if (![_dataDic[@"interactive_lessons"]isEqual:[NSNull null]]) {
//        
//        for (NSDictionary *dic in _dataDic[@"interactive_lessons"]) {
//            Classes *mod = [Classes yy_modelWithJSON:dic];
//            mod.classID = dic[@"id"];
//            [classArr addObject:mod];
//        }
//    }
//    
//    InteractionViewController *controller = [[InteractionViewController alloc]initWithChatroom:chatroom andNotice:noticeArr andTutorium:tutoium andTeacher:_teachersArray andClasses:classArr andOnlineMembers:membersArr];
//    [self.navigationController pushViewController:controller animated:YES];

    
}



#pragma mark- UIScrollView delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _myView.scrollView) {
        
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = scrollView.contentOffset.x / pageWidth;
        
        [_myView.segmentControl setSelectedSegmentIndex:page animated:YES];
    }
    
}

#pragma mark- UICollectionView datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger num;
    
    if (_classFeaturesArray.count==0) {
        num = 3;
    }else{
        num = _classFeaturesArray.count;
    }
    
    return num;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"CollectionCell";
    TeacherFeatureTagCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (_classFeaturesArray.count>indexPath.row) {
        
        cell.model = _classFeaturesArray[indexPath.row];
        [cell updateLayoutSubviews];
    }
    
    return cell;
    
}

#pragma mark- UICollectionView delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

/* item尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return  CGSizeMake(self.view.width_sd/3.0,20);
}




/**无数据占位图*/
- (UIView *)makePlaceHolderView{
    
    return [UIView new];
}

- (BOOL)enableScrollWhenPlaceHolderViewShowing{
    
    return YES;
}

/**返回上一页*/
- (void)returnLastpage{
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
