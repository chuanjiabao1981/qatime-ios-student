//
//  PersonalInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/12/5.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "NavigationBar.h"
#import "Personal_HeadTableViewCell.h"
#import "PersonalTableViewCell.h"
#import "UserInfoModel.h"
#import "UserInfoModel.h"
#import "UIImageView+WebCache.h"
#import "HcdDateTimePickerView.h"
#import "MMPickerView.h"
#import "PersonalDescViewController.h"
#import "UIViewController+HUD.h"
#import "RDVTabBarController.h"
#import "UIAlertController+Blocks.h"





@interface PersonalInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ChangeDescDelegate>
{
    
    NavigationBar *_navigationBar;
    
    /* list menu*/
    
    NSArray *_nameArr;
    NSArray *_nameArrEn;
    
    NSString *_token;
    NSString *_idNumber;
    
    /* 个人数据的dic*/
    __block NSMutableDictionary *_dataDic;
    
    /* 底下行自动高度的model*/
    UserInfoModel *_contentModel;
    
    /* */
    __block NSMutableArray *dataArr;
    
    /* <# State #>*/
    __block NSMutableDictionary *_dic;
    
    /* 更换头像的点击手势*/
    
    UITapGestureRecognizer *_tap;
    
    
    
    /* 选择器*/
    HcdDateTimePickerView *_birthdayPicker;
    
    /* 是否修改头像了*/
    
    BOOL changeImage;
    
    /* 年级必填*/
    
    BOOL grade;
    
    /* 是不是改了生日*/
    BOOL changeBirthday;
    
    /* 上传头像用的数据流*/
    NSData *_avatar;
    
    /* 注册页面初始化传值的变量*/
    NSString *_userName;
    NSString *_userGrade;
    UIImage *_userImage;
    
    /* 是否传值过来的?*/
    BOOL WriteMore;
    
    
}
@end

@implementation PersonalInfoViewController

-(instancetype)initWithName:(NSString *)name andGrade:(NSString *)chosegrade andHeadImage:(UIImage *)headImage withImageChange:(BOOL)imageChange{
    
    self = [super init];
    if (self) {
        
        if (name!=nil) {
            
            _userName = [NSString stringWithFormat:@"%@",name];
        }
        if (chosegrade!=nil) {
            
            _userGrade = [NSString stringWithFormat:@"%@",chosegrade];
        }
        if (headImage!=nil) {
            if (imageChange == YES) {
                
                _userImage = [[UIImage alloc]init];
                _userImage  = headImage;
                
                /* 直接赋值照片data*/
                _avatar = [NSData dataWithData: UIImagePNGRepresentation(headImage)];
            }else{
                
            }
        }
        
        
        /* 是"完善更多场景"*/
        
        WriteMore = YES;
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [self .view addSubview:_navigationBar];
    _navigationBar.titleLabel.text = @"个人信息";
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    
    _personalInfoView = [[PersonalInfoView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    [self.view addSubview:_personalInfoView];
    _personalInfoView.delegate = self;
    _personalInfoView.dataSource = self;
    _personalInfoView.tableFooterView = [UIView new];
    
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    _nameArr = @[@"头像",@"姓名",@"性别",@"生日",@"年级",@"地区",@"学校",@"自我介绍"];
    
    /* 如果是从注册页面传值过来的*/
    if (WriteMore == YES) {
        
        [_personalInfoView reloadData];
        
        
    }else{
        /* 请求个人信息数据*/
        [self requestUserInfo];
        
    }
    
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeHeadImage:)];
    
    
    
}

#pragma mark- 请求个人数据
- (void)requestUserInfo{
    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager GET:[NSString stringWithFormat:@"%@/api/v1/students/%@/info",Request_Header,_idNumber] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        /* 获取成功*/
        _dataDic = [NSMutableDictionary dictionaryWithDictionary:_dic[@"data"]];
        
        if ([_dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            
            for (NSString *key in _dic[@"data"]) {
                
                if ([_dataDic valueForKey:key]==nil||[[_dataDic valueForKey:key] isEqual:[NSNull null]] ) {
                    
                    [_dataDic setValue:@"未设置" forKey:key];
                    
                }
                
            }
            
            NSLog(@"%@",_dataDic);
        }else{
            
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录超时!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"userLogOut" object:nil];
                
                
            }] ;
            [alert addAction:sure];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
        
        [_personalInfoView reloadData];
        
        NSLog(@"%@",_dataDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}






/* 点击头像的方法*/
- (void)changeHeadImage:(UITapGestureRecognizer *)sender{
    
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"支持相机");
    }
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        NSLog(@"支持图库");
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        NSLog(@"支持相片库");
    }
    
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"上传头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
    }] ;
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }] ;
    UIAlertAction *photos = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }] ;
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }] ;
    
    
    [alert addAction:camera];
    [alert addAction:library];
    [alert addAction:photos];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

