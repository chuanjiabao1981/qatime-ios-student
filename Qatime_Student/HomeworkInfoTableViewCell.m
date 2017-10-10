//
//  HomeworkInfoTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "HomeworkInfoTableViewCell.h"
#import "QuestionPhotosCollectionViewCell.h"
#import "QuestionPhotosReuseCollectionViewCell.h"
#import "ZLPhoto.h"

@interface HomeworkInfoTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    
    UILabel *_myLabel;
    
    UILabel *_teacherLabel;
    
}

@end

@implementation HomeworkInfoTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _index = [[UILabel alloc]init];
        [self.contentView addSubview:_index];
        _index .font = TEXT_FONTSIZE;
        _index.textColor = [UIColor blackColor];
        _index.sd_layout
        .leftSpaceToView(self.contentView, 12*ScrenScale)
        .topSpaceToView(self.contentView, 10*ScrenScale)
        .autoHeightRatio(0);
        [_index setSingleLineAutoResizeWithMaxWidth:200];
        
        _title =[[UILabel alloc]init];
        [self.contentView addSubview:_title];
        _title .font = TEXT_FONTSIZE;
        _title.textColor = [UIColor blackColor];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.sd_layout
        .leftSpaceToView(_index, 10*ScrenScale)
        .topSpaceToView(self.contentView, 10*ScrenScale)
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .autoHeightRatio(0);
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//        layout.itemSize = CGSizeMake((UIScreenWidth -30*ScrenScale-40)/5.f, (UIScreenWidth -30*ScrenScale-40)/5.f);
        layout.itemSize = CGSizeMake((UIScreenWidth-20*ScrenScale-30)/5.f-2, (UIScreenWidth-20*ScrenScale-30)/5.f-2);
