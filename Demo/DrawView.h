//
//  DrawView.h
//  Demo
//
//  Created by 淼视觉 on 2017/9/25.
//  Copyright © 2017年 倪大头. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DrawView;
@protocol drawViewDelegate <NSObject>

- (void)drawViewTouchBegan;

@end
@interface DrawView : UIView
{
    CGMutablePathRef path;
    NSMutableArray *pathModelArray;//路径保存数组
}

@property (nonatomic,strong)UIColor *lineColor;//线条颜色

@property (nonatomic,assign)CGFloat lineWidth;//线条粗细

@property (nonatomic,assign)BOOL isErase;//是否是橡皮擦模式

@property id<drawViewDelegate>myDelegate;

- (void)undoAction;

- (void)clearAction;

@end
