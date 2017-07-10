//
//  NTESMeetingWhiteboardViewController.m
//  NIMEducationDemo
//
//  Created by fenric on 16/10/25.
//  Copyright © 2016年 Netease. All rights reserved.
//  一对一白板子控制器

#import "NTESMeetingWhiteboardViewController.h"
#import "UIViewController+AFHTTP.h"
#import "UIViewController+Token.h"
#import "UIView+NIMKitToast.h"
#import <NIMAVChat/NIMAVChat.h>
#import "UIView+Toast.h"
#import "NSString+TimeStamp.h"

#define VideoWidth [UIScreen mainScreen].bouns.size.width/4.0


@interface NTESMeetingWhiteboardViewController ()<NTESColorSelectViewDelegate, NTESMeetingRTSManagerDelegate, NTESWhiteboardCmdHandlerDelegate, NIMLoginManagerDelegate>{
    
    NSString *_classID;
    
    NSString *_roomID;
    
    UILabel *whiteBoardStatusLabel;
    UILabel *whiteBoardTipsLabel;
    
    /** 白板是否开启 */
    BOOL _whiteBoardON;
    
}



@end

@implementation NTESMeetingWhiteboardViewController


-(instancetype)initWithClassID:(NSString *)classID{
    
    if (self = [super init]) {
        
        _classID = [NSString stringWithFormat:@"%@",classID];
        _name = _classID;
        _cmdHander = [[NTESWhiteboardCmdHandler alloc] initWithDelegate:self];
//        _docHander = [[NTESDocumentHandler alloc]initWithDelegate:self];
        //加载白板服务
        [[NTESMeetingRTSManager defaultManager] setDataHandler:_cmdHander];
        _colors = @[@(0x000000), @(0xd1021c), @(0xfddc01), @(0x7dd21f), @(0x228bf7), @(0x9b0df5)];
        //根据自己的角色,判断画笔颜色
        if([NTESMeetingRolesManager defaultManager].myRole.isManager){
            _myDrawColorRGB = [_colors[0] intValue];
        }else{
            _myDrawColorRGB = [_colors[4] intValue];
        }
        _lines = [[NTESWhiteboardLines alloc] init];
        _myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
        _docInfoDic = [NSMutableDictionary dictionary];
        
        //上来就遮挡白板,不允许使用
        [self.view addSubview:self.maskView];
        _whiteBoardON = NO;
        self.maskView.hidden = NO;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(recivedDesktopShared:) name:@"RecivedDestopShared" object:nil];
        
        //开启白板
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(whiteBoardOn) name:@"DesktopSharedOff" object:nil];
        //关闭白板
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(whiteBoardOff) name:@"DesktopSharedOn" object:nil];
        
    }
    return self;
}


- (instancetype)initWithChatroom:(NIMChatroom *)room{
    if (self = [super init]) {
        _name = room.roomId;
        
        _cmdHander = [[NTESWhiteboardCmdHandler alloc] initWithDelegate:self];

        [[NTESMeetingRTSManager defaultManager] setDataHandler:_cmdHander];
        _colors = @[@(0x000000), @(0xd1021c), @(0xfddc01), @(0x7dd21f), @(0x228bf7), @(0x9b0df5)];
        if([NTESMeetingRolesManager defaultManager].myRole.isManager){
            _myDrawColorRGB = [_colors[0] intValue];
        }
        else
        {
            _myDrawColorRGB = [_colors[4] intValue];
        }
        _lines = [[NTESWhiteboardLines alloc] init];
        
        _myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
        
        _docInfoDic = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [[NTESMeetingRTSManager defaultManager] leaveCurrentConference];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getRoomID) object:nil];
}

- (void)dealloc{
    
    [[NTESMeetingRTSManager defaultManager] leaveCurrentConference];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getRoomID) object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    
    //白板进来什么都不做,先找服务器刷roomID
    [self getRoomID];
    
    [self initUI];
    
}



