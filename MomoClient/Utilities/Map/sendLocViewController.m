//
//  sendLocViewController.m
//  sendLoc
//
//  Created by Gao Semaus on 11-9-20.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import "sendLocViewController.h"
//#import "MapViewOverly.h"
#import "GAPI.h"
#import <CoreLocation/CoreLocation.h>

@implementation sendLocViewController
@synthesize mapview,isStartpos,in_latitude,in_longitude,in_title,in_subtitle;
@synthesize leftBtn;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"] autorelease];
    cell.textLabel.text = [[myArray objectAtIndex:indexPath.row] valueForKey:@"formatted_address"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [[[myArray objectAtIndex:indexPath.row] valueForKey:@"geometry"] valueForKey:@"location"];
    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([[dic valueForKey:@"lat"] doubleValue], [[dic valueForKey:@"lng"] doubleValue]);
    
    {
        NSArray *arr = [[myArray objectAtIndex:indexPath.row] valueForKey:@"address_components"];
        NSString *street = @"",*route=@"",*sublocalite=@"",*locality=@"";
        for (NSDictionary *tmp in arr) {
            if ([[tmp valueForKey:@"types"] containsObject:@"street_number"]) {
                street = [tmp valueForKey:@"long_name"];
            }
            if ([[tmp valueForKey:@"types"] containsObject:@"route"]) {
                route = [tmp valueForKey:@"long_name"];
            }
            if ([[tmp valueForKey:@"types"] containsObject:@"sublocality"]) {
                sublocalite = [tmp valueForKey:@"long_name"];
            }
            if ([[tmp valueForKey:@"types"] containsObject:@"locality"]) {
                locality = [tmp valueForKey:@"long_name"];
            }
        }
        NSString *result = [NSString stringWithFormat:@"%@%@%@%@",locality,sublocalite,route,street];
        
        [self addAnn:coor withTitle:result subTitle:[[myArray objectAtIndex:indexPath.row] valueForKey:@"formatted_address"]];
    }
    
    
    [mapview setRegion:MKCoordinateRegionMake(coor, mapview.region.span)];
    
    [self.searchDisplayController setActive:NO animated:YES];
}

#pragma mark -
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [messageVC dismissModalViewControllerAnimated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [mailVC dismissModalViewControllerAnimated:YES];
}

#pragma mark -
- (void)apiSuccess:(NSString *)_str
{
//    NSLog(@"%@",_str);
    NSDictionary *dic = [_str JSONValue];
    if ([[dic valueForKey:@"status"] isEqualToString:@"OK"]) {
        [myArray removeAllObjects];
        [myArray addObjectsFromArray:[dic valueForKey:@"results"]];
        [self.searchDisplayController.searchResultsTableView reloadData];
        
//        NSLog(@"%@",myArray);
    }
    else
    {
//        NSLog(@"error");
    }
}

- (void)apiError:(NSError *)_err
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    GAPI *api = [[GAPI alloc] init];
    [api setDelegate:self];
    [api requestURL:[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?address=%@&sensor=true",[[_searchBar text] URLEncodedString]] withSuccessSEL:@selector(apiSuccess:) errorSEL:@selector(apiError:)];
    [api release];
    
    searchText = [[NSString alloc] initWithString:[_searchBar text]];
    self.searchDisplayController.searchBar.placeholder = searchText;
//    self.searchDisplayController.searchBar.text = [_searchBar text];
}

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    controller.searchBar.text = searchText;
    [controller.searchResultsTableView reloadData];
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    
}


#pragma mark - View lifecycle
- (void)showSMSWithString:(NSString *)_str
{
    if ([MFMessageComposeViewController canSendText]) {
        if (messageVC) {
            [messageVC release];
            messageVC = nil;
        }
        messageVC = [[MFMessageComposeViewController alloc] init];
        [messageVC setBody:_str];
        messageVC.delegate = self;
        messageVC.messageComposeDelegate = self;
        [self presentModalViewController:messageVC animated:YES];
    }
    else
    {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:NSLocalizedString(@"The device can't send SMS now. Please check your system settings.",nil),nil] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
		[alertview show];
		[alertview release];
    }
}

