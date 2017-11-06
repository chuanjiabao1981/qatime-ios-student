//
//  AboutUsViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/30.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "AboutUsViewController.h"
#import "ShareView.h"
#import "NavigationBar.h"
#import "SnailQuickMaskPopups.h"
#import "ShareViewController.h"
 
#import "AboutUsTableViewCell.h"
#import "UIAlertController+Blocks.h"
#import "WXApiObject.h"
#import "UIViewController+HUD.h"

@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NavigationBar *_navigationBar;
    SnailQuickMaskPopups *_pops;
    //分享控制器
    ShareViewController *_share;
    
}

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
      
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), Navigation_Height)];
    
    _navigationBar.titleLabel.text = @"关于我们";
    [self.view addSubview:_navigationBar];
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    

    _aboutUsView  = [[AboutUsView alloc]initWithFrame:CGRectMake(0, Navigation_Height, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-Navigation_Height)];
    [self.view addSubview:_aboutUsView];
   
    _aboutUsView.menuTableView.delegate = self;
    _aboutUsView.menuTableView.dataSource = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sharedFinish:) name:@"SharedFinish" object:nil];
}

#pragma mark- tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    AboutUsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[AboutUsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
        cell.imageView.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        switch (indexPath.row) {
            case 0:
                cell.name.text = @"客服电话";
                cell.context.text = ServersPhone;
                cell.context.textColor = [UIColor blueColor];
                cell.context.attributedText = [[NSAttributedString alloc]initWithString:ServersPhone attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:1],NSUnderlineColorAttributeName:[UIColor blueColor]}];
                
                break;
            case 1:
                cell.name.text = @"客服QQ";
                cell.context.text = ServerQQ;
                break;
            case 2:
                cell.name.text = @"分享应用";
                cell.context.text = @"";
                break;
            default:
                break;
        }
        
    }
    
    return  cell;
    

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row ==0) {
        
//        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"是否拨打电话0353-2135828?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
//           
//            if (buttonIndex!=0) {
        
//                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://0353-2135828"];
                
//                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
        
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",ServersPhone];
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
//        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",ServersPhone]]];
//            }
//        }];
    }
    else if (indexPath.row == 2){
        
        _share = [[ShareViewController alloc]init];
        _share.view.frame = CGRectMake(0, 0, self.view.width_sd, TabBar_Height*1.5);
        _pops = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackTranslucent aView:_share.view];
        _pops.presentationStyle = PresentationStyleBottom;
        [_pops presentWithAnimated:YES completion:^(BOOL finished, SnailQuickMaskPopups * _Nonnull popups) {}];
        [_share.sharedView.wechatBtn addTarget:self action:@selector(wechatShare:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  60;
}

- (void)wechatShare:(UIButton *)sender{
    //在这儿传个参数.
    [_share sharedWithContentDic:@{
                                   @"type":@"link",
                                   @"content":@{
                                           @"title":@"答疑时间-K12在线教育平台",
                                           @"description":@"制造互联乐享教育-答疑时间与您共筑教育梦!",
                                           @"link":Request_Header
                                           }}];
    [_pops dismissWithAnimated:YES completion:^(BOOL finished, SnailQuickMaskPopups * _Nonnull popups) {
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