//        layout.minimumInteritemSpacing = 10;
//        layout.minimumLineSpacing = 10;
        
        _homeworkPhotosView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 10, 10) collectionViewLayout:layout];
        _homeworkPhotosView.backgroundColor = [UIColor whiteColor];
        _homeworkPhotosView.scrollEnabled = NO;
        
        [self.contentView addSubview:_homeworkPhotosView];
        _homeworkPhotosView.sd_layout
        .leftSpaceToView(self.contentView, 10*ScrenScale)
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(_title, 10*ScrenScale)
        .heightIs((UIScreenWidth -30*ScrenScale-40)/5.f);
        
        [_homeworkPhotosView registerClass:[QuestionPhotosCollectionViewCell class] forCellWithReuseIdentifier:@"photoCell"];
        _homeworkRecorder = [[YZReorder alloc]init];
        [self.contentView addSubview:_homeworkRecorder.view];
        _homeworkRecorder.view.sd_layout
        .leftEqualToView(_homeworkPhotosView)
        .rightEqualToView(_homeworkPhotosView)
        .topSpaceToView(_homeworkPhotosView, 10*ScrenScale)
        .heightIs(40);
        
        
        _status = [[UILabel alloc]init];
        [self.contentView addSubview:_status];
        _status .font = TEXT_FONTSIZE;
        _status.textColor = [UIColor blackColor];
        _status.sd_layout
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(_homeworkRecorder.view, 10*ScrenScale)
        .autoHeightRatio(0);
        [_status setSingleLineAutoResizeWithMaxWidth:300];
        
        
        ////答案区////
        
        _myLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_myLabel];
        _myLabel.font = TEXT_FONTSIZE;
        _myLabel.textColor = [UIColor blackColor];
        _myLabel.sd_layout
        .leftEqualToView(_index)
        .topSpaceToView(_homeworkRecorder.view, 10*ScrenScale)
        .autoHeightRatio(0);
        [_myLabel setSingleLineAutoResizeWithMaxWidth:300];
        _myLabel.text = @"我的答案:";
        _myLabel.hidden = YES;
        
        _answerTitle =[[UILabel alloc]init];
        [self.contentView addSubview:_answerTitle];
        _answerTitle.font = TEXT_FONTSIZE;
        _answerTitle.textColor = TITLECOLOR;
        _answerTitle.sd_layout
        .leftEqualToView(_index)
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(_myLabel, 10*ScrenScale)
        .autoHeightRatio(0);
        _answerTitle.hidden = YES;
        
        _answerPhotosView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 10, 10) collectionViewLayout:layout];
        _answerPhotosView.scrollEnabled = NO;
        _answerPhotosView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_answerPhotosView];
        _answerPhotosView.sd_layout
        .leftSpaceToView(self.contentView, 10*ScrenScale)
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(_answerTitle, 10*ScrenScale)
        .heightIs((UIScreenWidth -30*ScrenScale-40)/5.f);
        
        [_answerPhotosView registerClass:[QuestionPhotosReuseCollectionViewCell class] forCellWithReuseIdentifier:@"answerPhotoCell"];
        
        _answerRecorder = [[YZReorder alloc]init];
        [self.contentView addSubview:_answerRecorder.view];
        _answerRecorder.view.sd_layout
        .leftEqualToView(_answerPhotosView)
        .rightEqualToView(_answerPhotosView)
        .topSpaceToView(_answerPhotosView, 10*ScrenScale)
        .heightIs(40);
        
        //老师批改的 头
        _teacherLabel =[[UILabel alloc]init];
        [self.contentView addSubview:_teacherLabel];
        _teacherLabel.font = TEXT_FONTSIZE;
        _teacherLabel.textColor = [UIColor blackColor];
        _teacherLabel.sd_layout
        .leftEqualToView(_index)
        .topSpaceToView(_answerRecorder, 10*ScrenScale)
        .autoHeightRatio(0);
        [_teacherLabel setSingleLineAutoResizeWithMaxWidth:300];
        _teacherLabel.text = @"批改结果";
        _teacherLabel.hidden = YES;
        
        //老师批改的内容
        _teacherCheckTitle=[[UILabel alloc]init];
        [self.contentView addSubview:_teacherCheckTitle];
        _teacherCheckTitle.font = TEXT_FONTSIZE;
        _teacherCheckTitle.textColor = [UIColor blackColor];
        _teacherCheckTitle.sd_layout
        .leftEqualToView(_index)
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(_teacherLabel, 10*ScrenScale)
        .autoHeightRatio(0);
        _teacherCheckTitle.hidden = YES;
        
        //老师批改的 图片.
        _correctPhotosView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 10, 10) collectionViewLayout:layout];
        _correctPhotosView.scrollEnabled = NO;
        _correctPhotosView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_correctPhotosView];
        _correctPhotosView.sd_layout
        .leftSpaceToView(self.contentView, 10*ScrenScale)
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(_teacherCheckTitle, 10*ScrenScale)
        .heightIs((UIScreenWidth -30*ScrenScale-40)/5.f);
        
        [_correctPhotosView registerClass:[QuestionPhotosReuseCollectionViewCell class] forCellWithReuseIdentifier:@"correctPhotoCell"];
        
        _correctRecorder = [[YZReorder alloc]init];
        [self.contentView addSubview:_correctRecorder.view];
        _correctRecorder.view.sd_layout
        .leftEqualToView(_correctPhotosView)
        .rightEqualToView(_correctPhotosView)
        .topSpaceToView(_correctPhotosView, 10*ScrenScale)
        .heightIs(40);
        
        _homeworkPhotosView.dataSource = self;
        _homeworkPhotosView.delegate = self;
        _answerPhotosView.dataSource = self;
        _answerPhotosView.delegate = self;
        _correctPhotosView.dataSource = self;
        _correctPhotosView.delegate = self;
        
    }
    return self;
}

