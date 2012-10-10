
////  曾超
////  QQ:1490724

#import "FirstViewController.h"

@implementation FirstViewController
@synthesize btnRegister,btnLogin,backItem,rightBarButtonItem,btnBackImageView;
@synthesize myTableView; 
@synthesize list;
@synthesize locationManager;
@synthesize locationMeasurements;
@synthesize bestEffortAtLocation;
@synthesize titleLabel;
@synthesize request;

- (void)dealloc {
    [btnLogin release];
    [btnRegister release];
    [backItem release];
    [rightBarButtonItem release]; 
    [btnBackImageView release];
    [myTableView release];
    _refreshHeaderView=nil;
    [list release];
    [locationManager release];
    [thumbnail release];
    [titleLabel release];
    [locationMeasurements release];
    [bestEffortAtLocation release];
    [request cancel];
    [request release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.btnRegister =nil;
    self.btnLogin =nil;
    self.backItem =nil;
    self.rightBarButtonItem =nil;
    self.btnBackImageView =nil;
    self.myTableView =nil;
    _refreshHeaderView=nil;
    self.list =nil;
    self.locationManager =nil;
    thumbnail =nil;
    self.titleLabel =nil;
    self.locationMeasurements =nil;
    self.bestEffortAtLocation =nil;
    self.request=nil;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self!=nil) {
        self.title = @"拼车";
        CGRect tableViewFrame = self.view.bounds;
        tableViewFrame.size.height=410;
        //self.view.backgroundColor = [UIColor whiteColor];
        myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
        myTableView.delegate = self;
        myTableView.dataSource = self;
        myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        myTableView.scrollEnabled=YES;
        [self.view addSubview:self.myTableView];
    }
    return self;
}

- (void)viewDidLoad {
    
    
    
    self.locationMeasurements = [NSMutableArray array];
    
        
    
    btnBackImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_cover.png"]];
    btnBackImageView.frame = CGRectMake(0, 362, 320, 55);
    [self.view addSubview:btnBackImageView];
    
    btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogin.frame = CGRectMake(15, 365, 139, 49);
    btnLogin.backgroundColor = [UIColor clearColor];
    [btnLogin setImage:[UIImage imageNamed:@"register_normal.png"] forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(callRegisterWindow:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnLogin];

    btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRegister.frame = CGRectMake(167, 365, 139, 49);
    btnRegister.backgroundColor = [UIColor clearColor];
    [btnRegister setImage:[UIImage imageNamed:@"login_green.png"] forState:UIControlStateNormal];
    [btnRegister addTarget:self action:@selector(callLoginWindow:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btnRegister];
    
    self.myTableView.allowsSelection=FALSE;   
    [self.navigationController setNavigationBarHidden:FALSE];
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:(255.0/255.0) green:(127.0 / 255.0) blue:(0.0 / 255.0) alpha:1];

    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.myTableView.bounds.size.height, self.view.frame.size.width, self.myTableView.bounds.size.height)];
		view.delegate = self;
		[self.myTableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    list = [[NSMutableArray alloc] init];
    [self loadMemberList];
    
    //[self ViewFreshData];
    
    [super viewDidLoad];
}

-(void)loadMemberList
{
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = (double)10;
    [locationManager startUpdatingLocation];
    [self performSelector:@selector(stopUpdatingLocation:) withObject:@"Timed Out" afterDelay:(double)5];
    [self loadList]; 
    
}

- (void)stopUpdatingLocation:(NSString *)state {
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
}