- (void)showEmailWithString:(NSString *)_str title:(NSString *)_subject
{
    if ([MFMailComposeViewController canSendMail]) {
        if (mailVC) {
            [mailVC release];
            mailVC = nil;
        }
         mailVC = [[MFMailComposeViewController alloc] init];
        [mailVC setSubject:_subject];
        [mailVC setMessageBody:_str isHTML:YES];
        mailVC.delegate = self;
        mailVC.mailComposeDelegate = self;
        [self presentModalViewController:mailVC animated:YES];
    }
    else
    {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:NSLocalizedString(@"The device can't send Email now. Please check your system settings.",nil),nil] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
		[alertview show];
		[alertview release];
    }
}

#pragma mark -

- (void)annotationDidFinish:(Annotation *)_ann
{
    if([isStartpos isEqualToString:@"1"]){
        [[NSUserDefaults standardUserDefaults] setObject:_ann.title forKey:@"s_ann_title"];
        [[NSUserDefaults standardUserDefaults] setObject:_ann.subtitle forKey:@"s_ann_subtitle"];
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:_ann.title forKey:@"e_ann_title"];
        [[NSUserDefaults standardUserDefaults] setObject:_ann.subtitle forKey:@"e_ann_subtitle"];
    }
    [mapview selectAnnotation:_ann animated:YES];
}

- (void)addAnn:(CLLocationCoordinate2D)coor withTitle:(NSString *)_t subTitle:(NSString *)_subtitle
{
    static int i = 1;
    
    Annotation *ann = [[Annotation alloc] init];
    ann.coordinate = coor;
    [ann setDelegate:self];
    ann.title = NSLocalizedString(@"Loading...", nil);
    [ann setTag:i];
    if (_t && _subtitle) {
        [ann setTitle:_t];
        [ann setSubtitle:_subtitle];
    }
    else
    {
       [ann startLoc]; 
    }
    
    
    
    [mapview addAnnotation:ann];
    [ann release];
    i++;
}

- (void)touchesDidClick:(NSString *)_str
{
    [mapview removeAnnotations:[mapview annotations]];
    
//    NSLog(@"%@",_str);
    CGPoint point = CGPointFromString(_str);
    CLLocationCoordinate2D coor = [mapview convertPoint:point toCoordinateFromView:mapview];
    //NSLog(@"%f,%f",coor.latitude,coor.longitude);
    if([isStartpos isEqualToString:@"1"]){
        //NSLog(@"%@",[NSString stringWithFormat:@"%f",coor.latitude]);
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",coor.latitude] forKey:@"s_latitude"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",coor.longitude] forKey:@"s_longitude"];
        //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"s_latitude"]);
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",coor.latitude] forKey:@"e_latitude"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",coor.longitude] forKey:@"e_longitude"];
    }
    
    [self addAnn:coor withTitle:nil subTitle:nil];
    //[self.navigationController popViewControllerAnimated:TRUE];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        [self showSMSWithString:[NSString stringWithFormat:@"%@ http://maps.google.com/?q=%f,%f",clickString,loc.latitude,loc.longitude]];
    }
    else if (1 == buttonIndex)
    {
        [self showEmailWithString:[NSString stringWithFormat:@"%@ http://maps.google.com/?q=%f,%f",clickString,loc.latitude,loc.longitude] title:@"I'm here."];
    }
    else if (3 == buttonIndex)
    {
        UIPasteboard *appPasteBoard =  [UIPasteboard generalPasteboard];
		appPasteBoard.persistent = YES;
        NSString *pasteStr = [NSString stringWithFormat:@"%@ http://maps.google.com/?q=%f,%f",clickString,loc.latitude,loc.longitude];
		[appPasteBoard setString:pasteStr];
		
		UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"已复制",nil),nil] message:pasteStr delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
		[alertview show];
		[alertview release];
    }
    else if (2 == buttonIndex)
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/?q=%f,%f",loc.latitude,loc.longitude]];
        [[UIApplication sharedApplication] openURL:url];
    }
    else if (4 == buttonIndex)
    {
        int i = [actionSheet tag];
        for (Annotation *ann in [mapview annotations]) {
            if ([ann isKindOfClass:[Annotation class]] && ann.tag == i) {
                [mapview removeAnnotation:ann];
            }
        }
    }
}

