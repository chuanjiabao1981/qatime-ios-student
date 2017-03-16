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
#import "ClassSubjectCollectionViewCell.h"

@interface ChooseClassViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    
    NSString *_token;
    NSString *_idNumber;
    
    
    NSString *_grade;
    NSString *_subject;
    NavigationBar *_navigationBar;
    
    //弹窗蒙版
    SnailQuickMaskPopups *_pops;
    
    //筛选tag的存放数组
    NSArray *tags ;
    
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
    tags = @[@"不限",@"高考",@"中考",@"会考",@"小升初考试",@"高考志愿",@"英语考级",@"奥数竞赛",@"历年真题",@"期中期末试卷",@"自编试题",@"暑假课",@"寒假课",@"周末课",@"国庆假期课",@"基础课",@"巩固课",@"提高课",@"外教",@"冲刺",@"重点难点"];
    
    
    
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




#pragma mark- collectionview datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return tags.count;
    
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"CollectionCell";
    ClassSubjectCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.subject.text = tags[indexPath.row];
    cell.subject.font = [UIFont systemFontOfSize:14*ScrenScale];
    return cell;

    
}

#pragma mark- collectionview delegate
//item间距
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(20, 20, 0, 20);
}

//行距
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 20;
}

//点击选择
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [_filterView.tagsButton setTitle:tags[indexPath.row] forState:UIControlStateNormal];
    
    //蒙版消失之后 ,执行操作
    [_pops dismissWithAnimated:YES completion:^(BOOL finished, SnailQuickMaskPopups * _Nonnull popups) {
        
    }];
    
    
}





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
    
    [_filterView.tagsButton addTarget:self action:@selector(chooseTags:) forControlEvents:UIControlEventTouchUpInside];
    
}

//选择标签按钮
- (void)chooseTags:(UIButton *)sender{
    
    _pops = [SnailQuickMaskPopups popupsWithMaskStyle:MaskStyleBlackTranslucent aView:self.tagsFilterView];
    
    //已选过 和未选过的情况
    if (![sender.titleLabel.text isEqualToString:@"标签"]) {
        //把tag选项表的所有按钮遍历成未选中状态
        NSInteger index = 0;
        for (NSString *title in tags) {
            
            if ([sender.titleLabel.text isEqualToString:title]) {
                
                ClassSubjectCollectionViewCell *cell = [_tagsFilterView.tagsCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
                
                cell.subject.textColor = [UIColor whiteColor];
                cell.subject.backgroundColor = [UIColor orangeColor];
                cell.subject.layer.borderColor = [UIColor orangeColor].CGColor;
                
            }else{
                ClassSubjectCollectionViewCell *cell = [_tagsFilterView.tagsCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
                
                cell.subject.textColor = TITLECOLOR;
                cell.subject.backgroundColor = [UIColor whiteColor];
                cell.subject.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0].CGColor;
                
            }
            
            
            index ++;
        }
        

    }else{
        
        ClassSubjectCollectionViewCell *cell = [_tagsFilterView.tagsCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        cell.subject.textColor = [UIColor whiteColor];
        cell.subject.backgroundColor = [UIColor orangeColor];
        cell.subject.layer.borderColor = [UIColor orangeColor].CGColor;
        
    }
    

    
    [_pops presentWithAnimated:self completion:^(BOOL finished, SnailQuickMaskPopups * _Nonnull popups) {
        
    }];
}


//懒加载标签筛选列表
-(TagsFilterView *)tagsFilterView{
    
    if (!_tagsFilterView) {
        
        _tagsFilterView = [[TagsFilterView alloc]initWithFrame:CGRectMake(40, 120, self.view.width_sd-80, (self.view.width_sd-80)*1.6)];
        _tagsFilterView.backgroundColor = [UIColor whiteColor];
        
        _tagsFilterView.tagsCollection.delegate = self;
        _tagsFilterView.tagsCollection.dataSource = self;
        
        [_tagsFilterView.tagsCollection registerClass:[ClassSubjectCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
        
    }
    
    return _tagsFilterView;
    
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
