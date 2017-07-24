//
//  ExclusiveInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/7/24.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ExclusiveInfoViewController.h"
#import "UIControl+RemoveTarget.h"

@interface ExclusiveInfoViewController ()

@end

@implementation ExclusiveInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//重写父类方法
-(void)switchClassData:(NSDictionary *)dic{
  
    if ([dic[@"data"][@"course"][@"sell_type"]isEqualToString:@"charge"]) {//非免费课
        if (![dic[@"data"][@"ticket"]isEqual:[NSNull null]]) {//已试听过或已购买过
            //如果课程未结束
            if (![dic[@"data"][@"course"][@"status"]isEqualToString:@"completed"]) {
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
            if ([dic[@"data"][@"course"][@"tastable"]boolValue]==YES) {//可以加入试听
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
        if ([dic[@"data"][@"course"][@"off_shelve"]boolValue]==YES) {//已下架
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
        
    }else if ([dic[@"data"][@"course"][@"sell_type"]isEqualToString:@"free"]){//免费课
        //免费呀
        self.tutoriumInfoView.priceLabel.text = @"免费";
        
        if (dic[@"data"][@"ticket"]) {
            if (![dic[@"data"][@"ticket"]isEqual:[NSNull null]]) {//已购买(已加入到我的视频课列表里了)
                self.isBought = YES;
                if (![dic[@"data"][@"course"][@"status"]isEqualToString:@"completed"]) {
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
                if ([dic[@"data"][@"course"][@"off_shelve"]boolValue]==YES) {
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