/**获取roomID*/
- (void)getRoomID{
    
    [self GETSessionURL:[NSString stringWithFormat:@"%@/api/v1/live_studio/interactive_courses/%@/live_status",Request_Header,_classID] withHeaderInfo:[self getToken] andHeaderfield:@"Remember-Token" parameters:nil completeSuccess:^(id  _Nullable responds) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responds options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"status"]isEqualToNumber:@1]) {
            
            if ([dic[@"data"][@"live_info"][@"room_id"] isEqualToString:@""]) {
                //没有roomID,3秒后再次获取
                
                NSLog(@"获取roomID失败");
                [self performSelector:@selector(getRoomID) withObject:nil afterDelay:3];
                
            }else{
                
                [NSObject cancelPreviousPerformRequestsWithTarget:self];
                NSLog(@"获取roomID成功!进入一对一");
                //有roomID了 可以开始玩耍了
                _roomID = [NSString stringWithFormat:@"%@",dic[@"data"][@"live_info"][@"room_id"]];
                
                //加入白板会话
                [[NTESMeetingRTSManager defaultManager] setDelegate:self];
                [[NTESMeetingRTSManager defaultManager] joinConference:_roomID];
                
                NSError *error =[[NTESMeetingRTSManager defaultManager] joinConference:_roomID];
                
                
                //给上级controller(本页面的控制器)发送roomid消息
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RoomID" object:_roomID];
                
                
            }
            
        }else{
            
            //没有roomID,3秒后再次获取
            [self performSelector:@selector(getRoomID) withObject:nil afterDelay:3];
            
        }
        
    } failure:^(id  _Nullable erros) {
        //没有roomID,3秒后再次获取
        [self performSelector:@selector(getRoomID) withObject:nil afterDelay:3];
        
    }];
}



- (void)initUI{
    
    self.view.backgroundColor = UIColorFromRGB(0xedf1f5);
    [self.view addSubview:self.docView];
    
    //在这儿新建一个图,贴到白板上方(奇葩需求)
    
    [self.view addSubview:self.drawView];
    
    [self.view addSubview:self.controlPannel];
    
    [self.view addSubview:self.colorSelectView];
    [self.drawView addSubview:self.laserView];
    [self.docView setHidden:YES];
    [self.laserView setHidden:YES];
    
    [self.colorSelectView setHidden:YES];
    
    [self.controlPannel addSubview:self.cancelLineButton];
    [self.controlPannel addSubview:self.colorSelectButton];
    [self.controlPannel addSubview:self.pageNumLabel];
    [self.pageNumLabel setHidden:YES];

    [self.controlPannel addSubview:self.hintLabel];
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self checkPermission];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    CGFloat spacing = 15.f;
    
    self.controlPannel.width = self.view.width + 2.f;
    self.controlPannel.height = 50.f;
    self.controlPannel.left = - 1.f;
    self.controlPannel.bottom = self.view.bottom + 1.f;
    
    self.colorSelectButton.left = spacing;
    self.colorSelectButton.bottom = self.controlPannel.height - 7.f;
    
    self.cancelLineButton.left = self.colorSelectButton.right + spacing;
    self.cancelLineButton.bottom = self.colorSelectButton.bottom;
    
    self.clearAllButton.left = self.cancelLineButton.right + spacing;
    self.clearAllButton.bottom = self.cancelLineButton.bottom;
    
    self.openDocumentButton.left = self.clearAllButton.right + spacing;
    self.openDocumentButton.bottom = self.clearAllButton.bottom;
    
    self.colorSelectView.width = 34.f;
    self.colorSelectView.height = self.colorSelectView.width * _colors.count;
    self.colorSelectView.centerX = self.colorSelectButton.centerX;
    self.colorSelectView.bottom = self.controlPannel.top - 3.5f ;
    //小屏适配
    if (self.colorSelectView.height > self.view.height - self.controlPannel.height) {
        self.colorSelectView.height = self.view.height - self.controlPannel.height;
        self.colorSelectView.bottom = self.controlPannel.top;
    }
    
    self.hintLabel.left = self.cancelLineButton.right + spacing / 2.f;
    self.hintLabel.centerY = self.controlPannel.height / 2.f;
    
    
    CGFloat drawViewWidth = self.view.width - spacing;
    CGFloat drawViewHeight = self.view.height - self.controlPannel.height - spacing;
    
    if (drawViewHeight > drawViewWidth * 3.f / 4.f) {
        drawViewHeight = drawViewWidth * 3.f / 4.f;
    }
    else {
        drawViewWidth = drawViewHeight * 4.f / 3.f;
    }
    
    self.drawView.width = drawViewWidth;
    self.drawView.height = drawViewHeight;
    
    self.drawView.left = (self.view.width - self.drawView.width) / 2.f;
    self.drawView.top = self.view.top + (self.view.height - self.controlPannel.height - self.drawView.height) / 2.f;
    
    self.docView.width = drawViewWidth;
    self.docView.height = drawViewHeight;
    
    self.docView.left = self.drawView.left;
    self.docView.top = self.drawView.top;
    
    self.nextButton.right = self.view.width - 10.f;
    self.nextButton.centerY = self.colorSelectButton.centerY;
    
    self.pageNumLabel.right = self.view.width - 15.f;
    self.pageNumLabel.centerY = self.colorSelectButton.centerY;
    
    
    self.previousButton.right = self.pageNumLabel.left - 5.f;
    self.previousButton.centerY = self.colorSelectButton.centerY;
    
    self.closeDocButton.right = self.drawView.width - 5.f;
    self.closeDocButton.top = 5.f;
    
    self.imgloadLabel.width = drawViewWidth;
    self.imgloadLabel.height = drawViewHeight;
    self.imgloadLabel.centerX = self.drawView.width / 2.f;
    self.imgloadLabel.centerY = self.drawView.height / 2.f;
    
}

