//
//  RegUploadPicVC.m
//  MOMO
//
//  Created by 超 曾 on 12-4-19.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "RegUploadPicVC.h"
#import <MobileCoreServices/UTCoreTypes.h>


@implementation RegUploadPicVC
@synthesize imagePicker;
@synthesize imagePicture;
@synthesize btnRegister,btnLogin,backItem,rightBarButtonItem,btnBackImageView;
@synthesize myTableView; 
@synthesize list;
@synthesize locationManager;
@synthesize locationMeasurements;
@synthesize bestEffortAtLocation;
@synthesize btnCamera,btnPhotoLibrary;
@synthesize titleLabel;
@synthesize lbsMember;
@synthesize request;
@synthesize imageView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        self.title=@"会员资料";
        // 创建拍照控件对象
        self.imagePicker = [[[UIImagePickerController alloc] init] autorelease];
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
        {
            NSLog(@"模拟器没有摄像头");
        }else{
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;        
            // 设置媒体类型为所有对照相机有效的类型
            self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            self.imagePicker.allowsEditing = NO;
            // 设置拍照控件对象的委托
            self.imagePicker.delegate = self;
        }
        UIImage *imgHeaderBg = [UIImage imageNamed:@"banner01"];  
        if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) 
        {
            [self.navigationController.navigationBar setBackgroundImage:imgHeaderBg forBarMetrics:UIBarMetricsDefault];
        }
    }
    return self;
}


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
    [btnCamera release];
    [btnPhotoLibrary release];
    [imagePicker release];
    [lbsMember release];
    [request cancel];
	[request release];
    [imageView release];
    
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
    self.btnCamera =nil;
    self.btnPhotoLibrary =nil;
    self.lbsMember =nil;
    self.request =nil;
    self.imageView = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传头像";
    self.locationMeasurements = [NSMutableArray array];
    
#if 1  
    // Tested with the views contentMode set to redraw (forces call to drawRect:
    // on change of views frame) enabled and disabled.
    imageView.contentMode = UIViewContentModeRedraw;
#endif  
    
    imageView.displayAsStack = YES;
    imageView.image = [UIImage imageNamed:@"no.jpg"];
    
//    UIBarButtonItem *nextBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(login)];
//    self.navigationItem.rightBarButtonItem = nextBarItem;
    
    CGRect tableViewFrame = self.view.bounds;
    //tableViewFrame.size.height=410;
    tableViewFrame.origin.y=200;
    self.view.backgroundColor = [UIColor whiteColor];
    myTableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    myTableView.scrollEnabled=YES;
    [self.view addSubview:myTableView];

    myTableView.allowsSelection=FALSE;   
    [self.navigationController setNavigationBarHidden:FALSE];
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - myTableView.bounds.size.height, self.view.frame.size.width, myTableView.bounds.size.height)];
		view.delegate = self;
		[myTableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    list = [[NSMutableArray alloc] init];
    [self loadMemberList];
    
    //[self ViewFreshData];
}

-(void)loadMemberList
{
    // Create the manager object 
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    // This is the most important property to set for the manager. It ultimately determines how the manager will
    // attempt to acquire location and thus, the amount of power that will be consumed.
    locationManager.desiredAccuracy = (double)10;
    // Once configured, the location manager must be "started".
    [locationManager startUpdatingLocation];
    [self performSelector:@selector(stopUpdatingLocation:) withObject:@"Timed Out" afterDelay:(double)5];
    //[myTableView reloadData];
    [self loadList];
    
}

- (void)stopUpdatingLocation:(NSString *)state {
    [myTableView reloadData];
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
    [params setObject:[NSString stringWithFormat:@"%d",8] forKey:@"e"];
    
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
    [myTableView setContentOffset:CGPointMake(0, -75) animated:YES];
    [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:0.4];
}

-(void)doneManualRefresh{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:myTableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:myTableView];
}


- (IBAction)callRegisterWindow:(id)sender
{
    
    //    RegFirstStepViewController *vc = [[RegFirstStepViewController alloc] initWithNibName:@"RegFirstStepViewController" bundle:nil];
    //    backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    //    self.navigationItem.backBarButtonItem = backItem;
    //    [self.navigationController pushViewController:vc animated:YES];
    //    [vc release];
    
    //    RegStepOneVC *vc = [[RegStepOneVC alloc] initWithNibName:@"RegStepOneVC" bundle:nil];
    //    backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    //    self.navigationItem.backBarButtonItem = backItem;
    //    [self.navigationController pushViewController:vc animated:YES];
    //    [vc release];
    
    RegUploadPicVC *vc = [[[RegUploadPicVC alloc] initWithNibName:@"RegUploadPicVC" bundle:nil] autorelease];
    backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:vc animated:YES];
    
    
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
    [myTableView deselectRowAtIndexPath:
     [myTableView indexPathForSelectedRow] animated:NO];
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
        thumbnail = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"no.jpg"]];
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
        
//        NSString *sex = [[list objectAtIndex:indexPath.row * 4 +i] objectForKey:@"sex"];
//        if([sex isEqualToString:@"1"]){
//            sex=@"♂";
//        }else {
//            sex=@"♀";
//        }
        NSString *username = [[list objectAtIndex:indexPath.row * 4 +i] objectForKey:@"username"];
        titleLabel.text=[NSString stringWithFormat:@"%.2fkm %@",[[[list objectAtIndex:indexPath.row * 4 +i] objectForKey:@"distance"] floatValue]/1000,username];
        
        cell.backgroundColor = [UIColor colorWithRed:0 green:0.40784314 blue:0.21568627 alpha:1.0];
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:thumbnail.frame] autorelease];
        cell.selectedBackgroundView.backgroundColor = kHorizontalTableSelectedBackgroundColor;
        
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
    [myTableView reloadData];
    
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:myTableView];
	
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
    [myTableView reloadData];    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation:NSLocalizedString(@"Error", @"Error")];
    }
}

// 打开摄像头
- (IBAction)getCameraPicture:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker =
        [[UIImagePickerController alloc] init];
        picker.delegate = self; 
        picker.allowsEditing = YES;
        // 摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentModalViewController:picker animated:YES];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"温馨提示" 
                              message:@"您的当前设备没有摄像头，不能拍照" 
                              delegate:nil 
                              cancelButtonTitle:@"好" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}

// 选取图片
- (IBAction)getExistintPicture:(id)sender 
{

    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker =
        [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        // 图片库
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentModalViewController:picker animated:YES];
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"Error accessing photo library" 
                              message:@"Device does not support a photo library" 
                              delegate:nil 
                              cancelButtonTitle:@"Drat!" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // 处理静态照片
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        if (editedImage) {
            imageToSave = editedImage;
        }
        else {
            imageToSave = originalImage;
        }
        // 将静态照片（原始的或者被编辑过的）保存到相册（Camera Roll）
        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
        // 根据图片控件的尺寸缩放照片（只是为了显示效果。实际传输时依然使用原始照片）
        UIImage* scaledImage = [self imageWithImage:imageToSave scaledToSize:self.imageView.bounds.size];
        self.imageView.image = scaledImage;
        // 缓存传输照片
        self.imagePicture = imageToSave;
    }
    UploadOp *op = [[[UploadOp alloc] init] autorelease];
    op.imageToSend = self.imagePicture;
    op.email = lbsMember.email;
    NSString *result = [op uploading];
    NSLog(@"Result of Uploading: %@", result);
    
    [picker dismissModalViewControllerAnimated:YES];
    [picker release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
    [picker release];
}

#pragma mark - Utilities

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)login:(id)sender
{
    LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

@end
