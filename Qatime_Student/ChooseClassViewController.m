//
//  ChooseClassViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/3/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "ChooseClassViewController.h"
#import "NavigationBar.h"
#import "UIViewController+AFHTTP.h"
#import "QualityTableViewCell.h"
#import "MJRefresh.h"

@interface ChooseClassViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSString *_token;
    NSString *_idNumber;
    
    
    NSString *_grade;
    NSString *_subject;
    NavigationBar *_navigationBar;
    
    //存课程数据的数组
    NSMutableArray *_classesArray;
    
    

}

@end

@implementation ChooseClassViewController

-(instancetype)initWithGrade:(NSString *)grade andSubject:(NSString *)subject{
    
    self = [super init];
    
    if (self) {
        
        _grade = grade;
        _subject = subject;
        
    }
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化数据
    _classesArray = @[].mutableCopy;
    
    //导航栏
    [self setupNavigation];
    
    //token
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    //加载tableview
    [self setupMainView];
    
    //首次下拉刷新页面
    [_classTableView.mj_header  beginRefreshingWithCompletionBlock:^{
       
        //加载数据
        [self requestClass];
    }];
    
    
   

    
    
    
}





//加载数据
- (void)requestClass{
    
    NSDictionary *filDic ;
    if ([_subject isEqualToString:@"全部"]) {
        
        filDic = @{@"grade":_grade};
    }else{
        filDic = @{@"subject":_subject,@"grade":_grade};
    }
    
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/courses",Request_Header] withHeaderInfo:nil andHeaderfield:nil parameters:filDic completeSuccess:^(id  _Nullable responds) {
       
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            
            
            
            
            [_classTableView.mj_header endRefreshingWithCompletionBlock:^{
               
                [_classTableView reloadData];
                
            }];
            
        }else{
            //获取数据失败
        }
        
    }];
    
    
    
}

#pragma mark- tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_classesArray.count>0) {
        return _classesArray.count;
    }
    
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    QualityTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[QualityTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (_classesArray.count>indexPath.row) {
        
    }
    
    return  cell;
    
}


#pragma mark- tableview delegate






//加载主视图
- (void)setupMainView{
    
    _classTableView = ({
    
        UITableView *_ =[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_filterView.frame), self.view.width_sd, self.view.height_sd-CGRectGetMaxY(_filterView.frame)) style:UITableViewStylePlain];
        [self.view addSubview:_];
        _.backgroundColor = [UIColor whiteColor];
        _.delegate = self;
        _.dataSource = self;
        _.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //下拉刷新
        
        _.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           
            
            
            
            
        }];
        
        
    
        _;
    });
    
}


//加载navigation
- (void)setupNavigation{
    
    _navigationBar = ({
        NavigationBar *_ =[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
        [self.view addSubview:_];

        _.titleLabel.text = [NSString stringWithFormat:@"%@%@",_grade,_subject];
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        _;

    });
    
    _filterView = [[ClassFilterView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_navigationBar.frame), self.view.width_sd, 40)];
    
    [self.view addSubview:_filterView];
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
