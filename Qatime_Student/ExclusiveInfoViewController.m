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

@interface ExclusiveInfoViewController (){
    
    NSDictionary *_dataDic;
}

@end

@implementation ExclusiveInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
            
            ExclusiveInfo *model = [ExclusiveInfo yy_modelWithJSON:dic[@"data"][@"customized_group"]];
            model.classID = dic[@"data"][@"customized_group"][@"id"];
            model.descriptions = dic[@"data"][@"customized_group"][@"description"];
            
            self.tutoriumInfoView.exclusiveModel = model;
            
            if ([model.status isEqualToString:@"finished"]||[model.status isEqualToString:@"billing"]||[model.status isEqualToString:@"completed"]){
                //如果课程已结束,buybar不显示.什么都不显示了
                if (self.buyBar) {
                    self.buyBar.hidden = YES;
                    self.tutoriumInfoView.frame = CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd-Navigation_Height);
                }
                
            }
            [self switchClassData:dic];
            
            //给视图赋值tag的内容
            if (self.classModel.tag_list.count!=0) {
                [self.tutoriumInfoView.classTagsView addTags:self.classModel.tag_list withConfig:self.config];
            }else{
                self.config.tagBorderColor = [UIColor whiteColor];
                self.config.tagTextColor = TITLECOLOR;
                [self.tutoriumInfoView.classTagsView addTag:@"无" withConfig:self.config];
            }
            
            if (self.classFeaturesArray.count>3) {
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
    
    if ([dic[@"data"][@"customized_group"][@"sell_type"]isEqualToString:@"charge"]) {//非免费课
        if (dic[@"data"][@"ticket"]) {//已试听过或已购买过
            //如果课程未结束
            if (![dic[@"data"][@"customized_group"][@"status"]isEqualToString:@"completed"]) {
                if (dic[@"data"][@"ticket"][@"type"]) {
                    if ([dic[@"data"][@"ticket"][@"type"]isEqualToString:@"LiveStudio::BuyTicket"]) {//已购买,显示开始学习按钮
                        self.isBought = YES;
                        /* 已经购买的情况下*/
                        self.buyBar.applyButton.hidden = YES;
                        self.buyBar.listenButton.hidden = NO;
                        [self.buyBar.listenButton sd_clearAutoLayoutSettings];
                        self.buyBar.listenButton.sd_resetLayout
                        .leftSpaceToView(self.buyBar,10)
                        .topSpaceToView(self.buyBar,10)
                        .bottomSpaceToView(self.buyBar,10)
                        .rightSpaceToView(self.buyBar,10);
                        [self.buyBar.listenButton updateLayout];
                        [self.buyBar.listenButton setTitle:@"开始学习" forState:UIControlStateNormal];
                        self.buyBar.listenButton.backgroundColor = NAVIGATIONRED;
                        [self.buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [self.buyBar.listenButton addTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
                        
                    }else{//未购买,显示进入试听按钮 购买按钮照常使用
                        
                        self.isBought = NO;
                        
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
            }else{//课程已经结束了
                //整个购买栏直接隐藏吧
                self.buyBar.hidden = YES;
            }
            
        }else{//需要加入试听或购买
            if ([dic[@"data"][@"customized_group"][@"tastable"]boolValue]==YES) {//可以加入试听
                //显示加入试听,和立即购买两个按钮
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
                self.buyBar.listenButton.hidden = YES;
                [self.buyBar.applyButton removeAllTargets];
                self.buyBar.applyButton.sd_resetLayout
                .leftSpaceToView(self.buyBar, 10)
                .rightSpaceToView(self.buyBar, 10)
                .topSpaceToView(self.buyBar, 10)
                .bottomSpaceToView(self.buyBar, 10);
                [self.buyBar.applyButton updateLayout];
                [self.buyBar.applyButton addTarget:self action:@selector(buyClass) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }
        if ([dic[@"data"][@"customized_group"][@"off_shelve"]boolValue]==YES) {//已下架
            //已经下架
            [self.buyBar.listenButton removeAllTargets];
            self.buyBar.applyButton.hidden = YES;
            [self.buyBar.listenButton setTitle:@"已下架" forState:UIControlStateNormal];
            [self.buyBar.listenButton setBackgroundColor:TITLECOLOR];
            [self.buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.buyBar.listenButton.sd_resetLayout
            .leftSpaceToView(self.buyBar, 10)
            .rightSpaceToView(self.buyBar, 10)
            .topSpaceToView(self.buyBar, 10)
            .bottomSpaceToView(self.buyBar, 10);
            [self.buyBar.listenButton updateLayout];
            
        }
        
    }else if ([dic[@"data"][@"customized_group"][@"sell_type"]isEqualToString:@"free"]){//免费课
        //免费呀
        self.tutoriumInfoView.priceLabel.text = @"免费";
        
        if (dic[@"data"][@"ticket"]) {
            if (![dic[@"data"][@"ticket"]isEqual:[NSNull null]]) {//已购买(已加入到我的视频课列表里了)
                self.isBought = YES;
                if (![dic[@"data"][@"customized_group"][@"status"]isEqualToString:@"completed"]) {
                    //课程没结束又购买了
                    //可以直接进入学习
                    self.buyBar.applyButton.hidden = YES;
                    self.buyBar.listenButton.hidden = NO;
                    [self.buyBar.listenButton removeAllTargets];
                    self.buyBar.listenButton.sd_resetLayout
                    .leftSpaceToView(self.buyBar,10)
                    .topSpaceToView(self.buyBar,10)
                    .bottomSpaceToView(self.buyBar,10)
                    .rightSpaceToView(self.buyBar,10);
                    [self.buyBar.listenButton updateLayout];
                    [self.buyBar.listenButton setTitle:@"开始学习" forState:UIControlStateNormal];
                    self.buyBar.listenButton.backgroundColor = NAVIGATIONRED;
                    [self.buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [self.buyBar.listenButton addTarget:self action:@selector(listen) forControlEvents:UIControlEventTouchUpInside];
                    
                }else{
                    //课程已经结束了,干掉购买蓝
                    self.buyBar.hidden = YES;
                }
                
            }else{
                self.isBought  = NO;
                //未购买,立即报名 报完名变成进入学习 未曾拥有过不隐藏购买栏,只是提示下架而已
                if ([dic[@"data"][@"customized_group"][@"off_shelve"]boolValue]==YES) {
                    //已经下架
                    [self.buyBar.listenButton removeAllTargets];
                    self.buyBar.applyButton.hidden = YES;
                    [self.buyBar.listenButton setTitle:@"已下架" forState:UIControlStateNormal];
                    [self.buyBar.listenButton setBackgroundColor:TITLECOLOR];
                    [self.buyBar.listenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    self.buyBar.listenButton.sd_resetLayout
                    .leftSpaceToView(self.buyBar, 10)
                    .rightSpaceToView(self.buyBar, 10)
                    .topSpaceToView(self.buyBar, 10)
                    .bottomSpaceToView(self.buyBar, 10);
                    [self.buyBar.listenButton updateLayout];
                }else{
                    
                    self.buyBar.listenButton.hidden = YES;
                    self.buyBar.applyButton.sd_resetLayout
                    .leftSpaceToView(self.buyBar, 10)
                    .rightSpaceToView(self.buyBar, 10)
                    .topSpaceToView(self.buyBar, 10)
                    .bottomSpaceToView(self.buyBar, 10);
                    [self.buyBar.applyButton removeAllTargets];
                    [self.buyBar.applyButton addTarget:self action:@selector(addFreeClass) forControlEvents:UIControlEventTouchUpInside];
                }
                
            }
        }
        
    }
    
}

- (void)listen{
    
    ExclusivePlayerViewController *controller = [[ExclusivePlayerViewController alloc]initWithClassID:self.classID andChatTeamID:self.chatTeamID];
    [self.navigationController pushViewController:controller animated:YES];
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


- (void)addFreeClass{
    
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
