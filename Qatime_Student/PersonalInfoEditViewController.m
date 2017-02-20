//
//  PersonalInfoEditViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/1/10.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "PersonalInfoEditViewController.h"
#import "NavigationBar.h"
#import "MMPickerView.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+HUD.h"

@interface PersonalInfoEditViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    
    NavigationBar *_navigationBar;
    
    NSString *_token;
    NSString *_idNumber;
    
    /*保存个人信息数据的字典*/
    
    NSMutableDictionary *_infoDic;
    
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
    
    
    /* 上传头像用的数据流*/
    NSData *_avatar;
    
    
    /* 修改部分的信息*/
    NSURL *_imageURL;
    
    /* 提交数据用的字典*/
    NSMutableDictionary *_dataDic;
    
    
}

@end

@implementation PersonalInfoEditViewController

/* 初始化加载个人信息*/
-(instancetype)initWithInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        
        _infoDic = [NSMutableDictionary dictionaryWithDictionary:info];
        
    }
    return self;
    
}



- (void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
    [self.view addSubview:_navigationBar];
    
    _editTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.width_sd , self.view.height_sd*(0.15+0.07*5)+5) style:UITableViewStylePlain];
    [self.view addSubview:_editTableView];
    
    _editTableView.tableFooterView = [[UIView alloc]init];
    
    
    /* 完成按钮*/
    
    _finishButton = ({
        
        UIButton *_ = [[UIButton alloc]init];
        
        [_ setTitle:@"完成" forState:UIControlStateNormal];
        [_ setTitleColor:BUTTONRED forState:UIControlStateNormal];
        _.layer.borderWidth = 1;
        _.layer.borderColor = BUTTONRED.CGColor;
        [_ addTarget:self action:@selector(updateInfo) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_];
        _.sd_layout
        .leftSpaceToView(self.view,20)
        .rightSpaceToView(self.view ,20)
        .topSpaceToView(_editTableView,15)
        .heightIs(self.view.height_sd*0.065);
        _.sd_cornerRadius = [NSNumber numberWithFloat:M_PI*2];
        _;
    });
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    _navigationBar.titleLabel.text = @"修改个人信息";
    
    
    /* 指定列表代理*/
    _editTableView.delegate = self;
    _editTableView.dataSource = self;
    _editTableView.bounces = NO;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
//    [_editTableView addGestureRecognizer:tap];
    
    
    /* 提出token和学生id*/
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]) {
        _token =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"remember_token"]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"id"]) {
        
        _idNumber = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"id"]];
    }
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    
}
/* 点击头像的方法*/
- (void)changeHeadImage:(id)sender{
    
    
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
    
    _imageURL = info[@"UIImagePickerControllerReferenceURL"];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        
        EditHeadTableViewCell *cell = [_editTableView cellForRowAtIndexPath:path]  ;
        
        [cell.headImage setImage:info[@"UIImagePickerControllerEditedImage"]];
        
        _userImage = info[@"UIImagePickerControllerEditedImage"];
        
        _avatar = UIImageJPEGRepresentation(_userImage,0.8);
        
        changeImage = YES;
    }];
    
}

#pragma mark- tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =  [UITableViewCell new];
    
    switch (indexPath.row) {
        case 0:{
            
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            EditHeadTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[EditHeadTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                if (_infoDic) {
                    [cell.headImage setImage:_infoDic[@"head"]];
                }
                
                cell.headImage.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeHeadImage:)];
                [cell.headImage addGestureRecognizer:tap];
            }
            
            
            return  cell;
            
        }
            break;
        case 1:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            EditNameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[EditNameTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                if (_infoDic) {
                    
                    cell.nameText.text = _infoDic[@"name"];
                }
            }
            
            return  cell;
            
        }
            break;
        case 2:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            EditGenderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[EditGenderTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                if (_infoDic) {
                    
                    if ([_infoDic[@"gender"] isEqualToString:@"男"]) {
                        
                        cell.genderSegment.selectedSegmentIndex = 0;
                        
                    }else if ([_infoDic[@"gender"]isEqualToString:@"女"]){
                        
                        cell.genderSegment.selectedSegmentIndex = 1;
                    }
                }
                
            }
            
            return  cell;
            
        }
            break;
        case 3:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            EditBirthdayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[EditBirthdayTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                if (_infoDic) {
                    
                    cell.content.text = _infoDic[@"birthday"];
                }
                
            }
            
            return  cell;
            
        }
            break;
        case 4:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            EditBirthdayTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[EditBirthdayTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                
                cell.name.text = @"年级";
                if (_infoDic) {
                    cell.content.text = _infoDic[@"grade"];
                }
                
            }
            
            return  cell;
            
        }
            break;
        case 5:{
            /* cell的重用队列*/
            static NSString *cellIdenfier = @"cell";
            EditNameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
            if (cell==nil) {
                cell=[[EditNameTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
                
                cell.name.text = @"简介";
                [cell.nameText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                if (_infoDic) {
                    if (_infoDic[@"desc"]) {
                        
                        if ([_infoDic[@"desc"]isEqualToString:@""]) {
                            
                            cell.nameText.placeholder = @"一句话介绍自己";
                        }else{
                            cell.nameText.text = _infoDic[@"desc"];
                        }
                    }
                }
            }
            
            return  cell;
            
        }
            break;
    }
    
    return cell;
}
#pragma mark- tableview datesource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger height = 0;
    
    if (indexPath.row == 0) {
        height =  self.view.height_sd*0.15;
    }else{
        height = self.view.height_sd*0.07;
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:{
            
            [self changeHeadImage:[tableView cellForRowAtIndexPath:indexPath]];
            
            
        }
            break;
            
        case 2:{
            
            
            
        }
            break;
        case 3:{
            HcdDateTimePickerView *datePicker = [[HcdDateTimePickerView alloc]initWithDatePickerMode:DatePickerDateMode defaultDateTime:[NSDate date]];
            [self.view addSubview:datePicker];
            [datePicker showHcdDateTimePicker];
            typeof(self) __weak weakSelf = self;
            datePicker.clickedOkBtn = ^(NSString *dateTimeStr){
                
                EditBirthdayTableViewCell *cell= [weakSelf.editTableView cellForRowAtIndexPath:indexPath];
                cell.content.text = dateTimeStr;
                _infoDic[@"birthday"] = dateTimeStr;
                
            };
            
        }
            break;
            
        case 4:{
            [MMPickerView showPickerViewInView:self.view withStrings:[[NSUserDefaults standardUserDefaults]objectForKey:@"grade"] withOptions:@{NSFontAttributeName:[UIFont systemFontOfSize:22]} completion:^(NSString *selectedString) {
                
                EditBirthdayTableViewCell *cell= [_editTableView cellForRowAtIndexPath:indexPath];
                cell.content.text = selectedString;
                
                _infoDic[@"grade"] = selectedString;
                
            }];
            
        }
            break;
    }
    
}
- (void)textFieldDidChange:(UITextField *)textField{
    
    EditNameTableViewCell *nameCell =[_editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    EditNameTableViewCell *descCell =[_editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    
    if (textField == nameCell.nameText) {
        
        _infoDic[@"name"] = textField.text;
        
    }else if(textField == descCell.nameText) {
        
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
            
            _infoDic[@"description"] = textField.text;
        }else{
            _infoDic[@"desc"] = textField.text;
            
        }
    }
    
}


/* 键盘出现*/

- (void)keyboardWillShow:(NSNotification *)aNotification{
    
    // 获取通知的信息字典
    NSDictionary *userInfo = [aNotification userInfo];
    
    // 获取键盘弹出后的rect
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [ self.view setFrame:CGRectMake(0, -keyboardRect.size.height/2, self.view.width_sd, self.view.height_sd)];
        
    }];
    
}

