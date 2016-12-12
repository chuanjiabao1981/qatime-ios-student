//
//  WithdrawConfirmViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/12.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "WithdrawConfirmViewController.h"

@interface WithdrawConfirmViewController (){
    
    NSDictionary *_dataDic;
    
    
}


@end

@implementation WithdrawConfirmViewController

-(instancetype)initWithData:(NSDictionary *)datadic{
    
    self  =[super init];
    if (self) {
        
        
        _dataDic = [NSDictionary dictionaryWithDictionary:datadic];
        
        
    }
    return  self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
