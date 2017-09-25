//
//  DoHomeworkViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/9/13.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "DoHomeworkViewController.h"
#import "NavigationBar.h"
#import "UIViewController+ReturnLastPage.h"
#import "UIAlertController+Blocks.h"

@interface DoHomeworkViewController ()<UITextViewDelegate>{
    
    NavigationBar *_navBar;
    HomeworkInfo *_homework;
}

@end

@implementation DoHomeworkViewController

-(instancetype)initWithHomework:(HomeworkInfo *)homework{
    self = [super init];
    if (self) {
        _homework = homework;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
  
}

- (void)setupView{
    
    _navBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navBar];
    [_navBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    [_navBar.rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [_navBar.rightButton addTarget:self action:@selector(handinWork) forControlEvents:UIControlEventTouchUpInside];
    [_navBar.rightButton setupAutoSizeWithHorizontalPadding:10 buttonHeight:30];
    [_navBar.rightButton updateLayout];
    _navBar.titleLabel.text = @"做作业";
    self.view.backgroundColor = [UIColor whiteColor];
    _mainView = [[DoHomeworkView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.answers.delegate = self;
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_navBar, 0)
    .bottomSpaceToView(self.view, 0);
    
    if (_homework.myAnswerTitle) {
        _mainView.answers.text = _homework.myAnswerTitle;
    }
}


/** 提交作业 */
- (void)handinWork{
    
    [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"确定提交?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"提交"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex!=0) {
            
            _doHomework(_mainView.answers.text);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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