- (void)loadList
{
    [list removeAllObjects];
    list = [[NSMutableArray alloc] init];
    CLLocation *location = [locationManager location];
	CLLocationCoordinate2D coordinate= [location coordinate];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%f",coordinate.latitude] forKey:@"x"];
    [params setObject:[NSString stringWithFormat:@"%f",coordinate.longitude] forKey:@"y"];
    
    [params setObject:[NSString stringWithFormat:@"%d",0] forKey:@"s"];
    [params setObject:[NSString stringWithFormat:@"%d",20] forKey:@"e"];
    
    NSString *postURL=[Utility createPostURL:params];
    [params release];
    
    NSString *baseurl=@"updatepos.php";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?%@",host_url,baseurl,postURL]];
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
	[request startSynchronous];
    
    if (request) {
        if ([request error]) {
            NSString *result = [[request error] localizedDescription];
            //NSLog(@"%@",result);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        } else if ([request responseString]) {
            NSString *result = [request responseString];
            //NSLog(@"%@",result);
            if([result isEqualToString:@"40023"] || [result isEqualToString:@"40024"]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                [alertView release];
                
            }else{
                NSDictionary *mydict = [result JSONValue];
                NSMutableDictionary *tmpDict;
                NSArray *resultArr = (NSArray *)mydict;
                for (NSDictionary *item in resultArr) {
                    tmpDict = [[NSMutableDictionary alloc] init];
                    [tmpDict setValue:[item objectForKey: @"username"] forKey:@"username"];
                    [tmpDict setValue:[item objectForKey: @"sex"] forKey:@"sex"];
                    [tmpDict setValue:[item objectForKey: @"qianming"] forKey:@"qianming"];
                    [tmpDict setValue:[item objectForKey: @"b_date"] forKey:@"b_date"];
                    [tmpDict setValue:[item objectForKey: @"update_time"] forKey:@"update_time"];
                    [tmpDict setValue:[item objectForKey: @"pic"] forKey:@"pic"];
                    NSString *distance = [NSString stringWithFormat:@"%@",[item objectForKey: @"distance"]];
                    if([distance isEqualToString:@"<null>"]){
                        [tmpDict setValue:@"0" forKey:@"distance"];
                    }else{
                        [tmpDict setValue:[item objectForKey: @"distance"] forKey:@"distance"];
                    }
                    [list addObject:tmpDict];
                    [tmpDict release];
                    
                }
            }
            
        }
    }else{
        NSLog(@"request is nil.");
    }
    
}

-(void) ViewFreshData{
    [self.myTableView setContentOffset:CGPointMake(0, -75) animated:YES];
    [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:0.4];
}

-(void)doneManualRefresh{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.myTableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.myTableView];
}


