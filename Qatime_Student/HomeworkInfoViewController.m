//
//  HomeworkInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "HomeworkInfoViewController.h"
#import "NavigationBar.h"
#import "UIViewController+ReturnLastPage.h"
#import "NSString+TimeStamp.h"
#import "NetWorkTool.h"
#import "DoHomeworkViewController.h"
#import "Qatime_Student-Swift.h"


@interface HomeworkInfoViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NavigationBar *_naviBar;
    
    HomeworkManage *_homework;
    
    NSMutableArray *_itemsArray;
    
}

@property (nonatomic, strong) QuestionSubTitle * subtitle ;

@end

@implementation HomeworkInfoViewController

-(instancetype)initWithHomework:(HomeworkManage *)homework{
    self = [super init];
    if (self) {
        _homework = homework;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeData];
    
    [self setupView];
    
}

- (void)makeData{
    
    _itemsArray = @[].mutableCopy;
    //原始作业
    NSArray *homeworkArr = _homework.homework.items;
    //提交过得作业
    NSArray *submitArr = _homework.items;
    //批改过的作业
    NSArray *resolveArr = _homework.correction[@"items"];
    
    //一个保存了做过的作业的parentid的集合
    NSMutableArray *paretSet =[[NSMutableArray alloc]init];
    NSMutableArray *resolveSet = [[NSMutableArray alloc]init];
    //写过的作业
    if (submitArr) {
        for (NSDictionary *sub in submitArr) {
            [paretSet addObject:[NSString stringWithFormat:@"%@",sub[@"parent_id"]]];
        }
    }
    //批改过的作业
    if (resolveArr) {
        for (NSDictionary *resolve in resolveArr) {
            [resolveSet addObject:[NSString stringWithFormat:@"%@",resolve[@"parent_id"]]];
        }
    }
    //先把原始的作业信息拿出来 然后对比出来答案 然后加进去
    for (NSDictionary *item in homeworkArr) {
        HomeworkInfo *mod = [HomeworkInfo yy_modelWithJSON:item];
        mod.homeworkID = item[@"id"];
        if ([paretSet containsObject:[NSString stringWithFormat:@"%@",mod.homeworkID]]) {
            mod.status = @"submitted";
            for (NSDictionary *anser in submitArr) {
                if ([[NSString stringWithFormat:@"%@",mod.homeworkID]isEqualToString:[NSString stringWithFormat:@"%@",anser[@"parent_id"]]]) {
                    //这是答案的anser
                    mod.myAnswerTitle = anser[@"body"];
                    mod.answers = anser;
                }
            }
        }else{
            mod.status = @"pending";
        }
       
        [_itemsArray addObject:mod];
    }
    
    if (resolveArr) {
        for (NSDictionary *reso in resolveArr) {
            for (NSDictionary *ans in submitArr) {
                if ([[NSString stringWithFormat:@"%@",reso[@"parent_id"]] isEqualToString:[NSString stringWithFormat:@"%@",ans[@"id"]]]) {
                    //这就是批改对应上答案了 ans的parent_id 就是作业的id
                    for (HomeworkInfo *mod in _itemsArray) {
                        if ([[NSString stringWithFormat:@"%@",mod.homeworkID] isEqualToString:[NSString stringWithFormat:@"%@",ans[@"parent_id"]]]) {
                            mod.correction = reso[@"body"];
                            mod.status = @"resolved";
                        }
                    }
                }
            }
        }
    }
}

