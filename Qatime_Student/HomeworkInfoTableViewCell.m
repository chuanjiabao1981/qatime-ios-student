//
//  HomeworkInfoTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/12.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "HomeworkInfoTableViewCell.h"

@interface HomeworkInfoTableViewCell (){
    
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
        layout.itemSize = CGSizeMake((UIScreenWidth-20*ScrenScale-10)*0.5, (UIScreenWidth-20*ScrenScale-10)*0.5);
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
       
        _homeworkPhotosView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _homeworkPhotosView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_homeworkPhotosView];
        _homeworkPhotosView.sd_layout
        .leftSpaceToView(self.contentView, 10*ScrenScale)
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(_title, 10*ScrenScale)
        .heightIs((UIScreenWidth-20*ScrenScale-10)*0.5*3+20);
        
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
        .topSpaceToView(_title, 10*ScrenScale)
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
        
        _answerPhotosView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _answerPhotosView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_answerPhotosView];
        _answerPhotosView.sd_layout
        .leftSpaceToView(self.contentView, 10*ScrenScale)
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(_answerTitle, 10*ScrenScale)
        .heightIs((UIScreenWidth-20*ScrenScale-10)*0.5*3+20);
        
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
        
       
    }
    return self;
}

-(void)setModel:(HomeworkInfo *)model{
    
    _model = model;
    
    _title.text = model.body;
    
    //先判断老师留的作业有没有附件 有没有语音 ,有没有图片,有几个图片
    if (model.attachments) {
        for (NSDictionary *atts in model.attachments) {
            if (_havePhotos == NO) {
                if ([atts[@"file_type"]isEqualToString:@"png"]) {
                    _havePhotos = YES;
                }
            }
            if (_haveRecord == NO) {
                if ([atts[@"file_type"]isEqualToString:@"mp3"]) {
                    _haveRecord = YES;
                }
            }
            
        }
        
    }else{
        _havePhotos = NO;
        _haveRecord = NO;
    }
    
    //再判断学生做完作业之后,有没有图片有没有语音
    if (model.myAnswerPhotos) {
        _haveAnswerPhotos = YES;
    }else{
        _haveAnswerPhotos = NO;
    }
    if (model.myAnswerRecorderURL) {
        _haveAnswerRecord = YES;
    }else{
        _haveAnswerRecord = NO;
    }
    
    //最后再判断有没有批改
    if (![model.correction[@"attachments"] isEqual:[NSNull null]]) {
        
    }
    
    
    ////////////////////////////////////////////////////////
    
    if ([model.status isEqualToString:@"pending"]) {
        //未提交过作业
        if (model.edited == YES) {
            //如果已经写过答案了,那就把答案显示出来,别的不显示,可以再次编辑
            _status.hidden = YES;
            _myLabel.hidden = NO;
            _answerTitle.hidden = NO;
            _answerTitle.text = model.myAnswerTitle;
            
            _teacherLabel.hidden = YES;
            _teacherCheckTitle.hidden = YES;
            
            //判断老师的问题,是否有图片语音
            if (_havePhotos == YES && _haveRecord == YES ) {
                _homeworkPhotosView.hidden = NO;
                _homeworkRecorder.view.hidden = NO;
                _status.sd_layout
                .topSpaceToView(_homeworkRecorder.view, 10*ScrenScale);
                [_status updateLayout];
                
                [self haveAnswerdTheHomeWorkLayout];
            }
            
            
            if (_havePhotos == YES && _haveRecord == NO) {
                _homeworkPhotosView.hidden = NO;
                _homeworkRecorder.view.hidden = YES;
                _status.sd_layout
                .topSpaceToView(_homeworkPhotosView, 10*ScrenScale);
                [_status updateLayout];
                [self haveAnswerdTheHomeWorkLayout];
                
            }
            if (_havePhotos == NO && _haveRecord == YES) {
                
                _homeworkPhotosView.hidden = YES;
                _homeworkRecorder.view.hidden = NO;
                _homeworkRecorder.view.sd_layout
                .topSpaceToView(_title, 10*ScrenScale);
                [_homeworkRecorder.view updateLayout];
                _status.sd_layout
                .topSpaceToView(_homeworkRecorder.view, 10*ScrenScale);
                [_status updateLayout];
                
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
            if (_havePhotos == YES && _haveRecord == YES ) {
                _homeworkPhotosView.hidden = NO;
                _homeworkRecorder.view.hidden = NO;
                _status.sd_layout
                .topSpaceToView(_homeworkRecorder.view, 10*ScrenScale);
                [_status updateLayout];
            }
            
            if (_havePhotos == YES && _haveRecord == NO) {
                _homeworkPhotosView.hidden = NO;
                _homeworkRecorder.view.hidden = YES;
                _status.sd_layout
                .topSpaceToView(_homeworkPhotosView, 10*ScrenScale);
                [_status updateLayout];
                
            }
            if (_havePhotos == NO && _haveRecord == YES) {
                
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
        
        
    }else if ([model.status isEqualToString:@"submitted"]){
        //如果已经是提交过的作业,而且还没有批改的,只能看
        _status.hidden = YES;
        _myLabel.hidden = NO;
        _answerTitle.hidden = NO;
        
        _teacherLabel.hidden = YES;
        _teacherCheckTitle.hidden = YES;
        
        
        //这部分,根据音频/图片数据判断
        //判断老师的问题,是否有图片语音  换汤不换药.一样.
        if (_havePhotos == YES && _haveRecord == YES ) {
            _homeworkPhotosView.hidden = NO;
            _homeworkRecorder.view.hidden = NO;
            _status.sd_layout
            .topSpaceToView(_homeworkRecorder.view, 10*ScrenScale);
            [_status updateLayout];
            
            [self haveAnswerdTheHomeWorkLayout];
        }
        
        
        if (_havePhotos == YES && _haveRecord == NO) {
            _homeworkPhotosView.hidden = NO;
            _homeworkRecorder.view.hidden = YES;
            _status.sd_layout
            .topSpaceToView(_homeworkPhotosView, 10*ScrenScale);
            [_status updateLayout];
            [self haveAnswerdTheHomeWorkLayout];
            
        }
        if (_havePhotos == NO && _haveRecord == YES) {
            
            _homeworkPhotosView.hidden = YES;
            _homeworkRecorder.view.hidden = NO;
            _homeworkRecorder.view.sd_layout
            .topSpaceToView(_title, 10*ScrenScale);
            [_homeworkRecorder.view updateLayout];
            _status.sd_layout
            .topSpaceToView(_homeworkRecorder.view, 10*ScrenScale);
            [_status updateLayout];
            
            [self haveAnswerdTheHomeWorkLayout];
        }
        _status.text = @" ";
        _answerTitle.text = model.myAnswerTitle; //暂时这么写
        [self setupAutoHeightWithBottomView:_answerTitle bottomMargin:10*ScrenScale];
        
    }else if ([model.status isEqualToString:@"resolved"]){
        //已经批改过的 啥都显示啥都能看
        //注意  暂时还没有老师的批改带图片语音的....
        
        _status.hidden = YES;
        _myLabel.hidden = NO;
        _answerTitle.hidden = NO;
        _teacherLabel.hidden = NO;
        _teacherCheckTitle.hidden = NO;
       
        //这部分,根据音频/图片数据判断
        //判断老师的问题,是否有图片语音
        if (_havePhotos == YES && _haveRecord == YES ) {
            _homeworkPhotosView.hidden = NO;
            _homeworkRecorder.view.hidden = NO;
            _status.sd_layout
            .topSpaceToView(_homeworkRecorder.view, 10*ScrenScale);
            [_status updateLayout];
            
            
        }
        
        
        if (_havePhotos == YES && _haveRecord == NO) {
            _homeworkPhotosView.hidden = NO;
            _homeworkRecorder.view.hidden = YES;
            _status.sd_layout
            .topSpaceToView(_homeworkPhotosView, 10*ScrenScale);
            [_status updateLayout];
            [self haveAnswerdTheHomeWorkLayout];
            
        }
        if (_havePhotos == NO && _haveRecord == YES) {
            
            _homeworkPhotosView.hidden = YES;
            _homeworkRecorder.view.hidden = NO;
            _homeworkRecorder.view.sd_layout
            .topSpaceToView(_title, 10*ScrenScale);
            [_homeworkRecorder.view updateLayout];
            _status.sd_layout
            .topSpaceToView(_homeworkRecorder.view, 10*ScrenScale);
            [_status updateLayout];
            
            [self haveAnswerdTheHomeWorkLayout];
        }
        
        _teacherLabel.sd_layout
        .topSpaceToView(_answerTitle, 10*ScrenScale);
        [_teacherLabel updateLayout];
        
        _answerTitle.text = model.myAnswerTitle;
        _teacherCheckTitle.text = model.correction;
        [self setupAutoHeightWithBottomView:_teacherCheckTitle bottomMargin:10*ScrenScale];
    }
    
}


//1.已经写过答案的问题,的什么什么逻辑.
- (void)haveAnswerdTheHomeWorkLayout{
    //嵌套判断
    //学生做完作业了 有图片和语音
    if (_haveAnswerPhotos == YES && _haveAnswerRecord == YES) {
        _answerPhotosView.hidden = NO;
        _answerRecorder.view.hidden = NO;
        [self setupAutoHeightWithBottomView:_answerRecorder.view bottomMargin:10*ScrenScale];
    }
    //有图片没有语音
    if (_haveAnswerPhotos == YES && _haveAnswerRecord == NO) {
        _answerPhotosView.hidden = NO;
        _answerRecorder.view.hidden = YES;
        [self setupAutoHeightWithBottomView:_answerPhotosView bottomMargin:10*ScrenScale];
    }
    //有语音没图片
    if (_haveAnswerPhotos == NO && _haveAnswerRecord == YES) {
        _answerRecorder.view.sd_layout
        .topSpaceToView(_answerTitle, 10*ScrenScale);
        [_homeworkRecorder.view updateLayout];
        _answerPhotosView.hidden = YES;
        _answerRecorder.view.hidden = YES;
        [self setupAutoHeightWithBottomView:_answerRecorder.view bottomMargin:10*ScrenScale];
    }
    
}

- (void)haveAnswerdTheHomeWorkAndHaveCorrectedLayout{
    
    //嵌套判断 + 嵌套判断
    //学生做完作业了 有图片和语音
    if (_haveAnswerPhotos == YES && _haveAnswerRecord == YES) {
        _answerPhotosView.hidden = NO;
        _answerRecorder.view.hidden = NO;
        
        if (_haveCorrectPhotos == YES && _haveCorrectRecord == YES) {
            
        }
        if (_haveCorrectPhotos == YES && _haveCorrectRecord == NO) {
            
        }
        if (_haveCorrectPhotos == NO && _haveCorrectRecord == YES) {
            
        }
      
    }
    //有图片没有语音
    if (_haveAnswerPhotos == YES && _haveAnswerRecord == NO) {
        _answerPhotosView.hidden = NO;
        _answerRecorder.view.hidden = YES;
     
    }
    //有语音没图片
    if (_haveAnswerPhotos == NO && _haveAnswerRecord == YES) {
        _answerRecorder.view.sd_layout
        .topSpaceToView(_answerTitle, 10*ScrenScale);
        [_homeworkRecorder.view updateLayout];
        _answerPhotosView.hidden = YES;
        _answerRecorder.view.hidden = NO;
        
        
       
    }
    
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
