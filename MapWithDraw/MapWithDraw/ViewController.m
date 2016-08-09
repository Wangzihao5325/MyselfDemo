//
//  ViewController.m
//  MapWithDraw
//
//  Created by 王子豪 on 16/8/7.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)buildMap{

    isDrawing = FALSE;
    pointMuArr = [[NSMutableArray alloc]initWithCapacity:100];
    
    
    mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    mapView.mapType = MKMapTypeStandard;
    mapView.delegate = self;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 34.16;
    coordinate.longitude = 108.54;
    MKCoordinateSpan span;
    span.latitudeDelta = 50;
    span.longitudeDelta = 50;
    MKCoordinateRegion region;
    region.span = span;
    region.center = coordinate;

    
    [mapView setRegion:region];
    [self.view addSubview:mapView];
    
    myButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    myButton.backgroundColor = [UIColor colorWithRed:240/255.0 green:255/255.0 blue:255/255.0 alpha:0.8];
    [myButton setTitle:@"draw" forState:UIControlStateNormal];
    [myButton addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    [mapView addSubview:myButton];
    
    [self addDrawViewTo:mapView];
    
    
}

-(void)addDrawViewTo:(MKMapView*)mapViewObj{
    
    drawView = [[ZHMapDrawView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    drawView.backgroundColor = [UIColor clearColor];
    [mapViewObj addSubview:drawView];
}

-(void)clickButton{
    [mapView setScrollEnabled:NO];
    [mapView setZoomEnabled:NO];
    isDrawing = YES;
    drawView.isDrawing = TRUE;
    [drawView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self buildMap];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!isDrawing) {
        return;
    }
    [pointMuArr removeAllObjects];
    [mapView removeOverlay:myPolygon];
    CGPoint point = [[touches anyObject] locationInView:self.view];
    [pointMuArr addObject:[NSValue valueWithCGPoint:point]];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!isDrawing) {
        return;
    }
    CGPoint point = [[touches anyObject] locationInView:self.view];
    [pointMuArr addObject:[NSValue valueWithCGPoint:point]];

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!isDrawing) {
        return;
    }
    //关键代码
    CLLocationCoordinate2D coors[[pointMuArr count]];
//    CLLocationCoordinate2D *coors = malloc([pointMuArr count]*sizeof(CLLocationCoordinate2D));
    for (int i = 0; i < [pointMuArr count]; i ++) {
        CGPoint point = [[pointMuArr objectAtIndex:i] CGPointValue];
        CLLocationCoordinate2D coor = [mapView convertPoint:point toCoordinateFromView:mapView];//把屏幕上的点转化为经纬度
        coors[i] = CLLocationCoordinate2DMake(coor.latitude,coor.longitude);
    }
    myPolygon = [MKPolygon polygonWithCoordinates:coors count:[pointMuArr count]];//根据经纬度上的点生成多边形
    [mapView addOverlay:myPolygon];
    
    [mapView setScrollEnabled:YES];
    [mapView setZoomEnabled:YES];
    isDrawing = NO;
    [drawView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        MKPolygonView* aView = [[MKPolygonView alloc]initWithPolygon:(MKPolygon*)overlay];
        aView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        aView.lineWidth = 3;
        return aView;
    }
    return nil;
}
@end
