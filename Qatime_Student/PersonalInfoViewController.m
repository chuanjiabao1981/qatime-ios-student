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
#import "PersonalInfoEditViewController.h"
#import "UIAlertController+Blocks.h"



@interface PersonalInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ChangeDescDelegate,NSURLSessionDelegate>
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
    
    
    /* 注册页面初始化传值的变量*/
    NSString *_userName;
    NSString *_userGrade;
    UIImage *_userImage;
    
    /* 是否传值过来的?*/
    BOOL WriteMore;
    
    /* 上传头像用的数据流*/
    NSData *_avatar;
    
    /* 上传数据用的字典*/
    NSMutableDictionary *_infoDic;
    
    /* 照片的url*/
    NSURL *_imageURL;
    
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
                _avatar = UIImageJPEGRepresentation(_userImage,0.8);
                
                changeImage = YES;
                
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
    [_navigationBar.rightButton setImage:[UIImage imageNamed:@"pen"] forState:UIControlStateNormal];
    [_navigationBar.rightButton addTarget:self action:@selector(editInfo) forControlEvents:UIControlEventTouchUpInside];
//    _navigationBar.rightButton.hidden = YES;
    
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
    
    _nameArr = @[@"头像",@"姓名",@"性别",@"生日",@"年级"/*,@"学校"*/,@"简介"];
    
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
        [self loginStates:_dic];
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
            
            [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"登录超时!\n请重新登录" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"userLogOut" object:nil];
                
                
            }];
            
            
        }
        
        [_personalInfoView reloadData];
        
        NSLog(@"%@",_dataDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}



/* 点击头像的方法*/
- (void)changeHeadImage:(UITapGestureRecognizer *)sender{
    
    
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//    {
//        NSLog(@"支持相机");
//    }
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
//    {
//        NSLog(@"支持图库");
//    }
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
//    {
//        NSLog(@"支持相片库");
//    }
//    
//    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
//    picker.allowsEditing = YES;
//    picker.delegate = self;
//    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"上传头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        
//        [self presentViewController:picker animated:YES completion:nil];
//    }] ;
//    UIAlertAction *library = [UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        
//        [self presentViewController:picker animated:YES completion:nil];
//        
//    }] ;
//    UIAlertAction *photos = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//        
//        [self presentViewController:picker animated:YES completion:nil];
//        
//    }] ;
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//        
//    }] ;
//    
//    
//    [alert addAction:camera];
//    [alert addAction:library];
//    [alert addAction:photos];
//    [alert addAction:cancel];
//    
//    [self presentViewController:alert animated:YES completion:nil];
    
    
}

#pragma mark- ImagePicker delegate
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    
//    _imageURL = info[@"UIImagePickerControllerReferenceURL"];
//    
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
//        
//        Personal_HeadTableViewCell *cell = [_personalInfoView cellForRowAtIndexPath:path]  ;
//        
//        [cell.image setImage:info[@"UIImagePickerControllerEditedImage"]];
//        
//        _userImage = info[@"UIImagePickerControllerEditedImage"];
//        
//        _avatar = UIImageJPEGRepresentation(_userImage,0.8);
//        
//        changeImage = YES;
//    }];
//    
//}



#pragma mark- tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6;
    
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
            
//            cell.image.userInteractionEnabled = YES;
            
        }
        
        /* 如果是在"完善更多"的前提下*/
        if (WriteMore == YES) {
            
            /* 如果传来的图片不为nil*/
            if (changeImage==YES) {
                [cell.image setImage:_userImage];
            }else{
                [cell.image setImage:[UIImage imageNamed:@"人"]];
            }
            
            /* 如果是在个人信息中心完善更多信息*/
        }else{
            
            if (_dataDic[@"avatar_url"]) {
                if (![_dataDic[@"avatar_url"]isEqual:[NSNull null]]) {
                    
                    [cell.image sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"avatar_url"]]];
                }else{
                    [cell.image setImage:[UIImage imageNamed:@"人"]];
                }
            }
            
        }
