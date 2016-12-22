//
//  TLCityPickerController.m
//  TLCityPickerDemo
//
//  Created by 李伯坤 on 15/11/5.
//  Copyright © 2015年 李伯坤. All rights reserved.
//

#import "TLCityPickerController.h"
#import "TLCityPickerSearchResultController.h"
#import "TLCityHeaderView.h"
#import "TLCityGroupCell.h"
#import "RDVTabBarController.h"
#import "NavigationBar.h"
#import "City.h"
#import "ChineseString.h"
#import "YYModel.h"

@interface TLCityPickerController () <TLCityGroupCellDelegate, TLSearchResultControllerDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    NavigationBar *_navigationBar;
    
    /* title数组*/
    NSMutableArray *_titles;
    
    /* 保存城市排序数组*/
    NSMutableArray *_cities;
    
    /* 城市的*/
    NSMutableArray <City *>*_cityModels;
    
}

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) TLCityPickerSearchResultController *searchResultVC;

@property (nonatomic, strong) NSMutableArray *cityData;
@property (nonatomic, strong) NSMutableArray *localCityData;
@property (nonatomic, strong) NSMutableArray *hotCityData;
@property (nonatomic, strong) NSMutableArray *commonCityData;
@property (nonatomic, strong) NSMutableArray *arraySection;

@end

@implementation TLCityPickerController
@synthesize data = _data;
@synthesize commonCitys = _commonCitys;

-(void)viewWillAppear:(BOOL)animated{

    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationBar = ({
    
        NavigationBar *_=[[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        
        _.titleLabel.text = @"城市切换";
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(cancelButtonDown:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_];
        _;
    
    });
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexColor:[UIColor blackColor]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView registerClass:[TLCityGroupCell class] forCellReuseIdentifier:@"TLCityGroupCell"];
    [self.tableView registerClass:[TLCityHeaderView class] forHeaderFooterViewReuseIdentifier:@"TLCityHeaderView"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    /* 初始化*/
    _cityModels = @[].mutableCopy;
    
    /* 筛选用的数组*/
    
    /* 先把所有城市都弄出来*/
    NSMutableArray *cityTitles =@[].mutableCopy;
    NSMutableArray *citiesArr = self.data;
    for (NSDictionary *cityDic in citiesArr) {
        City *mod = [City yy_modelWithJSON:cityDic];
        mod.cityID = [NSString stringWithFormat:@"%@",cityDic[@"id"]];
        [cityTitles addObject:mod.name];
        [_cityModels addObject:mod];
    }
    
    
    /* 右侧滑动列表*/
    _titles = [ChineseString IndexArray:cityTitles];
    
    
    [_titles insertObjects:@[@"定位",@"最近",@"热门"] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
    
    /* 城市列表*/
    _cities = [ChineseString LetterSortArray:cityTitles];
    
    
    
    
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titles.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < 3) {
        return 1;
    }
//    TLCityGroup *group = [self.data objectAtIndex:section - 3];
    return [[_cities objectAtIndex:section-3] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 3) {
        
        TLCityGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLCityGroupCell"];
        if (indexPath.section == 0) {
            [cell setTitle:@"定位城市"];
            [cell setCityArray:self.localCityData];
        }
        else if (indexPath.section == 1) {
            [cell setTitle:@"最近访问城市"];
            [cell setCityArray:self.commonCityData];
        }
        else {
            [cell setTitle:@"热门城市"];
            [cell setCityArray:self.hotCityData];
        }
        [cell setDelegate:self];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    
    cell.textLabel.text =[[_cities objectAtIndex:indexPath.section-3]objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section < 3) {
        return nil;
    }
    TLCityHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TLCityHeaderView"];
    NSString *title = [_titles objectAtIndex:section];
    [headerView setTitle:title];
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [TLCityGroupCell getCellHeightOfCityArray:self.localCityData];
    }
    else if (indexPath.section == 1) {
        return [TLCityGroupCell getCellHeightOfCityArray:self.commonCityData];
    }
    else if (indexPath.section == 2){
        return [TLCityGroupCell getCellHeightOfCityArray:self.hotCityData];
    }
    return 43.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < 3) {
        return 0.0f;
    }
    return 23.5f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < 3) {
        return;
    }

    
    TLCity *city = [[TLCity alloc]init];
    for (City *mod in _cityModels) {
        if ([mod.name isEqualToString:[[_cities objectAtIndex:indexPath.section-3]objectAtIndex:indexPath.row]]) {
            
            city.cityName = mod.name;
            city.shortName = [ChineseString sortString:mod.name];
            city.workstations_count = mod.workstations_count;
            city.province_id = mod.province_id;
            city.initials =[ChineseString sortString:mod.name];
            city.pinyin =[ChineseString sortString:mod.name];
            city.cityID = mod.cityID;
        }
    }
    
    if (city) {
        
        [self didSelctedCity:city];
    }
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _titles;
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if(index == 0) {
        [self.tableView scrollRectToVisible:self.searchController.searchBar.frame animated:NO];
        return 0;
    }
    return index ;
}

#pragma mark TLCityGroupCellDelegate
- (void) cityGroupCellDidSelectCity:(TLCity *)city
{
    [self didSelctedCity:city];
}

