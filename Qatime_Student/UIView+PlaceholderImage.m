//
//  UIView+PlaceholderImage.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/29.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "UIView+PlaceholderImage.h"

static const void *placeholderImagekey = &placeholderImagekey;

@implementation UIView (PlaceholderImage)

-(void)makePlaceHolderImage:(UIImage * _Nullable)image{
    
    if ([self.subviews containsObject:self.placeholderImage]) {
        if (image!=nil) {
            [self.placeholderImage setImage:image];
        }else{
            [self.placeholderImage removeFromSuperview];
        }
    }else{
        
        if (image == nil) {
            
        }else{
            self.placeholderImage = [[UIImageView alloc]initWithImage:image];
            
            [self addSubview:self.placeholderImage];
            self.placeholderImage.sd_layout
            .leftSpaceToView(self, 0)
            .rightSpaceToView(self, 0)
            .topSpaceToView(self, 0)
            .bottomSpaceToView(self, 0);
            [self.placeholderImage updateLayout];
        }
    }
    
}


-(void)setPlaceholderImage:(UIImageView *)placeholderImage{
    
      objc_setAssociatedObject(self, placeholderImagekey, placeholderImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(UIImageView *)placeholderImage{
    
     return objc_getAssociatedObject(self, placeholderImagekey);
    
}
@end