//加入前和加入后的白板使用权限
- (void)checkPermission{
    
        if (_isJoined) {
            
//            self.hintLabel.hidden = YES;
            [self.colorSelectButton setBackgroundColor:UIColorFromRGB(_myDrawColorRGB)];
            self.colorSelectButton.enabled = YES;
            self.cancelLineButton.enabled = YES;
            self.clearAllButton.enabled = YES;
            self.maskView.hidden = YES;
            
        }
        else {
            
            self.hintLabel.text = @"直播开始后可使用白板工具";
            [self.colorSelectButton setBackgroundColor:[UIColor lightGrayColor]];
            self.colorSelectButton.enabled = YES;
            self.cancelLineButton.enabled = YES;
            self.clearAllButton.enabled = YES;
            self.colorSelectView.hidden = YES;
            self.maskView.hidden = NO;
            
        }
    
    //测试阶段代码
//    self.hintLabel.hidden = NO;
//    [self.colorSelectButton setBackgroundColor:UIColorFromRGB(_myDrawColorRGB)];
//    self.colorSelectButton.enabled = YES;
//    self.cancelLineButton.enabled = YES;
//    self.clearAllButton.enabled = YES;
}

- (UIView *)drawView
{
    if (!_drawView) {
        _drawView = [[NTESWhiteboardDrawView alloc] initWithFrame:CGRectZero];
        _drawView.backgroundColor = [UIColor whiteColor];
        _drawView.layer.borderColor = [UIColor whiteColor].CGColor;
        _drawView.layer.borderWidth = 2;
        _drawView.dataSource = _lines;
    }
    return _drawView;
}

- (UIView *)laserView
{
    if (!_laserView) {
        _laserView = [[UIView alloc]initWithFrame:CGRectZero];
        _laserView.width = 7;
        _laserView.height = 7;
        _laserView.backgroundColor = [UIColor redColor];
        _laserView.layer.cornerRadius = 3.5;
        _laserView.layer.masksToBounds = YES;
    }
    return _laserView;
}

- (UIView *)controlPannel
{
    if (!_controlPannel) {
        _controlPannel = [[UIView alloc] init];
        _controlPannel.layer.borderWidth = 1;
        _controlPannel.layer.borderColor = UIColorFromRGB(0xd7dade).CGColor;
        _controlPannel.backgroundColor = [UIColor whiteColor];
    }
    return _controlPannel;
}

- (UIButton *)clearAllButton
{
    if (!_clearAllButton) {
        _clearAllButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35.f, 35.f)];
        [_clearAllButton addTarget:self action:@selector(onClearAllPressed:)  forControlEvents:UIControlEventTouchUpInside];
        
        [_clearAllButton setBackgroundImage:[UIImage imageNamed:@"btn_whiteboard_clear_normal"] forState:UIControlStateNormal];
        [_clearAllButton setBackgroundImage:[UIImage imageNamed:@"btn_whiteboard_clear_pressed"] forState:UIControlStateHighlighted];
        [_clearAllButton setBackgroundImage:[UIImage imageNamed:@"btn_whiteboard_clear_disabled"] forState:UIControlStateDisabled];
    }
    return _clearAllButton;
}