- (void)showActionSheet:(int)i
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消",nil) destructiveButtonTitle:NSLocalizedString(@"发短信", nil) otherButtonTitles:NSLocalizedString(@"发邮件",nil),NSLocalizedString(@"谷歌地图",nil),NSLocalizedString(@"复制",nil),NSLocalizedString(@"删除",nil), nil];
//    [as showInView:self.view];
    [as showInView:[UIApplication sharedApplication].keyWindow];
    as.tag = i;
    [as release];
}

- (void)showDetails:(id)sender
{
    int i = [sender tag];
    NSArray *array = [mapview annotations];
    for (int j = 0; j < [array count]; j++) {
        if ([[array objectAtIndex:j] isKindOfClass:[Annotation class]] && [[array objectAtIndex:j] tag] == i) {
            [self showActionSheet:i];
            loc = [[array objectAtIndex:j] coordinate];
            [clickString release];
            clickString = nil;
            if (nil != [[array objectAtIndex:j] subtitle]) {
                clickString = [[NSString alloc] initWithString:[[array objectAtIndex:j] subtitle]];
            }
            else
            {
                clickString = @"";
            }
            
        }
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if (![annotation isKindOfClass:[Annotation class]]) {
        return nil;
    }
    static NSString *identifier = @"annotation";
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:identifier];  
    if (pinView == nil){        
        pinView = [[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];    
    }
    pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;
    pinView.draggable = YES;
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    rightButton.tag = [(Annotation *)annotation tag];
    [rightButton addTarget:self
                    action:@selector(showDetails:)
          forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView = rightButton;
    return pinView;

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState 
   fromOldState:(MKAnnotationViewDragState)oldState
{
    [(Annotation *)[view annotation] setTitle:NSLocalizedString(@"Loading...", nil)];
    [(Annotation *)[view annotation] setSubtitle:nil];
    [(Annotation *)[view annotation] startLoc];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    static BOOL firstRun = YES;
//    if (firstRun && !NotShouldLoc) {
//        firstRun = NO;
    [mapview setShowsUserLocation:FALSE];
    if([in_latitude doubleValue]>0){
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([in_latitude doubleValue], [in_longitude doubleValue]);
        [mapview setRegion:MKCoordinateRegionMake(coor, MKCoordinateSpanMake(0.007, 0.007)) animated:YES];
    }else{
        [mapview setRegion:MKCoordinateRegionMake(mapview.userLocation.coordinate, MKCoordinateSpanMake(0.007, 0.007)) animated:YES];
        [mapView setCenterCoordinate:mapview.userLocation.coordinate];
        
    }
//    }
}

- (void)saveAnn
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"myLoc.plist"];
	
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (Annotation *ann in [mapview annotations]) {
        if ([ann isKindOfClass:[Annotation class]]) {
            [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%f",ann.coordinate.latitude],@"lat",
                              [NSString stringWithFormat:@"%f",ann.coordinate.longitude],@"lng",
                              ann.title,@"title",
                              ann.subtitle,@"subtitle",
                              [NSString stringWithFormat:@"%f",mapview.centerCoordinate.latitude],@"mlat",
                              [NSString stringWithFormat:@"%f",mapview.centerCoordinate.longitude],@"mlng",
                              [NSString stringWithFormat:@"%f",mapview.region.span.latitudeDelta],@"mslat",
                              [NSString stringWithFormat:@"%f",mapview.region.span.longitudeDelta],@"mslng", 
                              nil]];
        }
    }
//    NSLog(@"%@",array);
    [array writeToFile:path atomically:YES];
    [array release];
    
}

#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        
    }
    else
    {
        [mapview removeAnnotations:[mapview annotations]];
    }
}

- (IBAction)cleanBtnDidClick:(id)sender {
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning!", nil) message:NSLocalizedString(@"All annotations will be deleted, continue?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"NO", nil) otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
    [al show];
    [al release];
}

