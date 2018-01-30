//
//  SegmentView.m
//  Demo
//
//  Created by 淼视觉 on 2018/1/30.
//  Copyright © 2018年 倪大头. All rights reserved.
//

#import "SegmentView.h"

@interface SegmentView()

@property (nonatomic, strong)UIScrollView *myScrollView;

@end

@implementation SegmentView
{
    CGFloat AW;
    NSMutableArray *labelArray;//存放标题的数组
    UIView *lineView;//标题下划线
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.myScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.myScrollView];
    }
    return self;
}

- (void)setTitleViewWithArray:(NSArray *)titleArray {
    //存放标题宽度的数组
    NSMutableArray *textWArray = [NSMutableArray array];
    labelArray = [NSMutableArray array];
    
    //计算scrollView.contentSize.width
    AW = 0;
    
    for (NSString *str in titleArray) {
        CGFloat textW = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
        [textWArray addObject:@(textW)];
        //计算所有标题宽度总和
        AW = textW + AW;
    }
    
    AW = AW + titleArray.count * 20 + 20;
    
    self.myScrollView.contentSize = CGSizeMake(AW, 0);
    
    for (int i = 0; i < textWArray.count; i++) {
        //创建标题label，间隔20距离
        UILabel *lastLabel;
        
        CGFloat startW;//按钮frame.x的位置

        if (i > 0) {
            lastLabel = labelArray[i - 1];
            startW = CGRectGetMaxX(lastLabel.frame) + 20;
        }else {
            startW = 20;
        }
   
        CGFloat W = [textWArray[i] floatValue];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(startW, 0, W, self.frame.size.height)];
        titleLabel.text = titleArray[i];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self.myScrollView addSubview:titleLabel];
        [titleLabel sizeToFit];
        titleLabel.center = CGPointMake(titleLabel.center.x, 40/2);
        [labelArray addObject:titleLabel];
    }
    
    lineView = [[UIView alloc]initWithFrame:CGRectMake(20, 38, [textWArray.firstObject floatValue], 1)];
    lineView.backgroundColor = [UIColor blackColor];
    [self.myScrollView addSubview:lineView];
}

- (void)beginMoveWithProgress:(CGFloat)progress {
    CGFloat decimal = progress - (int)progress;
    UILabel *fromLabel;
    UILabel *nextLabel;
    if (progress == labelArray.count - 1) {//最后一页
        fromLabel = labelArray[(int)progress];
        nextLabel = labelArray[(int)progress];
    }else {
        fromLabel = labelArray[(int)progress];
        nextLabel = labelArray[(int)progress + 1];
    }
    
    CGRect newFrame = lineView.frame;
    
    if (decimal < 0.5) {//前半页
        newFrame.origin.x = CGRectGetMinX(fromLabel.frame);
        newFrame.size.width = fromLabel.frame.size.width + (20 + nextLabel.frame.size.width) * decimal * 2;
    }else {//后半页
        newFrame.origin.x = CGRectGetMinX(fromLabel.frame) + (20 + fromLabel.frame.size.width) * (decimal - 0.5) * 2;
        newFrame.size.width = nextLabel.frame.size.width + (20 + fromLabel.frame.size.width) * (1 - decimal) * 2;
    }
    
    lineView.frame = newFrame;
    
    //选中的标题移动到屏幕中间
    [self setSelectLabelCenter:fromLabel];
}

- (void)setSelectLabelCenter:(UILabel *)selectLabel {
    if (selectLabel.center.x < UI_SCREEN_WIDTH/2) {
        [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if ((selectLabel.center.x + UI_SCREEN_WIDTH/2) < self.myScrollView.contentSize.width) {
        [self.myScrollView setContentOffset:CGPointMake(selectLabel.center.x - UI_SCREEN_WIDTH/2, 0) animated:YES];
    }else {
        [self.myScrollView setContentOffset:CGPointMake(self.myScrollView.contentSize.width - UI_SCREEN_WIDTH, 0) animated:YES];
    }
}

@end
