//
//  PathModal.h
//  Demo
//
//  Created by 淼视觉 on 2017/9/25.
//  Copyright © 2017年 倪大头. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathModel : NSObject

@property (nonatomic,strong)UIColor *color;

@property (nonatomic,assign)CGFloat width;

@property (nonatomic,assign)CGMutablePathRef path;

@property (nonatomic,assign)BOOL isErase;//是否是橡皮擦模式

@end