#pragma mark TLSearchResultControllerDelegate
- (void) searchResultControllerDidSelectCity:(TLCity *)city
{
    [self.searchController dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self didSelctedCity:city];
}

#pragma mark - Event Response
- (void) cancelButtonDown:(UIBarButtonItem *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(cityPickerControllerDidCancel:)]) {
        [_delegate cityPickerControllerDidCancel:self];
    }
}

#pragma mark - Private Methods
- (void) didSelctedCity:(TLCity *)city
{
    if (_delegate && [_delegate respondsToSelector:@selector(cityPickerController:didSelectCity:)]) {
        [_delegate cityPickerController:self didSelectCity:city];
    }
    
    if (self.commonCitys.count >= MAX_COMMON_CITY_NUMBER) {
        [self.commonCitys removeLastObject];
    }
    for (NSString *str in self.commonCitys) {
        if ([city.cityID isEqualToString:str]) {
            [self.commonCitys removeObject:str];
            break;
        }
    }
    [self.commonCitys insertObject:city.cityID atIndex:0];
    [[NSUserDefaults standardUserDefaults] setValue:self.commonCitys forKey:COMMON_CITY_DATA_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Setter
- (void) setCommonCitys:(NSMutableArray *)commonCitys
{
    _commonCitys = commonCitys;
    if (commonCitys != nil && commonCitys.count > 0) {
        [[NSUserDefaults standardUserDefaults] setValue:commonCitys forKey:COMMON_CITY_DATA_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

#pragma mark - Getter 
- (UISearchController *) searchController
{
    if (_searchController == nil) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultVC];
        [_searchController.searchBar setPlaceholder:@"请输入城市中文名称或拼音"];
        [_searchController.searchBar setBarTintColor:[UIColor colorWithWhite:0.95 alpha:1.0]];
        [_searchController.searchBar sizeToFit];
        [_searchController setSearchResultsUpdater:self.searchResultVC];
        [_searchController.searchBar.layer setBorderWidth:0.5f];
        [_searchController.searchBar.layer setBorderColor:[UIColor colorWithWhite:0.7 alpha:1.0].CGColor];
    }
    return _searchController;
}

- (TLCityPickerSearchResultController *) searchResultVC
{
    if (_searchResultVC == nil) {
        _searchResultVC = [[TLCityPickerSearchResultController alloc] init];
        _searchResultVC.cityData = self.cityData;
        _searchResultVC.searchResultDelegate = self;
    }
    return _searchResultVC;
}

- (NSMutableArray *) data
{
    
    if (_data == nil) {
         NSString *FilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"City.plist"];
        
        _data = [NSMutableArray arrayWithContentsOfFile:FilePath];
    }
    
    return _data;
}

- (NSMutableArray *) cityData
{
    if (_cityData == nil) {
        _cityData = [[NSMutableArray alloc] init];
    }
    return _cityData;
}

- (NSMutableArray *) localCityData
{
    if (_localCityData == nil) {
        _localCityData = [[NSMutableArray alloc] init];
        if (self.locationCityID != nil) {
            TLCity *city = nil;
            for (TLCity *item in self.cityData) {
                if ([item.cityID isEqualToString:self.locationCityID]) {
                    city = item;
                    break;
                }
            }
            if (city == nil) {
                NSLog(@"Not Found City: %@", self.locationCityID);
            }
            else {
                [_localCityData addObject:city];
            }
        }
    }
    return _localCityData;
}

- (NSMutableArray *) hotCityData
{
    if (_hotCityData == nil) {
        _hotCityData = [[NSMutableArray alloc] init];
        for (NSString *str in self.hotCitys) {
            TLCity *city = nil;
            for (TLCity *item in self.cityData) {
                if ([item.cityID isEqualToString:str]) {
                    city = item;
                    break;
                }
            }
            if (city == nil) {
                NSLog(@"Not Found City: %@", str);
            }
            else {
                [_hotCityData addObject:city];
            }
        }
    }
    return _hotCityData;
}

- (NSMutableArray *) commonCityData
{
    if (_commonCityData == nil) {
        _commonCityData = [[NSMutableArray alloc] init];
        for (NSString *str in self.commonCitys) {
            TLCity *city = nil;
            for (TLCity *item in self.cityData) {
                if ([item.cityID isEqualToString:str]) {
                    city = item;
                    break;
                }
            }
            if (city == nil) {
                NSLog(@"Not Found City: %@", str);
            }
            else {
                [_commonCityData addObject:city];
            }
        }
    }
    return _commonCityData;
}

- (NSMutableArray *) arraySection
{
    if (_arraySection == nil) {
        _arraySection = [[NSMutableArray alloc] initWithObjects:UITableViewIndexSearch, @"定位", @"最近", @"最热", nil];
    }
    return _arraySection;
}

- (NSMutableArray *) commonCitys
{
    if (_commonCitys == nil) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:COMMON_CITY_DATA_KEY];
        _commonCitys = (array == nil ? [[NSMutableArray alloc] init] : [[NSMutableArray alloc] initWithArray:array copyItems:YES]);
    }
    return _commonCitys;
}

@end
