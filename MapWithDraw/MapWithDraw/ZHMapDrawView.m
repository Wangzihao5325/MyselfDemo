//
//  ZHMapDrawView.m
//  MapWithDraw
//
//  Created by 王子豪 on 16/8/7.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "ZHMapDrawView.h"

@implementation ZHMapDrawView
-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self!=nil) {
        self.isDrawing = FALSE;
        int width = self.bounds.size.width;
        int height = self.bounds.size.height;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();//创建rgb色域
        context = CGBitmapContextCreate(Nil, width, height, 8, 4 * width,
                                        colorSpace, kCGImageAlphaPremultipliedFirst);
        CGColorSpaceRelease(colorSpace);
    }
    
    return self;
}


-(void)drawRect:(CGRect)rect{

    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextDrawImage(currentContext, rect, image);
    CGImageRelease(image);
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (!self.isDrawing) {
        return;
    }
    
    CGPoint nowPoint = [[touches anyObject]locationInView:self];
    CGPoint previousPoint = [[touches anyObject]previousLocationInView:self];
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 3);
    CGContextMoveToPoint(context, previousPoint.x, previousPoint.y);
    CGContextAddLineToPoint(context, nowPoint.x, nowPoint.y);
    CGContextSetRGBStrokeColor(context,0,0,1,1);
    CGContextStrokePath(context);
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (!self.isDrawing) {
        return;
    }
    
    self.isDrawing = FALSE;
    CGContextClearRect(context, self.frame);
    [self setNeedsDisplay];
}
@end
