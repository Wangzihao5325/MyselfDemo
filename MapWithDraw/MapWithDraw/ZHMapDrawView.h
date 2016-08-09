//
//  ZHMapDrawView.h
//  MapWithDraw
//
//  Created by 王子豪 on 16/8/7.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHMapDrawView : UIView{
    CGContextRef context;
}
@property(nonatomic)BOOL isDrawing;
@end
