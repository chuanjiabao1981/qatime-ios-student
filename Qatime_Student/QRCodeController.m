//
//  QRCodeController.m
//  Qatime_Student
//
//  Created by Shin on 2017/2/28.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "QRCodeController.h"
#import <AVFoundation/AVFoundation.h>

#import "NavigationBar.h"
#import "QRMaskView.h"
#import "UIViewController+HUD.h"
#import "UIAlertController+Blocks.h"

#import "TutoriumInfoViewController.h"

/**
 *  屏幕 高 宽 边界
 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_BOUNDS  [UIScreen mainScreen].bounds

#define TOP (SCREEN_HEIGHT-self.view.width_sd*2/3)/2
#define LEFT (SCREEN_WIDTH-self.view.width_sd*2/3)/2

#define kScanRect CGRectMake(LEFT, TOP, self.view.width_sd*2/3, self.view.width_sd*2/3)

@interface QRCodeController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    CAShapeLayer *cropLayer;
    
    NavigationBar *_navigationBar;
    
    //二维码图
    UIImageView *_qrcodeImage;
    //文字说明label
    UILabel *tipsLabel;
    
    //手电筒按钮
    UIImageView *torchButton;
    
    //遮盖view
    QRMaskView *maskView;
    
    
    
}
@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property (nonatomic, strong) UIImageView * line;

@end

@implementation QRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    
    _navigationBar  = ({
        
        NavigationBar *_ = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, 64)];
        [self.view addSubview:_];
        _.backgroundColor = [UIColor clearColor];
        _.contentView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        _.titleLabel.text = @"二维码扫描";
        
        [_.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [_.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
        _;
        
    });
    
    
    //加载扫描
    [self configView];
}

-(void)configView{
    
    
    [self setCropRect:kScanRect];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:kScanRect];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT, TOP+10, self.view.width_sd*2/3, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];

    //二维码图
    _qrcodeImage = ({
        UIImageView *_ = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qrcode"]];
        _.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:_];
        _;
        
    });
    
    //说明
    tipsLabel = ({
        UILabel *_ = [[UILabel alloc]init];
        _.textColor = [UIColor whiteColor];
        _.text = NSLocalizedString(@"将二维码置于框内即可扫描", nil);
        _.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:_];
        _;
        
    });
    
    
    torchButton  = ({
        UIImageView *_ = [[UIImageView alloc]init];
        _.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:_];
        _.image = [UIImage imageNamed:@"torch"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(turnTorch:)];
        _.userInteractionEnabled = YES;
        [_ addGestureRecognizer:tap];
        
        _;
    });
    
    
    //二维码和提示文字布局
    tipsLabel.sd_layout
    .leftEqualToView(imageView)
    .bottomSpaceToView(imageView,20)
    .autoHeightRatio(0);
    [tipsLabel setSingleLineAutoResizeWithMaxWidth:400];
    
    [tipsLabel updateLayout];
    
    //文字宽度
    CGFloat tipsWidth = tipsLabel.width_sd;
    //文字高度
    CGFloat tipsHeight = tipsLabel.height_sd;
    
    _qrcodeImage.sd_layout
    .leftSpaceToView(self.view,imageView.origin_sd.x+(imageView.width_sd-tipsWidth-5-tipsHeight)/2)
    .topEqualToView(tipsLabel)
    .bottomEqualToView(tipsLabel)
    .widthEqualToHeight();
    [_qrcodeImage updateLayout];
    
    tipsLabel.sd_layout
    .leftSpaceToView(_qrcodeImage,5);
    [tipsLabel updateLayout];
    
    //闪光灯开关按钮布局
    torchButton.sd_layout
    .centerXEqualToView(imageView)
    .topSpaceToView(imageView,self.view.height_sd*0.06)
    .widthIs(self.view.height_sd*0.06)
    .heightEqualToWidth();
    
    [torchButton updateLayout];
    
    //最后放遮罩
    maskView = [[QRMaskView alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, self.view.height_sd)];
    maskView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:maskView];
    [self.view bringSubviewToFront:maskView];
    [self performSelector:@selector(hideMask) withObject:nil afterDelay:0.3];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:0.3];
    
}

-(void)animation1{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, self.view.width_sd*2/3, 2);
        if (2*num >= (self.view.width_sd*2/3.0f-20)) {
            upOrdown = YES;
        }

    }else {
        num --;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, self.view.width_sd*2/3, 2);
        if (num == 0) {
            upOrdown = NO;
        }

    }
    
}

//绘制半透明背景
- (void)setCropRect:(CGRect)cropRect{
    
    cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, CGRectMake(0, 64, self.view.width_sd, self.view.height_sd-64));
//    CGPathAddRect(path, nil, _qrcodeImage.frame);
//    CGPathAddRect(path, nil, tipsLabel.frame);
//    CGPathAddRect(path, nil, torchButton.frame);
    
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.6];
    [cropLayer setNeedsDisplay];
    
    [self.view.layer addSublayer:cropLayer];
}

- (void)setupCamera
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device==nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置扫描区域
    CGFloat top = TOP/SCREEN_HEIGHT;
    CGFloat left = LEFT/SCREEN_WIDTH;
    CGFloat width = self.view.width_sd*2/3/SCREEN_WIDTH;
    CGFloat height = self.view.width_sd*2/3/SCREEN_HEIGHT;
    ///top 与 left 互换  width 与 height 互换
    [_output setRectOfInterest:CGRectMake(top,left, height, width)];
    
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode, nil]];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // Start
    [_session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        [timer setFireDate:[NSDate distantFuture]];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        NSLog(@"扫描结果：%@",stringValue);
        
        //辅导班ID
        __block NSString *courses;
        
        //优惠码
        __block NSString *promotionCode;
        
        
        if ([stringValue containsString:@"qatime.cn"]) {
            
            //正则匹配出来辅导班
            NSRange rangeCourses = [stringValue rangeOfString:@"/\\d+\\?" options:NSRegularExpressionSearch];
            courses = [stringValue substringWithRange:rangeCourses];
            courses = [[courses substringToIndex:[courses length]-1]substringFromIndex:1];
            
            /* 分割扫码扫出来的URL,筛出来优惠码*/
            NSRange rangeCode = [stringValue rangeOfString:@"coupon_code=" options:NSRegularExpressionSearch];
            promotionCode = [stringValue substringFromIndex:rangeCode.location+rangeCode.length];
            
            TutoriumInfoViewController *controller = [[TutoriumInfoViewController alloc]initWithClassID:courses andPromotionCode:promotionCode];
            [self.navigationController pushViewController:controller animated:YES];
            
