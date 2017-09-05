//
//  DownloadManagerViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/8/21.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "DownloadManagerViewController.h"
#import "NavigationBar.h"
#import "UIViewController+ReturnLastPage.h"
//#import "KsFileObjModel.h"
//#import "KsFileViewCell.h"
#import "KsFlieLookUpVC.h"
#import "UIView+Toast.h"
#import "UIControl+RemoveTarget.h"
#import "FileToolBar.h"
#import "UIAlertController+Blocks.h"
#import "CYLTableViewPlaceHolder.h"
#import "HaveNoClassView.h"
#import "CourseFile.h"
#import "CourseFileTableViewCell.h"
#import "UIViewController+HUD.h"
#import "MyDownloadFileTableViewCell.h"
#import <QuickLook/QuickLook.h>

@interface DownloadManagerViewController ()<UITableViewDelegate,UITableViewDataSource,QLPreviewControllerDelegate,QLPreviewControllerDataSource>{
    
    NavigationBar *_navigationBar;
    
    NSFileManager *_fileManager;
    
    NSString *_downloadPath;
    
    NSMutableArray *_filesArray;
    
    HaveNoClassView *_nofileView;
    
    BOOL _onEdit;
    
    BOOL _selectAll;
    
    NSURL *_savedFileURL;
    
}

@property (strong, nonatomic) NSMutableArray *selectedItems;//记录选中的cell的模型
@property (nonatomic,strong) UITableView *mainView;
@property (nonatomic,strong) UIDocumentInteractionController *documentInteraction;

@property (nonatomic, strong) FileToolBar * toolBar ;//删除工具栏

@end

@implementation DownloadManagerViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeNavigatioan];
    
    [self makeData];
    
    //读取和加载文件数据
    [self loadFiles];
    
    [self setupView];
    
    
}