- (void)viewWillAppear:(BOOL)animated
{
//    if (!NotFirstRun) {
//        NotFirstRun = YES;
        
//        NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"myLoc.plist"];
//        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//            NSArray *array = [NSArray arrayWithContentsOfFile:path];
//            for (NSDictionary *dic in array) {
//                CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([[dic valueForKey:@"lat"] doubleValue], [[dic valueForKey:@"lng"] doubleValue]);
//                [self addAnn:coor withTitle:[dic valueForKey:@"title"] subTitle:[dic valueForKey:@"subtitle"]];
//            }
//            if ([array count] > 0) {
//                NotShouldLoc = YES;
//                NSDictionary *dic = [array lastObject];
//                [mapview setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake([[dic valueForKey:@"mlat"] doubleValue], [[dic valueForKey:@"mlng"] doubleValue]), MKCoordinateSpanMake([[dic valueForKey:@"mslat"] doubleValue], [[dic valueForKey:@"mslng"] doubleValue])) animated:NO];
//            }
//        }
//    }
    
//    NSLog(@"%f,%f",[in_latitude doubleValue],[in_longitude doubleValue]);
//    CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([in_latitude doubleValue], [in_longitude doubleValue]);
//    [self addAnn:coor withTitle:in_title subTitle:in_subtitle];
//    //[mapview setZoomEnabled:TRUE];
//    
//    [mapview setRegion:MKCoordinateRegionMake(coor, MKCoordinateSpanMake(0.007, 0.007)) animated:YES];
    
    if([in_latitude doubleValue]>0)
    {
        CLLocationCoordinate2D coor = CLLocationCoordinate2DMake([in_latitude doubleValue], [in_longitude doubleValue]);
        [self addAnn:coor withTitle:in_title subTitle:in_subtitle];
        [mapview setRegion:MKCoordinateRegionMake(coor, MKCoordinateSpanMake(0.007, 0.007)) animated:YES];
        [mapview setShowsUserLocation:FALSE];
    }
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
    {
        [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
    }

    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 37)];
    [btnBack setBackgroundColor:[UIColor clearColor]];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(dismissWin) forControlEvents:UIControlEventTouchDown];
    
    
    UIBarButtonItem *barButtonIteLeft = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = barButtonIteLeft;
    [btnBack release];
    [barButtonIteLeft release];
    
    
    UIButton *btnDone = [[UIButton alloc] initWithFrame:CGRectMake(260, 0, 55, 37)];
    [btnDone setBackgroundColor:[UIColor clearColor]];
    [btnDone setBackgroundImage:[UIImage imageNamed:@"wancheng.png"] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(dismissWin) forControlEvents:UIControlEventTouchDown];
    
    
    UIBarButtonItem *barButtonIteRight = [[UIBarButtonItem alloc] initWithCustomView:btnDone];
    self.navigationItem.rightBarButtonItem = barButtonIteRight;
    [btnDone release];
    [barButtonIteRight release];
    
    
    self.title=@"选择和标注地点";
    
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
    
    myArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveAnn) name:@"saveAnn" object:nil];
}

- (void)dismissWin
{
    [self dismissModalViewControllerAnimated:TRUE];
}

- (void)viewDidUnload
{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"saveAnn" object:nil];
    [self setMapview:nil];
    [searchBar release];
    searchBar = nil;
    [searchDisplayController release];
    searchDisplayController = nil;
    [myArray release];
    myArray = nil;
    [isStartpos release];
    [in_latitude release];
    [in_longitude release];
    [in_title release];
    [in_subtitle release];
    [leftBtn release];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"saveAnn" object:nil];
    if (clickString) {
        [clickString release];
        clickString = nil;
    }
    if (searchText) {
        [searchText release];
        searchText = nil;
    }
    [myArray release];
    myArray = nil;
    if (messageVC) {
        [messageVC release];
        messageVC = nil;
    }
    if (mailVC) {
        [mailVC release];
        mailVC = nil;
    }
    [mapview release];
    [searchBar release];
    [searchDisplayController release];
    [isStartpos release];
    [in_latitude release];
    [in_longitude release];
    [in_title release];
    [in_subtitle release];
    [leftBtn release];
    
    [super dealloc];
}
@end
