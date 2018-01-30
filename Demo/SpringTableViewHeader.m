//
//  SpringTableViewHeader.m
//  Demo
//
//  Created by 淼视觉 on 2017/9/12.
//  Copyright © 2017年 倪大头. All rights reserved.
//

#import "SpringTableViewHeader.h"

@interface SpringTableViewHeader ()

@end

@implementation SpringTableViewHeader
{
    UITableView *myTableView;
    UIImageView *bannerImg;
    NSMutableArray *sectionArr;//记录section开合状态的数组
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    sectionArr = [NSMutableArray arrayWithObjects:@"1",@"0",@"0", nil];//"1"表示展开,"0"表示收起

    [self createView];
}

- (void)createView {
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -kScaleY*200, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT+kScaleY*200) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.tableHeaderView = [self createHeaderView];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    
    //返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(6, 25, 37, 34);
    [backBtn addTarget:self action:@selector(backPre) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
}

- (UIView *)createHeaderView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, kScaleY*500)];
    headerView.clipsToBounds = YES;
    
    bannerImg = [[UIImageView alloc]initWithFrame:headerView.frame];
    bannerImg.image = [UIImage imageNamed:@"swim"];
    bannerImg.contentMode = UIViewContentModeScaleAspectFill;
    [headerView addSubview:bannerImg];
    
    return headerView;
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([sectionArr[section] isEqualToString:@"1"]) {
        return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"springCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setCell:cell withIndexPath:indexPath];
    
    return cell;
}

- (void)setCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UILabel *cellLabel = [[UILabel alloc]init];
    cellLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row];
    cellLabel.textColor = [UIColor colorWithHexString:@"#333333" alpha:1];
    cellLabel.font = [UIFont fontWithName:LightFont size:17];
    [cellLabel sizeToFit];
    cellLabel.center = CGPointMake(kScaleX*15+cellLabel.frame.size.width/2, kScaleY*50/2);
    [cell.contentView addSubview:cellLabel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScaleY*50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, kScaleY*65)];
    sectionHeader.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *sectionHeaderTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionHeaderAction:)];
    sectionHeader.tag = section;
    [sectionHeader addGestureRecognizer:sectionHeaderTap];
    
    UILabel *sectionTitle = [[UILabel alloc]init];
    sectionTitle.text = [Utils iphoneType];
    sectionTitle.textColor = [UIColor colorWithHexString:@"#333333" alpha:1];
    sectionTitle.font = [UIFont fontWithName:LightFont size:15];
    [sectionTitle sizeToFit];
    sectionTitle.center = CGPointMake(kScaleX*15+sectionTitle.frame.size.width/2, kScaleY*65/2);
    [sectionHeader addSubview:sectionTitle];
    
    UIView *sectionLine = [[UIView alloc]initWithFrame:CGRectMake(kScaleX*15, kScaleY*65-1, kScaleX*360, 1)];
    sectionLine.backgroundColor = [UIColor colorWithHexString:@"#d8d8d8" alpha:1];
    [sectionHeader addSubview:sectionLine];
    
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kScaleY*65;
}

- (void)sectionHeaderAction:(UITapGestureRecognizer *)tap {
    if ([sectionArr[tap.view.tag] isEqualToString:@"1"]) {
        [sectionArr replaceObjectAtIndex:tap.view.tag withObject:@"0"];
    }else {
        [sectionArr replaceObjectAtIndex:tap.view.tag withObject:@"1"];
    }
    [myTableView reloadSections:[NSIndexSet indexSetWithIndex:tap.view.tag] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat downHight = -scrollView.contentOffset.y;//下拉的距离
    CGRect frame = bannerImg.frame;
    if (downHight < 0) {
        frame.size.height = kScaleY*500;
        bannerImg.frame = frame;
    }else if (downHight < kScaleY*200) {
        frame.size.height = kScaleY*500 + downHight;
        bannerImg.frame = frame;
    }else {
        frame.size.height = kScaleY*500 + kScaleY*200;
        bannerImg.frame = frame;
        
        myTableView.contentOffset = CGPointMake(0, -kScaleY*200);//最多往下拉动的距离，防止漏出白边
    }
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