//        [cell.image addGestureRecognizer:_tap];
        
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
//                case 6:
//                    cell.content.text = @"未设置";
//                    break;
//                case 7:
//                    cell.content.text = @"未设置";
//                    break;
                    
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
                    
//                    cell.content.text = [[NSString stringWithFormat:@"%@",[_dataDic valueForKey:@"province"]]stringByAppendingString:[NSString stringWithFormat:@"  %@",[_dataDic valueForKey:@"city"]]] ;
                    
                    
                    if ([[_dataDic valueForKey:@"desc"]isEqualToString:@""]) {
                        
                        cell.content.text = @"未设置";
                    }else{
                        
                        cell.content.text = [_dataDic valueForKey:@"desc"];
                    }
                    
                    
                    
                    
//                    [cell sd_clearAutoLayoutSettings];

                    
                }
                    break;
                 
                    
//                case 6:{
//                    
//                    cell.content.text = [_dataDic valueForKey:@"desc"];
//                    [cell sd_clearAutoLayoutSettings];
//                    
//                }
//                    break;
                    
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
        
        height =CGRectGetHeight(self.view.frame)*0.07;
    }
    return height;
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    switch (indexPath.row) {
//        case 1:
//            
//            [self showAlert:indexPath];
//            
//            break;
//        case 2:
//            
//            [self pickerViewShow:indexPath];
//            
//            break;
//            
//        case 3:
//            [self pickerViewShow:indexPath];
//            break;
//            
//        case 4:
//            [self pickerViewShow:indexPath];
//            break;
//            
//        case 5:{
//            
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"简介" message:@"请输入简介" preferredStyle:UIAlertControllerStyleAlert];
//            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//                
//            }];
//            
//            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//                [self dismissViewControllerAnimated:YES
//                                         completion:^{
//                                         }];
//                [_dataDic setValue:alert.textFields[0].text forKey:@"desc"];
//                [self changeUserDesc:alert.textFields[0].text];
//                
//            }];
//            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//            }];
//            [alert addAction:cancel];
//            [alert addAction:sure];
//            
//            [self presentViewController:alert animated:YES completion:^{}];
//            
//            
//        }
//            break;
//
//    }
//    
//    
//    
//}


/* 显示选择器*/
//- (void)pickerViewShow:(NSIndexPath *)indePath{
//    
//    
//    switch (indePath.row) {
//            
//        case 2:{
//            
//            [MMPickerView showPickerViewInView:self.view withStrings:@[@"男",@"女"] withOptions:@{MMfont:[UIFont systemFontOfSize:22*ScrenScale]} completion:^(NSString *selectedString) {
//                
//                PersonalTableViewCell *cell= [_personalInfoView cellForRowAtIndexPath:indePath];
//                cell.content.text = selectedString;
//                
//                if ([selectedString isEqualToString:@"男"]) {
//                    
//                    [_dataDic setObject:@"male" forKey:@"gender"];
//                    
//                }else if ([selectedString isEqualToString:@"女"]){
//                    
//                    [_dataDic setObject:@"female" forKey:@"gender"];
//                }
//                
//                
//            }];
//        }
//            
//            break;
//        case 3:{
//            
//            _birthdayPicker = [[HcdDateTimePickerView alloc]initWithDatePickerMode:DatePickerDateMode defaultDateTime:[NSDate date]];
//            [self .view addSubview:_birthdayPicker];
//            [_birthdayPicker showHcdDateTimePicker];
//            
//            typeof(self) __weak weakSelf = self;
//            
//            _birthdayPicker.clickedOkBtn = ^(NSString *dateTimeStr){
//                
//                PersonalTableViewCell *cell= [weakSelf.personalInfoView cellForRowAtIndexPath:indePath];
//                cell.content.text = dateTimeStr;
//                
//                [_dataDic setObject:dateTimeStr forKey:@"birthday"];
//                
//                changeBirthday = YES;
//                
//            };
//            
//        }
//            break;
//            
//            
//        case 4:{
//            
//            [MMPickerView showPickerViewInView:self.view withStrings:[[NSUserDefaults standardUserDefaults]objectForKey:@"grade"] withOptions:@{MMfont:[UIFont systemFontOfSize:22*ScrenScale]} completion:^(NSString *selectedString) {
//                
//                PersonalTableViewCell *cell= [_personalInfoView cellForRowAtIndexPath:indePath];
//                cell.content.text = selectedString;
//                
//                [_dataDic setObject:selectedString forKey:@"grade"];
//                
//                grade = YES;
//                
//            }];
//        }
//            
//            break;
//    }
//    
//}

