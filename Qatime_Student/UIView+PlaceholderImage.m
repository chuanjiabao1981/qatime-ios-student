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
    
    if (image!=nil) {
        
        self.placeholderImage = [[UIImageView alloc]initWithImage:image];
        self.placeholderImage.frame = self.bounds;
        [self addSubview:self.placeholderImage];
        
    }else{
        for (UIImageView *view in self.subviews) {
            if ([view isEqual:self.placeholderImage ]) {
                [self.placeholderImage removeFromSuperview];
            }
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