#pragma mark- ImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        
        Personal_HeadTableViewCell *cell = [_personalInfoView cellForRowAtIndexPath:path]  ;
        
        [cell.image setImage:info[@"UIImagePickerControllerOriginalImage"]];
        
        UIImage *image =info[@"UIImagePickerControllerOriginalImage"];
        
        _avatar = [NSData dataWithData: UIImagePNGRepresentation(image)];
        
        changeImage = YES;
    }];
    
}



#pragma mark- tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [UITableViewCell new];
    
    if (indexPath.row ==0) {
        
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"cell";
        Personal_HeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[Personal_HeadTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            
            cell.name.text = _nameArr[indexPath.row];
            cell.sd_tableView = tableView;
            cell.image.userInteractionEnabled = YES;
            
        }
        
        /* 如果是在"完善更多"的前提下*/
        if (WriteMore == YES) {
            
            /* 如果传来的图片不为nil*/
            if (changeImage==YES) {
                [cell.image setImage:_userImage];
            }else{
                [cell.image setImage:[UIImage imageNamed:@"person"]];
            }
            
            /* 如果是在个人信息中心完善更多信息*/
        }else{
            
            [cell.image sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"avatar_url"]]];
        }
        [cell.image addGestureRecognizer:_tap];
        
        return  cell;
        
    }else{
        
        /* cell的重用队列*/
        static NSString *cellIdenfier = @"cell";
        PersonalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
        if (cell==nil) {
            cell=[[PersonalTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            cell.name.text = _nameArr[indexPath.row];
            cell.content.textAlignment = NSTextAlignmentRight;
            cell.sd_tableView = tableView;
            
            NSLog(@"%@",_dataDic);
            
        }
        if (WriteMore==YES) {
            
            switch (indexPath.row) {
                case 1:
                    
                    if (_userName) {
                        
                        cell.content.text =_userName;
                    }else{
                        
                        cell.content.text = @"未设置";
                        
                    }
                    break;
                    
                case 2:
                    cell.content.text = @"未设置";
                    break;
                    
                case 3:
                    cell.content.text = @"未设置";
                    break;
                    
                case 4:
                    if (_userGrade) {
                        
                        cell.content.text = _userGrade;
                    }else{
                        
                        cell.content.text = @"未设置";
                    }
                    break;
                case 5:
                    cell.content.text = @"未设置";
                    break;
                case 6:
                    cell.content.text = @"未设置";
                    break;
                case 7:
                    cell.content.text = @"未设置";
                    break;
                    
            }
            
        }
        
        
        if ([[_dataDic allKeys]count]!=0) {
            
            switch (indexPath.row) {
                case 1:{
                    
                    cell.content.text =[NSString stringWithFormat:@"%@",[_dataDic valueForKey:@"name"]];
                    
                }
                    break;
                case 2:{
                    
                    if ([[_dataDic valueForKey:@"gender"] isEqualToString:@"male"]) {
                        cell.content.text = @"男";
                    }else if ([[_dataDic valueForKey:@"gender"] isEqualToString:@"female"]){
                        
                        cell.content.text = @"女";
                        
                    }
                    
                }
                    break;
                case 3:{
                    cell.content.text = [_dataDic valueForKey:@"birthday"];
                    
                }
                    break;
                case 4:{
                    
                    cell.content.text = [_dataDic valueForKey:@"grade"];
                }
                    break;
                case 5:{
                    
                    cell.content.text = [[NSString stringWithFormat:@"%@",[_dataDic valueForKey:@"province"]]stringByAppendingString:[NSString stringWithFormat:@"  %@",[_dataDic valueForKey:@"city"]]] ;
                    
                }
                    break;
                case 6:{
                    cell.content.text = [_dataDic valueForKey:@"school"];
                    
                }
                    break;
                    
                case 7:{
                    
                    cell.content.text = [_dataDic valueForKey:@"desc"];
                    [cell sd_clearAutoLayoutSettings];
                    
                }
                    break;
                    
            }
        }
        
        return  cell;
        
    }
    
    return cell;
    
}




#pragma mark- tableview delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height;
    
    
    if (indexPath.row==0) {
        
        height = CGRectGetHeight(self.view.frame)*0.15;
    }else{
        
        height =CGRectGetHeight(self.view.frame)*0.065;
    }
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 1:
            
            [self showAlert:indexPath];
            
            break;
        case 2:
            
            [self pickerViewShow:indexPath];
            
            break;
            
        case 3:
            [self pickerViewShow:indexPath];
            break;
            
        case 4:
            [self pickerViewShow:indexPath];
            break;
            
        case 5:
            
            break;
            
        case 6:
            [self showAlert:indexPath];
            break;
            
        case 7:
        {
            PersonalDescViewController *perVC = [PersonalDescViewController new];
            perVC.delegate = self;
            [self.navigationController pushViewController:perVC animated:YES];
            
            
        }
            break;
    }
    
    
    
}


