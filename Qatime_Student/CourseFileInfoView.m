//
//  CourseFileInfoView.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/5.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "CourseFileInfoView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NSString+TimeStamp.h"

@implementation CourseFileInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _fileImage = [[UIImageView alloc]init];
        [self addSubview:_fileImage];
        _fileImage.sd_layout
        .topSpaceToView(self, 105*ScrenScale)
        .centerXEqualToView(self)
        .widthIs(77*ScrenScale)
        .heightEqualToWidth();
        _fileImage.sd_cornerRadius = @(M_PI);
        
        _fileName = [[UILabel alloc]init];
        [self addSubview:_fileName];
        _fileName.textColor = [UIColor blackColor];
        _fileName.font = TITLEFONTSIZE;
        _fileName.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(_fileImage, 15*ScrenScale)
        .autoHeightRatio(0);
        [_fileName setSingleLineAutoResizeWithMaxWidth:2000];
        
        _fileSize = [[UILabel alloc]init];
        [self addSubview:_fileSize];
        _fileSize.font = TEXT_FONTSIZE;
        _fileSize.textColor = TITLECOLOR;
        _fileSize.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(_fileName, 20*ScrenScale)
        .autoHeightRatio(0);
        [_fileSize setSingleLineAutoResizeWithMaxWidth:1000];
        
        
        _created_at = [[UILabel alloc]init];
        [self addSubview:_created_at];
        _created_at.font = TEXT_FONTSIZE;
        _created_at.textColor = TITLECOLOR;
        _created_at.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(_fileSize, 10*ScrenScale)
        .autoHeightRatio(0);
        [_created_at setSingleLineAutoResizeWithMaxWidth:1000];
        
        _downloadBtn = [[UIButton alloc]init];
        [self addSubview:_downloadBtn];
        [_downloadBtn setBackgroundColor:BUTTONRED];
        [_downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_downloadBtn setTitle:@"下载至手机" forState:UIControlStateNormal];
        _downloadBtn.titleLabel.font = TEXT_FONTSIZE;
        
        _downloadBtn.sd_layout
        .topSpaceToView(_created_at, 50*ScrenScale)
        .centerXEqualToView(self);
        [_downloadBtn setupAutoSizeWithHorizontalPadding:60*ScrenScale buttonHeight:40];
        _downloadBtn.sd_cornerRadius = @(M_PI);
        
        _downloadProgress = [[UILabel alloc]init];
        _downloadProgress.font = TEXT_FONTSIZE_MIN;
        _downloadProgress.textColor = [UIColor blackColor];
        _downloadProgress.text = @"下载中...";
        [self addSubview:_downloadProgress];
        _downloadProgress.sd_layout
        .topSpaceToView(_created_at, 50*ScrenScale)
        .centerXEqualToView(self)
        .autoHeightRatio(0);
        [_downloadProgress setSingleLineAutoResizeWithMaxWidth:1000];
        [_downloadProgress updateLayout];
        
        _progressBar =[[M13ProgressViewBar alloc]initWithFrame:CGRectZero];
        _progressBar.progressDirection = M13ProgressViewBarProgressDirectionLeftToRight;
        _progressBar.showPercentage = YES;
        _progressBar.percentagePosition = M13ProgressViewBarPercentagePositionTop;
        _progressBar.primaryColor = BUTTONRED;
        [self addSubview:_progressBar];
        _progressBar.sd_layout
        .topSpaceToView(_downloadProgress, 15*ScrenScale)
        .centerXEqualToView(self)
        .leftSpaceToView(self, 40*ScrenScale320)
        .rightSpaceToView(self, 40*ScrenScale320)
        .heightIs(5);
        _downloadProgress.hidden = YES;
        _progressBar.hidden = YES;
        
    }
    return self;
}

-(void)setModel:(CourseFile *)model{
    
    _model = model;
    if ([model.type isEqualToString:@"Resource::DocumentFile"]) {
        if ([model.ext_name.lowercaseString isEqualToString:@"doc"]||[model.ext_name.lowercaseString isEqualToString:@"docx"]) {
            _fileImage.image = [UIImage imageNamed:@"word"];
        }else if ([model.ext_name.lowercaseString isEqualToString:@"xls"]||[model.ext_name.lowercaseString isEqualToString:@"xlsx"]){
            _fileImage.image = [UIImage imageNamed:@"excel"];
        }else if ([model.ext_name.lowercaseString isEqualToString:@"ppt"]||[model.ext_name.lowercaseString isEqualToString:@"pptx"]){
            _fileImage.image = [UIImage imageNamed:@"ppt"];
        }else if ([model.ext_name.lowercaseString isEqualToString:@"pdf"]){
            _fileImage.image = [UIImage imageNamed:@"pdf"];
        }
    }else if ([model.type isEqualToString:@"Resource::PictureFile"]){
        if ([model.ext_name.lowercaseString isEqualToString:@"png"]||[model.ext_name.lowercaseString isEqualToString:@"jpg"]) {
            [_fileImage sd_setImageWithURL:[NSURL URLWithString:model.file_url]];
        }
    }else if ([model.type isEqualToString:@"Resource::VideoFile"]){
        if ([model.ext_name.lowercaseString isEqualToString:@"mp4"]) {
            MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:model.file_url]];
            player.shouldAutoplay = NO;
            UIImage *thumbnail = [player thumbnailImageAtTime:1 timeOption:MPMovieTimeOptionNearestKeyFrame];
            _fileImage.image = thumbnail;
        }
        
    }else if ([model.type isEqualToString:@"Resource::OtherFile"]){
        _fileImage.image = [UIImage imageNamed:@"未知"];
    }
    
    if (model.name) {
        _fileName.text = model.name;
    }else{
        _fileName.text = [NSString stringWithFormat:@"%@",model.fileID];
    }
    
    _fileSize.text = [self switchFileSize:model.file_size];
    _created_at.text = [NSString stringWithFormat:@"上传时间:%@",[model.created_at changeTimeStampToDateString]];
 
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



@end
