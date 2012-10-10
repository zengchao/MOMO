//
//  ChatViewController.m
//  MOMO_DEMO
//
//  Created by 超 曾 on 12-4-15.
//  Copyright (c) 2012年 My Company. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize geolocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = (double)10;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
	CLLocationCoordinate2D coordinate = [location coordinate];
    Coordinate *c = [[Coordinate alloc] initWithCoordinate:coordinate];
    self.geolocation = c;
    [locationManager stopUpdatingLocation];    
    [self geocodeCoordinate:c.coordinate];
    
    [c release];
    if (mapView == nil)
        mapView = [[MKMapView alloc] initWithFrame:CGRectMake(10, 0, 300, 300)];
    [mapView removeAnnotation:annotation];
    [annotation release];
    annotation = [[PostAnnotation alloc] initWithCoordinate:self.geolocation.coordinate];
    [mapView addAnnotation:annotation];
    
    if (addressLabel == nil)
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 280, 30)];
    if (coordinateLabel == nil)
        coordinateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 332, 280, 20)];
    
    // Set center of map and show a region of around 200x100 meters
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.geolocation.coordinate, 200, 100);
    [mapView setRegion:region animated:YES];
    if (address) {
        addressLabel.text = address;
    } else {
        addressLabel.text = NSLocalizedString(@"Finding address...", @"");
        [self geocodeCoordinate:self.geolocation.coordinate];
    }
    addressLabel.font = [UIFont boldSystemFontOfSize:16];
    addressLabel.textColor = [UIColor darkGrayColor];
    CLLocationDegrees latitude = self.geolocation.latitude;
    CLLocationDegrees longitude = self.geolocation.longitude;
    int latD = trunc(fabs(latitude));
    int latM = trunc((fabs(latitude) - latD) * 60);
    int lonD = trunc(fabs(longitude));
    int lonM = trunc((fabs(longitude) - lonD) * 60);
    NSString *latDir = (latitude > 0) ? NSLocalizedString(@"North", @"") : NSLocalizedString(@"South", @"");
    NSString *lonDir = (longitude > 0) ? NSLocalizedString(@"East", @"") : NSLocalizedString(@"West", @"");
    if (latitude == 0.0) latDir = @"";
    if (longitude == 0.0) lonDir = @"";
    
    coordinateLabel.text = [NSString stringWithFormat:@"%i°%i' %@, %i°%i' %@",
                            latD, latM, latDir,
                            lonD, lonM, lonDir];
    //				coordinateLabel.text = [NSString stringWithFormat:@"%.6f, %.6f",
    //										self.geolocation.latitude,
    //										self.geolocation.longitude];
    coordinateLabel.font = [UIFont italicSystemFontOfSize:13];
    coordinateLabel.textColor = [UIColor darkGrayColor];
    
    [self.view addSubview:mapView];
    [self.view addSubview:addressLabel];
    [self.view addSubview:coordinateLabel];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [geolocation release];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
	// If it's a relatively recent event, turn off updates to save power
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
		if (!isUpdatingLocation) {
			return;
		}
		isUpdatingLocation = NO;
		CLLocationCoordinate2D coordinate = newLocation.coordinate;
#if FALSE // Switch this on/off for testing location updates
		double factor = 0.001f; 
		coordinate.latitude += factor * (rand() % 100);
		coordinate.longitude += factor * (rand() % 100);
#endif
		Coordinate *c = [[Coordinate alloc] initWithCoordinate:coordinate];
		self.geolocation = c;
        [locationManager stopUpdatingLocation];
		[self geocodeCoordinate:c.coordinate];
        
		[c release];
    }
    // else skip the event and process the next one.
}

#pragma mark -
#pragma mark MKReverseGeocoderDelegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	if (address)
		[address release];
	if (placemark.subLocality) {
		address = [NSString stringWithFormat:@"%@, %@, %@", placemark.subLocality, placemark.locality, placemark.country];
	} else {
		address = [NSString stringWithFormat:@"%@, %@, %@", placemark.locality, placemark.administrativeArea, placemark.country];
	}
	addressLabel.text = [address retain];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	//NSLog(@"Reverse geocoder failed for coordinate (%.6f, %.6f): %@",geocoder.coordinate.latitude,geocoder.coordinate.longitude,[error localizedDescription]);
	if (address)
		[address release];
	
	address = [NSString stringWithString:NSLocalizedString(@"Location unknown", @"")];
	addressLabel.text = [address retain];
}

- (void)geocodeCoordinate:(CLLocationCoordinate2D)c {
	if (reverseGeocoder) {
		if (reverseGeocoder.querying)
			[reverseGeocoder cancel];
		[reverseGeocoder release];
	}
	reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:c];
	reverseGeocoder.delegate = self;
	[reverseGeocoder start];	
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        //[self ViewFreshData];
    }
}

- (BOOL)supportEmoji  
{  
    BOOL hasEmoji = NO;  
#define kPreferencesPlistPath @"/private/var/mobile/Library/Preferences/com.apple.Preferences.plist"   
    NSDictionary *plistDict = [[NSDictionary alloc] initWithContentsOfFile:kPreferencesPlistPath];  
    NSNumber *emojiValue = [plistDict objectForKey:@"KeyboardEmojiEverywhere"];  
    if (emojiValue)     //value might not exist yet   
        hasEmoji = YES;  
    else  
        hasEmoji = NO;  
    [plistDict release];  
    
    return hasEmoji;  
}  


- (void)valueControl:(BOOL)open  
{  
    
#define kPreferencesPlistPath @"/private/var/mobile/Library/Preferences/com.apple.Preferences.plist"   
    NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:kPreferencesPlistPath];  
    [plistDict setValue:[NSNumber numberWithBool:open] forKey:@"KeyboardEmojiEverywhere"];  
    [plistDict writeToFile:kPreferencesPlistPath atomically:NO];  
    [plistDict release];  
}  



@end
