//
//  SqureMenu.m
//  YZSquareMenu
//
//  Created by Shin on 2016/9/28.
//  Copyright © 2016年 Shin. All rights reserved.
//

#import "YZSquareMenu.h"
#import "YZSquareMenuCell.h"


#define SCREENWIDTH self.frame.size.width
#define FRAMEWIDTH frame.size.width




@interface YZSquareMenu ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,YZSquareMenuDelegate>{
    
    UIView *_buttonView;
    UIImageView *iconView;
    UICollectionViewFlowLayout *layout;
    
}

@end

@implementation YZSquareMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        layout = [[UICollectionViewFlowLayout alloc]init];
        
        
        _collectionMenu=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) collectionViewLayout:layout];
        _collectionMenu.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_collectionMenu];
        
        
        [_collectionMenu registerClass:[YZSquareMenuCell class] forCellWithReuseIdentifier:@"cellId"];
        
      
        
    }
    return self;
}

- (void)setBreaklineStyle:(YZMenuBreaklineStyle *)breaklineStyle{
    
    _breaklineStyle = breaklineStyle;
    
}

- (void)setIconType:(YZMenuIconType *)iconType{
    
    _iconType= iconType;
    
    
    _collectionMenu.delegate = self;
    _collectionMenu.dataSource=self;
       
}

-(void)setLineWidth:(CGFloat)lineWidth{
    
    _lineWidth = lineWidth;
    
}

-(void)setBreaklineColor:(UIColor *)breaklineColor{
    
    _breaklineColor = breaklineColor;
    
}

-(void)setBreaklineWidthStyle:(YZBreaklineWidthStyle *)breaklineWidthStyle{
    
    _breaklineWidthStyle = breaklineWidthStyle;
}


-(void)setIconNumbers:(NSInteger)iconNumbers{
    
    _iconNumbers = iconNumbers;
    
    
    
}

-(void)setMenuIconName:(NSArray *)menuIconName{
    
    _menuIconName = menuIconName;
}


- (void)setMenuIconTitle:(NSArray *)menuIconTitle{
    
    _menuIconTitle = menuIconTitle;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return _lineWidth;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size;
    
    
    if (_iconNumbers<6) {
        
        size = CGSizeMake(CGRectGetWidth(self.frame)/_iconNumbers, CGRectGetWidth(self.frame)/_iconNumbers);
        
    }
    else{
        size = CGSizeMake(CGRectGetWidth(self.frame)/(_iconNumbers/2), CGRectGetWidth(self.frame)/(_iconNumbers/2));
        
        
    }
    
    
    return  size;
    
}

/* 初始化cell*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"cellId";
    YZSquareMenuCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.iconImage setImage:[UIImage imageNamed:_menuIconName[indexPath.row]]];
    [cell.iconTitle setText:_menuIconTitle[indexPath.row]];
    
    if (_iconType == YZMenuIconTypeRound) {
        cell.iconImage.layer.masksToBounds=YES;
        cell.iconImage.layer.cornerRadius = cell.iconImage.frame.size.width/2;
    }
    
    if (_iconType == YZMenuIconTypeCornerRound) {
        cell.iconImage.layer.masksToBounds=YES;
        cell.iconImage.layer.cornerRadius = M_PI*2;
    }
    
    if (_breaklineStyle ==YZMenuBreaklineStyleBottom) {
        
        
        UIView *line=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(cell.iconImage.frame), CGRectGetHeight(cell.contentView.frame), CGRectGetWidth(cell.iconImage.frame), self.lineWidth)];
        if (_breaklineWidthStyle==YZBreaklineWidthItem) {
            [line setFrame:CGRectMake(CGRectGetMinX(cell.contentView.frame), CGRectGetHeight(cell.contentView.frame), CGRectGetWidth(cell.contentView.frame), self.lineWidth)];
        }
        
              line.backgroundColor = self.breaklineColor;
        [cell.contentView addSubview: line];
        
    }
    
   
    
    if (_breaklineStyle ==YZMenuBreaklineStyleAll) {
        cell.contentView.layer.borderWidth=self.lineWidth;
        cell.contentView.layer.borderColor=self.breaklineColor.CGColor;
    }
    
    return cell;
    
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSLog(@"%ld",_iconNumbers);
    
    return  _iconNumbers;
    
}



#pragma mark- 公有方法实现

/* 初始化器1 一个方法涵盖所有属性*/
- (instancetype)initWithFrame:(CGRect)frame iconNumbers:(NSInteger)iconNumber menuIconName:(NSArray *)menuIconName menuIconTitle:(NSArray *)menuIconTitle iconType:(YZMenuIconType )iconType breaklineStyle:(YZMenuBreaklineStyle )breaklineStyle breaklineWidthStyle:(YZBreaklineWidthStyle)breaklineWidthStyle breaklineColor:(UIColor *)breaklineColor lineWidth:(CGFloat)lineWidth{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        layout = [[UICollectionViewFlowLayout alloc]init];
        
        
        _collectionMenu=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) collectionViewLayout:layout];
        _collectionMenu.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_collectionMenu];
        
        
        [_collectionMenu registerClass:[YZSquareMenuCell class] forCellWithReuseIdentifier:@"cellId"];
        
    
        
        self.iconNumbers = iconNumber;
        self.menuIconName = menuIconName;
        self.menuIconTitle = menuIconTitle;
        self.iconType = iconType;
        self.breaklineStyle = breaklineStyle;
        self.breaklineWidthStyle = breaklineWidthStyle;
        self.breaklineColor = breaklineColor;
        self.lineWidth = lineWidth;
        
    }
    
    return  self;
    
}

/* 初始化器2 一个方法调用图标和标题 参数为默认值*/
- (instancetype)initWithFrame:(CGRect)frame
                  iconNumbers:(NSInteger)iconNumber
                 menuIconName:(NSArray *)menuIconName
                menuIconTitle:(NSArray *)menuIconTitle
                     iconType:(YZMenuIconType)iconType{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        layout = [[UICollectionViewFlowLayout alloc]init];
        
        
        _collectionMenu=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)) collectionViewLayout:layout];
        _collectionMenu.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_collectionMenu];
        
        
        [_collectionMenu registerClass:[YZSquareMenuCell class] forCellWithReuseIdentifier:@"cellId"];
        self.iconNumbers = iconNumber;
        self.menuIconName = menuIconName;
        self.menuIconTitle = menuIconTitle;
        self.iconType = iconType;
        
        /* 默认部分*/
        
        self.breaklineStyle = YZMenuBreaklineStyleNone;
        
    }
    
    return  self;
    
    
    
}




/* 回调方法 点击事件*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [_yzSquareMenuDelegate touchesIconIndex:indexPath.row];
    
    
}




@end