-(void)setModel:(HomeworkInfo *)model{
    
    _model = model;
    _title.text = model.body;
    
    //先判断老师留的作业有没有附件 有没有语音 ,有没有图片,有几个图片
    if (_model.attachments) {
        for (NSDictionary *atts in _model.attachments) {
            if (_model.havePhotos == NO) {
                if ([atts[@"file_type"]isEqualToString:@"png"]) {
                    _model.havePhotos = YES;
                    [_model.homeworkPhotos addObject:atts];
                }
            }
            if (_model.haveRecord == NO) {
                if ([atts[@"file_type"]isEqualToString:@"mp3"]) {
                    _model.haveRecord = YES;
                    _model.homeworkRecordURL = atts[@"file_url"];
                }
            }
            
        }
        
    }else{
        _model.havePhotos = NO;
        _model.haveRecord = NO;
    }
    
    
    //加载一下搞一搞学生做作业的图片和语音
    if (_model.answers[@"attachments"]) {
        if ([_model.answers[@"attachments"] count]==0) {
            _model.haveAnswerPhotos = NO;
            _model.haveAnswerRecord = NO;
        }else{
            for (NSDictionary *atts in _model.answers[@"attachments"]) {
                if ([atts[@"file_type"]isEqualToString:@"png"]) {
                    _model.haveAnswerPhotos = YES;
                    [_model.myAnswerPhotos addObject:atts];
                }else if ([atts[@"file_type"]isEqualToString:@"mp3"]){
                    _model.haveAnswerRecord = YES;
                    _model.myAnswerRecorderURL  = atts[@"file_url"];
                }
            }
        }
    }
    
    //最后再判断有没有批改
    if (_model.correction) {
        //有批改.
        _model.haveCorrection = YES;
        for (NSDictionary *atts in _model.correction[@"attachments"]) {
            if ([atts[@"file_type"]isEqualToString:@"png"]) {
                _model.haveCorrectPhotos = YES;
                [_model.correctionPhotos addObject:atts];
            }else if ([atts[@"file_type"]isEqualToString:@"mp3"]){
                _model.haveCorrectRecord = YES;
                _model.correctionRecordURL = atts[@"file_url"];
            }
        }
    }else{
        
        _model.haveCorrection = NO;
        _model.haveCorrectPhotos = NO;
        _model.haveCorrectRecord = NO;
    }
    
    ////////////////////////////////////////////////////////
    
    if ([_model.status isEqualToString:@"pending"]) {
        //未提交过作业
        _correctPhotosView.hidden = YES;
        _correctRecorder.view.hidden = YES;
        if (_model.edited == YES) {
            //如果已经写过答案了,那就把答案显示出来,别的不显示,可以再次编辑
            _status.hidden = YES;
            _myLabel.hidden = NO;
            _answerTitle.hidden = NO;
            _answerTitle.sd_layout
            .topSpaceToView(_myLabel, 10);
            [_answerTitle updateLayout];
            
            if (model.myAnswerTitle) {
                _answerTitle.text = _model.myAnswerTitle;
            }else{
                _answerTitle.text = @" ";
            }
            
            _teacherLabel.hidden = YES;
            _teacherCheckTitle.hidden = YES;
            
            //判断老师的问题,是否有图片语音
            if (_model.havePhotos == YES && _model.haveRecord == YES ) {
                _homeworkPhotosView.hidden = NO;
                _homeworkRecorder.view.hidden = NO;
//                _status.sd_layout
//                .topSpaceToView(_homeworkRecorder.view, 10*ScrenScale);
//                [_status updateLayout];
                _myLabel.sd_layout
                .topSpaceToView(_homeworkRecorder.view, 10);
                [_myLabel updateLayout];
                
                _homeworkRecorder.view.sd_layout
                .topSpaceToView(_homeworkPhotosView, 10);
                [_homeworkRecorder.view updateLayout];
                
                [self haveAnswerdTheHomeWorkLayout];
            }
            
            if (_model.havePhotos == YES && _model.haveRecord == NO) {
                _homeworkPhotosView.hidden = NO;
                _homeworkRecorder.view.hidden = YES;
                _status.sd_layout
                .topSpaceToView(_homeworkPhotosView, 10*ScrenScale);
                [_status updateLayout];
                
                _myLabel.sd_layout
                .topSpaceToView(_homeworkPhotosView, 10);
                [_myLabel updateLayout];
                [self haveAnswerdTheHomeWorkLayout];
                
            }
            if (_model.havePhotos == NO && _model.haveRecord == YES) {
                
                _homeworkPhotosView.hidden = YES;
                _homeworkRecorder.view.hidden = NO;
                _homeworkRecorder.view.sd_layout
                .topSpaceToView(_title, 10*ScrenScale);
                [_homeworkRecorder.view updateLayout];
                _status.sd_layout
                .topSpaceToView(_homeworkRecorder.view, 10*ScrenScale);
                [_status updateLayout];
                
                _myLabel.sd_layout
                .topSpaceToView(_homeworkRecorder.view, 10);
                [_myLabel updateLayout];
                
                [self haveAnswerdTheHomeWorkLayout];
            }
            
        }else{
            //如果没写过答案,就让他写答案去
            _status.hidden = NO;
            _myLabel.hidden = YES;
            _answerTitle.hidden = YES;
            _teacherLabel.hidden = YES;
            _teacherCheckTitle.hidden = YES;
            _answerPhotosView.hidden = YES;
            _answerRecorder.view.hidden = YES;
            //反正也没有答案 , 那就只判断老师的问题,是否有图片语音
            if (_model.havePhotos == YES && _model.haveRecord == YES ) {
                _homeworkPhotosView.hidden = NO;
                _homeworkRecorder.view.hidden = NO;
                _status.sd_layout
                .topSpaceToView(_homeworkRecorder.view, 10*ScrenScale);
                [_status updateLayout];
            }
            
            if (_model.havePhotos == YES && _model.haveRecord == NO) {
                _homeworkPhotosView.hidden = NO;
                _homeworkRecorder.view.hidden = YES;
                _status.sd_layout
                .topSpaceToView(_homeworkPhotosView, 10*ScrenScale);
                [_status updateLayout];
                
            }
            if (_model.havePhotos == NO && _model.haveRecord == YES) {
                
                _homeworkPhotosView.hidden = YES;
                _homeworkRecorder.view.hidden = NO;
                _homeworkRecorder.view.sd_layout
                .topSpaceToView(_title, 10*ScrenScale);
                [_homeworkRecorder.view updateLayout];
                _status.sd_layout
                .topSpaceToView(_homeworkRecorder.view, 10*ScrenScale);
                [_status updateLayout];
            }
            
            _status.text = @"做作业";
            _status.textColor = [UIColor redColor];
            [self setupAutoHeightWithBottomView:_status bottomMargin:10*ScrenScale];
        }
        
        
    }else if ([_model.status isEqualToString:@"submitted"]){
        _correctPhotosView.hidden = YES;
        _correctRecorder.view.hidden = YES;
        //如果已经是提交过的作业,而且还没有批改的,能修改答案
        _status.hidden = YES;
        _myLabel.hidden = NO;
        _answerTitle.hidden = NO;
        _teacherLabel.hidden = YES;
        _teacherCheckTitle.hidden = YES;
        
        _status.text = @" ";
        _answerTitle.text = model.myAnswerTitle; //暂时这么写
        //这部分,根据音频/图片数据判断
        //判断老师的问题,是否有图片语音  换汤不换药.一样.
        if (_model.havePhotos == YES && _model.haveRecord == YES ) {
            _homeworkPhotosView.hidden = NO;
            _homeworkRecorder.view.hidden = NO;
            [self haveAnswerdTheHomeWorkLayout];
        }
        
        if (_model.havePhotos == YES && _model.haveRecord == NO) {
            _homeworkPhotosView.hidden = NO;
            _homeworkRecorder.view.hidden = YES;
            [self haveAnswerdTheHomeWorkLayout];
            
        }
        if (_model.havePhotos == NO && _model.haveRecord == YES) {
            
            _homeworkPhotosView.hidden = YES;
            _homeworkRecorder.view.hidden = NO;
            _homeworkRecorder.view.sd_layout
            .topSpaceToView(_title, 10*ScrenScale);
            [_homeworkRecorder.view updateLayout];
            [self haveAnswerdTheHomeWorkLayout];
        }
        
        //        [self setupAutoHeightWithBottomView:_answerTitle bottomMargin:10*ScrenScale];
        
    }else if ([_model.status isEqualToString:@"resolved"]){
        //已经批改过的 啥都显示啥都能看
        //注意  暂时还没有老师的批改带图片语音的....
        _correctPhotosView.hidden = NO;
        _correctRecorder.view.hidden = NO;
        _status.hidden = YES;
        _myLabel.hidden = NO;
        _answerTitle.hidden = NO;
        _teacherLabel.hidden = NO;
        _teacherCheckTitle.hidden = NO;
        
        //这部分,根据音频/图片数据判断
        //判断老师的问题,是否有图片语音
        if (_model.havePhotos == YES && _model.haveRecord == YES ) {
            _homeworkPhotosView.hidden = NO;
            _homeworkRecorder.view.hidden = NO;
            
            [self haveAnswerdTheHomeWorkAndHaveCorrectedLayout];
        }
        
        if (_model.havePhotos == YES && _model.haveRecord == NO) {
            _homeworkPhotosView.hidden = NO;
            _homeworkRecorder.view.hidden = YES;
            
            [self haveAnswerdTheHomeWorkAndHaveCorrectedLayout];
        }
        if (_model.havePhotos == NO && _model.haveRecord == YES) {
            
            _homeworkPhotosView.hidden = YES;
            _homeworkRecorder.view.hidden = NO;
            _homeworkRecorder.view.sd_layout
            .topSpaceToView(_title, 10*ScrenScale);
            [_homeworkRecorder.view updateLayout];
            
            [self haveAnswerdTheHomeWorkAndHaveCorrectedLayout];
        }
        
        _answerTitle.text = _model.myAnswerTitle;
        _teacherCheckTitle.text = _model.correction[@"body"];
        [self setupAutoHeightWithBottomView:_teacherCheckTitle bottomMargin:10*ScrenScale];
    }
    
    //    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshAllUI];
    });
    
}

