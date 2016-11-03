//
//  TutoriumViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/10/31.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "TutoriumViewController.h"
#import "TutoriumCollectionViewCell.h"
#import "MJRefresh.h"
#import "TutoriumList.h"
#import "YYModel.h"
#import "UIImageView+WebCache.h"

@interface TutoriumViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{

    /* 筛选条件的字段*/
    /* 筛选年级*/
    NSString *_filterGrade;

    /* 筛选科目*/
    NSString *_filterSubject;
    
    /* 返回页码*/
   NSInteger page;
    
    /* 返回每页的条目*/
  NSInteger per_Page;
    
    
    
    /* 数据model*/
    TutoriumList *_tutroiumList;
    
    /* 保存缓存数据的数组*/
    NSMutableArray <TutoriumList *> *listArr;
    
    /* 保存页面缓存的字典*/
    NSDictionary *listDic;
    
    
    
    /* 数据请求类型*/
    /* 0 为全部请求， 1 为筛选类型请求*/
    NSInteger filterStatus;
    
    
    
    /* 本地取出保存的缓存数据状态*/
    NSDictionary *savedDic;
    NSArray *list;
    TutoriumList *listInfo;
    TutoriumListInfo *infoModel;
    

    /* 本地沙盒缓存路径*/
    NSString *_tutoriumListFilePath;
}
@end

@implementation TutoriumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
//    self.view.backgroundColor = [UIColor whiteColor];
    _filterGrade = [NSString string];
    _filterSubject = [NSString string];
    if ([[NSFileManager defaultManager]fileExistsAtPath:_tutoriumListFilePath]) {
        
        NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:_tutoriumListFilePath]];
        page  = [[dic valueForKey:@"page"]integerValue ];
 
    }else{
    
        page = 1;
    }
    per_Page = 10;
    listArr= [[NSMutableArray alloc]init];
    infoModel = [[TutoriumListInfo alloc]init];
   
    /* 本地缓存的沙盒路径*/
     _tutoriumListFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Tutorium_List"];
    
    
    
    [[NSFileManager defaultManager]removeItemAtPath:_tutoriumListFilePath error:nil];
#pragma mark- 接受数据加载完成的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData:) name:@"DataLoaded" object:nil];
#pragma mark- 加载model数据
    
    /* 如果本地存在缓存数据*/
    if ([[NSFileManager defaultManager]fileExistsAtPath:_tutoriumListFilePath]){
        
        savedDic=[NSDictionary dictionaryWithDictionary: [NSKeyedUnarchiver unarchiveObjectWithFile:_tutoriumListFilePath]];
        
    }else{
        
        /* 初次请求数据 ，请求课程列表的所有数据 */
        [self requestDataWithGrade:@"" andSubject:@"" andPage:page andPerPage:per_Page];
        
    }
    
    
    #pragma mark- 导航栏
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64)];
    [self.view addSubview:_navigationBar];
    [_navigationBar.titleLabel setText:@"辅导班"];
    _navigationBar.backgroundColor = [UIColor colorWithRed:190/255.0f green:11/255.0f blue:11/255.0f alpha:1.0f];

    
    _tutoriumView = [[TutoriumView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-64-49)];
    [self .view addSubview:_tutoriumView];
    
    /* 瀑布流视图的代理*/
    _tutoriumView.classesCollectionView.delegate = self;
    _tutoriumView.classesCollectionView.dataSource = self;
    
    
    /* 瀑布流展示注册*/
    /* collectionView 注册cell、headerID、footerId*/
    [_tutoriumView.classesCollectionView registerClass:[TutoriumCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
  
    
    #pragma mark- collection 下拉加载  上滑刷新
    /* collection下拉加载  上滑刷新*/
    
    /* 下拉的block*/
    _tutoriumView.classesCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        /* 重新请求数据 带次数*/
            NSDictionary *dic=[NSDictionary dictionaryWithDictionary: [NSKeyedUnarchiver unarchiveObjectWithFile:_tutoriumListFilePath]];
        
//            listDic = @{@"page":[NSNumber numberWithInteger:pageNumber],
//                        @"per_page":[NSNumber numberWithInteger:perPage],
//                        @"filterGrade":grade,
//                        @"filterSubject":subject,
//                        @"filterStatus":[NSNumber numberWithInteger:filterStatus],
//                        @"listArr":listArr
//                        };
        
            [self requestDataWithGrade:dic[@"filterGrade"] andSubject:dic[@"filterSubject"] andPage:[[dic  valueForKey:@"page"]integerValue]  andPerPage:per_Page];
        
        [_tutoriumView.classesCollectionView.mj_header endRefreshing];
        
    }];
    
    /* 上滑的block*/
    _tutoriumView.classesCollectionView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [_tutoriumView.classesCollectionView.mj_footer endRefreshing];
        
        page ++;
        
        NSLog(@"%ld",page);
        
        /* 上滑 请求更多数据*/
        [self requestDataWithGrade:_filterGrade andSubject:_filterSubject andPage:page andPerPage:per_Page];
        
        
    }];
    
    
    
    

    
    
}
#pragma mark- collection的代理方法
/* item数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSDictionary *dic =[NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:_tutoriumListFilePath]];
    
    TutoriumList *_list=[[TutoriumList alloc]init];
    _list = [dic valueForKey:@"listArr"][section];
    
    NSLog(@"%ld",_list.data.count);
    
    return _list.data.count;
    
}
/* item重用队列*/
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        
    static NSString * CellIdentifier = @"CollectionCell";
    TutoriumCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    /* 直接本地保存的存储状态，然后解析并加载数据*/
    
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:_tutoriumListFilePath]) {
   
        
        NSLog(@"数据本地化存储完成");
        savedDic = [NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:_tutoriumListFilePath]];
