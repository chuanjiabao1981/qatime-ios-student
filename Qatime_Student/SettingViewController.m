//
//  SettingViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/29.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "SettingViewController.h"
#import "NIMSDK.h"
#import "SettingTableViewCell.h"
#import "NavigationBar.h"
#import "UIViewController_HUD.h"
#import "UIViewController+HUD.h"

#import "FileService.h"
#import "AboutUsViewController.h"
#import "NoticeSettingViewController.h"

#import "NELivePlayerViewController.h"

#define SCREENWIDTH self.view.frame.size.width
#define SCREENHEIGHT self.view.frame.size.height

@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    NSArray *menus;
    NavigationBar *_navigationBar;
    
   
    
    
    /* 版本*/
    NSString *_version;
    
    /* 缓存大小*/
    float cache;
    
    /* 余额*/
    NSString *_balance;
    
    
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navigationBar = ({
    
        NavigationBar *_ = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
        [_.leftButton setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
        _.titleLabel.text = @"系统设置";
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_];
        
        
        _;
    
    });
    

  
   
    
    
    
    menus = @[@"学习流程",@"提醒设置",@"检查更新",@"清理缓存",@"关于我们"];
    
    _settingView = [[SettingView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT)];
    [self.view addSubview:_settingView];
    [_settingView.logOutButton addTarget:self action:@selector(userLogOut) forControlEvents:UIControlEventTouchUpInside];
    
    _settingView.menuTableView.delegate = self;
    _settingView.menuTableView.dataSource = self;
    _settingView.menuTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    _settingView.menuTableView.tableFooterView = [[UIView alloc]init];
    
    /* 获取当前软件版本*/
    
    _version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    
//     NSString *FilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"<#File Path#>"];
    
    /* 获取缓存数据*/
    
    [self getCacheSpace];
    
    
    /* 测试视频按钮*/
    
    UIButton *but = [[UIButton alloc]init];
    [_settingView addSubview:but];
    but.sd_layout
    .leftSpaceToView(_settingView,40)
    .rightSpaceToView(_settingView,40)
    .bottomSpaceToView(_settingView.logOutButton,40)
    .heightIs(40);
    
    [but setTitle:@"播放视频" forState:UIControlStateNormal];
   
    [but addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}


/**
 播放视频.测试用
 */
- (void)play{
    
    NELivePlayerViewController *vc = [[NELivePlayerViewController alloc]initWithClassID:@"32"];
    
    [self.navigationController pushViewController:vc animated:YES];
}



/* 获取缓存大小*/
- (void)getCacheSpace{
    
    NSString *cacheStr = [FileService getPath];
    
   cache  = [FileService folderSizeAtPath:cacheStr];
    
}
/* 清除缓存*/
- (void)clearCache{
    
    [self loadingHUDStartLoadingWithTitle:@"正在清理"];
    NSString *cacheStr = [FileService getPath];
    [FileService clearCache:cacheStr];
    [self loadingHUDStopLoadingWithTitle:@"清理完毕!"];
    
    [self getCacheSpace];
    
    NSIndexPath *num = [NSIndexPath indexPathForRow:3 inSection:0];
    
    [_settingView.menuTableView reloadRowsAtIndexPaths:@[num] withRowAnimation:UITableViewRowAnimationFade];
    
    
    
    
}





/* 查询最新版本*/
- (void)requestVersion{
    
    __block  NSString *_newVersion;
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/system/check_update?category=student_client&platform=ios",Request_Header ] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"status"] isEqual:[NSNumber numberWithInteger:1]]) {
            
            if (![dic[@"data"] isEqual:[NSNull null]]) {
                
                /* 请求成功*/
                _newVersion  = [NSString stringWithFormat:@"%@",dic[@"data"]];
                NSLog(@"%@",_newVersion);
                
                
                /* 获取版本信息成功*/
                if ([_version isEqualToString:_newVersion]) {
                    [self loadingHUDStopLoadingWithTitle:@"已是最新版本"];
                }else{
                    
                    /* 检测到有新版的时候 弹出alert 提示是否升级*/
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"检测到新版本V %@,是否更新?",_newVersion] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    
                    [alert addAction:cancel];
                    [alert addAction:sure];
                    
                    [self presentViewController:alert animated:YES completion:^{
                        
                    }];
                    
                    
                    
                }
                
                
            }else{
                
                /* 数据错误*/
                [self loadingHUDStopLoadingWithTitle:@"数据错误"];
                
            }
            
            
        }else{
            
//            请求失败
            
            [self loadingHUDStopLoadingWithTitle:@"请求数据失败"];
            
            
            
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
    
}


#pragma mark- tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return menus.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    SettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[SettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        
        cell.sd_tableView = tableView;
        
        cell.settingName.text = menus[indexPath.row];
        
        cell.logoImage.hidden = YES;
        
        cell.settingName.sd_layout
        .leftSpaceToView(cell.contentView,20)
        .topSpaceToView(cell.contentView,10)
        .bottomSpaceToView(cell.contentView,10);
        [cell.settingName setSingleLineAutoResizeWithMaxWidth:1000];
        
        if (indexPath.row ==2) {
    
            cell.balance.hidden = NO;
            cell.balance.text  =  [NSString stringWithFormat:@"V %@",_version];
            
        }
        if (indexPath.row ==3) {
            cell.balance.hidden = NO;
            cell.balance.text = [NSString stringWithFormat:@"%.2f M",cache];
        }
        
        
    }
    
    return  cell;
    

}


#pragma mark- tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}

/* 点击事件*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    switch (indexPath.row) {
        case 0:{
            
            
        }
            break;
        case 1:{
            NoticeSettingViewController *noVC = [NoticeSettingViewController new];
            [self.navigationController pushViewController:noVC animated:YES];
            
        }
            break;
        case 2:{
            
            [self requestVersion];
        }
            break;
        case 3:{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"确定清理%.2f M的缓存?",cache] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
            }];
            UIAlertAction *sure= [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
                [self clearCache];
                
            }];
            
            [alert addAction:cancel];
            [alert addAction:sure];
            
            [self presentViewController:alert animated:YES completion:^{
                
            }];
            
            
            
            
        }
            break;
        case 4:{
            
            AboutUsViewController *abVC = [AboutUsViewController new];
            [self.navigationController pushViewController:abVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}



#pragma mark- 用户退出登录
- (void)userLogOut{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您真的确定退出？" preferredStyle:UIAlertControllerStyleAlert];
    /* 确定退出*/
    UIAlertAction *actionSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *userFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"User.data"];
        
        [[NSFileManager defaultManager]removeItemAtPath:userFilePath error:nil];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"id"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"remember_token"];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"chat_account"];
        
        
        /* 云信退出登录*/
        [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error){}];
        
        
        
        /* 发消息 给appdelegate*/
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userLogOut" object:nil];
        
    }];
    UIAlertAction *actionCancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [alert dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }];
    
    
    [alert addAction:actionCancel];
    [alert addAction:actionSure];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];

}


/* 返回上一页*/
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