//            //调试代码......
//            if (_session != nil && timer != nil) {
//                [_session startRunning];
//                [timer setFireDate:[NSDate date]];
//            }
            
        }else{
            
            [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"不支持的二维码" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                
                if (_session != nil && timer != nil) {
                    [_session startRunning];
                    [timer setFireDate:[NSDate date]];
                }
            }];
        }
        
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"无扫描信息" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (_session != nil && timer != nil) {
                [_session startRunning];
                [timer setFireDate:[NSDate date]];
            }
            
        }]];
        
        return;
    }
    
}

//根据扫描出来的字符串信息,跳转至应用相关页面的方法--->预留
- (void)jumpToPageWithQRInfo:(NSString *)qrInfo{
    
    
    
}

//开启关闭闪光灯
- (void)turnTorch:(UIButton *)sender{
    
    if ([_device hasTorch]) {
        if (_device.torchMode == AVCaptureTorchModeOn) {
            [_device lockForConfiguration:nil];
            [_device setTorchMode: AVCaptureTorchModeOff];
            [_device unlockForConfiguration];
        }else if(_device.torchMode == AVCaptureTorchModeOff){
            [_device lockForConfiguration:nil];
            [_device setTorchMode: AVCaptureTorchModeOn];
            [_device unlockForConfiguration];
        }
    }
    
    
    
}

//隐藏遮盖
- (void)hideMask{
    
    [UIView animateWithDuration:0.8 animations:^{
        
        maskView.alpha = 0;
    }];
    
    [self performSelector:@selector(removeMask) withObject:nil afterDelay:1];
    
    
}
- (void)removeMask{
    
    maskView.hidden = YES;
}

- (void)returnLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
