//
//  UIViewController+HUD.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/7.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "UIViewController+HUD.h"

@implementation UIViewController (HUD)

- (MBProgressHUD *)loadingHUD{
    MBProgressHUD *hud=[MBProgressHUD HUDForView:self.view];
    return hud;
}

-(MBProgressHUD *)endHUD{
    MBProgressHUD *hud=[MBProgressHUD HUDForView:self.view];
    return hud;
}


- (void)setLoadingHUD:(MBProgressHUD *)loadingHUD{
    
    
}

- (void)setEndHUD:(MBProgressHUD *)endHUD{
    
    
}


- (void)loadingHUDStartLoadingWithTitle:(NSString *)hudTitle{
    
    /* HUD框 提示*/
    self.loadingHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadingHUD.mode = MBProgressHUDModeDeterminate;
    //    self.loadingHUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    [self.loadingHUD setLabelText:hudTitle];
    self.loadingHUD.mode = MBProgressHUDModeIndeterminate;
    self.loadingHUD.labelFont = [UIFont systemFontOfSize:14];
    
}



/* HUD框 加载完成*/
- (void)loadingHUDStopLoadingWithTitle:(NSString *)hudTitle{
    [self.loadingHUD hide:YES ];
    self.endHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    self.endHUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    [self.endHUD setLabelText:hudTitle];
    self.endHUD.mode = MBProgressHUDModeText;
    [self.endHUD show:YES];
    [self.endHUD hide:YES afterDelay:1 ];
    self.endHUD.labelFont = [UIFont systemFontOfSize:14];
    
}







@end
