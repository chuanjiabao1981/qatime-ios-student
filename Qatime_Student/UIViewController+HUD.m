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





/* HUD框 正在加载*/
- (void)loadingHUDStartLoadingWithTitle:(NSString *)hudTitle{
    
    
    /* HUD框 提示正在登陆*/
    self.loadingHUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.loadingHUD.mode = MBProgressHUDModeDeterminate;
    self.loadingHUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    [self.loadingHUD.label setText:hudTitle];
    
    self.loadingHUD.mode = MBProgressHUDModeIndeterminate;
    
    
}



/* HUD框 加载完成*/
- (void)loadingHUDStopLoadingWithTitle:(NSString *)hudTitle{
    
    [self.loadingHUD hideAnimated:YES ];
    
    self.endHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.endHUD.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    [self.endHUD.label setText:hudTitle];
    
    self.endHUD.mode = MBProgressHUDModeText;
    
    [self.endHUD showAnimated:YES];
    
    [self.endHUD hideAnimated:YES afterDelay:1 ];
    
    
}


@end
