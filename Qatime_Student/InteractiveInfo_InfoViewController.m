//
//  InteractiveInfo_InfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/11/14.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "InteractiveInfo_InfoViewController.h"
#import "WorkFlowCollectionViewCell.h"
#import "ClassFeaturesCollectionViewCell.h"

/**
 顶部视图的折叠/展开状态
 
 - LeadingViewStateFold: 折叠
 - LeadingViewStateUnfold: 展开
 */
typedef NS_ENUM(NSUInteger, LeadingViewState) {
    LeadingViewStateFold,
    LeadingViewStateUnfold,
};
@interface InteractiveInfo_InfoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    OneOnOneClass *_classInfo;
    
    UICollectionReusableView *_titlesView;
    LeadingViewState _leadingViewState;
    
}

@end

@implementation InteractiveInfo_InfoViewController

-(instancetype)initWithOneOnOneClass:(OneOnOneClass *)oneOnOneClass{
    
    self = [super init];
    if (self) {
        _classInfo = oneOnOneClass;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeData];
    
    [self setupViews];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeFold) name:@"ChangeFold" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeUnfold) name:@"ChangeUnfold" object:nil];
    
}

- (void)makeData{
    
    //默认是展开状态
    _leadingViewState = LeadingViewStateUnfold;
    
    _classfeatures = @[
                       @{@"title":@"在线授课",
                         @"content":@"在线授课\n随时随地观看直播\n即可上课",
                         @"color":@"4ab6d0"
                         },
                       @{@"title":@"真人互动",
                         @"content":@"老师实时沟通\n答疑解惑,感受\n真实课堂",
                         @"color":@"f9c46d"
                         },
                       @{@"title":@"免费回放",
                         @"content":@"直播自动生成回放\n自由观看,多次学习",
                         @"color":@"e68b96"
                         },
                       @{@"title":@"插班报名",
                         @"content":@"支持插班价购买\n少花钱也能学",
                         @"color":@"ce89c5"
                         },
                       @{@"title":@"随时可退",
                         @"content":@"随时可以申请退款\n免除后顾之忧",
                         @"color":@"b3c95b"
                         },
                       @{@"title":@"跟踪报名",
                         @"content":@"跟踪式服务\n第一时间解决问题",
                         @"color":@"87a8e4"
                         }
                       ];
    _workflows = @[
                   @{@"image":@"work1",
                     @"title":@"1.购买课程",
                     @"subTitle":@"支持退款,放心购买"
                     },
                   @{@"image":@"work2",
                     @"title":@"2.准时上课",
                     @"subTitle":@"提前预习,按时上课"
                     },
                   @{@"image":@"work3",
                     @"title":@"3.在线授课",
                     @"subTitle":@"多人交流,生动直播"
                     },
                   @{@"image":@"work4",
                     @"title":@"4.上课结束",
                     @"subTitle":@"视频回放,想看就看"
                     }
                   ];
}

- (void)setupViews{
    
    //写两个高度出来
    _footView = [[InteractiveInfo_InfoFootView alloc]init];
    [self.view addSubview:_footView];
    _footView .sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    [_footView setupAutoHeightWithBottomView:_footView.replayLabel bottomMargin:20*ScrenScale];
    [_footView updateLayout];
    _footSize = _footView.size_sd;
    [_footView removeFromSuperviewAndClearAutoLayoutSettings];
    _footView = nil;
    
    _headView = [[InteractiveInfo_InfoHeadView alloc]init];
    [self.view addSubview:_headView];
    _headView .sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    [_headView updateLayout];
    _headView.model  = _classInfo;
    [_headView setupAutoHeightWithBottomView:_headView.features bottomMargin:0];
    [_headView updateLayout];
    _headSize = _headView.size;
    [_headView removeFromSuperviewAndClearAutoLayoutSettings];
    _headView = nil;
    
    [self setupMainView];
    
    //    //自动高度
//    typeof(self) __weak weakSelf = self;
//    _headView.tagEndrefresh = ^(CGFloat height) {
//        if (!weakSelf.mainView) {
//            _headSize = CGSizeMake(weakSelf.headView.width_sd, height);
//            [weakSelf setupMainView];
//            [weakSelf.headView removeFromSuperviewAndClearAutoLayoutSettings];
//        }else{
//            _headSize = CGSizeMake(_mainView.width_sd, height);
//            [weakSelf.mainView reloadData];
//        }
//    };
    
}