- (void)setupView{
    
    _naviBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_naviBar];
    [_naviBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    _naviBar.titleLabel.text = @"作业详情";
    [_naviBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    [_naviBar.rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [_naviBar.rightButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    
    _naviBar.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .heightIs(Navigation_Height);
    
    _mainView = [[HomeworkInfoView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(_naviBar, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
    _mainView.homeworkList.dataSource = self;
    _mainView.homeworkList.delegate = self;
    
    _mainView.subtitle.title.text = _homework.title;
    _mainView.subtitle.creat_at .text =[_homework.created_at changeTimeStampToDateString];
    [_mainView updateLayout];
    [_mainView.homeworkList updateLayout];
    
}

#pragma mark- tablview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _itemsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    HomeworkInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[HomeworkInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    cell.index.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    if (_itemsArray.count>indexPath.row) {
        cell.model = _itemsArray[indexPath.row];
    }
    
    return  cell;
}


#pragma mark- tablview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView cellHeightForIndexPath:indexPath model:_itemsArray[indexPath.row] keyPath:@"model" cellClass:[HomeworkInfoTableViewCell class] contentViewWidth:self.view.width_sd];
//    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __block HomeworkInfoTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    typeof(self) __weak weakSelf = self;
    if ([cell.model.status isEqualToString:@"pending"]) {
        //做作业
        //如果没做过作业,就直接进去做,做过了还可以改
        DoHomeworkViewController *controller = [[DoHomeworkViewController alloc]initWithHomework:cell.model];
        [self.navigationController pushViewController:controller animated:YES];
        
        controller.doHomework = ^(NSString *answer) {
            cell.model.myAnswerTitle = answer;
            cell.model.edited = YES;
            [weakSelf.mainView.homeworkList reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        
    }
}

/**  提交作业 */
- (void)submit{
    
//    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setValue:[self getToken] forHTTPHeaderField:@"Remember-Token"];
//    [manager.requestSerializer multipartFormRequestWithMethod:@"PATCH" URLString:[NSString stringWithFormat:@"%@/api/v1/live_studio/student_homeworks/%@",Request_Header,_homework.homeworkID] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        //制造数组
//        NSMutableArray *works = @[].mutableCopy;
//        for (HomeworkInfo *infos in _itemsArray) {
//            if (infos.myAnswerTitle) {
//                [works addObject:@{@"parend_id":_homework.parent_id,@"body":infos.myAnswerTitle}];
//            }
//        }
//
//        [formData appendPartWithFormData:[NSJSONSerialization dataWithJSONObject:works options:NSJSONWritingPrettyPrinted error:nil] name:@"task_items_attributes"];
//
//    } error:nil];
//    id<AFMultipartFormData> formData ;
//    NSMutableArray *works = @[].mutableCopy;
//    for (HomeworkInfo *infos in _itemsArray) {
//        if (infos.myAnswerTitle) {
//            [works addObject:@{@"parend_id":_homework.parent_id,@"body":infos.myAnswerTitle}];
//        }
//    }
    
//    [formData appendPartWithFormData:[NSJSONSerialization dataWithJSONObject:works options:NSJSONWritingPrettyPrinted error:nil] name:@"task_items_attributes"];
    
//    [manager PATCH:[NSString stringWithFormat:@"%@/api/v1/live_studio/student_homeworks/%@",Request_Header,_homework.homeworkID] parameters:@{@"task_items_attributes":[NSJSONSerialization dataWithJSONObject:works options:NSJSONWritingPrettyPrinted error:nil]} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        if (dic[@"status"]) {
//
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
//
    //手动上传吧
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"PATCH" URLString:[NSString stringWithFormat:@"%@/api/v1/live_studio/student_homeworks/%@",Request_Header,_homework.homeworkID] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSMutableArray *works = @[].mutableCopy;
        for (HomeworkInfo *infos in _itemsArray) {
            if (infos.myAnswerTitle) {
            }else{
                infos.myAnswerTitle = @" ";
            }
            [works addObject:@{@"parent_id":infos.homeworkID,@"body":infos.myAnswerTitle}];
        }
        [formData appendPartWithFormData:[NSJSONSerialization dataWithJSONObject:works options:NSJSONWritingPrettyPrinted error:nil] name:@"task_items_attributes"];
    } error:nil];
    
    [request addValue:[self getToken] forHTTPHeaderField:@"Remember-Token"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:15];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {} completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        NSDictionary *dics = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([dics[@"status"]isEqualToNumber:@1]) {
          //提交成功过了
            [self HUDStopWithTitle:@"提交成功"];
            [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"HomeworkDone" object:nil];
        }

    }];
    
     [uploadTask resume];
  
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
