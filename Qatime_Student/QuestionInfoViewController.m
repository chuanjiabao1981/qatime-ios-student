//
//  QuestionInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/21.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "QuestionInfoViewController.h"
#import "Questions.h"
#import "NavigationBar.h"
#import "UIViewController+ReturnLastPage.h"
@interface QuestionInfoViewController (){
    
    Questions *_question;
    
    NavigationBar *_navBar;
}

@end

@implementation QuestionInfoViewController

-(instancetype)initWithQuestion:(Questions *)question{
    self = [super init];
    if (self) {
        _question = question;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeData];
    [self setupView];
    
}

- (void)makeData{
    
}
- (void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    _navBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navBar];
    [_navBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    _navBar.titleLabel.text = _question.course_name;
    _questionInfoView = [[QuestionInfoView alloc]init];
    [self.view addSubview:_questionInfoView];
    [_questionInfoView setQuestionModWithModel:_question];
    _questionInfoView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(_navBar, 0)
    .rightSpaceToView(self.view, 0);
    [_questionInfoView updateLayout];
    
    UIView *line = [[UIView alloc]init];
    [self.view addSubview:line];
    line.backgroundColor = SEPERATELINECOLOR_2;
    line.sd_layout
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_questionInfoView, 0)
    .heightIs(0.5);
    
    _answerInfoView = [[AnswerInfoView alloc]init];
    [self.view addSubview:_answerInfoView];
    _answerInfoView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(line, 0)
    .rightSpaceToView(self.view,0);
    
    if (_question.answer) {
        _answerInfoView.hidden = NO;
        _answerInfoView.model = _question.answer;
        [_answerInfoView updateLayout];
    }else{
        _answerInfoView.hidden = YES;
    }
    
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
