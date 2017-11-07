//
//  ExclusiveInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/7/24.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ExclusiveInfoViewController.h"
#import "UIControl+RemoveTarget.h"
#import "ExclusivePlayerViewController.h"
#import "ExclusiveInfo.h"
#import "UIViewController+HUD.h"
#import "UIViewController+AFHTTP.h"
#import "UIViewController+Token.h"
#import "YYModel.h"
#import "UIAlertController+Blocks.h"
#import "OrderViewController.h"
#import "Features.h"
#import "TeacherFeatureTagCollectionViewCell.h"
#import "ClassesListTableViewCell.h"
#import "CYLTableViewPlaceHolder.h"
#import "ExclusiveLesson.h"
#import "ExclusiveOfflineClassTableViewCell.h"
#import "HaveNoClassView.h"
#import "VideoPlayerViewController.h"
#import "WorkFlowTableViewCell.h"
#import "NSNull+Json.h"
#import "CommonMenuView.h"
#import "ChatViewController.h"
#import "ExclusiveAskViewController.h"
#import "ExclusiveHomeworkViewController.h"
#import "ExclusiveCoursewareViewController.h"
#import "ExclusiveMembersViewController.h"
#import "ClassMembersViewController.h"
#import "SnailQuickMaskPopups.h"
#import "ShareViewController.h"
#import "WXApiObject.h"
#import "WXApi.h"

@interface ExclusiveInfoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate>{
    
    NSDictionary *_dataDic;
    
    NSMutableArray *_onlineClassArray;
    NSMutableArray *_offlineClassArray;

    //专属课独有的 导航栏右侧按钮
//    UIButton *_exclusiveMenuButton;
    
    NSString *_chatTeamID;
    
    BOOL _isFinished;
    
    NSArray *_newWorkFlowArr;
    
    CGFloat _buttonWidth;
    
    ExclusiveInfo *_model;
    
    ShareViewController *_share;
    SnailQuickMaskPopups *_pops;
    
}


@end

@implementation ExclusiveInfoViewController

-(void)viewDidDisappear:(BOOL)animated{
    [CommonMenuView clearMenu];
}
-(void)viewDidAppear:(BOOL)animated{
    [self makeMenu];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _buttonWidth = self.view.width_sd/4-15*ScrenScale;
    
    //导航栏右侧按钮
    [self setupNavigationButton];
    
    _newWorkFlowArr = @[@{@"image":@"work1",@"title":@"1.购买课程",@"subTitle":@"支持退款,放心购买"},
                        @{@"image":@"work2",@"title":@"2.准时上课",@"subTitle":@"提前预习,按时上课"},
                        @{@"image":@"work3",@"title":@"3.在线授课",@"subTitle":@"多人交流,生动直播"},
                        @{@"image":@"work4",@"title":@"4.上课结束",@"subTitle":@"互动答疑,随时解惑"}];
    
    _onlineClassArray = @[].mutableCopy;
    _offlineClassArray = @[].mutableCopy;
    
    self.tutoriumInfoView.classFeature.delegate = self;
    self.tutoriumInfoView.classFeature.dataSource = self;
    
    //注册cell
    [self.tutoriumInfoView.classFeature registerClass:[TeacherFeatureTagCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];

    self.tutoriumInfoView.classesListTableView.delegate = self;
    self.tutoriumInfoView.classesListTableView.dataSource = self;
    self.tutoriumInfoView.classesListTableView.tag = 1;
    
    self.tutoriumInfoView.workFlowView.delegate = self;
    self.tutoriumInfoView.workFlowView.dataSource = self;
    self.tutoriumInfoView.workFlowView.tag = 2;
    
    //分一线程,请求chateamid
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestChatTeam];
    });
    
    self.tutoriumInfoView.tags.hidden = YES;
    self.tutoriumInfoView.classTagsView.hidden = YES;
    self.tutoriumInfoView.taget.sd_layout.topSpaceToView(self.tutoriumInfoView.liveTimeLabel, 20);
    [self.tutoriumInfoView.taget updateLayout];
    
    UILabel *replay = [[UILabel alloc]init];
    replay.text = @"回放说明";
    replay.font = TITLEFONTSIZE;
    [self.tutoriumInfoView.view1 addSubview:replay];
    
    replay.sd_layout
    .leftEqualToView(self.tutoriumInfoView.afterLabel)
    .topSpaceToView(self.tutoriumInfoView.afterLabel,20)
    .autoHeightRatio(0);
    [replay setSingleLineAutoResizeWithMaxWidth:100];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 5;
    NSDictionary *attribute = @{NSFontAttributeName:TEXT_FONTSIZE,
                                NSParagraphStyleAttributeName:style};
    UILabel *replayLabel = [[UILabel alloc]init];
     [self.tutoriumInfoView.view1 addSubview:replayLabel];
    replayLabel.font = TEXT_FONTSIZE;
    replayLabel.textColor = TITLECOLOR;
    replayLabel.textAlignment = NSTextAlignmentLeft;
    replayLabel.isAttributedContent = YES;
    replayLabel.attributedText = [[NSMutableAttributedString alloc]initWithString:@"1、购买课程后方可观看回放；\n2、专属课课程回放暂无任何观看限制，学生可任意观看；\n3、直播结束后最晚于24小时内上传回放；\n4、回放内容不完全等于直播内容，请尽量观看直播进行学习；\n5、回放内容仅供学生学习使用，未经允许不得进行录制。" attributes:attribute];
    replayLabel.sd_layout
    .topSpaceToView(replay,10)
    .leftEqualToView(replay)
    .rightSpaceToView(self.tutoriumInfoView.view1,20)
    .autoHeightRatio(0);
    [replayLabel updateLayout];
    self.tutoriumInfoView.replayLabel.hidden = YES;
    
    [self.tutoriumInfoView.view1 setupAutoContentSizeWithBottomView:replayLabel bottomMargin:20];
    
    //微信分享功能的回调通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sharedFinish:) name:@"SharedFinish" object:nil];
}