- (UIButton *)cancelLineButton
{
    if (!_cancelLineButton) {
        
        _cancelLineButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35.f, 35.f)];
        [_cancelLineButton addTarget:self action:@selector(onCancelLinePressed:)  forControlEvents:UIControlEventTouchUpInside];
        
        [_cancelLineButton setBackgroundImage:[UIImage imageNamed:@"btn_whiteboard_cancel_normal"] forState:UIControlStateNormal];
        [_cancelLineButton setBackgroundImage:[UIImage imageNamed:@"btn_whiteboard_cancel_pressed"] forState:UIControlStateHighlighted];
        [_cancelLineButton setBackgroundImage:[UIImage imageNamed:@"btn_whiteboard_cancel_disabled"] forState:UIControlStateDisabled];
        
    }
    return _cancelLineButton;
}

- (UIButton *)colorSelectButton
{
    if (!_colorSelectButton) {
        _colorSelectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35.f, 35.f)];
        _colorSelectButton.layer.cornerRadius = 35.f / 2.f;
        [_colorSelectButton setBackgroundColor:UIColorFromRGB(_myDrawColorRGB)];
        [_colorSelectButton setBackgroundImage:[UIImage imageNamed:@"btn_whiteboard_select_color_disabled"] forState:UIControlStateDisabled];
        
        [_colorSelectButton addTarget:self action:@selector(onColorSelectPressed:)  forControlEvents:UIControlEventTouchUpInside];
        
        UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(9.f, 9.f, 17.f, 17.f)];
        circle.layer.cornerRadius = 17.f / 2.f;
        circle.layer.borderColor = [UIColor whiteColor].CGColor;
        circle.layer.borderWidth = 1;
        [circle setUserInteractionEnabled:NO];
        [_colorSelectButton addSubview:circle];
    }
    return _colorSelectButton;
}

-(UIButton*)openDocumentButton
{
    if (!_openDocumentButton) {
        _openDocumentButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35.f, 35.f)];
        [_openDocumentButton addTarget:self action:@selector(onOpenDocumentPressed:)  forControlEvents:UIControlEventTouchUpInside];
        
        [_openDocumentButton setBackgroundImage:[UIImage imageNamed:@"btn_whiteboard_file_normal"] forState:UIControlStateNormal];
        [_openDocumentButton setBackgroundImage:[UIImage imageNamed:@"btn_whiteboard_file_pressed"] forState:UIControlStateHighlighted];
        
    }
    return _openDocumentButton;
}

-(UIButton*)previousButton
{
    if (!_previousButton) {
        _previousButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35.f, 35.f)];
        [_previousButton addTarget:self action:@selector(onPreviousPagePressed:)  forControlEvents:UIControlEventTouchUpInside];
        [_previousButton setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
        [_previousButton setImage:[UIImage imageNamed:@"btn_whiteboard_page_previous"] forState:UIControlStateNormal];
        [_previousButton setImage:[UIImage imageNamed:@"btn_whiteboard_page_previous_pressed"] forState:UIControlStateHighlighted];
        [_previousButton setImage:[UIImage imageNamed:@"btn_whiteboard_page_previous_disable"] forState:UIControlStateDisabled];
    }
    return _previousButton;
}

-(UIButton*)nextButton
{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35.f, 35.f)];
        [_nextButton addTarget:self action:@selector(onNextPagePressed:)  forControlEvents:UIControlEventTouchUpInside];
        [_nextButton setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
        [_nextButton setImage:[UIImage imageNamed:@"btn_whiteboard_page_next"] forState:UIControlStateNormal];
        [_nextButton setImage:[UIImage imageNamed:@"btn_whiteboard_page_next_pressed"] forState:UIControlStateHighlighted];
        [_nextButton setImage:[UIImage imageNamed:@"btn_whiteboard_page_next_disable"] forState:UIControlStateDisabled];
        
    }
    return _nextButton;
}

-(UIButton*)closeDocButton
{
    if (!_closeDocButton) {
        _closeDocButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35.f, 35.f)];
        [_closeDocButton addTarget:self action:@selector(onCloseDocPressed:)  forControlEvents:UIControlEventTouchUpInside];
        _closeDocButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_closeDocButton setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeDocButton setBackgroundImage:[UIImage imageNamed:@"chatroom_interaction_bottom"] forState:UIControlStateNormal];
        [_closeDocButton setBackgroundImage:[UIImage imageNamed:@"chatroom_interaction_bottom_selected"] forState:UIControlStateHighlighted];
    }
    return _closeDocButton;
}