/* 显示选择器*/
- (void)pickerViewShow:(NSIndexPath *)indePath{
    
    
    switch (indePath.row) {
            
        case 2:{
            
            [MMPickerView showPickerViewInView:self.view withStrings:@[@"男",@"女"] withOptions:@{MMfont:[UIFont systemFontOfSize:22*ScrenScale]} completion:^(NSString *selectedString) {
                
                PersonalTableViewCell *cell= [_personalInfoView cellForRowAtIndexPath:indePath];
                cell.content.text = selectedString;
                
                if ([selectedString isEqualToString:@"男"]) {
                    
                    [_dataDic setObject:@"male" forKey:@"gender"];
                    
                }else if ([selectedString isEqualToString:@"女"]){
                    
                    [_dataDic setObject:@"female" forKey:@"gender"];
                }
                
                
            }];
        }
            
            break;
        case 3:{
            
            _birthdayPicker = [[HcdDateTimePickerView alloc]initWithDatePickerMode:DatePickerDateMode defaultDateTime:[NSDate date]];
            [self .view addSubview:_birthdayPicker];
            [_birthdayPicker showHcdDateTimePicker];
            
            typeof(self) __weak weakSelf = self;
            
            _birthdayPicker.clickedOkBtn = ^(NSString *dateTimeStr){
                
                PersonalTableViewCell *cell= [weakSelf.personalInfoView cellForRowAtIndexPath:indePath];
                cell.content.text = dateTimeStr;
                
                [_dataDic setObject:dateTimeStr forKey:@"birthday"];
                
                changeBirthday = YES;
                
            };
            
        }
            break;
            
            
        case 4:{
            
            [MMPickerView showPickerViewInView:self.view withStrings:[[NSUserDefaults standardUserDefaults]objectForKey:@"grade"] withOptions:@{MMfont:[UIFont systemFontOfSize:22*ScrenScale]} completion:^(NSString *selectedString) {
                
                PersonalTableViewCell *cell= [_personalInfoView cellForRowAtIndexPath:indePath];
                cell.content.text = selectedString;
                
                [_dataDic setObject:selectedString forKey:@"grade"];
                
                grade = YES;
                
            }];
        }
            
            break;
    }
    
}

#pragma mark- 封装 textfiel alert
- (void)showAlert:(NSIndexPath *)indexPath{
    
    NSString *message = @"".mutableCopy;
    
    switch (indexPath.row) {
        case 1:
            message =@"修改姓名";
            break;
            
        case 6:
            message = @"修改学校";
            
            break;
    }
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        

    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }] ;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        PersonalTableViewCell *cell = [_personalInfoView cellForRowAtIndexPath:indexPath];
        cell.content.text = alert.textFields[0].text;
        
        [_dataDic setObject:alert.textFields[0].text forKey:indexPath.row==1?@"name":@"school"];
        
        
    }] ;
    
    [alert addAction:cancel];
    [alert addAction:sure];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

