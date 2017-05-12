//
//  UIViewController+HUD.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "UIViewController+HUD.h"

static const void *loadingHUDKey = &loadingHUDKey;

static const void *endHUDKey = &endHUDKey;

@implementation UIViewController (HUD)


-(void)setLoadingHUD:(MBProgressHUD *)loadingHUD{
    
    objc_setAssociatedObject(self, loadingHUDKey, loadingHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(MBProgressHUD *)loadingHUD{
    
    return objc_getAssociatedObject(self, loadingHUDKey);
}

-(void)setEndHUD:(MBProgressHUD *)endHUD{
    
    objc_setAssociatedObject(self,endHUDKey , endHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(MBProgressHUD *)endHUD{
    
    return objc_getAssociatedObject(self, endHUDKey);
}



- (void)HUDStartWithTitle:(NSString * _Nullable)hudTitle{
            
        /* HUD框 提示*/
        self.loadingHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.loadingHUD.mode = MBProgressHUDModeDeterminate;
        //    self.loadingHUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        [self.loadingHUD setLabelText:hudTitle];
        self.loadingHUD.mode = MBProgressHUDModeIndeterminate;
        self.loadingHUD.labelFont = [UIFont systemFontOfSize:14*ScrenScale];
    
}



/* HUD框 加载完成*/
- (void)HUDStopWithTitle:(NSString * _Nullable)hudTitle{
    
    if (hudTitle == nil) {
        
         [self.loadingHUD hide:YES];
    }else{
        
        [self.loadingHUD hide:YES ];
        self.endHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //    self.endHUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        [self.endHUD setLabelText:hudTitle];
        self.endHUD.mode = MBProgressHUDModeText;
        [self.endHUD show:YES];
        [self.endHUD hide:YES afterDelay:1 ];
        self.endHUD.labelFont = [UIFont systemFontOfSize:14*ScrenScale];
    }
    
    
}

- (void)stopHUD{
    
    [self.loadingHUD hide:YES];
    
}





@end