//        listDic = @{@"page":[NSNumber numberWithInteger:pageNumber],
//                    @"per_page":[NSNumber numberWithInteger:perPage],
//                    @"filterGrade":grade,
//                    @"filterSubject":subject,
//                    @"filterStatus":[NSNumber numberWithInteger:filterStatus],
//                    @"listArr":listArr
//                    };

        
    /* 手动 解析model第二层数据*/
        list=savedDic[@"listArr"];
        NSLog(@"%@",list);
        listInfo = list[indexPath.section];
        
        NSLog(@"%@",listInfo.data);
        
        infoModel = [TutoriumListInfo yy_modelWithDictionary:listInfo.data[indexPath.row]];
        
        NSLog(@"%@",infoModel.name);
        
    }else{
        
        /* 如果本地没有保存的数据 ，重新发送请求*/
        [self requestDataWithGrade:@"" andSubject:@"" andPage:1 andPerPage:10];
        
        
    }
    
/* 在解析正确的情况下*/
    if (listInfo) {
        
    /* cell按照model 加载图片*/
        
        /* 服务器后台没有数据，使用静态图片*/
//    [cell.classImage sd_setImageWithURL:[NSURL URLWithString:infoModel.publicize]];
        [cell.classImage setImage:[UIImage imageNamed:@"school"]];
    
    
    /* cell按照开课时间  计算和加载距离开课日期*/
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    
    //创建了两个日期对象
    /* 视频开始时间*/
    NSDate *startDate=[dateFormatter dateFromString:infoModel.preview_time];
    
    /* 当前时间*/
    NSDate *nowDate=[NSDate date];
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
   
    NSTimeInterval time=[nowDate timeIntervalSinceDate:startDate];
    
    int days=((int)time)/(3600*24);
//    int hours=((int)time)%(3600*24)/3600;
    NSString *dateContent=[[NSString alloc] initWithFormat:@"距离开课%i天",days];
    
    
    /* cell 的距开始天数 赋值*/
    [cell.timeToStart setText:dateContent];
    
    /* cell 教师姓名 赋值*/
    [cell.teacherName setText:infoModel.teacher_name];
    
    /* cell 科目赋值*/
    
    [cell.subjectName setText:infoModel.subject];
    
    /* cell 年级赋值*/
    [cell.grade setText:infoModel.grade];
    
    /* cell 价格赋值*/
    [ cell.price setText:[NSString stringWithFormat:@"¥%@.00",infoModel.price]];
    
    /* cell 已购买的用户 赋值*/
    [cell.saleNumber setText:infoModel.buy_tickets_count];
        
    }
    return cell;

  
}





