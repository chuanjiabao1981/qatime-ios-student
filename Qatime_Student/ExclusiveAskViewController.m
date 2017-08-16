//
//  ExclusiveAskViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ExclusiveAskViewController.h"
#import "NavigationBar.h"
#import "YYModel.h"
#import "Questions.h"
#import "Qatime_Student-Swift.h"
#import "HMSegmentedControl+Category.h"
#import "NewQuestionViewController.h"


@interface ExclusiveAskViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NavigationBar *_navigationBar;
    
    NSString *_classID;
    
    NSMutableArray *_questionsArray;
    
}

@end

@implementation ExclusiveAskViewController

-(instancetype)initWithClassID:(NSString *)classID{
    self = [super init];
    if (self) {
        
        _classID = classID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self makeData];
    
    [self setupViews];
    
    
}

- (void)makeData{
    _questionsArray = @[].mutableCopy;
    
    NSDictionary *dic = @{@"title":@"如何长高?",
                          @"name":@"王牡丹",
                          @"creat_at":@"2017-08-23 23:00:00",
                          @"resolve":@"false"};
    NSDictionary *dic2 = @{@"title":@"如何长高?",
                           @"name":@"王牡丹",
                           @"creat_at":@"2017-08-23 23:00:00",
                           @"resolve":@"true"};
    NSDictionary *dic3 = @{@"title":@"如何长高?",
                           @"name":@"王牡丹",
                           @"creat_at":@"2017-08-23 23:00:00",
                           @"resolve":@"false"};
    
    NSArray *ques = @[dic,dic2,dic3];
    for (NSDictionary *dic in ques) {
        
        Questions *mod = [Questions yy_modelWithJSON:dic];
        [_questionsArray addObject:mod];
    }
    
    
}

- (void)setupViews{
    
    //navigation
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview: _navigationBar];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    _navigationBar.titleLabel.text = @"课程提问";
    [_navigationBar.rightButton setImage:[UIImage imageNamed:@"加"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar.rightButton addTarget:self action:@selector(newQuestion) forControlEvents:UIControlEventTouchUpInside];
    
    //mainView
    _mainView = [[ExclusiveAskView alloc]init];
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(_navigationBar, 0)
    .bottomSpaceToView(self.view, 0);
    
    _mainView.allQuestionsList.delegate = self;
    _mainView.allQuestionsList.dataSource = self;
    _mainView.myQuestionsList.delegate = self;
    _mainView.myQuestionsList.dataSource = self;
    
    _mainView.scrollView.delegate = self;
    
}

#pragma mark- UITableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _questionsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    QuestionsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[QuestionsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    [cell setModelWithModel:_questionsArray[indexPath.row]];
    
    return  cell;
    
}



#pragma mark- UITableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _mainView.scrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger pages = scrollView.contentOffset.x / pageWidth;
        
        [self.mainView.segmentControl setSelectedSegmentIndex:pages animated:YES];
        
    }

    
}


/** 添加新问题 */
- (void)newQuestion{
    
    NewQuestionViewController *controller = [[NewQuestionViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
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