/**
 导航栏右侧按钮
 */
- (void)setupNavigationButton{
    
    [self.navigationBar.rightButton setImage:[UIImage imageNamed:@"moreMenu"] forState:UIControlStateNormal];
//    self.navigationBar.rightButton.hidden = YES;
    [self.navigationBar.rightButton addTarget:self action:@selector(moreMenu) forControlEvents:UIControlEventTouchUpInside];
}

- (void)makeMenu{
    NSDictionary *dict1 = @{@"imageName" : @"icon_button_affirm",
                            @"itemName" : @"进入聊天"
                            };
    NSDictionary *dict2 = @{@"imageName" : @"icon_button_recall",
                            @"itemName" : @"课程作业"
                            };
    NSDictionary *dict3 = @{@"imageName" : @"icon_button_record",
                            @"itemName" : @"全部提问"
                            };
    NSDictionary *dict4 = @{@"imageName" : @"icon_button_record",
                            @"itemName" : @"课件文件"
                            };
    NSDictionary *dict5 = @{@"imageName" : @"icon_button_record",
                            @"itemName" : @"成员列表"
                            };
    NSArray *menuArray = @[dict1,dict2,dict3,dict4,dict5];
    
    if (_isFinished == NO) {
        menuArray = @[dict1,dict2,dict3,dict4,dict5];
    }else{
        menuArray = @[dict2,dict3,dict4,dict5];
    }
    
    __weak __typeof(&*self)weakSelf = self;
    /**
     *  创建普通的MenuView，frame可以传递空值，宽度默认120，高度自适应
     */
    [CommonMenuView createMenuWithFrame:CGRectZero target:self dataArray:menuArray itemsClickBlock:^(NSString *str, NSInteger tag) {
        [weakSelf doSomething:(NSString *)str tag:(NSInteger)tag]; // do something
    } backViewTap:^{
        weakSelf.navigationBar.rightButton .selected = NO;; // 这里的目的是，让rightButton点击，可再次pop出menu
    }];
}
/** 更多菜单 */
- (void)moreMenu{
    
    [self popMenu:CGPointMake(self.navigationBar.rightButton.centerX_sd,self.navigationBar.bottom_sd)];
}
- (void)popMenu:(CGPoint)point{
    if (self.navigationBar.rightButton.selected == NO) {
        [CommonMenuView showMenuAtPoint:point];
        self.navigationBar.rightButton.selected = YES;
    }else{
        [CommonMenuView hidden];
        self.navigationBar.rightButton.selected = NO;
    }
}

