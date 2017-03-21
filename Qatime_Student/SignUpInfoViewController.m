//
//  SignUpInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/1.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "SignUpInfoViewController.h"
#import "HcdDateTimePickerView.h"

#import "MMPickerView.h"
#import "GradeList.h"
#import "UIViewController+HUD.h"
#import "UIAlertController+Blocks.h"

#import "PersonalInfoViewController.h"
#import "ProvinceChosenViewController.h"


@interface SignUpInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    GradeList *gradelist;
    
    /* 登录信息*/
    NSString *_login_Account;
    NSString *_login_Password;
    
    
    /* 地区传值*/
    NSString *_province;
    NSString *_city;
    
    
    BOOL changeImage;
}

@end

@implementation SignUpInfoViewController


-(instancetype)initWithAccount:(NSString *)account andPassword:(NSString *)password{
    self = [super init];
    if (self) {
       
        _login_Account = [NSString stringWithFormat:@"%@",account];
        _login_Password = [NSString  stringWithFormat:@"%@",password];
        
    }
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view .backgroundColor = [UIColor whiteColor];
    
    /* 导航栏*/
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [_navigationBar.titleLabel setText:@"完善信息"];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navigationBar];
    
    /* 添加详情页视图*/
    _signUpInfoView = [[SignUpInfoView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    [self.view addSubview:_signUpInfoView];
    
    
    /* 上传头像按钮方法*/
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upLoadHeadImage)];
    [_signUpInfoView.headImage addGestureRecognizer:imageTap];
    
    
    /* 加载年级信息*/
    gradelist = [[GradeList alloc]init];
    
    

    /* 点击选择年级方法*/
    [_signUpInfoView.grade addTarget:self action:@selector(choseGrade:) forControlEvents:UIControlEventTouchUpInside];
    
    /* 点击选择地区方法*/
    [_signUpInfoView.chooseLocationButton addTarget:self action:@selector(chooseLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    /* 立即进入按钮*/
    [_signUpInfoView.enterButton addTarget:self action:@selector(enterIndex) forControlEvents:UIControlEventTouchUpInside];
    
    
    /* 完善资料按钮*/
    [_signUpInfoView.moreButton addTarget:self action:@selector(writeMore) forControlEvents:UIControlEventTouchUpInside];
    
    
    /* 监听地址修改完毕*/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLocation:) name:@"ChangeLocation" object:nil];
    
    
    
    /* 发起自动登录*/
    [self login];
    
    
    
}

#pragma mark- 选择年级
- (void)choseGrade:(UIButton *)sender{
    
    [MMPickerView showPickerViewInView:self.view withStrings:gradelist.grade withOptions:@{NSFontAttributeName:[UIFont systemFontOfSize:18*ScrenScale]} completion:^(NSString *selectedString) {
        
        [sender setTitle:selectedString forState:UIControlStateNormal];
    }];
    
}

#pragma mark- 选择地区
- (void)chooseLocation:(UIButton *)sender{
    
    ProvinceChosenViewController *controller = [[ProvinceChosenViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark- 地区变化
- (void)changeLocation:(NSNotification *)notification{
    
    NSDictionary *location = [notification object];
    
    [_signUpInfoView.chooseLocationButton setTitle:[NSString stringWithFormat:@"%@  %@",location[@"province"],location[@"city"]] forState:UIControlStateNormal];
    
    [_signUpInfoView.chooseLocationButton setTitleColor:TITLECOLOR forState:UIControlStateNormal];
    
    /* 初始化地区字段,传入"完善更多"页面*/
    
    _province = [NSString stringWithFormat:@"%@",location[@"province"]];
    _city = [NSString stringWithFormat:@"%@",location[@"city"]];
    
}



#pragma mark- 立即进入主页方法
- (void)enterIndex{
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Login"]) {
        
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"Login"]==YES) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UserLogin" object:nil];
            
        }else{
            
            [UIAlertController showAlertInViewController:self withTitle:nil message:@"自动登录失败,请退出后手动登录" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"userLogOut" object:nil];
                
            }];
        }
    }
}

/* 登录方法*/
- (void)login{
    
    if (_login_Account&&_login_Password) {
        
        AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer =[AFHTTPResponseSerializer serializer];
        [manager POST:[NSString stringWithFormat:@"%@/api/v1/sessions",Request_Header] parameters:@{@"login_account":_login_Account,@"password":_login_Password,@"client_type":@"app",@"client_cate":@"student_client"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([dataDic[@"status"]isEqualToNumber:@1]) {
                /* 这是登录成功了*/
                if (dataDic[@"data"]) {
                    /* 本地保存各种能保存的数据*/
                    [[NSUserDefaults standardUserDefaults]setValue:dataDic[@"data"][@"remember_token"] forKey:@"remember_token"];
                    
                    [[NSUserDefaults standardUserDefaults]setValue:dataDic[@"data"][@"user"][@"id"] forKey:@"id"];
                    
                    [[NSUserDefaults standardUserDefaults]setValue:dataDic[@"data"][@"user"][@"login_mobile"] forKey:@"login_mobile"];
                    
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Login"];
                    
                }
                
            }else{
                /* 登录失败,请重试*/
                [self loadingHUDStopLoadingWithTitle:@"登录失败,请稍后重试"];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}


/* 上传头像按钮点击方法*/
- (void)upLoadHeadImage {
    
    /* 弹出提示框，选择照片选取方式*/
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择照片选取方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    /* 相机选取*/
    UIAlertAction *actionCamera=[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
        
    }];
    
    /* 从照片中选取*/
    UIAlertAction *actionLibrary=[UIAlertAction actionWithTitle:@"照片库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
        
    }];
    
    /* 取消*/
    UIAlertAction *actionCancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:actionCamera];
    [alert addAction:actionLibrary];
    [alert addAction:actionCancel];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
}


#pragma mark- 获取图片的回调方法
/* 获取图片的回调方法*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSLog(@"%@",info);
    
    dispatch_queue_t imagequeue= dispatch_queue_create("image", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(imagequeue, ^{
     UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [_signUpInfoView.headImage setImage:image];
        
        changeImage = YES;

    });
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

/* 完善信息页面*/
- (void)writeMore{
    
    PersonalInfoViewController *contorller = [[PersonalInfoViewController alloc]initWithName:_signUpInfoView.userName.text==nil?@"未设置":_signUpInfoView.userName.text andGrade:[_signUpInfoView.grade.titleLabel.text isEqualToString:@"选择所在年级"]?@"未设置":_signUpInfoView.grade.titleLabel.text andHeadImage:_signUpInfoView.headImage.image==nil?[UIImage imageNamed:@"人"]:_signUpInfoView.headImage.image  withImageChange:changeImage andProvince:_province==nil?@"未设置":_province city:_city==nil?@"未设置":_city];
    
    [self.navigationController pushViewController:contorller animated:YES];
    
}



/* 返回上一页*/
- (void)returnLastPage:(UIButton *)sender{
    
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
