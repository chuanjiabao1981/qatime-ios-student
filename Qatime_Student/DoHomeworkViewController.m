//
//  DoHomeworkViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/13.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "DoHomeworkViewController.h"
#import "NavigationBar.h"
#import "UIViewController+ReturnLastPage.h"
#import "UIAlertController+Blocks.h"
#import "ZLPhoto.h"
#import "QuestionPhotosCollectionViewCell.h"
#import "NetWorkTool.h"
#import "LCActionSheet.h"

@interface DoHomeworkViewController ()<UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,ZLPhotoPickerBrowserViewControllerDelegate>{
    
    NavigationBar *_navBar;
    HomeworkInfo *_homework;
    
    NSMutableArray *_phototsArray;
    NSMutableArray *_atechmentArray;
    
    NSIndexPath *_clickedIndexPath;
    
    NSString *_recorderFileURL;
    
    WriteType _writeType;
    
}

@end

@implementation DoHomeworkViewController

-(instancetype)initWithHomework:(HomeworkInfo *)homework andWriteType:(WriteType)writeType{
    self = [super init];
    if (self) {
        _homework = homework;
        _writeType = writeType;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeData];
    [self setupView];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)makeData{
    _phototsArray = @[].mutableCopy;
    if (_writeType == Rewrite) {
        _atechmentArray = _homework.myAnswerPhotos;
        for (NSDictionary *atts in _homework.myAnswerPhotos) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:atts[@"file_url"]]];
            UIImage *image = [UIImage imageWithData:data];
            [_phototsArray addObject:image];
        }
    }else{
        _atechmentArray = @[].mutableCopy;
    }
}

- (void)setupView{
    
    _navBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navBar];
    [_navBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    [_navBar.rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [_navBar.rightButton addTarget:self action:@selector(handinWork) forControlEvents:UIControlEventTouchUpInside];
    [_navBar.rightButton setupAutoSizeWithHorizontalPadding:10 buttonHeight:30];
    [_navBar.rightButton updateLayout];
    _navBar.titleLabel.text = @"做作业";
    self.view.backgroundColor = [UIColor whiteColor];
    _mainView = [[DoHomeworkView alloc]init];
    [self.view addSubview:_mainView];

    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_navBar, 0)
    .bottomSpaceToView(self.view, 0);
    
    _mainView.title.delegate = self ;
    _mainView.questions.delegate = self;

    _mainView.photosView.delegate = self;
    _mainView.photosView.dataSource = self;
    
    [_mainView.photosView registerClass:[QuestionPhotosCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    typeof(self) __weak weakSelf = self;
    _mainView.recorder.finishedFile = ^(NSString *recordfileURL) {
        _recorderFileURL = recordfileURL;
        
        [weakSelf uploadRecorder];
    };
    
    if (_homework.myAnswerTitle) {
        _mainView.questions.text = _homework.myAnswerTitle;
    }
}
#pragma mark- UITextField
-(void)textDidChange:(id<UITextInput>)textInput{
    
    if (_mainView.title.text.length>20) {
        _mainView.title.text = [_mainView.title.text substringToIndex:20];
        [self HUDStopWithTitle:@"问题标题最多20字"];
    }
}


- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView == _mainView.questions) {
        if (textView.text.length>100) {
            textView.text = [textView.text substringToIndex:100];
            [self HUDStopWithTitle:@"问题最多100字"];
        }
    }
}