- (IBAction)callRegisterWindow:(UIButton *)sender
{
    if(![Utility connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        RegStepOneVC *vc = [[[RegStepOneVC alloc] initWithNibName:@"RegStepOneVC" bundle:nil] autorelease];
        backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backItem;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)callLoginWindow:(UIButton *)sender
{
    if(![Utility connectedToNetwork])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接失败,请查看网络是否连接正常！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        LoginViewController *vc = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
        backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backItem;  
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{  
    int i = [list count]/4;
    if([list count]%4>0)i=i+1;
    
    return i;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (void) unselectCurrentRow
{
    [self.myTableView deselectRowAtIndexPath:
    [self.myTableView indexPathForSelectedRow] animated:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
    [self performSelector:@selector(unselectCurrentRow) withObject:nil];
    tableView.allowsSelection=FALSE;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{        
    
    static NSString *CellIdentifier = @"Cell2";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    //删除cell.contentView中所有内容，避免以下建立新的重复
    int i = [[cell.contentView subviews] count] - 1;
    for(;i >= 0 ; i--)
    {
        [[[cell.contentView subviews] objectAtIndex:i] removeFromSuperview];
    }
    
    int cnt = 4;
    if([list count]>0){
        if(([list count]/4)<indexPath.row+1){
            cnt = [list count]%4;    
        }
    }else{
        cnt=0;
    }
    
    for(int i=0;i<cnt;i++){
        EGOImageView *asyncImageView = [[EGOImageView alloc] init];
		asyncImageView.frame = CGRectMake(kArticleCellHorizontalInnerPadding*(i+1)+(kCellWidth - kArticleCellHorizontalInnerPadding * 2)*i, kArticleCellVerticalInnerPadding, kCellWidth - kArticleCellHorizontalInnerPadding * 2, kCellHeight - kArticleCellVerticalInnerPadding * 2);
        
        //添加边框  
        CALayer * layer = [asyncImageView layer];  
        layer.borderColor = [[UIColor whiteColor] CGColor];  
        layer.borderWidth = 1.0f;  
        //添加四个边阴影  
        asyncImageView.layer.shadowColor = [UIColor blackColor].CGColor;  
        asyncImageView.layer.shadowOffset = CGSizeMake(0, 0);  
        asyncImageView.layer.shadowOpacity = 0.5;  
        asyncImageView.layer.shadowRadius = 2.0;//给iamgeview添加阴影 < wbr > 和边框  
        //添加两个边阴影  
        asyncImageView.layer.shadowColor = [UIColor blackColor].CGColor;  
        asyncImageView.layer.shadowOffset = CGSizeMake(2, 2);  
        asyncImageView.layer.shadowOpacity = 0.5;  
        asyncImageView.layer.shadowRadius = 2.0; 
        
		[cell.contentView addSubview:asyncImageView];
        
        
        thumbnail = [[EGOImageView alloc] init];
        thumbnail.frame = CGRectMake(kArticleCellHorizontalInnerPadding*(i+1)+(kCellWidth - kArticleCellHorizontalInnerPadding * 2)*i, kArticleCellVerticalInnerPadding, kCellWidth - kArticleCellHorizontalInnerPadding * 2, kCellHeight - kArticleCellVerticalInnerPadding * 2);
        thumbnail.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",host_url,[[list objectAtIndex:indexPath.row * 4 +i] objectForKey:@"pic"]]];
        
        [cell.contentView addSubview:thumbnail];
        
        titleLabel = [[ArticleTitleLabel alloc] initWithFrame:CGRectMake(0, thumbnail.frame.size.height * 0.632, thumbnail.frame.size.width, thumbnail.frame.size.height * 0.37)];
        titleLabel.opaque = YES;
        [titleLabel setPersistentBackgroundColor:[UIColor colorWithRed:0 green:0.4745098 blue:0.29019808 alpha:0.9]];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:11];
        titleLabel.numberOfLines = 2;
        [thumbnail addSubview:titleLabel];
        
        
        NSString *sex = [[list objectAtIndex:indexPath.row * 4 +i] objectForKey:@"sex"];
        if([sex isEqualToString:@"1"]){
            sex=@"♂";
        }else {
            sex=@"♀";
        }
        
        titleLabel.text=[NSString stringWithFormat:@"%.2fkm %@",[[[list objectAtIndex:indexPath.row * 4 +i] objectForKey:@"distance"] floatValue]/1000,sex];
        
        cell.backgroundColor = [UIColor colorWithRed:0 green:0.40784314 blue:0.21568627 alpha:1.0];
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:thumbnail.frame] autorelease];
        cell.selectedBackgroundView.backgroundColor = kHorizontalTableSelectedBackgroundColor;
        [titleLabel release];
        [thumbnail release];
        
        //cell.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        
    }
    
    
    return cell;
    
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	//取新数据
    [self loadMemberList];
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	//重新加载tableview
    [self.myTableView reloadData];
    
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Location manager

/**
 Return a location manager -- create one if necessary.
 */
- (CLLocationManager *)locationManager {
	
    if (locationManager != nil) {
		return locationManager;
	}
	
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[locationManager setDelegate:self];
	
	return locationManager;
}


/*
 * We want to get and store a location measurement that meets the desired accuracy. For this example, we are
 *      going to use horizontal accuracy as the deciding factor. In other cases, you may wish to use vertical
 *      accuracy, or both together.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // store all of the measurements, just so we can see what kind of data we might receive
    [locationMeasurements addObject:newLocation];
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the measurement to see if it is more accurate than the previous measurement
    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        self.bestEffortAtLocation = newLocation;
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue 
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of 
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            // 
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            [self stopUpdatingLocation:NSLocalizedString(@"Acquired Location", @"Acquired Location")];
            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
        }
    }
    // update the display with the new location data
    [self.myTableView reloadData];    
    /*
    if (mapView == nil)
        mapView = [[MKMapView alloc] initWithFrame:CGRectMake(10, 0, 300, 300)];
    [mapView removeAnnotation:annotation];
    [annotation release];
    annotation = [[PostAnnotation alloc] initWithCoordinate:[self.bestEffortAtLocation coordinate]];
    [mapView addAnnotation:annotation];
    
    
    // Set center of map and show a region of around 200x100 meters
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.bestEffortAtLocation.coordinate, 10, 10);
    [mapView setRegion:region animated:YES];*/
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a 
    // timeout that will stop the location manager to save power.
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
    }
}


-(BOOL)canBecomeFirstResponder 

{
    return YES;
}

-(void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated 

{
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self ViewFreshData];
    }
}

@end
