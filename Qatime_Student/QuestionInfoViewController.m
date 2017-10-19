//
//  QuestionInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/21.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "QuestionInfoViewController.h"
#import "Questions.h"
#import "NavigationBar.h"
#import "UIViewController+ReturnLastPage.h"
#import "QuestionPhotosCollectionViewCell.h"
#import "ZLPhoto.h"

@interface QuestionInfoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    Questions *_question;
    
    NavigationBar *_navBar;
    
    NSMutableArray *_questionPics;
    NSMutableArray *_answerPics;
    
}

@end

@implementation QuestionInfoViewController

-(instancetype)initWithQuestion:(Questions *)question{
    self = [super init];
    if (self) {
        _question = question;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeData];
    [self setupView];
    
}

- (void)makeData{
    
    _questionPics = @[].mutableCopy;
    _answerPics = @[].mutableCopy;
    
}
- (void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    _navBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navBar];
    [_navBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    _navBar.titleLabel.text = _question.course_name;
    _questionInfoView = [[QuestionInfoView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_questionInfoView];
    _questionInfoView.model = _question;
    _questionInfoView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(_navBar, 0)
    .rightSpaceToView(self.view, 0);
    
    UIView *line = [[UIView alloc]init];
    [self.view addSubview:line];
    line.backgroundColor = SEPERATELINECOLOR_2;
    line.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_questionInfoView, 0)
    .heightIs(0.5);
    
    _answerInfoView = [[AnswerInfoView alloc]init];
    [self.view addSubview:_answerInfoView];
    _answerInfoView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(line, 0)
    .rightSpaceToView(self.view,0);
    
    _questionInfoView .model = _question;
    if (_question.answer) {
        _answerInfoView.model = _question.answer;
    }else{
        _answerInfoView.hidden = YES;
    }
    [_questionInfoView updateLayout];
    //处理model
    if (_question.attachments) {
        for (NSDictionary *atts in _question.attachments) {
            if ([atts[@"file_type"]isEqualToString:@"png"]||[atts[@"file_type"]isEqualToString:@"jpg"]||[atts[@"file_type"]isEqualToString:@"jpeg"]) {
                [_questionPics addObject:atts];
            }else if ([atts[@"file_type"]isEqualToString:@"mp3"]){
                [_questionInfoView.recorder setPlayerFileURL:[NSURL URLWithString:atts[@"file_url"]]];
            }
        }
    }
    
    if (_question.answer.attachments) {
        for (NSDictionary *atts in _question.answer.attachments) {
            if ([atts[@"file_type"]isEqualToString:@"png"]||[atts[@"file_type"]isEqualToString:@"jpg"]||[atts[@"file_type"]isEqualToString:@"jpeg"]) {
                [_answerPics addObject:atts];
            }else if ([atts[@"file_type"]isEqualToString:@"mp3"]){
                [_answerInfoView.recorder setPlayerFileURL:[NSURL URLWithString:atts[@"file_url"]]];
            }
        }
    }
    
    _questionInfoView.photosView.delegate = self;
    _questionInfoView.photosView.dataSource = self;
    _questionInfoView.photosView.tag = 1;
    [_questionInfoView.photosView registerClass:[QuestionPhotosCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    
    _answerInfoView.photosView.delegate = self;
    _answerInfoView.photosView.dataSource = self;
    _answerInfoView.photosView.tag =2;
    [_answerInfoView.photosView registerClass:[QuestionPhotosCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger row = 0;
    if (collectionView.tag == 1) {
        row = _questionPics.count;
    }else if (collectionView.tag == 2){
        row = _answerPics.count;
    }
    return row;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *itemCell;
    if (collectionView.tag == 1) {
        
        static NSString * CellIdentifier = @"collectionCell";
        QuestionPhotosCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.deleteBtn.hidden = YES;
        if (_questionPics.count>indexPath.row) {
            [cell.image sd_setImageWithURL:[NSURL URLWithString:_questionPics[indexPath.item][@"file_url"]]];
        }
        
        itemCell = cell;

    }else if (collectionView.tag == 2){
        static NSString * CellIdentifier = @"Cell";
        QuestionPhotosCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.deleteBtn.hidden = YES;
        if (_answerPics.count>indexPath.row) {
            [cell.image sd_setImageWithURL:[NSURL URLWithString:_answerPics[indexPath.item][@"file_url"]]];
        }
        
        itemCell = cell;
    }
    
    return itemCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((UIScreenWidth-40*ScrenScale-10)/5.f, (UIScreenWidth-40*ScrenScale-10)/5.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10*ScrenScale;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10*ScrenScale;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //预览照片啊
    //用ZLPhoto
    NSMutableArray *photos = @[].mutableCopy;
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    pickerBrowser.status = UIViewAnimationAnimationStatusZoom;
    // 数据源/delegate
    for (QuestionPhotosCollectionViewCell *cell in collectionView.visibleCells) {
        
        ZLPhotoPickerBrowserPhoto *mod = [[ZLPhotoPickerBrowserPhoto alloc]init];
        mod.toView = cell.image;
        mod.photoImage = cell.image.image;
        [photos addObject:mod];
        
    }
    
    
    pickerBrowser.photos = photos;
    // 当前选中的值
    pickerBrowser.currentIndex = indexPath.row;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
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
