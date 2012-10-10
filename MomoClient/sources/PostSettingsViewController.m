#import "PostSettingsViewController.h"

#define kPasswordFooterSectionHeight         68.0f
#define kResizePhotoSettingSectionHeight     60.0f
#define TAG_PICKER_STATUS       0
#define TAG_PICKER_VISIBILITY   1
#define TAG_PICKER_DATE         2

@interface PostSettingsViewController (Private)

- (void)showPicker:(UIView *)picker;
- (void)geocodeCoordinate:(CLLocationCoordinate2D)c;

@end

@implementation PostSettingsViewController
//@synthesize postDetailViewController;
@synthesize geolocation;

- (void)dealloc {
    if (locationManager) {
		locationManager.delegate = nil;
		[locationManager stopUpdatingLocation];
		[locationManager release];
	}
	if (reverseGeocoder) {
		reverseGeocoder.delegate = nil;
		[reverseGeocoder cancel];
		[reverseGeocoder release];
	}
	[address release];
	[mapGeotagTableViewCell release];
    [removeGeotagTableViewCell release];
	mapView.delegate = nil;
	[mapView release];
	[addressLabel release];
	[coordinateLabel release];
	
    [actionSheet release];
    [popover release];
    [pickerView release];
    [datePickerView release];
    [visibilityList release];
    [statusList release];
    [geolocation release];
    
    [super dealloc];
}

- (void)endEditingAction:(id)sender {
	if (passwordTextField != nil){
    [passwordTextField resignFirstResponder];
	}
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)endEditingForTextFieldAction:(id)sender {
    [passwordTextField endEditing:YES];
}

- (void)viewDidLoad {

	
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
		locationManager.distanceFilter = 10;
		
		// FIXME: only add tag if it's a new post. If user removes tag we shouldn't try to add it again

			isUpdatingLocation = YES;
			[locationManager startUpdatingLocation];
}

- (void)viewDidUnload {
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    [locationManager release];
    locationManager = nil;
    
    [mapView release];
    mapView = nil;
    
    [reverseGeocoder cancel];
    reverseGeocoder.delegate = nil;
    [reverseGeocoder release];
    reverseGeocoder = nil;
    
    statusTitleLabel = nil;
    visibilityTitleLabel = nil;
    passwordTextField = nil;

    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self reloadData];
	[statusTableViewCell becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2; // Geolocation
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0)
		return NSLocalizedString(@"Publish", @"");
	else if (section == 1)
		return NSLocalizedString(@"Geolocation", @"");
	else
		return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
	case 0:
		
		break;
	case 1: // Geolocation
		switch (indexPath.row) {
			case 0: // Add/update location
				
				break;
			case 1:
				NSLog(@"Reloading map");
				if (mapGeotagTableViewCell == nil)
					mapGeotagTableViewCell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 188)];
				if (mapView == nil)
					mapView = [[MKMapView alloc] initWithFrame:CGRectMake(10, 0, 300, 130)];
				[mapView removeAnnotation:annotation];
				[annotation release];
				annotation = [[PostAnnotation alloc] initWithCoordinate:self.geolocation.coordinate];
				[mapView addAnnotation:annotation];

				if (addressLabel == nil)
					addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, 280, 30)];
				if (coordinateLabel == nil)
					coordinateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 162, 280, 20)];

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
//										postDetailViewController.post.geolocation.latitude,
//										postDetailViewController.post.geolocation.longitude];
				coordinateLabel.font = [UIFont italicSystemFontOfSize:13];
				coordinateLabel.textColor = [UIColor darkGrayColor];
				
				[mapGeotagTableViewCell addSubview:mapView];
				[mapGeotagTableViewCell addSubview:addressLabel];
				[mapGeotagTableViewCell addSubview:coordinateLabel];

				return mapGeotagTableViewCell;
				break;
			case 2:
				
				break;

		}
	}
	
    // Configure the cell
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0) && (indexPath.row == 1))
        return 88.f;
    else if ((indexPath.section == 1) && (indexPath.row == 1))
		return 188.0f;
	else
        return 44.0f;
}

- (void)reloadData {
	
    [tableView reloadData];
}

- (void)tableView:(UITableView *)atableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)aPickerView numberOfRowsInComponent:(NSInteger)component {
    if (aPickerView.tag == TAG_PICKER_STATUS) {
        return [statusList count];
    } else if (aPickerView.tag == TAG_PICKER_VISIBILITY) {
        return [visibilityList count];
    }
    return 0;
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)aPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (aPickerView.tag == TAG_PICKER_STATUS) {
        return [statusList objectAtIndex:row];
    } else if (aPickerView.tag == TAG_PICKER_VISIBILITY) {
        return [visibilityList objectAtIndex:row];
    }

    return @"";
}

- (void)pickerView:(UIPickerView *)aPickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [tableView reloadData];
}

- (void)datePickerChanged {
    [tableView reloadData];
}

#pragma mark -
#pragma mark Pickers and keyboard animations

- (void)showPicker:(UIView *)picker {
    
}

- (void)hidePicker {
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    [actionSheet release]; actionSheet = nil;
}

- (void)removeDate {
    

}

- (void)keyboardWillShow:(NSNotification *)keyboardInfo {
    isShowingKeyboard = YES;
}

- (void)keyboardWillHide:(NSNotification *)keyboardInfo {
    isShowingKeyboard = NO;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

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
		// Factor values (YMMV)
		// 0.0001 ~> whithin your zip code (for testing small map changes)
		// 0.01 ~> nearby cities (good for testing address label changes)
		double factor = 0.001f; 
		coordinate.latitude += factor * (rand() % 100);
		coordinate.longitude += factor * (rand() % 100);
#endif
		Coordinate *c = [[Coordinate alloc] initWithCoordinate:coordinate];
		self.geolocation = c;
		
        NSLog(@"Added geotag (%+.6f, %+.6f)",
			  c.latitude,
			  c.longitude);
		[locationManager stopUpdatingLocation];
		[tableView reloadData];
		
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
	NSLog(@"Reverse geocoder failed for coordinate (%.6f, %.6f): %@",
		  geocoder.coordinate.latitude,
		  geocoder.coordinate.longitude,
		  [error localizedDescription]);
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

@end
