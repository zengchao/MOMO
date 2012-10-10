//
//  ChatViewController.h
//  MOMO_DEMO
//
//  Created by 超 曾 on 12-4-15.
//  Copyright (c) 2012年 My Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ChatViewController : UIViewController<CLLocationManagerDelegate, MKReverseGeocoderDelegate>
{
    IBOutlet MKMapView *mapView;
    BOOL isUpdatingLocation;
    CLLocationManager *locationManager;
    NSString *address;
	MKReverseGeocoder *reverseGeocoder;
    IBOutlet UILabel *addressLabel;
	IBOutlet UILabel *coordinateLabel;
}
@end
