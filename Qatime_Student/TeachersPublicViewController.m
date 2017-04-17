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
    /**存放一对一课程的数组*/
    NSMutableArray *_oneOnOneClasses;
    /**视频课程的数组*/
    NSMutableArray *_videoClasses;
    
    TeachersPublic_Classes *_teacherPublicClass;
    
    UICollectionViewFlowLayout *_flowLayout;
    
    /* 头视图的尺寸*/
    CGSize headerSize;
    
    /**section的数量~~*/
    NSInteger _publicCount;
    NSInteger _oneOnOneCount;
    NSInteger _videoCount;
    
}
/**section2的title*/
@property (nonatomic, strong) UIView *secTitle ;
/**section3的title*/
@property (nonatomic, strong) UIView *thirdTitle ;
/**section的分割线*/
@property (nonatomic, strong) UIView *sepLine;


@end

@implementation TeachersPublicViewController

- (instancetype)initWithTeacherID:(NSString *)teacherID
{
    self = [super init];
    if (self) {
        _teacherID  = teacherID.mutableCopy;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化数据
    _publicClasses = @[].mutableCopy;
    _publicCount = 0;
    _oneOnOneClasses = @[].mutableCopy;
    _oneOnOneCount = 0;
    _videoClasses = @[].mutableCopy;
    _videoCount = 0;
    
    [self loadingHUDStartLoadingWithTitle:@"加载中"];
    
    /* 请求教师个人详情*/
    [self requestTeachersInfoWithID:_teacherID];
    
    
}

//加载视图
- (void)setupViews{
    
    [self loadingHUDStartLoadingWithTitle:nil];
    
    //比较特殊的导航栏
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
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
    
    [_teachersPublicCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId2"];
    
    [_teachersPublicCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerId3"];
    
     [_teachersPublicCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerId"];
    
    [_teachersPublicCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerId2"];
    
    [_teachersPublicCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerId3"];
    
    _teachersPublicCollectionView.delegate = self;
    _teachersPublicCollectionView.dataSource = self;

    [self.view addSubview:_navigationBar];

}


#pragma mark- collectionView datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger num = 0;
    if (_publicCount!=0) {
        if (_oneOnOneCount==0&&_videoCount==0) {
            num = _publicCount;
        }else if (_oneOnOneCount !=0 &&_videoCount==0){
            if (section == 0) {
                num = _publicCount;
            }else if (section == 1){
                num = _oneOnOneCount;
            }
        }else if (_oneOnOneCount == 0 && _videoCount != 0){
            if (section == 0) {
                num = _publicCount;
            }else if (section == 1){
                num = _videoCount;
            }
        }else if (_oneOnOneCount != 0 && _videoCount != 0){
            if (section == 0) {
                num = _publicCount;
            }else if (section == 1){
                num = _oneOnOneCount;
            }else if (section == 2){
                num = _videoCount;
            }
        }
    }else{
        if (_oneOnOneCount==0&&_videoCount==0) {
            num = 0;
        }else if (_oneOnOneCount !=0 &&_videoCount==0){
            if (section == 0) {
                num = _oneOnOneCount;
            }
        }else if (_oneOnOneCount == 0 && _videoCount != 0){
            if (section == 0) {
                num = _videoCount;
            }
        }else if (_oneOnOneCount != 0 && _videoCount != 0){
            if (section == 0) {
                num = _oneOnOneCount;
            }else if (section == 1){
                num = _videoCount;
            }
        }
    }
    
    return num;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"cellId";
    TeacherPublicClassCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (_oneOnOneClasses.count!=0) {
        if (indexPath.section == 0) {
            
            if (_oneOnOneClasses.count>indexPath.row) {
                cell.model = _oneOnOneClasses[indexPath.row];
            }
            
        }else if (indexPath.section ==1){
            if (_publicClasses.count >indexPath.row) {
                
                cell.model = _publicClasses[indexPath.row];
                
            }
        }
        
    }else{
        
        if (_publicClasses.count >indexPath.row) {
            
            cell.model = _publicClasses[indexPath.row];
            
        }
    }
    
    return cell;
    
}


#pragma mark- collectionview delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    NSInteger num = 0;
    if (_publicCount!=0) {
        num++;
    }
    if (_oneOnOneCount!=0) {
        num++;
    }
    if (_videoCount!=0) {
        num++;
    }
    
    return num;
}


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
    
    CGSize size  = CGSizeZero;
    //两个section的情况
    if (_oneOnOneClasses.count!=0) {
        if (section == 0) {
            size = headerSize;
            
        }else if (section == 1){
            
            size = CGSizeMake(self.view.width_sd, 40);
        }
        
        //一个section的情况
    }else{
        size = headerSize;
    }
    
    return  size;
}

//每个footer的尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    CGSize size  = CGSizeZero;
    
    //两个section的情况
    if (_oneOnOneClasses.count!=0) {
        if (section == 0) {
            size = CGSizeMake(self.view.width_sd, 50);
        }else{
            size = CGSizeZero;
        }
        
        //一个section的情况
    }else{
        size = CGSizeZero;
    }
    
    return  size;

}

// 获取Header / Footer 的方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *header;
    //有没有直播课
    if (_publicCount!=0) {
        if (_oneOnOneCount!=0&&_videoCount!=0) {
            //三个section的情况
            if (indexPath.section == 0) {
                //section的header
                if (kind == UICollectionElementKindSectionHeader){
                    NSString *CellIdentifier = @"headerId";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:_teachersPublicHeaderView];
                    _teachersPublicHeaderView.classList.text = @"直播课";
                    _teachersPublicHeaderView.frame = CGRectMake(0, -20, header.width_sd, header.height_sd);
                }
                //section的footer
                else if (kind == UICollectionElementKindSectionFooter){
                    NSString *CellIdentifier = @"footerId";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:self.sepLine];
                }
                //section 1
            }else if (indexPath.section == 1){
                if (kind == UICollectionElementKindSectionHeader){
                    NSString *CellIdentifier = @"headerId2";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:self.secTitle];
                }else if (kind == UICollectionElementKindSectionFooter){
                    NSString *CellIdentifier = @"footerId2";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:self.sepLine];
                }
            }else if (indexPath.section==2){
                if (kind == UICollectionElementKindSectionHeader){
                    NSString *CellIdentifier = @"headerId3";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:self.thirdTitle];
                }
            }
        }else if (_oneOnOneCount==0 &&_videoCount!=0){
            //两个section的情况
            if (indexPath.section == 0) {
                //section的header
                if (kind == UICollectionElementKindSectionHeader){
                    NSString *CellIdentifier = @"headerId";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:_teachersPublicHeaderView];
                    _teachersPublicHeaderView.classList.text = @"直播课";
                    _teachersPublicHeaderView.frame = CGRectMake(0, -20, header.width_sd, header.height_sd);
                }
                //section的footer
                else if (kind == UICollectionElementKindSectionFooter){
                    NSString *CellIdentifier = @"footerId";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:self.sepLine];
                }
                //section 1
            }else if (indexPath.section == 1){
                if (kind == UICollectionElementKindSectionHeader){
                    NSString *CellIdentifier = @"headerId2";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:self.secTitle];
                }
            }
        }else if (_oneOnOneCount!=0 &&_videoCount==0){
            //两个section的情况
            if (indexPath.section == 0) {
                //section的header
                if (kind == UICollectionElementKindSectionHeader){
                    NSString *CellIdentifier = @"headerId";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:_teachersPublicHeaderView];
                    _teachersPublicHeaderView.classList.text = @"直播课";
                    _teachersPublicHeaderView.frame = CGRectMake(0, -20, header.width_sd, header.height_sd);
                }
                //section的footer
                else if (kind == UICollectionElementKindSectionFooter){
                    NSString *CellIdentifier = @"footerId";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:self.sepLine];
                }
                //section 1
            }else if (indexPath.section == 1){
                if (kind == UICollectionElementKindSectionHeader){
                    NSString *CellIdentifier = @"headerId2";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:self.thirdTitle];
                }
            }
        }else if (_oneOnOneCount==0 &&_videoCount==0){
            //一个section的情况
            if (indexPath.section == 0) {
                //section的header
                if (kind == UICollectionElementKindSectionHeader){
                    NSString *CellIdentifier = @"headerId";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:_teachersPublicHeaderView];
                    _teachersPublicHeaderView.classList.text = @"直播课";
                    _teachersPublicHeaderView.frame = CGRectMake(0, -20, header.width_sd, header.height_sd);
                }
                //section的footer
                else if (kind == UICollectionElementKindSectionFooter){
                    NSString *CellIdentifier = @"footerId";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:self.sepLine];
                }
            }
        }
    }else{
        if (_oneOnOneCount!=0&&_videoCount!=0) {
            //两个section的情况
            if (indexPath.section == 0) {
                //section的header
                if (kind == UICollectionElementKindSectionHeader){
                    NSString *CellIdentifier = @"headerId";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:_teachersPublicHeaderView];
                    _teachersPublicHeaderView.classList.text = @"一对一";
                    _teachersPublicHeaderView.frame = CGRectMake(0, -20, header.width_sd, header.height_sd);
                }
                //section的footer
                else if (kind == UICollectionElementKindSectionFooter){
                    NSString *CellIdentifier = @"footerId";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:self.sepLine];
                }
                //section 1
            }else if (indexPath.section == 1){
                if (kind == UICollectionElementKindSectionHeader){
                    NSString *CellIdentifier = @"headerId2";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:self.thirdTitle];
                }else if (kind == UICollectionElementKindSectionFooter){
                    NSString *CellIdentifier = @"footerId2";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:self.sepLine];
                }
            }
        }else if (_oneOnOneCount==0 &&_videoCount!=0){
            //一个section的情况
            if (indexPath.section == 0) {
                //section的header
                if (kind == UICollectionElementKindSectionHeader){
                    NSString *CellIdentifier = @"headerId";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:_teachersPublicHeaderView];
                    _teachersPublicHeaderView.classList.text = @"视频课";
                    _teachersPublicHeaderView.frame = CGRectMake(0, -20, header.width_sd, header.height_sd);
                }
            }
        }else if (_oneOnOneCount==0 &&_videoCount==0){
            //啥数据都没有的情况
            if (indexPath.section == 0) {
                //section的header
                if (kind == UICollectionElementKindSectionHeader){
                    NSString *CellIdentifier = @"headerId";
                    //从缓存中获取 Headercell
                    header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
                    [header addSubview:_teachersPublicHeaderView];
                    _teachersPublicHeaderView.classList.text = @"";
                    _teachersPublicHeaderView.frame = CGRectMake(0, -20, header.width_sd, header.height_sd);
                }
            }
        }
    }
        
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
            
            //解析教师公开内容
            _teacherPublicInfo = [TeachersPublicInfo yy_modelWithDictionary:dic[@"data"]];
            
            //教师简介富文本
            _teacherPublicInfo.attributeDescription = [[NSMutableAttributedString alloc]initWithData:[_teacherPublicInfo.desc dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil  error:nil];
            
            //yymodel解析教师公开课程数据
            NSMutableArray *publichArr =[NSMutableArray arrayWithArray: dic[@"data"][@"courses"]];
            
            for (NSDictionary *classDic in publichArr) {
                
                TutoriumListInfo *mod = [TutoriumListInfo yy_modelWithJSON:classDic];
                
                mod.classID = classDic[@"id"];
                
                [_publicClasses addObject:mod];
            }
            _publicCount = _publicClasses.count;
            
            //yymodel解析教师一对一课程数据
            for (NSDictionary *classDic in dic[@"data"][@"courses"]) {
                TutoriumListInfo *mod = [TutoriumListInfo yy_modelWithJSON:classDic];
                mod.classID = classDic[@"id"];
                [_oneOnOneClasses addObject:mod];
            }
            _oneOnOneCount = _oneOnOneClasses.count;
            
            //yymodel解析教师视频课数据
            for (NSDictionary *classDic in dic[@"data"][@"courses"]) {
                TutoriumListInfo *mod = [TutoriumListInfo yy_modelWithJSON:classDic];
                mod.classID = classDic[@"id"];
                [_videoClasses addObject:mod];
            }
            _videoCount = _videoClasses.count;
            
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
    
        _teachersPublicHeaderView.selfInterview.attributedText = teacherInfo.attributeDescription;
        
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

    [_teachersPublicHeaderView.selfInterview updateLayout];
    headerSize = CGSizeMake(_teachersPublicHeaderView.width_sd, _teachersPublicHeaderView.selfInterview.bottom_sd);
    
    [_teachersPublicCollectionView reloadData];
    [_teachersPublicCollectionView setNeedsLayout];
    [_teachersPublicCollectionView setNeedsDisplay];

}
#pragma mark- get method
-(UIView *)sepLine{
    if (!_sepLine) {
        
        _sepLine = [[UIView alloc]init];
        _sepLine.frame = CGRectMake(0, 0, self.view.width_sd, 50) ;
        UIView *line = [[UIView alloc]init];
        [_sepLine addSubview:line];
        line.sd_layout
        .topSpaceToView(_sepLine, 20)
        .bottomSpaceToView(_sepLine, 20)
        .leftSpaceToView(_sepLine, 0)
        .rightSpaceToView(_sepLine, 0);
        line.backgroundColor = SEPERATELINECOLOR;
        [line updateLayout];
    }
    return _sepLine;
    
}
-(UIView *)secTitle{
    
    if (!_secTitle) {
        _secTitle = [[UIView alloc]init];
        _secTitle.frame = CGRectMake(0, 0, self.view.width_sd, 40);
        UILabel *label = [[UILabel alloc]init];
        label.text = @"一对一";
        label.font = TITLEFONTSIZE;
        [_secTitle addSubview:label];
        label.sd_layout
        .leftSpaceToView(_secTitle, 12)
        .centerYEqualToView(_secTitle)
        .autoHeightRatio(0);
        [label setSingleLineAutoResizeWithMaxWidth:100];
        
        [label updateLayout];
    }
    return _secTitle;
}

-(UIView *)thirdTitle{
    
    if (!_thirdTitle) {
        _thirdTitle = [[UIView alloc]init];
        _thirdTitle.frame = CGRectMake(0, 0, self.view.width_sd, 40);
        UILabel *label = [[UILabel alloc]init];
        label.text = @"视频课";
        label.font = TITLEFONTSIZE;
        [_thirdTitle addSubview:label];
        label.sd_layout
        .leftSpaceToView(_thirdTitle, 12)
        .centerYEqualToView(_thirdTitle)
        .autoHeightRatio(0);
        [label setSingleLineAutoResizeWithMaxWidth:100];
        
        [label updateLayout];
    }
    return _thirdTitle;
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