#pragma mark- 封装 textfiel alert
//- (void)showAlert:(NSIndexPath *)indexPath{
//    
//    NSString *message = @"".mutableCopy;
//    
//    switch (indexPath.row) {
//        case 1:
//            message =@"修改姓名";
//            break;
//            
//            //        case 6:
//            //            message = @"修改学校";
//            //
//            //            break;
//    }
//    
//    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        
//        
//        
//    }];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }] ;
//    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        PersonalTableViewCell *cell = [_personalInfoView cellForRowAtIndexPath:indexPath];
//        cell.content.text = alert.textFields[0].text;
//        
//        [_dataDic setObject:alert.textFields[0].text forKey:indexPath.row==1?@"name":@"school"];
//        
//        
//    }] ;
//    
//    [alert addAction:cancel];
//    [alert addAction:sure];
//    
//    [self presentViewController:alert animated:YES completion:nil];
//    
//    
//}

/* 代理传值 从上一个页面修改完成之后 该页面个人简介值发生变化*/
- (void) changeUserDesc:(NSString *)desc{
    
    NSLog(@"%@",desc);
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeDesc" object:nil];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:5 inSection:0];
    PersonalTableViewCell *cell = [_personalInfoView cellForRowAtIndexPath:indexPath];
//    [cell.content sd_clearAutoLayoutSettings];
//    
    cell.content.text = [NSString stringWithFormat:@"%@",desc];
    
//    [cell.contentView layoutIfNeeded];
//    
//    [cell setHeight_sd:cell.content.height_sd+20];
//    
//    [_personalInfoView setNeedsLayout];
    
    [_dataDic setValue:desc forKey:@"desc"];
    
    
}


