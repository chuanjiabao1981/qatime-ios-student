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

#import "NavigationBar.h"
 
#import "LocalChoseView.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "UIViewController+HUD.h"

@interface TLCityPickerController () <TLCityGroupCellDelegate, TLSearchResultControllerDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>{
    
    
    NSString *_cityFilePath;
    NavigationBar *_navigationBar;
    
    /* 次级导航栏*/
    LocalChoseView *_localChoseView;
    
    /* 地区*/
    NSString *_loaclCity;
    
    /* 已选城市*/
    NSString *_chosenCity;
    
    
}

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) TLCityPickerSearchResultController *searchResultVC;

@property (nonatomic, strong) NSMutableArray *cityData;
@property (nonatomic, strong) NSMutableArray *localCityData;
@property (nonatomic, strong) NSMutableArray *hotCityData;
@property (nonatomic, strong) NSMutableArray *commonCityData;
@property (nonatomic, strong) NSMutableArray *arraySection;

/* 定位管理器*/
@property (nonatomic, strong) CLLocationManager* locationManager;

@end

@implementation TLCityPickerController
@synthesize data = _data;
@synthesize commonCitys = _commonCitys;

-(instancetype)initWithLoacatedCity:(NSString *)city{
    
    self = [super init];
    if (self) {
    
        _chosenCity = [NSString stringWithFormat:@"%@",city];
    }
    return self;
}

- (void)loadView{
    
    [super loadView];
    _navigationBar =({
        NavigationBar *_ = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        
        _.titleLabel.text = @"切换城市";
        [_.leftButton addTarget:self action:@selector(cancelButtonDown:) forControlEvents:UIControlEventTouchUpInside];
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_];
        _;
    });
    
    _localChoseView = ({
        LocalChoseView *_=[[LocalChoseView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd, 44)];
        [self.view addSubview:_];
        _;
    
    });
    
    
    self.tableView = ({
        UITableView *_ = [[UITableView alloc]initWithFrame:CGRectMake(0, 108, self.view.width_sd, self.view.height_sd-64) style:UITableViewStylePlain];
        [_ setSectionIndexBackgroundColor:[UIColor clearColor]];
        [_ setSectionIndexColor:[UIColor blackColor]];
        [_ registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [_ registerClass:[TLCityGroupCell class] forCellReuseIdentifier:@"TLCityGroupCell"];
        [_ registerClass:[TLCityHeaderView class] forHeaderFooterViewReuseIdentifier:@"TLCityHeaderView"];
        _.delegate= self;
        _.dataSource = self;
        [self.view addSubview:_];
        
        _;
    });
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _cityFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"City.plist"];
    
    /* 次级导航栏的*/
    [_localChoseView.city setTitle:_chosenCity forState:UIControlStateNormal];
    
    [_localChoseView.getLocal addTarget:self action:@selector(getLocation) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count + 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0||section == 2) {
        
        return 0;
    }else if (section == 1) {
        return 1;
    }
    TLCityGroup *group = [self.data objectAtIndex:section - 3];
    return group.arrayCitys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < 3) {
        TLCityGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLCityGroupCell"];
        if (indexPath.section == 0) {
//            [cell setTitle:@"定位城市"];
//            [cell setCityArray:self.localCityData];
        }
        else if (indexPath.section == 1) {
            [cell setTitle:@"最近访问城市"];
            [cell setCityArray:self.commonCityData];
        }
        else {
//            [cell setTitle:@"全国"];
//            [cell setCityArray:self.hotCityData];
        }
        [cell setDelegate:self];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    TLCityGroup *group = [self.data objectAtIndex:indexPath.section - 3];
    TLCity *city =  [group.arrayCitys objectAtIndex:indexPath.row];
    [cell.textLabel setText:city.cityName];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < 3) {
        return nil;
    }
    TLCityHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TLCityHeaderView"];
    NSString *title = [_arraySection objectAtIndex:section + 1];
    [headerView setTitle:title];
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
//        return [TLCityGroupCell getCellHeightOfCityArray:self.localCityData];
    }
    else if (indexPath.section == 1) {
        return [TLCityGroupCell getCellHeightOfCityArray:self.commonCityData];
    }
    else if (indexPath.section == 2){
//        return [TLCityGroupCell getCellHeightOfCityArray:self.hotCityData];
    }
    return 43.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section < 3) {
        return 0.0f;
    }
    return 23.5f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < 3) {
        return;
    }
    TLCityGroup *group = [self.data objectAtIndex:indexPath.section - 3];
    TLCity *city = [group.arrayCitys objectAtIndex:indexPath.row];
    [self didSelctedCity:city];
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.arraySection;
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if(index == 0) {
        [self.tableView scrollRectToVisible:self.searchController.searchBar.frame animated:NO];
        return -1;
    }
    return index - 1;
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
        
        if (_cityFilePath) {
            
        }else{
          _cityFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"City.plist"];
        }
        
        NSArray *array = [NSArray arrayWithContentsOfFile:_cityFilePath]   ;
        _data = [[NSMutableArray alloc] init];
        for (NSDictionary *groupDic in array) {
            TLCityGroup *group = [[TLCityGroup alloc] init];
            group.groupName = [groupDic objectForKey:@"initial"];
            for (NSDictionary *dic in [groupDic objectForKey:@"citys"]) {
                TLCity *city = [[TLCity alloc] init];
                city.cityID = [dic objectForKey:@"city_key"];
                city.cityName = [dic objectForKey:@"city_name"];
                city.shortName = [dic objectForKey:@"short_name"];
                [group.arrayCitys addObject:city];
                [self.cityData addObject:city];
            }
            [self.arraySection addObject:group.groupName];
            [_data addObject:group];
        }
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
        _arraySection = [[NSMutableArray alloc] initWithObjects:UITableViewIndexSearch, @"定位", @"最近",@"", nil];
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

#pragma mark- 发起定位
- (void)getLocation{
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    /** 由于IOS8中定位的授权机制改变 需要进行手动授权
     * 获取授权认证，两个方法：
     * [self.locationManager requestWhenInUseAuthorization];
     * [self.locationManager requestAlwaysAuthorization];
     */
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        NSLog(@"requestAlwaysAuthorization");
        [self.locationManager requestAlwaysAuthorization];
    }
    
    //开始定位，不断调用其代理方法
    [self.locationManager startUpdatingLocation];
    self.locationManager.delegate = self;
    
    NSLog(@"start gps");
    [self loadingHUDStartLoadingWithTitle:@"正在获取定位信息"];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}

#pragma mark Location and Delegate


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    // 1.获取用户位置的对象
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             
             _loaclCity = [NSString stringWithFormat:@"%@", placemark.subLocality];
             
             /* 定位信息存本地*/
             [[NSUserDefaults standardUserDefaults]setValue:_loaclCity forKey:@"Location"];
             

             
             if (!_loaclCity) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 _loaclCity = placemark.administrativeArea;
                 
             }
             
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
         
         [self loadingHUDStopLoadingWithTitle:@"定位成功"];
         
         
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前定位城市是%@,是否切换到该城市?",_loaclCity] preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
             
         }] ;
         UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             
             [[NSNotificationCenter defaultCenter]postNotificationName:@"UseLocal" object:_loaclCity];
             
             [self.navigationController popViewControllerAnimated:YES];
             
         }] ;
         
         [alert addAction:cancel];
         [alert addAction:sure];
         
         [self presentViewController:alert animated:YES completion:nil];
         
     }];
    
    // 2.停止定位
    
    if (_loaclCity) {
        
        [manager stopUpdatingLocation];
    }
    
    
}



- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
}




@end
