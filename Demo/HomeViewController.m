//
//  HomeViewController.m
//  Demo
//
//  Created by 淼视觉 on 2017/9/8.
//  Copyright © 2017年 倪大头. All rights reserved.
//

#import "HomeViewController.h"
#import "ContinueScrollView.h"//手动循环scrollView
#import "QRCodeViewController.h"//二维码生成/扫描
#import "RecordingViewController.h"//录音
#import "SpringTableViewHeader.h"//tableViewHeader拉伸
#import "DrawViewController.h"//画板（贝塞尔曲线）
#import "SegmentViewController.h"//Segment

@interface HomeViewController ()

@end

@implementation HomeViewController
{
    UITableView *myTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createView];
}

- (void)createView {
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-44) style:UITableViewStylePlain];
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        myTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        myTableView.scrollIndicatorInsets = myTableView.contentInset;
        myTableView.estimatedRowHeight = 0;
        myTableView.estimatedSectionHeaderHeight = 0;
        myTableView.estimatedSectionFooterHeight = 0;
    }
    [self.view addSubview:myTableView];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"homeCell";
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
    
    UIImageView *bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, kScaleY*120)];
    bgImg.image = [UIImage imageNamed:@"banner"];
    bgImg.contentMode = UIViewContentModeScaleAspectFill;
    bgImg.clipsToBounds = YES;
    [cell.contentView addSubview:bgImg];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:LightFont size:27];
    
    switch (indexPath.row) {
        case 0:
        {
            titleLabel.text = @"ScrollView循环滑动";
            break;
        }
        case 1:
        {
            titleLabel.text = @"二维码生成/扫描";
            break;
        }
        case 2:
        {
            titleLabel.text = @"录音";
            break;
        }
        case 3:
        {
            titleLabel.text = @"tableViewHeader拉伸";
            break;
        }
        case 4:
        {
            titleLabel.text = @"贝塞尔曲线";
            break;
        }
        case 5:
        {
            titleLabel.text = @"自定义Segment";
            break;
        }
            
        default:
            break;
    }
    
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(bgImg.frame.size.width/2, bgImg.frame.size.height/2);
    [cell.contentView addSubview:titleLabel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScaleY*121;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            ContinueScrollView *continueScroll = [[ContinueScrollView alloc]init];
            continueScroll.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:continueScroll animated:YES];
            break;
        }
        case 1:
        {
            QRCodeViewController *qrcodeVC = [[QRCodeViewController alloc]init];
            qrcodeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:qrcodeVC animated:YES];
            break;
        }
        case 2:
        {
            RecordingViewController *recording = [[RecordingViewController alloc]init];
            recording.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:recording animated:YES];
            break;
        }
        case 3:
        {
            SpringTableViewHeader *springHeader = [[SpringTableViewHeader alloc]init];
            springHeader.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:springHeader animated:YES];
            break;
        }
        case 4:
        {
            DrawViewController *drawViewController = [[DrawViewController alloc]init];
            drawViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:drawViewController animated:YES];
            break;
        }
        case 5:
        {
            SegmentViewController *segmentVC = [[SegmentViewController alloc]init];
            segmentVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:segmentVC animated:YES];
        }
            
        default:
            break;
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