- (void)refreshAllUI{
    
    if (_model.homeworkPhotos.count!=0) {
        [_homeworkPhotosView reloadData];
    }
    if (_model.myAnswerPhotos.count!=0) {
        [_answerPhotosView reloadData];
    }
    if (_model.correctionPhotos.count!=0) {
        [_correctPhotosView reloadData];
    }
    
}


//1.已经写过答案的问题,的什么什么逻辑.
- (void)haveAnswerdTheHomeWorkLayout{
    //嵌套判断
    //学生做完作业了 有图片和语音
    if (_model.haveAnswerPhotos == YES && _model.haveAnswerRecord == YES) {
        _answerPhotosView.hidden = NO;
        _answerRecorder.view.hidden = NO;
        [self answerTitleLayout];
        [self setupAutoHeightWithBottomView:_answerRecorder.view bottomMargin:10*ScrenScale];
    }
    //有图片没有语音
    if (_model.haveAnswerPhotos == YES && _model.haveAnswerRecord == NO) {
        _answerPhotosView.hidden = NO;
        _answerRecorder.view.hidden = YES;
        _answerPhotosView.sd_layout
        .topSpaceToView(_myLabel, 10);
        [_answerPhotosView updateLayout];
        [self answerTitleLayout];
        [self setupAutoHeightWithBottomView:_answerPhotosView bottomMargin:10*ScrenScale];
    }
    //有语音没图片
    if (_model.haveAnswerPhotos == NO && _model.haveAnswerRecord == YES) {
        _answerRecorder.view.sd_layout
        .topSpaceToView(_answerTitle, 10*ScrenScale);
        [_homeworkRecorder.view updateLayout];
        _answerPhotosView.hidden = YES;
        _answerRecorder.view.hidden = NO;
        [self answerTitleLayout];
        [self setupAutoHeightWithBottomView:_answerRecorder.view bottomMargin:10*ScrenScale];
    }
    if (_model.haveAnswerPhotos == NO && _model.haveAnswerRecord == NO) {
        _answerPhotosView.hidden = YES;
        _answerRecorder.view.hidden = YES;
        [self answerTitleLayout];
        [self setupAutoHeightWithBottomView:_answerTitle bottomMargin:10*ScrenScale];
    }
    
}