- (void)makeNavigatioan{
    _navigationBar = [[NavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.width_sd, Navigation_Height)];
    [self.view addSubview:_navigationBar];
    _navigationBar.titleLabel.text = @"我的下载";
    [_navigationBar.leftButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [_navigationBar.leftButton addTarget:self action:@selector(returnLastPage) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar.rightButton setImage:[UIImage imageNamed:@"垃圾桶"] forState:UIControlStateNormal];
    [_navigationBar.rightButton addTarget:self action:@selector(editTableView:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)makeData{
    _fileManager = [NSFileManager defaultManager];
    _downloadPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"download"];
    
    _filesArray = @[].mutableCopy;
    _selectedItems = @[].mutableCopy;
    
}

- (void)loadFiles{
    
     NSArray<NSString *> *downLoadFiles = [_fileManager contentsOfDirectoryAtPath:_downloadPath error: NULL];
    for(NSString *str in downLoadFiles){
        MyDownloadFile *mod = [[MyDownloadFile alloc] initWithFilePath: [NSString stringWithFormat:@"%@/%@",_downloadPath, str]];
        [_filesArray addObject: mod];
    }
    
}

- (void)setupView{
    
    _mainView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_mainView];
    _mainView.sd_layout
    .leftSpaceToView(self.view,0)
    .topSpaceToView(_navigationBar, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
    _mainView.tableFooterView = [UIView new];
    _mainView.delegate = self;
    _mainView.dataSource = self;
    
    
    _toolBar = [[FileToolBar alloc]init];
    [self.view addSubview:_toolBar];
    _toolBar.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, -TabBar_Height)
    .heightIs(TabBar_Height);
    
    [_toolBar.selectAllBtn addTarget:self action:@selector(selecteAllItem:) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar.deletBtn addTarget:self action:@selector(deleteItems:) forControlEvents:UIControlEventTouchUpInside];
    
    _nofileView = [[HaveNoClassView alloc]initWithTitle:@"暂无下载内容"];
    [_mainView updateLayout];
    if (_filesArray.count == 0) {
        _navigationBar.rightButton.hidden = YES;
        [_mainView addSubview:_nofileView];
        _nofileView.frame = _mainView.bounds;
        [_mainView cyl_reloadData];
    }
}

- (void)editTableView:(id)sender{
    
    if ([sender isMemberOfClass:[UILongPressGestureRecognizer class]]) {
        //cell长按的回调
        UILongPressGestureRecognizer *sender1 = (UILongPressGestureRecognizer *)sender;
        switch (sender1.state) {
            case UIGestureRecognizerStateBegan:{
                
                if (_onEdit == NO) {
                    [self showToolBar];
                    [_navigationBar.rightButton setImage:nil forState:UIControlStateNormal];
                    [_navigationBar.rightButton setTitle:@"取消" forState:UIControlStateNormal];
                    _navigationBar.rightButton.sd_layout.autoWidthRatio(2.f);
                    [_navigationBar.rightButton updateLayout];

                    for (MyDownloadFileTableViewCell *cell in _mainView.visibleCells) {
                        [cell enterEditMode];
                    }
                    for (MyDownloadFile *mod in _filesArray) {
                        mod.onEdit = !_onEdit;
                    }
                    _onEdit = !_onEdit;
                }

            }
                break;
        }
        
    }else if ([sender isMemberOfClass:[UIButton class]]){
        //按钮
        if (_onEdit == NO) {
            [self showToolBar];
            [_navigationBar.rightButton setImage:nil forState:UIControlStateNormal];
            [_navigationBar.rightButton setTitle:@"取消" forState:UIControlStateNormal];
            _navigationBar.rightButton.sd_layout.autoWidthRatio(2.f);
            [_navigationBar.rightButton updateLayout];
            for (MyDownloadFileTableViewCell *cell in _mainView.visibleCells) {
                [cell enterEditMode];
            }
            for (MyDownloadFile *mod in _filesArray) {
                mod.onEdit = !_onEdit;
            }
        }else{
            [self hideToolBar];
            [_navigationBar.rightButton setImage:[UIImage imageNamed:@"垃圾桶"] forState:UIControlStateNormal];
            [_navigationBar.rightButton setTitle:nil forState:UIControlStateNormal];
            _navigationBar.rightButton.sd_layout.autoWidthRatio(1.0);
            [_navigationBar.rightButton updateLayout];
            for (MyDownloadFileTableViewCell *cell in _mainView.visibleCells) {
                [cell exitEditeMode];
                
            }
            for (MyDownloadFile *mod in _filesArray) {
                mod.onEdit = !_onEdit;
            }
            if (_selectedItems.count!=0) {
                for (MyDownloadFileTableViewCell *cell in _mainView.visibleCells) {
                    if (cell.sendBtn.selected) {
                        [cell clickBtn:cell.sendBtn];
                    }
                }
            }
        }
        _onEdit = !_onEdit;
    }
}


- (void)selecteAllItem:(UIButton *)sender{
  
    if (_selectedItems.count == _filesArray.count) {
        //现在已经是全选的了,那就直接, 不选了
        for (MyDownloadFileTableViewCell *cell in _mainView.visibleCells) {
            [cell clickBtn:cell.sendBtn];
        }
        _selectedItems = @[].mutableCopy;
        for (MyDownloadFile *mod in _filesArray) {
            mod.select = NO;
        }
        [_toolBar.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_toolBar.deletBtn setTitle:@"删除" forState:UIControlStateNormal];
    }else{
        for (MyDownloadFileTableViewCell *cell in _mainView.visibleCells) {
            if (cell.sendBtn.selected) {
                
            }else{
                [cell clickBtn:cell.sendBtn];
            }
        }
        _selectedItems = @[].mutableCopy;
        for (MyDownloadFile *mod in _filesArray) {
            mod.select = YES;
            [_selectedItems addObject:mod];
        }
       [_toolBar.selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        [_toolBar.deletBtn setTitle:[NSString stringWithFormat:@"删除(%ld)",_filesArray.count] forState:UIControlStateNormal];
    }
}

- (void)deleteItems:(UIButton *)sender{
    
    if (_selectedItems.count == 0) {
        
        [self HUDStopWithTitle:@"未选择任何项目"];
    }else{
        
        [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"是否确认删除?" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"删除"] tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex!=0) {
                [self HUDStartWithTitle:@"删除中"];
                //删除文件
                NSMutableArray *items = _selectedItems.copy;
                for (MyDownloadFile *mod in items) {
                    [_fileManager removeItemAtPath:mod.filePath error:nil];
                    [_selectedItems removeObject:mod];
                }
                _filesArray = @[].mutableCopy;
                [self loadFiles];
                [_mainView cyl_reloadData];
                [_toolBar.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
                [_toolBar.deletBtn setTitle:@"删除" forState:UIControlStateNormal];
                [self editTableView:_navigationBar.rightButton];
                [self HUDStopWithTitle:nil];
                
                if (_filesArray.count == 0) {
                    _navigationBar.rightButton.hidden = YES;
                }
            }
            
        }];
    }
    
}


