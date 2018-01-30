//
//  SegmentView.h
//  Demo
//
//  Created by 淼视觉 on 2018/1/30.
//  Copyright © 2018年 倪大头. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SegmentView : UIView

- (void)setTitleViewWithArray:(NSArray *)titleArray;

- (void)beginMoveWithProgress:(CGFloat)progress;

@end