#pragma mark -- 专属菜单点击 回调事件(自定义)
- (void)doSomething:(NSString *)str tag:(NSInteger)tag{
    
    __block UIViewController *controller ;
    
    if (_isFinished == YES) {
        switch (tag) {
            case 1:{
                controller = [[ExclusiveHomeworkViewController alloc]initWithClassID:self.classID];
            }
                break;
            case 2:{
                controller = [[ExclusiveAskViewController alloc]initWithClassID:self.classID];
            }
                break;
            case 3:{
                controller = [[ExclusiveCoursewareViewController alloc]initWithClassID:self.classID];
            }
                break;
            case 4:{
                controller = [[ClassMembersViewController alloc]initWithClassID:self.classID];
            }
                break;
        }
        
    }else{
        switch (tag) {
            case 1:{
                
                __block TutoriumListInfo *tutorium = [[TutoriumListInfo alloc]init];
                tutorium.classID = self.classID;
                if (_chatTeamID) {
                    tutorium.chat_team_id = _chatTeamID;
                }
                controller = [[ChatViewController alloc]initWithClass:tutorium andClassType:ExclusiveCourseType];
            }
                break;
            case 2:{
                controller = [[ExclusiveHomeworkViewController alloc]initWithClassID:self.classID];
            }
                break;
            case 3:{
                controller = [[ExclusiveAskViewController alloc]initWithClassID:self.classID];
            }
                break;
            case 4:{
                controller = [[ExclusiveCoursewareViewController alloc]initWithClassID:self.classID];
            }
                break;
            case 5:{
                controller = [[ClassMembersViewController alloc]initWithClassID:self.classID];
            }
                break;
        }
    }
    
    self.navigationBar.rightButton.selected = NO;
    [self.navigationController pushViewController:controller animated:YES];
    
    [CommonMenuView hidden];
}

//重写父类方法
/** 根据初始化传值进来的id 进行网络请求*/
- (void)requestClassesInfoWith:(NSString *)classid{
    
    [self HUDStartWithTitle:nil];
    self.buyBar.applyButton.hidden = NO;
    self.buyBar.listenButton.hidden = YES;
    self.buyBar.applyButton.sd_layout
    .leftSpaceToView(self.buyBar, 10);
    [self.buyBar.applyButton updateLayout];
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/customized_groups/%@/detail",Request_Header,self.classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
        
        /* 拿到数据字典*/
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        [self loginStates:dic];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            _dataDic = dic[@"data"][@"customized_group"];
            
            _model = [ExclusiveInfo yy_modelWithJSON:dic[@"data"][@"customized_group"]];
            _model.classID = dic[@"data"][@"customized_group"][@"id"];
            _model.descriptions = dic[@"data"][@"customized_group"][@"description"];
            
            self.classID = dic[@"data"][@"customized_group"][@"id"];
            
            self.tutoriumInfoView.exclusiveModel = _model;
//            self.tutoriumInfoView.classFeature.hidden = YES;
            self.navigationBar.titleLabel.text = _model.name;
            if ([_model.status isEqualToString:@"finished"]||[_model.status isEqualToString:@"billing"]||[_model.status isEqualToString:@"completed"]){
                //如果课程已结束,buybar不显示.什么都不显示了
                if (self.buyBar) {
                    self.buyBar.hidden = YES;
                    self.tutoriumInfoView.frame = CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd-Navigation_Height);
                }
            }
            
            //线上课
            for (NSDictionary *lesson in dic[@"data"][@"customized_group"][@"scheduled_lessons"]) {
                ExclusiveLesson *mod = [ExclusiveLesson yy_modelWithJSON:lesson];
                mod.lessonId = lesson[@"id"];
                mod.isOfflineClass = NO;
                [_onlineClassArray addObject:mod];
            }
            //线下课
            for (NSDictionary *lesson in dic[@"data"][@"customized_group"][@"offline_lessons"]) {
                ExclusiveLesson *mod = [ExclusiveLesson yy_modelWithJSON:lesson];
                mod.lessonId = lesson[@"id"];
                mod.isOfflineClass = YES;
                [_offlineClassArray addObject:mod];
            }
            
            [self.tutoriumInfoView.classesListTableView cyl_reloadData];
            
            [self switchClassData:dic];
            
            //给视图赋值tag的内容
            if (self.classModel.tag_list.count!=0) {
                [self.tutoriumInfoView.classTagsView addTags:self.classModel.tag_list withConfig:self.config];
            }else{
                self.config.tagBorderColor = [UIColor whiteColor];
                self.config.tagTextColor = TITLECOLOR;
                [self.tutoriumInfoView.classTagsView addTag:@"无" withConfig:self.config];
            }
            
            //课程特色
            for (NSString *key in _dataDic[@"icons"]) {
                if (![key isEqualToString:@"cheap_moment"]) {
                    if ([_dataDic[@"icons"][key]boolValue]==YES) {
                        Features *mod = [[Features alloc]init];
                        mod.include = [_dataDic[@"icons"][key] boolValue];
                        mod.content = key;
                        [self.classFeaturesArray addObject:mod];
                    }
                }
            }
            
            [self.tutoriumInfoView.classFeature reloadData];
            
            if (self.classFeaturesArray.count>3) {
                self.tutoriumInfoView.classFeature.sd_resetLayout
                .leftSpaceToView(self.tutoriumInfoView, 0)
                .rightSpaceToView(self.tutoriumInfoView, 0)
                .topSpaceToView(self.tutoriumInfoView.status, 10)
                .heightIs(40);
                [self.tutoriumInfoView.classFeature updateLayout];
                [self.tutoriumInfoView.classFeature layoutIfNeeded];
            }else{
                self.tutoriumInfoView.classFeature.sd_resetLayout
                .leftSpaceToView(self.tutoriumInfoView, 0)
                .rightSpaceToView(self.tutoriumInfoView, 0)
                .topSpaceToView(self.tutoriumInfoView.status, 10)
                .heightIs(40);
                [self.tutoriumInfoView.classFeature updateLayout];
                [self.tutoriumInfoView.classFeature layoutIfNeeded];
            }
            
            self.tutoriumInfoView.classFeature.sd_layout
            .heightIs(self.tutoriumInfoView.classFeature.contentSize.height);
            [self.tutoriumInfoView.classFeature updateLayout];
            [self HUDStopWithTitle:nil];
            
            
        }
        
    } failure:^(id  _Nullable erros) {
        
    }];
}

