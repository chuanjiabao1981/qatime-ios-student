//
//  CourseFileTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/5.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "CourseFileTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NSString+TimeStamp.h"

@implementation CourseFileTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _fileImage = [[UIImageView alloc]init];
        [self.contentView addSubview:_fileImage];
        _fileImage.sd_layout
        .leftSpaceToView(self.contentView, 15*ScrenScale)
        .topSpaceToView(self.contentView, 15*ScrenScale)
        .bottomSpaceToView(self.contentView, 15*ScrenScale)
        .widthEqualToHeight();
        _fileImage.sd_cornerRadius = @2;
        
        _name = [[UILabel alloc]init];
        [self.contentView addSubview: _name];
        _name.sd_layout
        .leftSpaceToView(_fileImage, 10*ScrenScale)
        .topEqualToView(_fileImage)
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .autoHeightRatio(0);
        [_name setMaxNumberOfLinesToShow:1];
        _name.font = TEXT_FONTSIZE;
        _name.textColor = [UIColor blackColor];
        
        _size = [[UILabel alloc]init];
        [self.contentView addSubview:_size];
        _size.sd_layout
        .leftEqualToView(_name)
        .bottomEqualToView(_fileImage)
        .autoHeightRatio(0);
        [_size setSingleLineAutoResizeWithMaxWidth:1000];
        _size.font = TEXT_FONTSIZE_MIN;
        _size.textColor = TITLECOLOR;
        
        _info = [[UILabel alloc]init];
        [self.contentView addSubview:_info];
        _info.font = TEXT_FONTSIZE_MIN;
        _info.textColor = TITLECOLOR;
        
        _info.sd_layout
        .bottomEqualToView(_size)
        .leftSpaceToView(_size, 20*ScrenScale)
        .autoHeightRatio(0);
        [_info setSingleLineAutoResizeWithMaxWidth:1000];
        
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
        _name.text = model.name;
    }else{
        _name.text = [NSString stringWithFormat:@"%@",model.fileID];
    }
    
    _size.text = [self switchFileSize:model.file_size];
    _info.text = [NSString stringWithFormat:@"上传时间:%@",[model.created_at changeTimeStampToDateString]];
    
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


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
