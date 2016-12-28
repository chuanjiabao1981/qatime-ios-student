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
#import "RDVTabBarController.h"
#import "TutoriumInfoViewController.h"

@interface TeachersPublicViewController ()
<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

{
    
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




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [self.view addSubview:_navigationBar];
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    _teachersPublicHeaderView = [[TeachersPublicHeaderView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 400)];
    
    
    [self.view addSubview:_teachersPublicHeaderView];
    
    //
    //    dispatch_queue_t mian1 = dispatch_queue_create("main", DISPATCH_CURRENT_QUEUE_LABEL);
    //    dispatch_sync(mian1, ^{
    
    /* 初始化后直接发送教师公开页的请求*/
    [self requestTeachersInfoWithID:_teacherID];
    
    //    });
    
    
    
    /* 接收label的frame变化的监听*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sizeToFitHeight) name:@"LabelTextChange" object:nil];
    
    
    headerSize = CGSizeMake(CGRectGetWidth(self.view.frame), 600);
    
    _flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _flowLayout.headerReferenceSize = headerSize;
    
    
    
    //    dispatch_queue_t mian2 = dispatch_queue_create("main", DISPATCH_CURRENT_QUEUE_LABEL);
    //    dispatch_sync(mian2, ^{
    
    /* collection部分*/
    _teachersPublicCollectionView = [[TeachersPublicCollectionView alloc]initWithFrame:CGRectMake(0,64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64) collectionViewLayout:_flowLayout];
    [self.view addSubview:_teachersPublicCollectionView];
    _teachersPublicCollectionView.backgroundColor = [UIColor whiteColor];
    _teachersPublicCollectionView.showsVerticalScrollIndicator = NO;
    _teachersPublicCollectionView.bounces = NO;
    /* collectionView 注册cell、headerID、footerId*/
    [_teachersPublicCollectionView registerClass:[TeacherPublicClassCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [_teachersPublicCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId"];
    
    _teachersPublicCollectionView.delegate = self;
    _teachersPublicCollectionView.dataSource = self;
    
    _publicClasses = @[].mutableCopy;
    
    
    
}




#pragma mark- collectionView datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _publicClasses.count;
    
}

/* 复用池*/
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString * CellIdentifier = @"cellId";
    TeacherPublicClassCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    if (_publicClasses.count >indexPath.row) {
        
        /* yymodel解析教师公开页的课程model*/
        
        cell.model = _publicClasses[indexPath.row];
        
        //        _teacherPublicClass = [TeachersPublic_Classes yy_modelWithDictionary:_publicClasses[indexPath.row]];
        //        _teacherPublicClass.classID =[_publicClasses[indexPath.row] valueForKey:@"id"];
        //
        //        [cell.classImage sd_setImageWithURL:[NSURL URLWithString:_teacherPublicClass.publicize]];
        //        cell.className.text = _teacherPublicClass.name;
        //        cell.grade.text = _teacherPublicClass.grade;
        //        cell.subjectName.text = _teacherPublicClass.subject;
        //        cell.priceLabel .text = [NSString stringWithFormat:@"¥%@",_teacherPublicClass.price];
        
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
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"headerId";
    //从缓存中获取 Headercell
    
    UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    [header addSubview:_teachersPublicHeaderView];
    
    
    
    return header;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TeacherPublicClassCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
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
        
        NSString *status = [NSString stringWithFormat:@"%@",dic[@"status"]];
        
        
        if (![status isEqualToString:@"1"]) {
            /* 登录错误*/
            
            
        }else{
            
            /* yymodel解析教师公开信息*/
            _teacherPublicInfo = [TeachersPublicInfo yy_modelWithDictionary:dic[@"data"]];
            
            
            //            NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",_teacherPublicInfo.name,_teacherPublicInfo.desc,_teacherPublicInfo.teaching_years,_teacherPublicInfo.gender,_teacherPublicInfo.grade,_teacherPublicInfo.subject,_teacherPublicInfo.category,_teacherPublicInfo.province,_teacherPublicInfo.city,_teacherPublicInfo.avatar_url,_teacherPublicInfo.courses);
            
            //             yymodel解析教师公开课程
            NSMutableArray *publichArr =[NSMutableArray arrayWithArray: dic[@"data"][@"courses"]];
            
            
            for (NSDictionary *classDic in publichArr) {
                TutoriumListInfo *mod = [TutoriumListInfo yy_modelWithJSON:classDic];
                
                mod.classID = classDic[@"id"];
                
                [_publicClasses addObject:mod];
            }
            
            [self refreshTeacherInfoWith:_teacherPublicInfo];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

/* 刷新页面的信息*/
- (void)refreshTeacherInfoWith:(TeachersPublicInfo *)teacherInfo{
    
    if (teacherInfo) {
        
        
        _teachersPublicHeaderView.teacherNameLabel.text =teacherInfo.name;
        [_teachersPublicHeaderView.teacherHeadImage sd_setImageWithURL:[NSURL URLWithString:teacherInfo.avatar_url]];
        _teachersPublicHeaderView.category.text = teacherInfo.category;
        _teachersPublicHeaderView.subject.text = teacherInfo.subject;
        _teachersPublicHeaderView.teaching_year.text = teacherInfo.teaching_years;
        _teachersPublicHeaderView.province.text = teacherInfo.province;
        _teachersPublicHeaderView.city .text = teacherInfo.city;
        _teachersPublicHeaderView.workPlace .text = teacherInfo.school;
        
        _teachersPublicHeaderView.selfInterview.text = teacherInfo.desc;
        
        [self sizeToFitHeight];
        
        headerSize = CGSizeMake(CGRectGetWidth(_teachersPublicHeaderView.frame), CGRectGetHeight( _teachersPublicHeaderView.frame));
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LabelTextChange" object:nil];
        
        
        
        
    }
    
    
}


#pragma mark- label自适应高度方法
- (void)sizeToFitHeight{
    
    CGRect rect = [_teachersPublicHeaderView.selfInterview.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: _teachersPublicHeaderView.selfInterview.font} context:nil];
    
    _teachersPublicHeaderView.selfInterview.frame = CGRectMake(_teachersPublicHeaderView.selfInterview.frame.origin.x, _teachersPublicHeaderView.selfInterview.frame.origin.y, CGRectGetWidth(self.view.frame)-20, rect.size.height) ;
    
    /* headerview的尺寸也变化*/
    _teachersPublicHeaderView.frame = CGRectMake(0,0,CGRectGetWidth(self.view.frame) , CGRectGetMaxY(_teachersPublicHeaderView.selfInterview.frame)+10);
    
    headerSize =CGSizeMake(_teachersPublicHeaderView.frame.size.width, _teachersPublicHeaderView.frame.size.height);
    
    [_teachersPublicCollectionView reloadData];
    [_teachersPublicCollectionView setNeedsLayout];
    [_teachersPublicCollectionView setNeedsDisplay];
    
    
    
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