- (UIImageView*)docView
{
    if (!_docView) {
        _docView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _docView.contentMode = UIViewContentModeScaleAspectFit;
        _docView.backgroundColor = [UIColor whiteColor];
    }
    return _docView;
}
- (NTESColorSelectView *)colorSelectView
{
    if (!_colorSelectView) {
        _colorSelectView = [[NTESColorSelectView alloc] initWithFrame:CGRectZero
                                                               colors:_colors
                                                             delegate:self];
    }
    return _colorSelectView;
}

- (UILabel *)hintLabel
{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.text = @"直播开始后可使用白板工具";
        _hintLabel.textColor = UIColorFromRGB(0x999999);
        _hintLabel.font = [UIFont systemFontOfSize:12.f];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        [_hintLabel sizeToFit];
    }
    return _hintLabel;
}

- (UILabel *)pageNumLabel
{
    if (!_pageNumLabel) {
        _pageNumLabel = [[UILabel alloc] init];
        _pageNumLabel.text = [NSString stringWithFormat:@"%d/%lu",_currentPage,(unsigned long)_docInfo.numberOfPages];
        _pageNumLabel.textColor = UIColorFromRGB(0x999999);
        _pageNumLabel.font = [UIFont systemFontOfSize:15.f];
        _pageNumLabel.textAlignment = NSTextAlignmentCenter;
        [_pageNumLabel sizeToFit];
    }
    return _pageNumLabel;
}

- (UILabel *)imgloadLabel
{
    if (!_imgloadLabel) {
        _imgloadLabel = [[UILabel alloc] init];
        _imgloadLabel.text = @"加载中...";
        _imgloadLabel.textColor = UIColorFromRGB(0x999999);
        _imgloadLabel.font = [UIFont systemFontOfSize:15.f];
        _imgloadLabel.textAlignment = NSTextAlignmentCenter;
        _imgloadLabel.backgroundColor = [UIColor whiteColor];
    }
    return _imgloadLabel;
}


-(UIView *)maskView{
    
    if (!_maskView) {
        _maskView = [[UIView alloc]init];
        _maskView.frame = self.view.bounds;
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.userInteractionEnabled = YES;
    }
    return _maskView;
}

- (void)nothing{
    
    
}


-(void)setCurrentPage:(int)currentPage
{
    _currentPage = currentPage;
    if (self.docInfo.numberOfPages ==1) {
        self.previousButton.enabled = NO;
        self.nextButton.enabled = NO;
    }
    else
    {
        if (_currentPage == 1) {
            self.previousButton.enabled = NO;
            self.nextButton.enabled = YES;
        }
        else if (_currentPage == self.docInfo.numberOfPages) {
            self.nextButton.enabled = NO;
            self.previousButton.enabled = YES;
        }
        else
        {
            self.previousButton.enabled = YES;
            self.nextButton.enabled = YES;
        }
    }
    self.pageNumLabel.text = [NSString stringWithFormat:@"%d/%lu",_currentPage,(unsigned long)_docInfo.numberOfPages];
    [self.pageNumLabel sizeToFit];
    [self.view setNeedsLayout];
    
    
}
#pragma mark - User Interactions
- (void)onClearAllPressed:(id)sender
{
    [_lines clear];
    [_cmdHander sendPureCmd:NTESWhiteBoardCmdTypeClearLines to:nil];
    
}

- (void)onCancelLinePressed:(id)sender
{
    [_lines cancelLastLine:_myUid];
    [_cmdHander sendPureCmd:NTESWhiteBoardCmdTypeCancelLine to:nil];
}

- (void)onColorSelectPressed:(id)sender
{
    [self.colorSelectView setHidden:!(self.colorSelectView.hidden)];
}

- (void)onColorSeclected:(int)rgbColor
{
    [self.colorSelectButton setBackgroundColor:UIColorFromRGB(rgbColor)];
    _myDrawColorRGB = rgbColor;
    [self.colorSelectView setHidden:YES];
}

- (void)onOpenDocumentPressed:(id)sender
{
//    NTESDocumentViewController *docVc = [[NTESDocumentViewController alloc]init];
//    docVc.delegate = self;
//    [self.navigationController pushViewController:docVc animated:YES];
}