- (void)showToolBar{
    [UIView animateWithDuration:0.3 animations:^{
       
        _toolBar.sd_layout
        .bottomSpaceToView(self.view, 0);
        _mainView.sd_layout
        .bottomSpaceToView(self.view, TabBar_Height);
        [_toolBar updateLayout];
        [_mainView updateLayout];
    }];
    
}

- (void)hideToolBar{
    [UIView animateWithDuration:0.3 animations:^{
       
        _toolBar.sd_layout
        .bottomSpaceToView(self.view, -TabBar_Height);
        _mainView.sd_layout
        .bottomSpaceToView(self.view, 0);
        [_toolBar updateLayout];
        [_mainView updateLayout];
    }];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_filesArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    MyDownloadFileTableViewCell *cell = (MyDownloadFileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"fileCell"];
    if (cell == nil) {
        cell = [[MyDownloadFileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fileCell"];
    }
    MyDownloadFile *actualFile = [_filesArray objectAtIndex:indexPath.row];
    actualFile.onEdit = _onEdit;
    cell.model = actualFile;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(editTableView:)];
    [cell addGestureRecognizer:longPress];
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
   
    __weak typeof(self) weakSelf = self;
    //设置cell的选中事件
    cell.Clickblock = ^(MyDownloadFile *model,UIButton *btn){
      
        if (btn.isSelected) {
            [weakSelf.selectedItems addObject:model];
        }else{
            [weakSelf.selectedItems removeObject:model];
        }
        
        if (weakSelf.selectedItems.count!=0) {
            [_toolBar.deletBtn setTitle:[NSString stringWithFormat:@"删除(%ld)",weakSelf.selectedItems.count] forState:UIControlStateNormal];
        }else{
            [_toolBar.deletBtn setTitle:@"删除" forState:UIControlStateNormal];
        }
        
        if (_selectedItems.count == _filesArray.count) {
            [_toolBar.selectAllBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        }else{
            [_toolBar.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        }
    };

    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyDownloadFile *actualFile = [_filesArray objectAtIndex:indexPath.row];
    NSString *cachePath =actualFile.filePath;
    
    NSLog(@"调用文件查看控制器%@---type %zd, %@",actualFile.name,actualFile.fileType,cachePath);
//    KsFlieLookUpVC *vc = [[KsFlieLookUpVC alloc] initWithFileModel:actualFile];
//    [self.navigationController pushViewController:vc animated:YES];
    
    
    _savedFileURL = [NSURL fileURLWithPath:actualFile.filePath];
    QLPreviewController *myQlPreViewController = [[QLPreviewController alloc]init];
    
    myQlPreViewController.delegate =self;
    
    myQlPreViewController.dataSource =self;
    
    [myQlPreViewController setCurrentPreviewItemIndex:0];
    
    [self presentViewController:myQlPreViewController animated:YES completion:nil];
    
}
#pragma mark - QLPreviewControllerDataSource

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller

{
    
    return 1;
    
}



- (id)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    
    return _savedFileURL; //返回文件路径
    
}


- (NSMutableArray *)selectedItems
{
    if (!_selectedItems) {
        _selectedItems = @[].mutableCopy;
    }
    return _selectedItems;
}

- (UIView *)makePlaceHolderView{
    
    return _nofileView;
}


- (BOOL)enableScrollWhenPlaceHolderViewShowing{
    return YES;
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
