//
//  PathModal.m
//  Demo
//
//  Created by 淼视觉 on 2017/9/25.
//  Copyright © 2017年 倪大头. All rights reserved.
//

#import "PathModel.h"

@implementation PathModel

- (void)setPath:(CGMutablePathRef)path {
    if (_path != path) {
        _path = (CGMutablePathRef)CGPathRetain(path);
    }
}

- (void)dealloc {
    CGPathRelease(self.path);
}

@end