- (void)onNextPagePressed:(id)sender
{
    self.currentPage++;
    [self loadImageOnWhiteboard];
}

- (void)onPreviousPagePressed:(id)sender
{
    self.currentPage--;
    [self loadImageOnWhiteboard];
}

-(void)onCloseDocPressed:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定关闭文档，回到纯白版模式吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"关闭文档", nil];
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        switch (index) {
            case 1:{
                self.docView.hidden = YES;
                self.nextButton.hidden = YES;
                self.previousButton.hidden = YES;
                self.pageNumLabel.hidden = YES;
                self.closeDocButton.hidden = YES;
                self.drawView.backgroundColor = [UIColor whiteColor];
                self.currentPage = 0;
//                [self onSendDocShareInfoToUser:nil];
                break;
            }
                
            default:
                break;
        }
    }];
}
#pragma mark  - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (_whiteBoardON == YES) {
        self.colorSelectView.hidden = YES;
        CGPoint p = [[touches anyObject] locationInView:_drawView];
        [self onPointCollected:p type:NTESWhiteboardPointTypeStart];
    }else{
        
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_whiteBoardON == YES) {
        
        CGPoint p = [[touches anyObject] locationInView:_drawView];
        [self onPointCollected:p type:NTESWhiteboardPointTypeMove];
    }else{
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_whiteBoardON == YES) {
        
        CGPoint p = [[touches anyObject] locationInView:_drawView];
        [self onPointCollected:p type:NTESWhiteboardPointTypeEnd];
    }else{
        
    }
}

- (void)onPointCollected:(CGPoint)p type:(NTESWhiteboardPointType)type{
    
    if (p.x < 0 || p.y < 0 || p.x > _drawView.frame.size.width || p.y > _drawView.frame.size.height) {
        return;
    }
    
    NTESWhiteboardPoint *point = [[NTESWhiteboardPoint alloc] init];
    point.type = type;
    point.xScale = p.x/_drawView.frame.size.width;
    point.yScale = p.y/_drawView.frame.size.height;
    point.colorRGB = _myDrawColorRGB;
    [_cmdHander sendMyPoint:point];
    [_lines addPoint:point uid:_myUid];
}


# pragma mark - NTESMeetingRTSManagerDelegate
- (void)onReserve:(NSString *)name result:(NSError *)result
{
    if (result == nil) {
        NSError *result = [[NTESMeetingRTSManager defaultManager] joinConference:_name];
    }
    else {
        [self.view makeToast:[NSString stringWithFormat:@"预订白板出错:%zd", result.code]];
    }
}

- (void)onJoin:(NSString *)name result:(NSError *)result
{
    if (result == nil) {
        
        _whiteBoardON = YES;
        if (_isJoined == YES) {
            
        }else{
            _isJoined = YES;
            [self checkPermission];
            [self.view makeToast:@"进入互动"];
            //白板可用的通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"WhiteBoardEnable" object:nil];
            [_lines clear];
            //聊天不可以发送语音
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"CanSendVoice"];
            [_cmdHander sendPureCmd:NTESWhiteBoardCmdTypeSyncRequest to:nil];
            
            _hintLabel.text = @"正在进行白板互动";
        }
        
    }else{
        
    }
}

- (void)onLeft:(NSString *)name error:(NSError *)error
{
    [self.view makeToast:[NSString stringWithFormat:@"已离开白板:%zd", error.code]];
    _isJoined = NO;
    
    NSError *result = [[NTESMeetingRTSManager defaultManager] joinConference:_name];
    
    [self checkPermission];
}

- (void)onUserJoined:(NSString *)uid conference:(NSString *)name
{
    
    //加入音视频互动了
    
}

- (void)onUserLeft:(NSString *)uid conference:(NSString *)name
{
    
    if ([uid isEqualToString:_myUid]) {
        
        //自己再加入一次
        [[NTESMeetingRTSManager defaultManager] joinConference:_roomID];
    }
}

#pragma mark - NTESWhiteboardCmdHandlerDelegate
- (void)onReceivePoint:(NTESWhiteboardPoint *)point from:(NSString *)sender
{
    [_lines addPoint:point uid:sender];
}