-(void)switchClassData:(NSDictionary *)dic{
    //限制人数大于报名人数
    if ([dic[@"data"][@"customized_group"][@"max_users"] integerValue]>[dic[@"data"][
        @"customized_group"][@"users_count"]integerValue]) {
        
        if ([dic[@"data"][@"customized_group"][@"sell_type"]isEqualToString:@"charge"]) {//非免费课
            if (dic[@"data"][@"ticket"]) {//已试听过或已购买过
                //如果课程未结束
                if (![dic[@"data"][@"customized_group"][@"status"]isEqualToString:@"completed"]) {
                    if (dic[@"data"][@"ticket"][@"type"]) {
                        if ([dic[@"data"][@"ticket"][@"type"]isEqualToString:@"LiveStudio::BuyTicket"]) {//已购买,显示开始学习按钮
                            self.buyBar.hidden = NO;
                            self.isBought = YES;
                            /* 已经购买的情况下*/
                            self.buyBar.applyButton.hidden = YES;
                            self.buyBar.listenButton.hidden = NO;
//                            [self.buyBar.listenButton sd_clearAutoLayoutSettings];
                            self.buyBar.listenButton.sd_resetLayout
                            .topSpaceToView(self.buyBar,10*ScrenScale)
                            .bottomSpaceToView(self.buyBar,10*ScrenScale)
                            .rightSpaceToView(self.buyBar,10*ScrenScale)
                            .widthIs(_buttonWidth);
                            [self.buyBar.listenButton updateLayout];
                            [self.buyBar.listenButton setTitle:@"开始学习" forState:UIControlStateNormal];
                            self.buyBar.listenButton.backgroundColor = NAVIGATIONRED;
                            [self.buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                            [self.buyBar.listenButton addTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
                        }else{//未购买,显示进入试听按钮 购买按钮照常使用
                            self.isBought = NO;
                            self.buyBar.hidden = NO;
                            [self.buyBar.applyButton removeAllTargets];
                            [self.buyBar.applyButton addTarget:self action:@selector(buyClass) forControlEvents:UIControlEventTouchUpInside];
                            if ([dic[@"data"][@"ticket"][@"used_count"] integerValue] >= [dic[@"data"][@"ticket"][@"buy_count"]integerValue] ) {
                                //试听结束,显示试听结束按钮
                                /* 不可以试听*/
                                [self.buyBar.listenButton setTitle:@"试听结束" forState:UIControlStateNormal];
                                [self.buyBar.listenButton setBackgroundColor:[UIColor colorWithRed:0.84 green:0.47 blue:0.44 alpha:1.0]];
                                [self.buyBar.listenButton removeTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
                                self.buyBar.listenButton.enabled = NO;
                            }else{
                                [self.buyBar.listenButton setTitle:@"进入试听" forState:UIControlStateNormal];
                                [self.buyBar.listenButton setBackgroundColor:NAVIGATIONRED];
                                [self.buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                [self.buyBar.listenButton addTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
                            }
                        }
                    }
                    _isFinished = NO;
                    self.navigationBar.rightButton.hidden = NO;
                }else{//课程已经结束了
                    //整个购买栏直接隐藏吧
                    self.buyBar.hidden = YES;
                    _isFinished = YES;
                    self.navigationBar.rightButton.hidden = NO;
                    self.tutoriumInfoView.sd_layout
                    .bottomSpaceToView(self.view, 0);
                    [self.tutoriumInfoView updateLayout];
                }
            }else{//需要加入试听或购买
                if ([dic[@"data"][@"customized_group"][@"tastable"]boolValue]==YES) {//可以加入试听
                    //显示加入试听,和立即购买两个按钮
                    self.buyBar.hidden = NO;
                    self.buyBar.hidden = NO;
                    self.buyBar.listenButton.hidden = NO;
                    [self.buyBar.listenButton removeAllTargets];
                    [self.buyBar.listenButton setTitle:@"加入试听" forState:UIControlStateNormal];
                    [self.buyBar.listenButton setBackgroundColor:[UIColor whiteColor]];
                    [self.buyBar.listenButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
                    [self.buyBar.listenButton addTarget:self action:@selector(addListen) forControlEvents:UIControlEventTouchUpInside];
                    self.buyBar.applyButton.hidden = NO;
                    [self.buyBar.applyButton removeAllTargets];
                    [self.buyBar.applyButton setTitle:@"立即报名" forState:UIControlStateNormal];
                    [self.buyBar.applyButton setBackgroundColor:[UIColor whiteColor]];
                    [self.buyBar.applyButton setTitleColor:BUTTONRED forState:UIControlStateNormal];
                    [self.buyBar.applyButton addTarget:self action:@selector(buyClass) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    //不能试听,只能购买
                    self.buyBar.hidden = NO;
                    self.buyBar.listenButton.hidden = YES;
                    [self.buyBar.applyButton removeAllTargets];
                    self.buyBar.applyButton.sd_resetLayout
                    .topSpaceToView(self.buyBar,10*ScrenScale)
                    .bottomSpaceToView(self.buyBar,10*ScrenScale)
                    .rightSpaceToView(self.buyBar,10*ScrenScale)
                    .widthIs(_buttonWidth);
                    [self.buyBar.applyButton updateLayout];
                    [self.buyBar.applyButton addTarget:self action:@selector(buyClass) forControlEvents:UIControlEventTouchUpInside];
                }
                
            }
            if ([dic[@"data"][@"customized_group"][@"off_shelve"]boolValue]==YES) {//已下架
                //已经下架
                self.buyBar.hidden = YES;
                self.tutoriumInfoView.priceLabel.text = @"已下架";
                _isFinished = YES;
                self.tutoriumInfoView.sd_layout
                .bottomSpaceToView(self.view, 0);
                [self.tutoriumInfoView updateLayout];
            }
            
        }else if ([dic[@"data"][@"customized_group"][@"sell_type"]isEqualToString:@"free"]){//免费课
            //免费呀
            
            self.tutoriumInfoView.priceLabel.text = @"免费";
            
            if (dic[@"data"][@"ticket"]) {//买过
                if (![dic[@"data"][@"ticket"]isEqual:[NSNull null]]) {//已购买(已加入到我的视频课列表里了)
                    self.buyBar.hidden = NO;
                    self.isBought = YES;
                    if (![dic[@"data"][@"customized_group"][@"status"]isEqualToString:@"completed"]) {
                        //课程没结束又购买了
                        //可以直接进入学习
                        self.buyBar.applyButton.hidden = YES;
                        self.buyBar.listenButton.hidden = NO;
                        [self.buyBar.listenButton removeAllTargets];
                        self.buyBar.listenButton.sd_resetLayout
                        .topSpaceToView(self.buyBar,10*ScrenScale)
                        .bottomSpaceToView(self.buyBar,10*ScrenScale)
                        .rightSpaceToView(self.buyBar,10*ScrenScale)
                        .widthIs(_buttonWidth);
                        [self.buyBar.listenButton updateLayout];
                        [self.buyBar.listenButton setTitle:@"开始学习" forState:UIControlStateNormal];
                        self.buyBar.listenButton.backgroundColor = NAVIGATIONRED;
                        [self.buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [self.buyBar.listenButton addTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
                        
                    }else{
                        //课程已经结束了,干掉购买蓝
                        self.buyBar.hidden = YES;
                        self.tutoriumInfoView.sd_layout
                        .bottomSpaceToView(self.view, 0);
                        [self.tutoriumInfoView updateLayout];
                    }
                    
                }else{
                    self.isBought  = NO;
                    //未购买,立即报名 报完名变成进入学习 未曾拥有过不隐藏购买栏,只是提示下架而已
                    if ([dic[@"data"][@"customized_group"][@"off_shelve"]boolValue]==YES) {
                        //已经下架
                        self.buyBar.hidden = YES;
                        self.tutoriumInfoView.priceLabel.text = @"已下架";
                        self.tutoriumInfoView.sd_layout
                        .bottomSpaceToView(self.view, 0);
                        [self.tutoriumInfoView updateLayout];
                    }else{
                        //如果没下架
                        self.buyBar.hidden = NO;
                        self.buyBar.listenButton.hidden = YES;
                        self.buyBar.applyButton.sd_resetLayout
                        .topSpaceToView(self.buyBar,10*ScrenScale)
                        .bottomSpaceToView(self.buyBar,10*ScrenScale)
                        .rightSpaceToView(self.buyBar,10*ScrenScale)
                        .widthIs(_buttonWidth);
                        [self.buyBar.applyButton updateLayout];
                        [self.buyBar.applyButton removeAllTargets];
                        [self.buyBar.applyButton addTarget:self action:@selector(addFreeClass) forControlEvents:UIControlEventTouchUpInside];
                    }
                    
                }
            }else{
                self.isBought  = NO;
                //未购买,立即报名 报完名变成进入学习 未曾拥有过不隐藏购买栏,只是提示下架而已
                if ([dic[@"data"][@"customized_group"][@"off_shelve"]boolValue]==YES) {
                    //已经下架
                    self.buyBar.hidden = NO;
                    [self.buyBar.listenButton removeAllTargets];
                    self.buyBar.applyButton.hidden = YES;
                    [self.buyBar.listenButton setTitle:@"已下架" forState:UIControlStateNormal];
                    [self.buyBar.listenButton setBackgroundColor:TITLECOLOR];
                    [self.buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    self.buyBar.listenButton.sd_resetLayout
                    .topSpaceToView(self.buyBar,10*ScrenScale)
                    .bottomSpaceToView(self.buyBar,10*ScrenScale)
                    .rightSpaceToView(self.buyBar,10*ScrenScale)
                    .widthIs(_buttonWidth);
                    [self.buyBar.listenButton updateLayout];
                }else{
                    self.buyBar.hidden = NO;
                    self.buyBar.listenButton.hidden = YES;
                    self.buyBar.applyButton.sd_resetLayout
                    .topSpaceToView(self.buyBar,10*ScrenScale)
                    .bottomSpaceToView(self.buyBar,10*ScrenScale)
                    .rightSpaceToView(self.buyBar,10*ScrenScale)
                    .widthIs(_buttonWidth);
                    [self.buyBar.applyButton updateLayout];
                    [self.buyBar.applyButton removeAllTargets];
                    [self.buyBar.applyButton addTarget:self action:@selector(addFreeClass) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
    }else{
        self.buyBar.hidden = NO;
        self.buyBar.listenButton.sd_layout
        .topSpaceToView(self.buyBar,10*ScrenScale)
        .bottomSpaceToView(self.buyBar,10*ScrenScale)
        .rightSpaceToView(self.buyBar,10*ScrenScale)
        .widthIs(_buttonWidth);
        [self.buyBar.listenButton updateLayout];
        [self.buyBar.listenButton setBackgroundColor:TITLECOLOR];
        [self.buyBar.listenButton removeAllTargets];
        [self.buyBar.listenButton setTitle:@"已报满" forState:UIControlStateNormal];
        [self.buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    //显示更多按钮啊
    if (self.isBought == YES) {
        self.navigationBar.rightButton.hidden = NO;
    }
}

- (void)listen{
    
    [self HUDStartWithTitle:nil];
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/customized_groups/%@/play",Request_Header,self.classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
        
        [self HUDStopWithTitle:nil];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            if (![[dic[@"data"][@"customized_group"][@"chat_team"]description]isEqualToString:@"0(NSNull)"]) {
                if (dic[@"data"][@"customized_group"][@"chat_team"][@"team_id"]) {
                    self.chatTeamID = dic[@"data"][@"customized_group"][@"chat_team"][@"team_id"];
                }
            }
            ExclusivePlayerViewController *controller = [[ExclusivePlayerViewController alloc]initWithClassID:self.classID andChatTeamID:self.chatTeamID andBoardAddress:dic[@"data"][@"customized_group"][@"board_pull_stream"] andTeacherAddress:dic[@"data"][@"customized_group"][@"camera_pull_stream"]];
            [self.navigationController pushViewController:controller animated:YES];

        }else{
            [self HUDStopWithTitle:@"请稍后重试"];
        }
        
    } failure:^(id  _Nullable erros) {
        [self HUDStopWithTitle:nil];
        [self HUDStopWithTitle:@"请稍后重试"];
    }];
    
}

- (void)buyClass{
    
    if (_dataDic) {
        
        if (![_dataDic[@"status"] isEqualToString:@"completed"]&&![_dataDic[@"status"] isEqualToString:@"finished"]&&![_dataDic[@"status"] isEqualToString:@"billing"]) {
            
            //砍掉
            if ([_dataDic[@"status"] isEqualToString:@"teaching"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该辅导已开课,是否继续购买?" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }] ;
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self requestOrder];
                }] ;
                
                [alert addAction:cancel];
                [alert addAction:sure];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }else{
                [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"是否确定购买该课程?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                    if (buttonIndex!=0) {
                        [self requestOrder];
                    }
                    
                }];
            }
        }else{
            
            [self HUDStopWithTitle:@"当前课程不支持购买"];
            
        }
        
    }
}
#pragma mark- tableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    NSInteger row;
    
    if (tableView.tag == 1) {
        if (section == 0 ) {
            row = _onlineClassArray.count;
        }else{
            row = _offlineClassArray.count;
        }
    }else {
        
        row = _newWorkFlowArr.count;
    }
    
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableCell;
    
    if (tableView.tag == 1) {
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
                    
                    if (self.isBought == YES) {
                        if (cell.exclusiveModel.replayable == YES) {
                            cell.status.text = @"观看回放";
                            cell.status.textColor = BUTTONRED;
                        }else{
                            [cell switchStatus:cell.exclusiveModel];
                        }
                        
                    }else{
                       [cell switchStatus:cell.exclusiveModel];
                    }
                }
            }
            tableCell = cell;
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
            
            tableCell = cell;
        }
    }else{
        
        
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"tablecell";
        WorkFlowTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[WorkFlowTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"tablecell"];
        }
        
        if (self.workFlowArr.count>indexPath.row) {
            [cell.image setImage:[UIImage imageNamed:self.workFlowArr[indexPath.row][@"image"]]];
            cell.title.text = _newWorkFlowArr[indexPath.row][@"title"];
            cell.subTitle.text = _newWorkFlowArr[indexPath.row][@"subTitle"];
        }
        
        return  cell;

    }
    
    return  tableCell;
    
}

/* 点击课程表,进入回放的点击事件*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1) {
        if (indexPath.section == 0) {
          ClassesListTableViewCell *cell = (ClassesListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            if (self.isBought ==YES) {
                if (cell.exclusiveModel.replayable == YES) {
                    //专属课回放详情
                    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/scheduled_lessons/%@/replay",Request_Header,cell.exclusiveModel.lessonId] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
                        
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
                        
                        if ([dic[@"status"]isEqualToNumber:@1]) {
                            
                            if ([dic[@"data"][@"replayable"]boolValue]== YES) {
                                if (dic[@"data"][@"replay"]==nil) {
                                    
                                }else{
                                    NSMutableArray *decodeParm = [[NSMutableArray alloc] init];
                                    [decodeParm addObject:@"software"];
                                    [decodeParm addObject:@"videoOnDemand"];
                                    
                                    VideoPlayerViewController *video  = [[VideoPlayerViewController alloc]initWithURL:[NSURL URLWithString:dic[@"data"][@"replay"][@"orig_url"]] andDecodeParm:decodeParm andTitle:dic[@"data"][@"name"]];
//                                    VideoPlayerViewController *video = [[VideoPlayerViewController alloc]initWithURL:[NSURL URLWithString:dic[@"data"][@"replay"][@"orig_url"]] andDecodeParm:decodeParm];
                                    [self presentViewController:video animated:YES completion:^{
                                        
                                    }];
                                }
                                
                            }else{
                              [self HUDStopWithTitle:@"服务器繁忙"];
                            }
                            
                        }else{
                            [self HUDStopWithTitle:@"暂无回放视频"];
                        }
                        
                    }failure:^(id  _Nullable erros) {
                        
                    }];
                }else{
                    
                    
                }
                
                
            }else{
                
            }
        }
        
    }
}

#pragma mark- UITableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView.tag == 1) {
        if (_offlineClassArray.count>0) {
            return 2;
        }else{
            return 1;
        }
        
    }else{
        return 1;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        
        if (section == 0){
            return @"线上直播";
        }else{
            return @"线下讲课";
        }
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0;
    if (tableView.tag == 1) {
        
        if (indexPath.section == 0) {
            if (_onlineClassArray.count>indexPath.row) {
                
                height = [tableView cellHeightForIndexPath:indexPath model:_onlineClassArray[indexPath.row] keyPath:@"exclusiveModel" cellClass:[ClassesListTableViewCell class] contentViewWidth:self.view.width_sd];
            }
        }else{
            if (_offlineClassArray.count>indexPath.row) {
                height = [tableView cellHeightForIndexPath:indexPath model:_offlineClassArray[indexPath.row] keyPath:@"model" cellClass:[ExclusiveOfflineClassTableViewCell class] contentViewWidth:self.view.width_sd];
            }
        }
    }else{
        height = (self.view.width_sd-100*ScrenScale)/4.0;
    }
    return height;
    
}

- (UIView *)makePlaceHolderView{
    HaveNoClassView *view = [[HaveNoClassView alloc]initWithTitle:@"暂无数据"];
    return view;
}

- (BOOL)enableScrollWhenPlaceHolderViewShowing{
    return YES;
}


#pragma mark- UICollectionView datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  
    return self.classFeaturesArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"CollectionCell";
    TeacherFeatureTagCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (self.classFeaturesArray.count>indexPath.row) {
        
        cell.model = self.classFeaturesArray[indexPath.row];
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

/** 请求chatteamid */
- (void)requestChatTeam{
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/customized_groups/%@/play",Request_Header,self.classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil withProgress:^(NSProgress * _Nullable progress) {
    } completeSuccess:^(id  _Nullable responds) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            _chatTeamID = [NSString stringWithFormat:@"%@", dic[@"data"][@"customized_group"][@"chat_team"][@"team_id"]];
        }else{
            
        }
    } failure:^(id  _Nullable erros) {
        
    }];
    
}

