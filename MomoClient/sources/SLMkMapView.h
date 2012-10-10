//
//  SLMkMapView.h
//  sendLoc
//
//  Created by Gao Semaus on 11-9-21.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SLMkMapView : MKMapView
{
    UILongPressGestureRecognizer *gestureRecognizer;
}
@end