/* 进入编辑页面*/
- (void)editInfo{
    
    
    NSArray *contentArr = @[@"head",@"name",@"gender",@"birthday",@"grade",@"desc"];
    
    
    /* 需要传入下一页面的值*/
    NSMutableDictionary *info = @{}.mutableCopy;
    
    
    /* 遍历出所有cell中的value*/
    for (NSInteger i=0; i<contentArr.count; i++) {
        if (i==0) {
            Personal_HeadTableViewCell *cell = [_personalInfoView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [info setValue:cell.image.image==nil?[UIImage imageNamed:@"人"]:cell.image.image forKey:contentArr[i]];
        }else{
            PersonalTableViewCell *cell =[_personalInfoView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [info setValue:cell.content.text==nil?@"":cell.content.text forKey:contentArr[i]];
        }
        
    }
    
    
 
    
    PersonalInfoEditViewController *edit = [[PersonalInfoEditViewController alloc]initWithInfo:info];
    [self.navigationController pushViewController:edit animated:YES];
    
    
    
}




/* 返回上一页*/

- (void)returnLastPage{
    
//    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0 ];
//    Personal_HeadTableViewCell *headcell =[_personalInfoView cellForRowAtIndexPath:path];
//    
//    if (headcell.image.image) {
//        
//        if (headcell.image.image == [UIImage imageNamed:@"人"]) {
//            
//            [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请选择头像" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
//                
//            }];
//            
//        }else{
//            
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
//            
//            PersonalTableViewCell *cell = [_personalInfoView cellForRowAtIndexPath:indexPath];
//            
//            if ([cell.content.text isEqualToString:@"未设置"]||[cell.content.text isEqualToString:@""]) {
//                
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择年级!" preferredStyle:UIAlertControllerStyleAlert];
//                
//                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    
//                }] ;
//                
//                
//                [alert addAction:sure];
//                
//                [self presentViewController:alert animated:YES completion:nil];
//                
//                
//            }else{
//                
//                NSIndexPath *indexP = [NSIndexPath indexPathForRow:1 inSection:0];
//                
//                PersonalTableViewCell *cell = [_personalInfoView cellForRowAtIndexPath:indexP];
//                if ([cell.content.text isEqualToString:@"未设置"]||[cell.content.text isEqualToString:@""]) {
//                    
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入姓名!" preferredStyle:UIAlertControllerStyleAlert];
//                    
//                    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        
//                    }] ;
//                    
//                    
//                    [alert addAction:sure];
//                    
//                    [self presentViewController:alert animated:YES completion:nil];
//                }else{
//                    
//                    [self updateUserInfo];
//                    [self returnFrontPage];
//                    
//                }
//                
//            }
//        }
//    }else{
//        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"请选择头像" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
//            
//        }];
//        
//        
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

/* 更新个人信息*/
- (void)updateUserInfo{
    
//    _infoDic =[NSMutableDictionary dictionaryWithDictionary: @{@"name":_dataDic[@"name"]?_dataDic[@"name"]:_userName,@"gender":_dataDic[@"gender"]?_dataDic[@"gender"]:@"",@"desc":_dataDic[@"desc"]?_dataDic[@"desc"]:@"",}];
//    
//    if (WriteMore == YES) {
//        if (changeImage == NO) {
//            //            _avatar = UIImageJPEGRepresentation([UIImage imageNamed:@"人"],1);
//            [_infoDic setValue:_avatar forKey:@"avatar"];
//        }else{
//            
//            [_infoDic setValue:_avatar forKey:@"avatar"];
//        }
//    }else{
//        
//        Personal_HeadTableViewCell *cell = [_personalInfoView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0 ]];
//        //        _avatar = UIImagePNGRepresentation(cell.image.image);
//        _avatar = UIImageJPEGRepresentation(cell.image.image, 0.9);
//        
////        [_infoDic setObject:_avatar forKey:@"avatar"];
//        
//    }
//    if (changeBirthday ==YES) {
//        [_infoDic setValue:_dataDic[@"birthday"] forKey:@"birthday"];
//    }
//    if (_dataDic[@"gender"] !=nil) {
//        [_infoDic setObject:_dataDic[@"gender"] forKey:@"gender"];
//    }
//    if (grade == YES||![_dataDic[@"grade"] isEqualToString:@"未设置"]) {
//        [_infoDic setObject:_dataDic[@"grade"]?_dataDic[@"grade"]:_userGrade forKey:@"grade"];
//    }
//    
//    
//    
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"PUT" URLString:[NSString stringWithFormat:@"%@/api/v1/students/%@",Request_Header,_idNumber] parameters:_dataDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//        [formData appendPartWithFileData:_avatar name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
//        
//    } error:nil];
//    
//    [request addValue:_token forHTTPHeaderField:@"Remember-Token"];
//    [request addValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    //    [request setHTTPMethod:@"PUT"];
//    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
//    [request setTimeoutInterval:15];
//    
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSURLSessionUploadTask *uploadTask;
//    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            NSLog(@"%f.0%@", uploadProgress.fractionCompleted*100,@"%");
//            
//        });
//        
//    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//        } else {
//            NSLog(@"%@ %@", response, responseObject);
//            
//            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
//            
//            [self loginStates:dic];
//            if ([dic[@"status"]isEqualToNumber:@1]) {
//                
//                [[NSUserDefaults standardUserDefaults]setValue:dic[@"data"][@"avatar_url"] forKey:@"avatar_url"];
//                [[NSUserDefaults standardUserDefaults]setValue:dic[@"data"][@"name"] forKey:@"name"];
//                [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeInfoSuccess" object:dic];
//            }
//            
//            
//        }
//    }];
//    
//    [uploadTask resume];
//    
    
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
