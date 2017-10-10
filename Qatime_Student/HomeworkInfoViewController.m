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
#import "QuestionPhotosCollectionViewCell.h"


@interface HomeworkInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,PhotoBrowserDelegate>{
    
    NavigationBar *_naviBar;
    
    HomeworkManage *_homework;
    
    NSMutableArray *_itemsArray;
    
    NSMutableArray *_atachmentsArray;
    
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
    
    _atachmentsArray = @[].mutableCopy;
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
        mod.attachments = item[@"attachments"];
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
    //批改
    if (resolveArr) {
        for (NSDictionary *reso in resolveArr) {
            for (NSDictionary *ans in submitArr) {
                if ([[NSString stringWithFormat:@"%@",reso[@"parent_id"]] isEqualToString:[NSString stringWithFormat:@"%@",ans[@"id"]]]) {
                    //这就是批改对应上答案了 ans的parent_id 就是作业的id
                    for (HomeworkInfo *mod in _itemsArray) {
                        if ([[NSString stringWithFormat:@"%@",mod.homeworkID] isEqualToString:[NSString stringWithFormat:@"%@",ans[@"parent_id"]]]) {
                            mod.correction = reso;
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
    [_naviBar.rightButton setupAutoSizeWithHorizontalPadding:10 buttonHeight:30];
    [_naviBar.rightButton updateLayout];
    
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
    _mainView.subtitle.creat_at .text = [@"创建时间:" stringByAppendingString:[_homework.created_at changeTimeStampToDateString]];
    [_mainView updateLayout];
    [_mainView.homeworkList updateLayout];
    
    if (_homework.items.count>0) {
        _naviBar.rightButton.hidden = YES;
    }else{
        
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;//解决cellForItemAtIndexPath not called问题
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
        cell.homeworkPhotosView.tag = indexPath.row +1000;
        cell.answerPhotosView.tag = indexPath.row +2000;
        
        cell.photoDelegate = self;
        //注册教师发的作业的图片
//        cell.homeworkPhotosView.dataSource = self;
//        cell.homeworkPhotosView.delegate = self;
        
        //注册学生回答的图片
//        cell.answerPhotosView.dataSource = self;
//        cell.answerPhotosView.delegate = self;
        
//        [cell.homeworkPhotosView reloadData];
        
        for (NSDictionary *mod in cell.model.attachments) {
            if ([mod[@"file_type"]isEqualToString:@"mp3"]) {
                [cell.homeworkRecorder setRecordFileUrl:[NSURL URLWithString:mod[@"file_url"]]];
            }
        }
    }
    
    return  cell;
}


#pragma mark- tablview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [tableView cellHeightForIndexPath:indexPath model:_itemsArray[indexPath.row] keyPath:@"model" cellClass:[HomeworkInfoTableViewCell class] contentViewWidth:self.view.width_sd];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __block HomeworkInfoTableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    typeof(self) __weak weakSelf = self;
    if ([cell.model.status isEqualToString:@"pending"]) {
        //做作业
        //如果没做过作业,就直接进去做,做过了不可以改
        DoHomeworkViewController *controller = [[DoHomeworkViewController alloc]initWithHomework:cell.model];
        [self.navigationController pushViewController:controller animated:YES];
        
        //这方方法改了
        controller.doHomework = ^(NSDictionary *answer) {
            cell.model.myAnswerTitle = answer[@"body"];
            
            for (NSDictionary *atts in answer[@"attachment"]) {
                if ([atts[@"file_type"]isEqualToString:@"png"]) {
                    [cell.model.myAnswerPhotos addObject:atts];
                    cell.model.haveAnswerPhotos = YES;
                }else if ([atts[@"file_type"]isEqualToString:@"mp3"]){
                    cell.model.myAnswerRecorderURL = atts[@"file_url"];
                    cell.model.haveAnswerRecord = YES;
                }
            }
            cell.model.edited = YES;
            [weakSelf.mainView.homeworkList reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
    }
}



/**  提交作业 */
- (void)submit{
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
-(void)showPicker:(ZLPhotoPickerBrowserViewController *)picker{
    
    [picker showPickerVc:self];
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