- (void)onReceiveCmd:(NTESWhiteBoardCmdType)type from:(NSString *)sender
{
    if (type == NTESWhiteBoardCmdTypeCancelLine) {
        [_lines cancelLastLine:sender];
    }
    else if (type == NTESWhiteBoardCmdTypeClearLines) {
        [_lines clear];
        [_cmdHander sendPureCmd:NTESWhiteBoardCmdTypeClearLinesAck to:nil];
    }
    else if (type == NTESWhiteBoardCmdTypeClearLinesAck) {
        [_lines clearUser:sender];
    }
    else if (type == NTESWhiteBoardCmdTypeSyncPrepare) {
        [_lines clear];
        [_cmdHander sendPureCmd:NTESWhiteBoardCmdTypeSyncPrepareAck to:sender];
    }
    
    
}

- (void)onReceiveSyncRequestFrom:(NSString *)sender{
    
    
}

- (void)onReceiveSyncPoints:(NSMutableArray *)points owner:(NSString *)owner
{
    [_lines clearUser:owner];
    
    for (NTESWhiteboardPoint *point in points) {
        [_lines addPoint:point uid:owner];
    }
}

- (void)onReceiveLaserPoint:(NTESWhiteboardPoint *)point from:(NSString *)sender
{
    [self.laserView setHidden:NO];
    CGPoint p = CGPointMake(point.xScale * self.drawView.frame.size.width , point.yScale * self.drawView.frame.size.height);
    self.laserView.center = p;
}

-(void)onReceiveHiddenLaserfrom:(NSString *)sender{
    
    [self.laserView setHidden:YES];
}


#pragma mark- 监听回调
/** 给白板发送收到屏幕共享消息了的回调方法 */
- (void)recivedDesktopShared:(NSNotification *)note{
    
    /** 
     id: '1498890637474', # 使用时间戳
     parentID: '1498888033381' # 父消息ID
     type: 'InteractiveSwitchResponse', # 消息类型
     status: 'read' # 消息已读
     
     格式:
     "当前时间戳,收到的消息的时间戳,InteractiveSwitchResponse,read"
     */
    
    NSString *parentID = [note object];
    NSString *timeStamp = [@"" getCurrentTimestamp];
    NSString *receved = [NSString stringWithFormat:@"17:%@,%@,InteractiveSwitchResponse,read;",timeStamp,parentID];
    NSLog(@"%@",receved);
//    [_cmdHander sendRecieved:receved];
    
     [[NTESMeetingRTSManager defaultManager] sendRTSData:[receved dataUsingEncoding:NSUTF8StringEncoding] toUser:nil];
    NSLog(@"给白板回复了收到屏幕共享开关的消息");
    
}





#pragma mark - NIMLoginManagerDelegate
- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepLoginOK) {
        if (!_isJoined) {
            NSError *result = [[NTESMeetingRTSManager defaultManager] joinConference:_classID];
            //            DDLogError(@"Rejoin rts conference: %@ result %zd", _name, result.code);
        }
    }
}

#pragma mark - private method
-(void)loadImageOnWhiteboard
{

}



-(UIImage *)loadImage:(NSString*)filePath{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:filePath]) {
        NSData * data = [NSData dataWithContentsOfFile:filePath];
        UIImage *image = [UIImage imageWithData:data];
        return image;
    }
    return nil;
}


- (void)whiteBoardOff{
    
    _whiteBoardON = NO;
    [[NTESMeetingRolesManager defaultManager]setMyWhiteBoard:NO];
    self.maskView.hidden = NO;
    [self.maskView updateLayout];
    _hintLabel.text = @"正在进行屏幕共享";
    
}

- (void)whiteBoardOn{
    
    _whiteBoardON = YES;
    [[NTESMeetingRolesManager defaultManager]setMyWhiteBoard:YES];
    self.maskView.hidden = YES;
    [self.maskView updateLayout];
    _hintLabel.text = @"正在进行白板互动";
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        //转回竖屏的时候,白板重新加载一下子
//        [[NTESMeetingRTSManager defaultManager].dataHandler handleReceivedData:nil sender:nil];
        [_drawView updateLayout];
        if (_whiteBoardON == YES) {
            self.maskView.hidden = YES;
        }else{
            
            self.maskView.hidden = NO;
        }
        
        
    }else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        //白板转到全屏的时候 ,直接关闭
         
        
    }
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    

    
}


@end
