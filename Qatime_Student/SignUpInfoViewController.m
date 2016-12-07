//
//  SignUpInfoViewController.m
//  Qatime_Student
//
//  Created by Shin on 2016/11/1.
//  Copyright © 2016年 WWTD. All rights reserved.
//

#import "SignUpInfoViewController.h"
#import "HcdDateTimePickerView.h"
#import "GradeList.h"
#import "MMPickerView.h"


@interface SignUpInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    
    GradeList *gradelist;
    UIPickerView *pickerView;
    UIView *dock;
    UIVisualEffectView *effectview;
    
    
}

@end

@implementation SignUpInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view .backgroundColor = [UIColor whiteColor];
    
    /* 导航栏*/
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 64)];
    [_navigationBar.titleLabel setText:@"完善信息"];
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
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
    UITapGestureRecognizer *gradeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseGrade)];
    [_signUpInfoView.grade addGestureRecognizer:gradeTap];
    
    
    
    /* 立即进入按钮*/
    [_signUpInfoView.enterButton addTarget:self action:@selector(enterIndex) forControlEvents:UIControlEventTouchUpInside];
    
    
    /* 完善资料按钮*/
    
    [_signUpInfoView.moreButton addTarget:self action:@selector(writeMore) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    
    
    
    
}


#pragma mark- 立即进入方法
- (void)enterIndex{
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"EnterWithoutLogin" object:nil];
    
}




/* 完成按钮点击事件*/

//- (void)finishedSign{
//    
//    /* 取出token*/
//     NSString *FilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"token.data"];
//   
//    /* 取出存储的文件  成为一字典*/
//    NSDictionary *dataDic = [NSDictionary dictionaryWithDictionary: [NSKeyedUnarchiver unarchiveObjectWithFile:FilePath]];
//    
//    
//    /* token字段字符串*/
//    NSString *token = [NSString stringWithFormat:@"%@",dataDic[@"remember-token"]];
//    
//    /* id字段*/
//    
//    NSDictionary *userDic=[NSDictionary dictionaryWithDictionary:dataDic[@"user"]];
//    
//    NSUInteger userID = (NSUInteger)userDic[@"id"];
//    
//    /* name字段*/
//    
//    // _signUpInfoView.userName.text
//    
//    /* avatar字段   图片文件。。*/
//    
//    NSData *headImageData = UIImageJPEGRepresentation(_signUpInfoView.headImage.image, 0.8f);
//    
//    
//    
//    /* grade字段*/
//   // _signUpInfoView.gradeButton.titleLabel.text
//    
//    /* gender字段*/
//    /* birthday字段*/
//    
//    //PUT上去的字典
//    
//    NSDictionary *uploadDic=@{@"Remember-Token": token, //@"G_t7FJTt86Fi6Eg98scsrg",
//                              @"id": userDic[@"id"]   ,
//                              @"name":_signUpInfoView.userName.text,
//                              @"avatar":headImageData,
////                              @"grade":_signUpInfoView.gradeButton.titleLabel.text,
////                              @"birthday":_signUpInfoView.birthday.titleLabel.text,
//                              };
//    
//    
//    /* 向服务器发送请求 确定上传数据*/
//    AFHTTPSessionManager *manager=  [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
//    [manager PUT:[NSString stringWithFormat:@"http://testing.qatime.cn/api/v1/students/%@/profile",userDic[@"id"] ] parameters:uploadDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@",dic);
//        
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
//    
//    
//    
//}


#pragma mark- 选择生日的点击事件

//- (void)chooseBirthDay{
//    
//    
//    HcdDateTimePickerView *dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:0]];
//    dateTimePickerView.datePickerMode = DatePickerDateMode;
//    dateTimePickerView.clickedOkBtn = ^(NSString * datetimeStr){
//        
////        [_signUpInfoView.birthday setTitle:datetimeStr forState:UIControlStateNormal];
//        
//        
//        NSLog(@"%@", datetimeStr);
//    };
//    [self.view addSubview:dateTimePickerView];
//    [dateTimePickerView showHcdDateTimePicker];
//    
//    
//    
//}

#pragma mark- 选择年级列表
- (void)chooseGrade{
    
//     添加一个模糊背景
    UIBlurEffect *effect=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    effectview=[[UIVisualEffectView alloc]initWithEffect:effect];
    [effectview setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    [self.view addSubview:effectview];
    
    
    
    pickerView=[[UIPickerView alloc]init];
    pickerView .dataSource = self;
    pickerView .delegate = self;
    pickerView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:pickerView];
    
    pickerView.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightRatioToView(self.view,0.25).widthRatioToView(self.view,1.0f).bottomSpaceToView(self.view,0);
    
    /* pickerView的顶视图 确定和取消两个选项。*/
    dock=[[UIView alloc]init];
    [self.view addSubview:dock];
    dock.sd_layout.leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).bottomSpaceToView(pickerView,0).heightRatioToView(pickerView,0.25f);
    dock.backgroundColor = USERGREEN;
    
    
    /* 确定按钮*/
    UIButton *sureButton=[[UIButton alloc]init];
    [dock addSubview:sureButton];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.sd_layout.heightRatioToView(dock,0.8).centerYEqualToView(dock).widthIs(60).rightSpaceToView(dock,0);
    [sureButton addTarget:self action:@selector(sureChoseGrade) forControlEvents:UIControlEventTouchUpInside];
    
    
}




/* pickerView的代理方法*/
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 30;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return gradelist.grade.count;
    
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    
    return gradelist.grade[row];
    
    
    
}

/* 选择的*/
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    [_signUpInfoView.grade setText:gradelist.grade[row] ];
     
    
    
}


/* 确定选择*/
- (void)sureChoseGrade{
    
    [pickerView removeFromSuperview];
    [dock removeFromSuperview ];
    [effectview removeFromSuperview];
    
    
    
}





/* 上传头像按钮点击方法*/
- (void)upLoadHeadImage {
    
    /* 弹出提示框，选择照片选取方式*/
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择照片选取方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    /* 相机选取*/
    UIAlertAction *actionCamera=[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imagePicker.delegate = self;
        
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
        
    }];
    
    /* 从照片中选取*/
    UIAlertAction *actionLibrary=[UIAlertAction actionWithTitle:@"照片库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
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
     UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    [_signUpInfoView.headImage setImage:image];
        
        
        /* 头像 轻量级存储本地*/
        //[[NSUserDefaults standardUserDefaults]setObject:image forKey:@"userHeadImage"];
    
    });
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
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
