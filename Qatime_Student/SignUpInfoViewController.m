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


@interface SignUpInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    GradeList *gradelist;
    
    
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
    [_signUpInfoView.grade addTarget:self action:@selector(choseGrade:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    /* 立即进入按钮*/
    [_signUpInfoView.enterButton addTarget:self action:@selector(enterIndex) forControlEvents:UIControlEventTouchUpInside];
    
    
    /* 完善资料按钮*/
    
//    [_signUpInfoView.moreButton addTarget:self action:@selector(writeMore) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

#pragma mark- 选择年级
- (void)choseGrade:(UIButton *)sender{
    [MMPickerView showPickerViewInView:self.view withStrings:gradelist.grade withOptions:@{NSFontAttributeName:[UIFont systemFontOfSize:18*ScrenScale]} completion:^(NSString *selectedString) {
        
        [sender setTitle:selectedString forState:UIControlStateNormal];
    }];
    
}


#pragma mark- 立即进入主页方法
- (void)enterIndex{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"EnterWithoutLogin" object:nil];
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