/* section数量*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:_tutoriumListFilePath]) {
        
        
        NSDictionary *dic =[NSDictionary dictionaryWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:_tutoriumListFilePath]];
        
        NSLog(@"%ld",[[dic valueForKey:@"listArr"] count]);
        
        return [[dic valueForKey:@"listArr"] count];
        
    }
    

    return 1;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((CGRectGetWidth(self.view.bounds)-40)/2, (CGRectGetWidth(self.view.bounds)-40)/2);
}

/* 最小行间距*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
    
}
/* 最小列间距*/
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
    
}
/* 上下左右的间距*/
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}




#pragma mark- item被选中的回调方法
/* item被选中的回调方法*/
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}



#pragma mark- 拿到model后的加载数据 刷新页面的 方法
- (void)loadData:(nullable NSNotification *)notification{
    
    
    
    [_tutoriumView.classesCollectionView reloadData];
    [_tutoriumView.classesCollectionView setNeedsLayout];
    [_tutoriumView.classesCollectionView setNeedsDisplay];
    
    NSLog(@"重新刷新collection完成");
    
    
}



#pragma mark- 请求数据和重新请求数据方法
- (void)requestDataWithGrade:(NSString *)grade andSubject:(NSString *)subject andPage:(NSInteger)pageNumber andPerPage:(NSInteger)perPage{
    
    
    /* 取出token*/
    NSString *remember_token=[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"];
    NSLog(@"%@",remember_token);
    
    /* 发请求获取课程列表*/
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue:remember_token forHTTPHeaderField:@"Remember-Token"];
    
    NSString *requestStrURL=[NSString string];
    
    if ([grade isEqualToString:@""]&&[subject isEqualToString:@""]) {
        
        requestStrURL = [NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/courses?page=%ld&per_page=%ld",pageNumber,perPage];
 
    }
    else if (![grade isEqualToString:@""]&&[subject isEqualToString:@""]) {
        requestStrURL = [NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/courses?page=%ld&per_page=%ld&grade=%@",pageNumber,perPage,grade];
    }
    else if ([grade isEqualToString:@""]&&![subject isEqualToString:@""]) {
        requestStrURL = [NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/courses?page=%ld&per_page=%ld&subject=%@",pageNumber,perPage,subject];
    }
    else if (![grade isEqualToString:@""]&&![subject isEqualToString:@""]) {
        requestStrURL = [NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/live_studio/courses?page=%ld&per_page=%ld&subject=%@&grade=%@",pageNumber,perPage,subject,grade];
    }
    
    
    
    [manager GET:requestStrURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        /* 使用YYModel解析创建model  get回来的数据是个数组内含字典 引入tag值来确定数组下标*/
        _tutroiumList = [TutoriumList yy_modelWithJSON:responseObject];
        
       NSLog(@"%@,%@",_tutroiumList.status,_tutroiumList.data);
        
        
        
        /* 缓存数据源添加获取的Model*/
        [listArr addObject:_tutroiumList];
        
        NSLog(@"%@",listArr[0].data);
        NSLog(@"%ld",listArr.count);
        
        listDic = @{@"page":[NSNumber numberWithInteger:pageNumber],
                    @"per_page":[NSNumber numberWithInteger:perPage],
                    @"filterGrade":grade,
                    @"filterSubject":subject,
                    @"filterStatus":[NSNumber numberWithInteger:filterStatus],
                    @"listArr":listArr
                    };
        
        /* 测试代码*/
        TutoriumList *tu =[[TutoriumList alloc]init];
        tu = listDic[@"listArr"];
        
//        NSLog(@"%@",tu.tutoriumListInfo);
        
        /* 获取到的数据缓存到本地*/
        /* 保存的数据中含有自定义对象，保存到沙盒*/
        [NSKeyedArchiver archiveRootObject:listDic toFile:_tutoriumListFilePath];
       
        /* 本地状态变化*/
//        savedDic =[NSDictionary dictionaryWithDictionary: listDic];
        
        
        
        /* 加载数据完成后  视图重新加载数据*/
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DataLoaded" object:nil];
        
        [self loadData:nil];
        
        NSLog(@"加载数据完成。");
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

    
    
}

#pragma mark- 缓存数据源添加数据方法
/* 缓存数据源添加数据*/

- (void)listArrayIncreaseData:(NSDictionary *)data{
    
    
    
    
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