/* 代理传值 从上一个页面修改完成之后 该页面个人简介值发生变化*/
- (void) changeUserDesc:(NSString *)desc{
    
    NSLog(@"%@",desc);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeDesc" object:nil];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:7 inSection:0];
    PersonalTableViewCell *cell = [_personalInfoView cellForRowAtIndexPath:indexPath];
    [cell.content sd_clearAutoLayoutSettings];
    
    cell.content.text = [NSString stringWithFormat:@"%@",desc];
    
    [cell.contentView layoutIfNeeded];
    
    [cell setHeight_sd:cell.content.height_sd+20];
    
    
    [_personalInfoView setNeedsLayout];
    
    [_dataDic setObject:desc forKey:@"desc"];
    
    
}




/* 返回上一页*/

- (void)returnLastPage{
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0 ];
    Personal_HeadTableViewCell *headcell =[_personalInfoView cellForRowAtIndexPath:path];
    
    
    if (headcell.image.image == [UIImage imageNamed:@"人"]) {
        
       [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请选择头像" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {}];
        
        
    }else{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        
        PersonalTableViewCell *cell = [_personalInfoView cellForRowAtIndexPath:indexPath];
        
        if ([cell.content.text isEqualToString:@"未设置"]) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择年级!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }] ;
            
            
            [alert addAction:sure];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否保存?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [self returnFrontPage];
                
            }] ;
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
                [self updateUserInfo];
                
                [self loadingHUDStartLoadingWithTitle:@"正在提交个人信息"];
                
            }] ;
            
            [alert addAction:cancel];
            [alert addAction:sure];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }
    }
    
    
    
    
    
}

/* 更新个人信息*/
- (void)updateUserInfo{
    
    
//    [self loadingHUDStartLoadingWithTitle:@"正在提交信息"];
    
    NSMutableDictionary *dic = nil;
    
        dic =[NSMutableDictionary dictionaryWithDictionary: @{
                @"name":_dataDic[@"name"]?_dataDic[@"name"]:_userName,
                @"gender":_dataDic[@"gender"]?_dataDic[@"gender"]:@"",
                @"desc":_dataDic[@"desc"]?_dataDic[@"desc"]:@"",
                @"school":_dataDic[@"school"]?_dataDic[@"school"]:@""
                
                }];
    
    if (WriteMore == YES) {
        if (changeImage == NO) {
            _avatar = UIImagePNGRepresentation([UIImage imageNamed:@"人"]);
            [dic setValue:_avatar forKey:@"avatar"];
        }
    }else{
        
        [dic setObject:_avatar forKey:@"avatar"];
        
    }
    if (changeBirthday ==YES) {
        [dic setValue:_dataDic[@"birthday"] forKey:@"birthday"];
    }
    if (_dataDic[@"gender"] !=nil) {
        [dic setObject:_dataDic[@"gender"] forKey:@"gender"];
    }
    if (grade == YES||![_dataDic[@"grade"] isEqualToString:@"未设置"]) {
        [dic setObject:_dataDic[@"grade"]?_dataDic[@"grade"]:_userGrade forKey:@"grade"];
    }

    
    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:_token forHTTPHeaderField:@"Remember-Token"];
    [manager PUT:[NSString stringWithFormat:@"%@/api/v1/students/%@",Request_Header,_idNumber] parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"%@",dic);
        if ([dic[@"status"]isEqual:[NSNumber numberWithInteger:1]]) {
            /* 修改成功*/
            
            [self loadingHUDStopLoadingWithTitle:@"修改成功!"];
            
            [self performSelector:@selector(returnFrontPage) withObject:nil afterDelay:1];
            
        }else{
            
            [self loadingHUDStopLoadingWithTitle:@"修改失败!"];
            
            [self performSelector:@selector(returnFrontPage) withObject:nil afterDelay:1];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)returnFrontPage{
    
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
