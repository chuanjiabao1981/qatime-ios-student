//
//  NewQuestionViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "NewQuestionViewController.h"
#import "NavigationBar.h"
#import "QuestionPhotosCollectionViewCell.h"
#import "LCActionSheet.h"
#import "KSPhotoBrowser.h"
#import "UIViewController+HUD.h"
#import "UIControl+RemoveTarget.h"
#import "UIAlertController+Blocks.h"
#import "ZLPhotoPickerBrowserViewController.h"


@interface NewQuestionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,ZLPhotoPickerBrowserViewControllerDelegate>{
    
    NavigationBar *_navigationBar;
    
    NSMutableArray *_phototsArray;
    
}



@end

@implementation NewQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNDGRAY;
    
    [self makeData];
    [self setupView];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
}

- (void)makeData{
    
    _phototsArray = @[].mutableCopy;
}

- (void)setupView{
    //navigation
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navigationBar];
    _navigationBar.titleLabel.text = @"提问";
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.rightButton setImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    //mainView
    _mainView = [[NewQuestionView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_navigationBar, 0)
    .bottomSpaceToView(self.view, 0);
    
    _mainView.title.delegate = self ;
    _mainView.questions.delegate = self;
    
    _mainView.photosView.delegate = self;
    _mainView.photosView.dataSource = self;
    
    [_mainView.photosView registerClass:[QuestionPhotosCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    
    [self addChildViewController:_mainView.recorder];
    
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
        }
    }
    return cell;
}

- (void)deleteImage:(UIButton *)sender{
    
    [_phototsArray removeObjectAtIndex:sender.tag];
    [_mainView.photosView reloadData];
    
}

#pragma mark- collectionview delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //没照片的时候
    if (_phototsArray.count == 0) {
        if (indexPath.row == 0) {
          [self showSheet];
        }
    }else{
        if (indexPath.row == _phototsArray.count) {
            [self showSheet];
        }else{
            //预览照片啊
            //用ZLPhoto
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
        [self presentViewController:picker animated:YES completion:^{}];
        
    } otherButtonTitleArray:@[@"照相机",@"图库",@"相册"]];
    
    [sheet show];
}

//图片回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSLog(@"%@",info);
    
    @try {
        [picker dismissViewControllerAnimated:YES completion:^{
        }];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [_phototsArray addObject:image];
        [_mainView.photosView reloadData];
    } @catch (NSException *exception) {

    } @finally {
        
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