#pragma mark- 收集订单信息,并传入下一页,开始提交订单
- (void)requestOrder{
    
    OrderViewController *orderVC;
    if (self.promotionCode) {
        orderVC = [[OrderViewController alloc]initWithClassID:self.classID andPromotionCode:self.promotionCode andClassType:ExclusiveType andProductName:_dataDic[@"name"]];
    }else{
        
        orderVC= [[OrderViewController alloc]initWithClassID:self.classID andClassType:ExclusiveType andProductName:_dataDic[@"name"]];
    }
    
    [self.navigationController pushViewController:orderVC animated:YES];
    
}


/**
 购买免费专属课
 */
- (void)addFreeClass{
    
}


/** 分享功能 */
- (void)share{
    _share = [[ShareViewController alloc]init];
    _share.view.frame = CGRectMake(0, 0, self.view.width_sd, TabBar_Height*1.5);
    _pops = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackTranslucent aView:_share.view];
    _pops.presentationStyle = PresentationStyleBottom;
    [_pops presentWithAnimated:YES completion:^(BOOL finished, SnailQuickMaskPopups * _Nonnull popups) {}];
    [_share.sharedView.wechatBtn addTarget:self action:@selector(wechatShare:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)wechatShare:(UIButton *)sender{
    [_pops dismissWithAnimated:YES completion:^(BOOL finished, SnailQuickMaskPopups * _Nonnull popups) {
    }];
    if (![WXApi isWXAppInstalled]) {
        [self HUDStopWithTitle:@"您尚未安装微信"];
        return;
    }
    //在这儿传个参数.
    [_share sharedWithContentDic:@{
                                   @"type":@"link",
                                   @"content":@{
                                           @"title":_model.name,
                                           @"description":@"专属课程",
                                           @"link":[NSString stringWithFormat:@"%@/live_studio/customized_groups/%@",Request_Header,self.classID]
                                           }
                                   }];
    
}

- (void)sharedFinish:(NSNotification *)notification{
    SendMessageToWXResp *resp = [notification object];
    if (resp.errCode == 0) {
        [self HUDStopWithTitle:@"分享成功"];
    }else if (resp.errCode == -1){
        [self HUDStopWithTitle:@"分享失败"];
    }else if (resp.errCode == -2){
        [self HUDStopWithTitle:@"取消分享"];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
