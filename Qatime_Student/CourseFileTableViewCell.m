//
//  CourseFileTableViewCell.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/5.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "CourseFileTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation CourseFileTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _fileImage = [[UIImageView alloc]init];
        [self.contentView addSubview:_fileImage];
        _fileImage.sd_layout
        .leftSpaceToView(self.contentView, 10*ScrenScale)
        .topSpaceToView(self.contentView, 10*ScrenScale)
        .bottomSpaceToView(self.contentView, 10*ScrenScale)
        .widthEqualToHeight();
        _fileImage.sd_cornerRadius = @(M_PI);
        
        _name = [[UILabel alloc]init];
        [self.contentView addSubview: _name];
        _name.sd_layout
        .leftSpaceToView(_fileImage, 5*ScrenScale)
        .topEqualToView(_name)
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
        _info.sd_layout
        .leftSpaceToView(_size, 10*ScrenScale)
        .bottomEqualToView(_size)
        .rightSpaceToView(self.contentView, 10*ScrenScale)
        .autoHeightRatio(0);
        _info.font = TEXT_FONTSIZE_MIN;
        _info.textColor = TITLECOLOR;
        
        
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
    
    _name.text = model.name;
    _info.text = [NSString stringWithFormat:@"%@  上传时间:%@",[self switchFileSize:model.file_size],@""];
    
}

- (NSString *)switchFileSize:(NSString *)bitSize{
    
    NSString *sizeString;
    
    NSNumber *fileSize = [NSNumber numberWithLong:[bitSize longLongValue]];
    CGFloat size = [fileSize unsignedLongLongValue];
    NSString *sizestr = [NSString stringWithFormat:@"%qi",[fileSize unsignedLongLongValue]];
    //            NSLog(@"File size: %@\n",fileSize);
    if (sizestr.length <=3) {
        sizeString = [NSString stringWithFormat:@"%.1f B",size];
    } else if(sizestr.length>3 && sizestr.length<7){
        sizeString = [NSString stringWithFormat:@"%.1f KB",size/1000.0];
    }else{
        sizeString = [NSString stringWithFormat:@"%.1f M",size/(1000.0 * 1000)];
    }
    return sizeString;
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