- (void)haveAnswerdTheHomeWorkAndHaveCorrectedLayout{
    
    //嵌套判断 + 嵌套判断
    //学生做完作业了 有图片和语音
    if (_model.haveAnswerPhotos == YES && _model.haveAnswerRecord == YES) {
        _answerPhotosView.hidden = NO;
        _answerRecorder.view.hidden = NO;
        
        if (_model.haveCorrectPhotos == YES && _model.haveCorrectRecord == YES) {
            _correctPhotosView.hidden = NO;
            _correctRecorder.view.hidden = NO;
            [self correctTitleLayout];
            [self setupAutoHeightWithBottomView:_answerRecorder.view bottomMargin:10];
        }
        if (_model.haveCorrectPhotos == YES && _model.haveCorrectRecord == NO) {
            _correctPhotosView.hidden = NO;
            _correctRecorder.view.hidden = YES;
            [self correctTitleLayout];
            [self setupAutoHeightWithBottomView:_correctPhotosView bottomMargin:10];
            
        }
        if (_model.haveCorrectPhotos == NO && _model.haveCorrectRecord == YES) {
            _correctPhotosView.hidden = YES;
            _correctRecorder.view.hidden = NO;
            _correctRecorder.view.sd_layout
            .topSpaceToView(_teacherCheckTitle, 10);
            [_correctRecorder.view updateLayout];
            [self correctTitleLayout];
            [self setupAutoHeightWithBottomView:_correctRecorder.view bottomMargin:10];
        }
        
    }
    //有图片没有语音
    if (_model.haveAnswerPhotos == YES && _model.haveAnswerRecord == NO) {
        _answerPhotosView.hidden = NO;
        _answerRecorder.view.hidden = YES;
        if (_model.haveCorrectPhotos == YES && _model.haveCorrectRecord == YES) {
            _correctPhotosView.hidden = NO;
            _correctRecorder.view.hidden = NO;
            [self correctTitleLayout];
            [self setupAutoHeightWithBottomView:_answerRecorder.view bottomMargin:10];
        }
        if (_model.haveCorrectPhotos == YES && _model.haveCorrectRecord == NO) {
            _correctPhotosView.hidden = NO;
            _correctRecorder.view.hidden = YES;
            [self correctTitleLayout];
            [self setupAutoHeightWithBottomView:_correctPhotosView bottomMargin:10];
            
        }
        if (_model.haveCorrectPhotos == NO && _model.haveCorrectRecord == YES) {
            _correctPhotosView.hidden = YES;
            _correctRecorder.view.hidden = NO;
            _correctRecorder.view.sd_layout
            .topSpaceToView(_teacherCheckTitle, 10);
            [_correctRecorder.view updateLayout];
            [self correctTitleLayout];
            [self setupAutoHeightWithBottomView:_correctRecorder.view bottomMargin:10];
        }
    }
    //有语音没图片
    if (_model.haveAnswerPhotos == NO && _model.haveAnswerRecord == YES) {
        _answerRecorder.view.sd_layout
        .topSpaceToView(_answerTitle, 10*ScrenScale);
        [_homeworkRecorder.view updateLayout];
        _answerPhotosView.hidden = YES;
        _answerRecorder.view.hidden = NO;
        if (_model.haveCorrectPhotos == YES && _model.haveCorrectRecord == YES) {
            _correctPhotosView.hidden = NO;
            _correctRecorder.view.hidden = NO;
            [self correctTitleLayout];
            [self setupAutoHeightWithBottomView:_answerRecorder.view bottomMargin:10];
        }
        if (_model.haveCorrectPhotos == YES && _model.haveCorrectRecord == NO) {
            _correctPhotosView.hidden = NO;
            _correctRecorder.view.hidden = YES;
            [self correctTitleLayout];
            [self setupAutoHeightWithBottomView:_correctPhotosView bottomMargin:10];
            
        }
        if (_model.haveCorrectPhotos == NO && _model.haveCorrectRecord == YES) {
            _correctPhotosView.hidden = YES;
            _correctRecorder.view.hidden = NO;
            _correctRecorder.view.sd_layout
            .topSpaceToView(_teacherCheckTitle, 10);
            [_correctRecorder.view updateLayout];
            [self correctTitleLayout];
            [self setupAutoHeightWithBottomView:_correctRecorder.view bottomMargin:10];
        }
        
    }
    
}

