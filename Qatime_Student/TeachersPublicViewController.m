//
//  TeachersPublicViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/9.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "TeachersPublicViewController.h"
#import "NavigationBar.h"
#import "TeachersPublicInfo.h"
#import "YYModel.h"
#import "UIImageView+WebCache.h"
#import "TeacherPublicClassCollectionViewCell.h"
#import "TeachersPublic_Classes.h"
 
#import "TutoriumInfoViewController.h"
#import "NSString+ChangeYearsToChinese.h"

#import "UIViewController+AFHTTP.h"
#import "UIViewController+HUD.h"

@interface TeachersPublicViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>{
    
    /* 头视图*/
    TeachersPublicHeaderView *_teachersPublicHeaderView ;
    
    NavigationBar *_navigationBar;
    
    /* 教师公开信息model*/
    TeachersPublicInfo *_teacherPublicInfo;
    
    /* 教师课程存放的数组*/
    NSMutableArray *_publicClasses;
    
    TeachersPublic_Classes *_teacherPublicClass;
    
    UICollectionViewFlowLayout *_flowLayout;
    
    /* 头视图的尺寸*/
    CGSize headerSize;
    
}

@end

@implementation TeachersPublicViewController

- (instancetype)initWithTeacherID:(NSString *)teacherID
{
    self = [super init];
    if (self) {
        
        _teacherID = @"".mutableCopy;
        _teacherID  = teacherID;
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化数据
     _publicClasses = @[].mutableCopy;
    
    /* 请求教师个人详情*/
    [self requestTeachersInfoWithID:_teacherID];
    
    
    
}

//加载视图
- (void)setupViews{
    
    [self loadingHUDStartLoadingWithTitle:nil];
    
    //比较特殊的导航栏
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
//    _navigationBar.contentView.backgroundColor = [UIColor clearColor];
//    [_navigationBar.leftButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
//    _navigationBar.leftButton.layer.masksToBounds = YES;
//    _navigationBar.leftButton.layer.cornerRadius = _navigationBar.leftButton.height_sd/2;
    
    [_navigationBar.leftButton updateLayout];
    
    //头视图
    _teachersPublicHeaderView = [[TeachersPublicHeaderView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 400)];
    headerSize = CGSizeMake(CGRectGetWidth(self.view.frame), 600);
    
    //collection
    _flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _flowLayout.headerReferenceSize = headerSize;
    _teachersPublicCollectionView = [[TeachersPublicCollectionView alloc]initWithFrame:CGRectMake(0, Navigation_Height, self.view.width_sd, self.view.height_sd-Navigation_Height) collectionViewLayout:_flowLayout];
    
    [self.view addSubview:_teachersPublicCollectionView];
    _teachersPublicCollectionView.backgroundColor = [UIColor whiteColor];
    _teachersPublicCollectionView.showsVerticalScrollIndicator = NO;
    
    /* collectionView 注册cell、headerID、footerId*/
    [_teachersPublicCollectionView registerClass:[TeacherPublicClassCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [_teachersPublicCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId"];
    
    _teachersPublicCollectionView.delegate = self;
    _teachersPublicCollectionView.dataSource = self;

   
    
    [self.view addSubview:_navigationBar];

}


#pragma mark- collectionView datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _publicClasses.count;
    
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"cellId";
    TeacherPublicClassCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (_publicClasses.count >indexPath.row) {
        
        cell.model = _publicClasses[indexPath.row];
        cell.sd_indexPath = indexPath;
    }
    
    return cell;
    
}


#pragma mark- collectionview delegate
/* item尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return  CGSizeMake((self.view.width_sd-40)/2, (self.view.width_sd-40)/2);
    
}

/* 四边裁剪*/

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 15, 10, 10);
}



////这个方法是返回 Header的大小 size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return  headerSize;
}

// 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"headerId";
    //从缓存中获取 Headercell
    UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [header addSubview:_teachersPublicHeaderView];
    _teachersPublicHeaderView.frame = CGRectMake(0, -20, header.width_sd, header.height_sd);
    
    return header;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TeacherPublicClassCollectionViewCell *cell = (TeacherPublicClassCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    TutoriumInfoViewController *controller = [[TutoriumInfoViewController alloc]initWithClassID:cell.model.classID];
    
    [self.navigationController pushViewController:controller animated:YES];
    
}



