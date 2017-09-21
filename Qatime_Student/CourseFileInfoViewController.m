//
//  CourseFileInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/5.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "CourseFileInfoViewController.h"
#import "NavigationBar.h"
#import "UIViewController+HUD.h"
#import "UIViewController+ReturnLastPage.h"
#import "UIControl+RemoveTarget.h"
#import <QuickLook/QuickLook.h>

@interface CourseFileInfoViewController ()<QLPreviewControllerDelegate,QLPreviewControllerDataSource>{
    
    NavigationBar *_navBar;
    
    CourseFile *_courseFile;
    
    // 下载句柄
    NSURLSessionDownloadTask *_downloadTask;
    
    //保存的文件路径
    __block NSURL *_savedFileURL;
}

@end

@implementation CourseFileInfoViewController

-(instancetype)initWithFile:(CourseFile *)file{
    
    self = [super init];
    if (self) {
        _courseFile = file;
        if (_courseFile.name==nil) {
            _courseFile.name = [NSString stringWithFormat:@"%@",_courseFile.fileID];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self makeData];
    
    [self setupMainView];
    
    [self searchFiles];
    
}

- (void)makeData{
    
    
}

- (void)setupMainView{
    _navBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navBar];
    [_navBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    _navBar.titleLabel.text = _courseFile.name;
    
    _mainView = [[CourseFileInfoView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_navBar, 0)
    .bottomSpaceToView(self.view, 0);
    _mainView.model = _courseFile ;
    
    [_mainView.downloadBtn addTarget:self action:@selector(downloadFile:) forControlEvents:UIControlEventTouchUpInside];
    
}
//看看是不是下载过
- (void)searchFiles{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
   BOOL had_downloaded =  [manager fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"download"]stringByAppendingPathComponent:_courseFile.name]];
    if (had_downloaded == YES) {
        //下载过
        [_mainView.downloadBtn setTitle:@"查看文件" forState:UIControlStateNormal];
        [_mainView.downloadBtn removeAllTargets];
        [_mainView.downloadBtn addTarget:self action:@selector(previewFile:) forControlEvents:UIControlEventTouchUpInside];
        _savedFileURL = [NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"download"]stringByAppendingPathComponent:_courseFile.name]];
    }else{
      //没下载过
        
    }
    
}

/** 下载文件吧 */
- (void)downloadFile:(UIButton *)sender{
    
    typeof(self) __weak weakSelf = self;
    _mainView.downloadBtn.hidden = YES;
    //远程地址
    NSURL *URL = [NSURL URLWithString:_courseFile.file_url];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //下载Task操作
    _downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        
        // 给Progress添加监听 KVO
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置进度条的百分比
            weakSelf.mainView.downloadProgress.hidden = NO;
            weakSelf.mainView.progressBar.hidden = NO;
            [weakSelf.mainView.progressBar setProgress:1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount animated:YES];
            
            NSString *pro =[NSString stringWithFormat:@"%.0f",downloadProgress.fractionCompleted*100];
            NSString *totalSize = [self switchFileSize:_courseFile.file_size];
            NSString *currentSize = [self switchFileSize:[NSString stringWithFormat:@"%f",([_courseFile.file_size longLongValue]*downloadProgress.fractionCompleted)]];
            _mainView.downloadProgress.text = [NSString stringWithFormat:@"下载中...(%@ / %@ )",currentSize,totalSize];
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        // 对应宏->DownloadPath
//        return [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"download"]];
        
        NSURL *fileURL =[NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"download"]stringByAppendingPathComponent:response.suggestedFilename]];
        
        return fileURL;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        //设置下载完成操作
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
        _savedFileURL = filePath;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self HUDStopWithTitle:@"下载完成"];
            weakSelf.mainView.downloadProgress.hidden = YES;
            weakSelf.mainView.progressBar.hidden = YES;
            weakSelf.mainView.downloadBtn.hidden = NO;
            [weakSelf.mainView.downloadBtn setTitle:@"查看文件" forState:UIControlStateNormal];
            [weakSelf.mainView.downloadBtn removeAllTargets];
            [weakSelf.mainView.downloadBtn addTarget:self action:@selector(previewFile:) forControlEvents:UIControlEventTouchUpInside];
        });

    }];
    
    //开始下载
    [_downloadTask resume];
    
}

- (NSString *)switchFileSize:(NSString *)bitSize{
    
    NSString *sizeText;
    long long size;
    size = bitSize.longLongValue;
    if (size >= pow(10, 9)) { // size >= 1GB
        sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
    } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
        sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
    } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
        sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
    } else { // 1KB > size
        sizeText = [NSString stringWithFormat:@"%zdB", size];
    }
    
    return sizeText;
}

//预览文件
- (void)previewFile:(UIButton *)sender{
    
    QLPreviewController *myQlPreViewController = [[QLPreviewController alloc]init];
//    myQlPreViewController.tabBarController.tabBar.hidden = YES;
    myQlPreViewController.delegate =self;
    
    myQlPreViewController.dataSource =self;
    
    [myQlPreViewController setCurrentPreviewItemIndex:0];
    myQlPreViewController.hidesBottomBarWhenPushed = YES;
//    [self presentViewController:myQlPreViewController animated:YES completion:nil];
    [self.navigationController pushViewController:myQlPreViewController animated:YES];
    
}
#pragma mark - QLPreviewControllerDataSource

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller

{
    
    return 1;
    
}


- (id)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    
    return _savedFileURL; //返回文件路径
    
}



- (void)cancelDownload{
    //取消
    [_downloadTask cancel];
}

- (void)returnLastPage{
    [self cancelDownload];
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
