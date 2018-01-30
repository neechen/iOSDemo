//
//  DrawView.m
//  Demo
//
//  Created by 淼视觉 on 2017/9/25.
//  Copyright © 2017年 倪大头. All rights reserved.
//

#import "DrawView.h"
#import "PathModel.h"

@implementation DrawView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        pathModelArray = [NSMutableArray array];
        self.lineColor = [UIColor blackColor];
        self.lineWidth = 5.0;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    for (PathModel *model in pathModelArray) {//先把数组里的线条画上
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddPath(context, model.path);
        if (model.isErase) {//橡皮擦模式
            CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
            [[UIColor clearColor] setStroke];
            CGContextSetLineWidth(context, 15.0);
        }else {
            [model.color setStroke];
            CGContextSetLineWidth(context, model.width);
        }
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    if (path) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddPath(context, path);
        
        if (self.isErase) {//橡皮擦模式
            CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
            [[UIColor clearColor] setStroke];
            CGContextSetLineWidth(context, 15.0);//设置橡皮粗细
        }else {
            [self.lineColor setStroke];//设置画笔颜色
            CGContextSetLineWidth(context, self.lineWidth);//设置画笔粗细
        }
        
        CGContextDrawPath(context, kCGPathStroke);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.myDelegate drawViewTouchBegan];
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    //添加初始的点
    path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, currentPoint.x, currentPoint.y);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    //添加新的点
    CGPathAddLineToPoint(path, NULL, currentPoint.x, currentPoint.y);
    //重新绘图
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //保存每一笔线条
    PathModel *model = [[PathModel alloc]init];
    model.color = self.lineColor;
    model.width = self.lineWidth;
    model.path = path;
    model.isErase = _isErase;
    [pathModelArray addObject:model];
    
    CGPathRelease(path);
    path = nil;
}

- (void)undoAction {//撤销
    [pathModelArray removeLastObject];
    [self setNeedsDisplay];
}

- (void)clearAction {//清屏
    [pathModelArray removeAllObjects];
    [self setNeedsDisplay];
}

@end