#pragma mark- 教师详细信息请求
- (void)requestTeachersInfoWithID:(NSString *)teacherID{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/teachers/%@/profile",Request_Header,teacherID] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        [self loginStates:dic];
        
        NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
        
        if (![status isEqualToString:@"1"]) {
            /* 登录错误*/
            
        }else{
            
            //解析教室公开内容
            _teacherPublicInfo = [TeachersPublicInfo yy_modelWithDictionary:dic[@"data"]];
            
            //yymodel解析教师公开课程
            NSMutableArray *publichArr =[NSMutableArray arrayWithArray: dic[@"data"][@"courses"]];
            
            for (NSDictionary *classDic in publichArr) {
                TutoriumListInfo *mod = [TutoriumListInfo yy_modelWithJSON:classDic];
                
                mod.classID = classDic[@"id"];
                
                [_publicClasses addObject:mod];
            }
            
            //加载视图
            [self setupViews];
           
            [_teachersPublicCollectionView reloadData];
            
            //加载头视图数据
            [self refreshTeacherInfoWith:_teacherPublicInfo];
            
            [self loadingHUDStopLoadingWithTitle:nil];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self loadingHUDStopLoadingWithTitle:nil];
    }];
    
}

/* 刷新页面的信息*/
- (void)refreshTeacherInfoWith:(TeachersPublicInfo *)teacherInfo{
    
    if (teacherInfo) {
        
        _navigationBar.titleLabel.text =teacherInfo.name;
        _teachersPublicHeaderView.teacherNameLabel.text =teacherInfo.name;
        
        [_teachersPublicHeaderView.teacherHeadImage sd_setImageWithURL:[NSURL URLWithString:teacherInfo.avatar_url]];
        _teachersPublicHeaderView.categoryAndSubject.text = [NSString stringWithFormat:@"%@%@",teacherInfo.category==nil?@"":teacherInfo.category,teacherInfo.subject==nil?@"":teacherInfo.subject];
        
        _teachersPublicHeaderView.teaching_year.text = [teacherInfo.teaching_years changeEnglishYearsToChinese];
        
        _teachersPublicHeaderView.location.text = [NSString stringWithFormat:@"%@  %@",teacherInfo.province==nil?@"":teacherInfo.province,teacherInfo.city==nil?@"":teacherInfo.city];
        _teachersPublicHeaderView.workPlace .text = teacherInfo.school;
        _teachersPublicHeaderView.selfInterview.text = teacherInfo.desc;
        
        if ([teacherInfo.gender isEqualToString:@"male"]) {
            [_teachersPublicHeaderView.genderImage setImage:[UIImage imageNamed:@"男"]];
        }else if ([teacherInfo.gender isEqualToString:@"female"]){
            [_teachersPublicHeaderView.genderImage setImage:[UIImage imageNamed:@"女"]];
        }else{
            
        }
        
        [self sizeToFitHeight];
        
        headerSize = CGSizeMake(CGRectGetWidth(_teachersPublicHeaderView.frame), CGRectGetHeight( _teachersPublicHeaderView.frame));
        
        
    }
    
}

#pragma mark- 滑动渐变
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _teachersPublicCollectionView) {
        
        
        
        
    }
    
}


#pragma mark- label自适应高度方法
- (void)sizeToFitHeight{
    
    CGRect rect = [_teachersPublicHeaderView.selfInterview.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: _teachersPublicHeaderView.selfInterview.font} context:nil];
    
    [_teachersPublicHeaderView.selfInterview clearAutoHeigtSettings];
    _teachersPublicHeaderView.selfInterview.sd_layout
    .heightIs(rect.size.height);
    [_teachersPublicHeaderView.selfInterview updateLayout];
    
    [_teachersPublicHeaderView.classList updateLayout];
    
    /* headerview的尺寸也变化*/
    _teachersPublicHeaderView.frame = CGRectMake(0,0,self.view.width_sd , _teachersPublicHeaderView.classList.bottom_sd-20);
    
    headerSize =CGSizeMake(_teachersPublicHeaderView.width_sd, _teachersPublicHeaderView.height_sd);
    
    [_teachersPublicCollectionView reloadData];
    [_teachersPublicCollectionView setNeedsLayout];
    [_teachersPublicCollectionView setNeedsDisplay];

}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
}


/* 返回上一页*/
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