/* 键盘隐藏*/
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    // 获取通知信息字典
    NSDictionary* userInfo = [aNotification userInfo];
    
    // 获取键盘隐藏动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [self.view setFrame:CGRectMake(0, 0, self.view.width_sd , self.view.height_sd)];
        
    }];
}


- (void)keyboardWillChange:(NSNotification *)aNotification{
    
    
    
}

/* 提交个人信息*/
- (void)updateInfo{
    
    /* 组成个人信息的字典*/
    _dataDic =[NSMutableDictionary dictionaryWithDictionary: @{@"name":_infoDic[@"name"]?_infoDic[@"name"]:@"",@"gender":_infoDic[@"gender"]?_infoDic[@"gender"]:@"",@"desc":_infoDic[@"desc"]?_infoDic[@"desc"]:@"",}];
    
    /* 取出头像*/
    EditHeadTableViewCell *cell = [_editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0 ]];
    
    _avatar = UIImageJPEGRepresentation(cell.headImage.image, 0.9);
    
    if (changeBirthday ==YES) {
        [_dataDic setValue:_infoDic[@"birthday"] forKey:@"birthday"];
    }
    if (_dataDic[@"gender"] !=nil) {
        
        EditGenderTableViewCell *cell = [_editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        if (cell.genderSegment.selectedSegmentIndex == 0) {
            _dataDic[@"gender"] =@"male";
        }else{
            _dataDic[@"gender"] =@"female";
        }
        
    }
    if (grade == YES||![_infoDic[@"grade"] isEqualToString:@"未设置"]) {
        [_dataDic setObject:_infoDic[@"grade"]?_infoDic[@"grade"]:@"" forKey:@"grade"];
    }
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"PUT" URLString:[NSString stringWithFormat:@"%@/api/v1/students/%@",Request_Header,_idNumber] parameters:_dataDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:_avatar name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
        
    } error:nil];
    
    [request addValue:_token forHTTPHeaderField:@"Remember-Token"];
    [request addValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //    [request setHTTPMethod:@"PUT"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:15];
    
//    [self loadingHUDStartLoadingWithTitle:@"正在提交"];
    
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self loadingHUDStartLoadingWithTitle:[NSString stringWithFormat:@"正在提交 %ld%@",(NSInteger)uploadProgress.fractionCompleted*100,@"%"]];
            
            
        });
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:responseObject];
            
            [self loginStates:dic];
            if ([dic[@"status"]isEqualToNumber:@1]) {
                
                [[NSUserDefaults standardUserDefaults]setValue:dic[@"data"][@"avatar_url"] forKey:@"avatar_url"];
                [[NSUserDefaults standardUserDefaults]setValue:dic[@"data"][@"name"] forKey:@"name"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ChangeInfoSuccess" object:dic];
                
                [self loadingHUDStopLoadingWithTitle:@"修改成功"];
                [self performSelector:@selector(returnLastPage) withObject:nil afterDelay:1];
                
                
            }
            
            
        }
    }];
    
    [uploadTask resume];
    
    
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    EditNameTableViewCell *nameCell = [_editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    EditNameTableViewCell *descCell =[_editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    [nameCell.nameText resignFirstResponder];
    [descCell.nameText resignFirstResponder];
    
}
- (void)resign{
    EditNameTableViewCell *nameCell = [_editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    EditNameTableViewCell *descCell =[_editTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    [nameCell resignFirstResponder];
    [descCell resignFirstResponder];
    
}



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
