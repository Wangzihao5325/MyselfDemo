//
//  ViewController.h
//  MapWithDraw
//
//  Created by 王子豪 on 16/8/7.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ZHMapDrawView.h"
@interface ViewController : UIViewController<MKMapViewDelegate>{

    MKMapView *mapView;
    ZHMapDrawView *drawView;
    UIButton *myButton;
    
    NSMutableArray *pointMuArr;
    MKPolygon *myPolygon;
    BOOL isDrawing;
}
@end

