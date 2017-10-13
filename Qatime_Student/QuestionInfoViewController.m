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
#import "QuestionPhotosCollectionViewCell.h"

@interface QuestionInfoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    Questions *_question;
    
    NavigationBar *_navBar;
    
    NSMutableArray *_questionPics;
    NSMutableArray *_answerPics;
    
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
    
    _questionPics = @[].mutableCopy;
    _answerPics = @[].mutableCopy;
    
}
- (void)setupView{
    self.view.backgroundColor = [UIColor whiteColor];
    _navBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navBar];
    [_navBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    _navBar.titleLabel.text = _question.course_name;
    _questionInfoView = [[QuestionInfoView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_questionInfoView];
    _questionInfoView.model = _question;
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
    
    _questionInfoView.photosView.delegate = self;
    _questionInfoView.photosView.dataSource = self;
    _questionInfoView.photosView.tag = 1;
    [_questionInfoView.photosView registerClass:[QuestionPhotosCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    
    _answerInfoView.photosView.delegate = self;
    _answerInfoView.photosView.dataSource = self;
    _answerInfoView.photosView.tag =2;
    [_answerInfoView.photosView registerClass:[QuestionPhotosCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger row = 0;
    if (collectionView.tag == 1) {
        row = _questionPics.count;
    }else if (collectionView.tag == 2){
        row = _answerPics.count;
    }
    return row;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *itemCell;
    if (collectionView.tag == 1) {
        
        static NSString * CellIdentifier = @"collectionCell";
        QuestionPhotosCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        if (_questionPics.count>indexPath.row) {
            
        }
        
        itemCell = cell;

    }else if (collectionView.tag == 2){
        static NSString * CellIdentifier = @"Cell";
        QuestionPhotosCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        if (_answerPics.count>indexPath.row) {
            
        }
        
        itemCell = cell;
    }
    
    return itemCell;
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
