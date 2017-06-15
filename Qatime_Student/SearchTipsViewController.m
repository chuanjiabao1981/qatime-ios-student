//
//  SearchTipsViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/6/15.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "SearchTipsViewController.h"
#import "NavigationBar.h"
#import "SearchViewController.h"
#import "UIViewController+HUD.h"

@interface SearchTipsViewController ()<UITextFieldDelegate,TTGTextTagCollectionViewDelegate>{
    
    NavigationBar *_navigationBar;
    
    UITextField *_searchText;
    
    UILabel *_tips;
    
}

@end

@implementation SearchTipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //导航栏
    [self navigation];
    
    //主视图
    [self setupMainView];
    
}

/**制作导航栏*/
- (void)navigation{
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navigationBar];
    [_navigationBar.rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [_navigationBar.rightButton setupAutoSizeWithHorizontalPadding:5 buttonHeight:30*ScrenScale];
    [_navigationBar.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_navigationBar.rightButton addTarget:self action:@selector(cancelSearchAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_navigationBar.rightButton updateLayout];
    //放一个能打字的搜索框上去
    UIView *searchView = [[UIView alloc]init];
    searchView.backgroundColor = [UIColor whiteColor];
    [_navigationBar addSubview:searchView];
    searchView.sd_layout
    .topEqualToView(_navigationBar.rightButton)
    .bottomEqualToView(_navigationBar.rightButton)
    .rightSpaceToView(_navigationBar.rightButton, 10*ScrenScale)
    .leftSpaceToView(_navigationBar, 10*ScrenScale);
    searchView.sd_cornerRadiusFromHeightRatio = @0.5;
    
    //放大镜
    UIImageView *scope = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scope"]];
    [searchView addSubview:scope];
    scope.sd_layout
    .leftSpaceToView(searchView, 10)
    .centerYEqualToView(searchView)
    .heightRatioToView(searchView, 0.5)
    .widthEqualToHeight();
    
    //输入框
    _searchText = [[UITextField alloc]init];
    _searchText.returnKeyType = UIReturnKeySearch;
    [searchView addSubview:_searchText];
    _searchText.delegate = self;
    _searchText.placeholder = @"搜索课程/教师";
    _searchText.font = TEXT_FONTSIZE;
    _searchText.sd_layout
    .leftSpaceToView(scope, 10)
    .rightSpaceToView(searchView, 10)
    .topSpaceToView(searchView, 0)
    .bottomSpaceToView(searchView, 0);
    [_searchText becomeFirstResponder];
    
}



/**主视图*/
- (void)setupMainView{
    
    _tips = [[UILabel alloc]init];
    [self.view addSubview:_tips];
    _tips.text = @"搜索内容示范:";
    _tips.font = TEXT_FONTSIZE;
    _tips.textColor = SEPERATELINECOLOR_2;
    _tips.sd_layout
    .topSpaceToView(_navigationBar, 20)
    .leftSpaceToView(self.view, 20)
    .autoHeightRatio(0);
    [_tips setSingleLineAutoResizeWithMaxWidth:300];
    
    _mainView = [[TTGTextTagCollectionView alloc]init];
    _mainView.delegate = self;
    _mainView.alignment = TTGTagCollectionAlignmentFillByExpandingSpace;
    _mainView.scrollDirection = TTGTagCollectionScrollDirectionVertical;
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftEqualToView(_tips)
    .rightSpaceToView(self.view, 40)
    .topSpaceToView(_tips, 20)
    .bottomSpaceToView(self.view, 0);
    
    TTGTextTagConfig *config = [[TTGTextTagConfig alloc]init];
    config.tagTextFont = TEXT_FONTSIZE;
    config.tagBackgroundColor = SEPERATELINECOLOR;
    config.tagTextColor = TITLECOLOR;
    config.tagShadowColor = [UIColor clearColor];
    
    [_mainView addTags:@[@"高考",@"语文",@"初二",@"动态电路",@"力学",@"必修"]  withConfig:config];
    
}

//搜索去了
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([textField.text isEqualToString:@""]) {
        
        [self HUDStopWithTitle:@"请输入搜索内容"];
        
    }else{
        
        //开始搜索
        SearchViewController *controller = [[SearchViewController alloc]initWithSearchKey:textField.text];
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    return [textField resignFirstResponder];
}

#pragma mark- TTGTag delgate
-(void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView updateContentSize:(CGSize)contentSize{
    
    if (textTagCollectionView == _mainView) {
        _mainView.sd_resetLayout
        .leftEqualToView(_tips)
        .topSpaceToView(_tips, 20*ScrenScale)
        .rightSpaceToView(self.view, 40*ScrenScale)
        .heightIs(contentSize.height);
    }
    
}



/**取消搜索*/
- (void)cancelSearchAction{
    
    [self.navigationController popViewControllerAnimated:NO];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
     [self.view endEditing:YES];
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
