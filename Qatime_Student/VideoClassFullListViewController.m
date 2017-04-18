//
//  VideoClassFullListViewController.m
//  Qatime_Student
//
//  Created by Shin on 2017/4/18.
//  Copyright © 2017年 WWTD. All rights reserved.
//

#import "VideoClassFullListViewController.h"

@interface VideoClassFullListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *classArray ;

@end

@implementation VideoClassFullListViewController

-(instancetype)initWithArray:(NSArray *)classArray{
    self = [super init];
    if (self) {
        
        _classArray = [NSArray arrayWithArray:classArray];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _classList = [[UITableView alloc]init];
    [self.view addSubview:_classList];
    _classList.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
    _classList.dataSource = self;
    _classList.delegate = self;
    
}

#pragma mark- UITableView datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _classArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    /* cell的重用队列*/
    static NSString *cellIdenfier = @"cell";
    VideoClassFullScreenListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    if (cell==nil) {
        cell=[[VideoClassFullScreenListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (_classArray.count>indexPath.row) {
        cell.numbers.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        cell.model = _classArray[indexPath.row];
    }
    
    
    return  cell;
    

}

#pragma mark- UITableView delegate



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