//"我的答案"标题位置确定
- (void)answerTitleLayout{
    if (_homeworkRecorder.view.hidden == NO) {
        _myLabel.sd_layout
        .topSpaceToView(_homeworkRecorder.view, 10);
        [_myLabel updateLayout];
    }else {
        if (_homeworkPhotosView.hidden == NO) {
            _myLabel.sd_layout
            .topSpaceToView(_homeworkPhotosView, 10);
            [_myLabel updateLayout];
        }else{
            _myLabel.sd_layout
            .topSpaceToView(_title, 10);
            [_myLabel updateLayout];
        }
    }
}

/** 老师批改 - 标题位置确定 */
- (void)correctTitleLayout{
    
    if (_answerRecorder.view.hidden == NO) {
        _teacherLabel.sd_layout
        .topSpaceToView(_answerRecorder.view, 10);
        [_teacherLabel updateLayout];
    }else {
        if (_correctPhotosView.hidden == NO) {
            _teacherLabel.sd_layout
            .topSpaceToView(_correctPhotosView, 10);
            [_teacherLabel updateLayout];
        }else{
            _teacherLabel.sd_layout
            .topSpaceToView(_answerTitle, 10);
            [_teacherLabel updateLayout];
        }
    }
}



#pragma mark- collectionview datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger items = 1;
    if (collectionView == _homeworkPhotosView) {
        if (_model.homeworkPhotos.count == 0) {
            items = 1;
        }else{
            items = _model.homeworkPhotos.count;
        }
        NSLog(@"homeworkPhotosView ; %ld",items);
    }else if (collectionView == _answerPhotosView){
        if (_model.myAnswerPhotos.count == 0) {
            items = 1;
        }else{
            items = _model.myAnswerPhotos.count;
        }
        NSLog(@"answerPhotosView ; %ld",items);
    }else if (collectionView == _correctPhotosView){
        if (_model.correctionPhotos.count == 0) {
            items = 1;
        }else{
            items = _model.correctionPhotos.count;
        }
        NSLog(@"correctPhotosView ; %ld",items);
    }
    
    return items;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cells;
    
    if (collectionView == _homeworkPhotosView) {
        
        static NSString * CellIdentifier = @"photoCell";
        QuestionPhotosCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (_model.homeworkPhotos.count>indexPath.item) {
            
            [cell.image sd_setImageWithURL:[NSURL URLWithString:_model.homeworkPhotos[indexPath.item][@"file_url"]]];
        }
        
        cell.deleteBtn.hidden = YES;
        cells = cell;
        
    }else if (collectionView == _answerPhotosView){
        
        static NSString * CellIdentifiers = @"answerPhotoCell";
        QuestionPhotosReuseCollectionViewCell * cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifiers forIndexPath:indexPath];
        
        if (_model.myAnswerPhotos.count>indexPath.item) {
            if ([_model.myAnswerPhotos[indexPath.item][@"file_type"] isEqualToString:@"png"]) {
                [cell2.image sd_setImageWithURL:[NSURL URLWithString:_model.myAnswerPhotos[indexPath.item][@"file_url"]]];
            }
        }
        cell2.deleteBtn.hidden = YES;
        cells = cell2;
    }else if (collectionView == _correctPhotosView){
        
        static NSString * CellIdentifiers = @"correctPhotoCell";
        QuestionPhotosReuseCollectionViewCell * cell3 = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifiers forIndexPath:indexPath];
        
        if (_model.correctionPhotos.count>indexPath.item) {
            if ([_model.correctionPhotos[indexPath.item][@"file_type"] isEqualToString:@"png"]) {
                [cell3.image sd_setImageWithURL:[NSURL URLWithString:_model.correctionPhotos[indexPath.item][@"file_url"]]];
            }
        }
        cell3.deleteBtn.hidden = YES;
        cells = cell3;
    }
    return cells;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((UIScreenWidth-20*ScrenScale-30)/5.f-2, (UIScreenWidth-20*ScrenScale-30)/5.f-2);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
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
    
    pickerBrowser.editing = NO;
    pickerBrowser.photos = photos;
    // 当前选中的值
    pickerBrowser.currentIndex = indexPath.row;
    
    // 展示控制器
    // 直接调到当前展示的那个控制器上去展示图片
    [_photoDelegate showPicker:pickerBrowser];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