#pragma mark- collectionview datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger items;
    if (_phototsArray.count == 0) {
        items = 1;
    }else{
        items = _phototsArray.count + 1;
    }
    return items;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"cellID";
    QuestionPhotosCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (_phototsArray.count == 0) {
        cell.image.image = [UIImage imageNamed:@"question_addphoto"];
        cell.deleteBtn.hidden = YES;
    }else{
        if (indexPath.row == _phototsArray.count) {
            cell.image.image = [UIImage imageNamed:@"question_addphoto"];
            cell.deleteBtn.hidden = YES;
        }else{
            cell.deleteBtn.hidden = NO;
            cell.image.image = _phototsArray[indexPath.row];
            cell.deleteBtn.tag = indexPath.row;
            [cell.deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
            cell.faidBtn .tag = indexPath.item +10;
            [cell.faidBtn addTarget:self action:@selector(uploadAgain:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return cell;
}

- (void)deleteImage:(UIButton *)sender{
    
    [_phototsArray removeObjectAtIndex:sender.tag];
    if (_atechmentArray[sender.tag]) {
        [_atechmentArray removeObjectAtIndex:sender.tag];
    }
    [_mainView.photosView reloadData];
}

#pragma mark- collectionview delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self resign];
    
    //没照片的时候
    if (_phototsArray.count == 0) {
        if (indexPath.row == 0) {
            [self showSheet];
            _clickedIndexPath = indexPath;
        }
    }else{
        if (indexPath.row == _phototsArray.count) {
            [self showSheet];
            _clickedIndexPath = indexPath;
        }else{
            //预览照片啊
            //用ZLPhoto
            _clickedIndexPath = nil;
            NSMutableArray *photos = @[].mutableCopy;
            ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
            // 淡入淡出效果
            pickerBrowser.status = UIViewAnimationAnimationStatusZoom;
            // 数据源/delegate
            for (QuestionPhotosCollectionViewCell *cell in collectionView.visibleCells) {
                if (cell.deleteBtn.hidden == NO) {
                    ZLPhotoPickerBrowserPhoto *mod = [[ZLPhotoPickerBrowserPhoto alloc]init];
                    mod.toView = cell.image;
                    mod.photoImage = cell.image.image;
                    [photos addObject:mod];
                }
            }
            
            pickerBrowser.editing = YES;
            pickerBrowser.photos = photos;
            // 能够删除
            pickerBrowser.delegate = self;
            // 当前选中的值
            pickerBrowser.currentIndex = indexPath.row;
            // 展示控制器
            [pickerBrowser showPickerVc:self];
            
        }
    }
}

/**
 *  删除indexPath对应索引的图片
 *
 *  @param index 要删除的索引值
 */
- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{
    
    [_phototsArray removeObjectAtIndex:index];
    [_mainView.photosView reloadData];
    
}

- (void)showSheet{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    picker.delegate = self;
    LCActionSheet *sheet = [[LCActionSheet alloc]initWithTitle:@"选择头像" cancelButtonTitle:@"取消" clicked:^(LCActionSheet *actionSheet, NSInteger buttonIndex) {
        
        switch (buttonIndex) {
            case 0:
                return ;
                break;
                
            case 1:{
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
            }
                break;
            case 2:{
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
            }
                break;
            case 3:{
                picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                
            }
                break;
        }
        
        picker.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:picker animated:YES completion:^{}];
        
    } otherButtonTitleArray:@[@"照相机",@"图库",@"相册"]];
    
    [sheet show];
}

//图片回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    QuestionPhotosCollectionViewCell *cell ;
    if (_clickedIndexPath) {
        cell = [_mainView.photosView cellForItemAtIndexPath:_clickedIndexPath];
    }
    
    NSLog(@"%@",info);
    
    @try {
        [picker dismissViewControllerAnimated:YES completion:^{
        }];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [_phototsArray addObject:image];
        [_mainView.photosView reloadData];
        
        /**
         注意:选择完图片之后,直接上传!不要等都选择完了之后一起上传.
         1.选一张上传一张.
         2.显示上传进度.
         */
        
        [self uploadImageWithIndexPath:_clickedIndexPath?_clickedIndexPath:[NSIndexPath indexPathForItem:_phototsArray.count-1 inSection:0] andImage:image];
        
        if (cell) {
            
        }
        
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}


/**
 上传图片方法
 
 @param indexPath cell的indexpath
 @param image 图片
 */
- (void)uploadImageWithIndexPath:(NSIndexPath *)indexPath andImage:(UIImage *)image{
    
    QuestionPhotosCollectionViewCell *cell = (QuestionPhotosCollectionViewCell *)[_mainView.photosView cellForItemAtIndexPath:indexPath];
    cell.effectView.hidden = NO;
    
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[self getToken] forHTTPHeaderField:@"Remember-Token"];
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/live_studio/attachments",Request_Header] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(image,1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        cell.effectView.hidden = NO;
        //进度
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        
        // 给Progress添加监听 KVO
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        // 回到主队列刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置进度条的百分比
            cell.effectView.hidden = NO;
            [cell.progress setProgress:1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount animated:YES];
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            //可以了
            NSMutableDictionary * fileDic = [NSMutableDictionary dictionaryWithDictionary:dic[@"data"]];
            [fileDic setValue:[NSString stringWithFormat:@"%ld",indexPath.item] forKey:@"index"];
            [_atechmentArray insertObject:fileDic atIndex:indexPath.item];
            cell.effectView.hidden = YES;
        }else{
            //上传失败
            cell.faildEffectView.hidden = NO;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //网络错误
        cell.faildEffectView.hidden = NO;
        [self HUDStopWithTitle:@"请检查网络"];
    }];
    
}

/** 重新上传 */
- (void)uploadAgain:(UIButton *)sender{
    
    NSIndexPath *indexs = [NSIndexPath indexPathForItem:sender.tag-10 inSection:0];
    
    QuestionPhotosCollectionViewCell *cell = [_mainView.photosView cellForItemAtIndexPath:indexs];
    [self uploadImageWithIndexPath:indexs andImage:cell.image.image];
    
}

- (void)uploadRecorder{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:[self getToken] forHTTPHeaderField:@"Remember-Token"];
    [manager POST:[NSString stringWithFormat:@"%@/api/v1/live_studio/attachments",Request_Header] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *recorderData = [NSData dataWithContentsOfFile:_recorderFileURL];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp3", str];
        [formData appendPartWithFileData:recorderData name:@"file" fileName:fileName mimeType:@"audio/mp3"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            [_atechmentArray addObject:dic[@"data"]];
        }else{
            //音频上传失败
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self HUDStopWithTitle:@"请检查网络"];
    }];
    
    
}






/** 提交作业 */
- (void)handinWork{
    
    [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"确定提交?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"提交"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex!=0) {
            
            //两个字段.
            //1.attachment;
            //2.body;
            NSDictionary *answerDic = @{
                                      @"body":_mainView.questions.text,
                                      @"attachment":_atechmentArray
                                      };
            _doHomework(answerDic);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (void)resign{
    [_mainView.title resignFirstResponder];
    [_mainView.questions resignFirstResponder];
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