/** 主视图 最主要的视图 */
- (void)setupMainView{
    //主视图
    [self.view updateLayout];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    _mainView = [[InteractiveInfo_InfoView alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, self.view.height_sd) collectionViewLayout:layout];
    _mainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainView];
    _mainView.scrollEnabled = YES;
    _mainView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    [_mainView updateLayout];
    [_mainView registerClass:[ClassFeaturesCollectionViewCell class] forCellWithReuseIdentifier:@"classfeatureCell"];
    [_mainView registerClass:[WorkFlowCollectionViewCell class] forCellWithReuseIdentifier:@"workflowCell"];
    
    [_mainView registerClass:[InteractiveInfo_InfoHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headID"];
    [_mainView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headID2"];//是个什么都没有的视图.
    [_mainView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footID"];
    [_mainView registerClass:[InteractiveInfo_InfoFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footID2"];
    _mainView.delegate = self;
    _mainView.dataSource = self;
    _mainView.scrollEnabled = YES;
    [_mainView updateLayout];
    
}
#pragma mark- collectionview datasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return _classfeatures.count;
    }else{
        return _workflows.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString * CellIdentifier = @"classfeatureCell";
        ClassFeaturesCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        if (_classfeatures.count>indexPath.item) {
            [cell makeFeatures:_classfeatures[indexPath.item]];
        }
        return cell;
    }else{
        static NSString * CellIdentifier = @"workflowCell";
        WorkFlowCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        if (_workflows.count>indexPath.item) {
            [cell makeWorkFlow:_workflows[indexPath.item]];
        }
        return cell;
    }
}


#pragma mark- collectionview delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
}


#pragma mark- collection head and foot
//这个方法是返回 Header的大小 size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return _headSize;
    }else{
        return CGSizeMake(collectionView.width_sd, 5*ScrenScale);
    }
}
//这个方法是返回 Footer的大小 size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return CGSizeMake(collectionView.width_sd, 10);
    }else{
        return _footSize;
    }
}

//这个也是最重要的方法 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *view = nil;
    _headView = nil;
    _footView = nil;
    _titlesView = nil;
    if (indexPath.section == 0) {
        if (kind == UICollectionElementKindSectionHeader) {
            //第0个section的头
            _headView = (InteractiveInfo_InfoHeadView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headID" forIndexPath:indexPath];
            _headView.model = _classInfo;
            
            view = _headView;
        }else{
            view =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footID" forIndexPath:indexPath];
            //            UICollectionReusableView *viewss= [[UICollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 1)];
            //            [view addSubview:viewss];
        }
    }else{
        if (kind == UICollectionElementKindSectionHeader) {
            //第1个section的头 就一个label
            //多出来的一个头
            view =[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headID2" forIndexPath:indexPath];
            _titlesView  = [[UICollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, collectionView.width_sd, 5*ScrenScale)];
            UILabel *title = [[UILabel alloc]init];
            title.text = @"学习流程";
            [_titlesView addSubview:title];
            title.font = [UIFont systemFontOfSize:20*ScrenScale];
            title.textColor = [UIColor blackColor];
            title.sd_layout
            .centerXEqualToView(collectionView)
            .centerYEqualToView(_titlesView)
            .autoHeightRatio(0);
            [title setSingleLineAutoResizeWithMaxWidth:2000];
            [view addSubview:_titlesView];
        }else{
            //返回footer
            _footView =(InteractiveInfo_InfoFootView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footID2" forIndexPath:indexPath];
            view = _footView;
        }
    }
    
    return view;
}

//尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(_mainView.width_sd/2.f-10*ScrenScale, _mainView.width_sd/2*0.95);
    }else{
        return CGSizeMake(_mainView.width_sd-60*ScrenScale, (_mainView.width_sd)/4.0);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 10*ScrenScale;
    }else{
        return 10*ScrenScale;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return 10*ScrenScale;
    }else{
        return 10*ScrenScale;
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    if (section == 0) {
        return UIEdgeInsetsMake(30*ScrenScale, 0 ,40*ScrenScale, 0);
    }else{
        return UIEdgeInsetsMake(25*ScrenScale, 0, 0, 0);
    }
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint point = scrollView.contentOffset;
    
    if (_leadingViewState == LeadingViewStateUnfold) {
        //在展开状态的时候
        if (point.y>scrollView.origin_sd.y+Navigation_Height/2) {
            //做成折叠
            [self makeFold];
            NSLog(@"往上滑");
        }else if (point.y<scrollView.origin_sd.y){
            NSLog(@"往下拉");
        }
    }else{
        //在折叠状态的时候
        if (point.y<scrollView.origin_sd.y-20) {
            [self makeUnfold];
            NSLog(@"往下拉2");
        }else if (point.y>scrollView.origin_sd.y){
            NSLog(@"往上滑2");
            
        }
    }
    
}

/** 做成折叠 */
- (void)makeFold{
    if (_leadingViewState == LeadingViewStateUnfold) {
        _leadingViewState = LeadingViewStateFold;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Fold" object:nil];
    }
}

/** 做成展开 */
- (void)makeUnfold{
    if (_leadingViewState == LeadingViewStateFold) {
        _leadingViewState = LeadingViewStateUnfold;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"Unfold" object:nil];
    }
    
}

- (void)changeFold{
    if (_leadingViewState == LeadingViewStateUnfold) {
        _leadingViewState = LeadingViewStateFold;
    }
}

- (void)changeUnfold{
    if (_leadingViewState == LeadingViewStateFold) {
        _leadingViewState = LeadingViewStateUnfold;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
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
