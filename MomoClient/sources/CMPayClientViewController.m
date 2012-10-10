//
//  CMPayClientViewController.m
//  CMPayClient
//

#import "CMPayClientViewController.h"
#import "Constants.h"

@implementation CMPayClientViewController

@synthesize itemCatlist;
@synthesize itemProlist;
//@synthesize itemPro;
//@synthesize itemCat;
@synthesize currentElement;
@synthesize isLoadProlist;
//@synthesize tableView;
@synthesize overLayer;
@synthesize currentCatlist;
@synthesize array;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}

- (void)dealloc
{
    [currentCatlist release];
    [itemProlist release];
    //[itemPro release];
    [currentElement release];
    //[itemCat release];
    [itemCatlist release];
    [tableView release];
    [overLayer release];
    //_refreshHeaderView = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//获取淘宝所有的种类
-(void)getItemCats
{
    NSMutableDictionary *params=[[[NSMutableDictionary alloc] init] autorelease];
    [params setObject:@"cid,name" forKey:@"fields"];
    [params setObject:@"0" forKey:@"parent_cid"];
    [params setObject:@"taobao.itemcats.get" forKey:@"method"];

    // 1 . 首先设置XML数据，并初始化NSXMLParser
    NSData *resultData=[Utility getResultData:params];
    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:resultData];
    [xmlParser setDelegate:self];
    [xmlParser parse];
    [xmlParser release];
}

//加载指定页数的数据,每页20条
-(void)reloadTableInPage:(NSInteger)index
{
    self.currentCatlist=[[[NSMutableArray alloc] init] autorelease];
    if([self.itemCatlist count]<RecordsPerPage)
    {
        for(int i=0;i<(index-1)*RecordsPerPage+[self.itemCatlist count];i++)
        {
            //ItemCategoryModel *selectCat=[self.itemCatlist objectAtIndex:i];
            //[self.currentCatlist addObject:selectCat];
        }

    }
    else
    {
        for(int i=(index-1)*RecordsPerPage;i<(index-1)*RecordsPerPage+RecordsPerPage;i++)
        {
            //ItemCategoryModel *selectCat=[self.itemCatlist objectAtIndex:i];
            //[self.currentCatlist addObject:selectCat];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

-(void)viewWillAppear:(BOOL)animated
{
    if(self.overLayer.superview!=nil)
    {
        [self.overLayer removeFromSuperview];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    currentPage=1;//设置默认显示第一页
    self.currentCatlist=[[[NSMutableArray alloc] init] autorelease];
    
    UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cat_bg.jpg"]];
    img.alpha=0.3;
    self.tableView.backgroundView=img;
    [img release];
    self.isLoadProlist=NO;
    self.navigationController.navigationBar.tintColor=[UIColor darkGrayColor];
    
    self.itemProlist=[[[NSMutableArray alloc] init] autorelease];
    self.itemCatlist=[[[NSMutableArray alloc] init] autorelease];
    
//    DoubleTapSegmentedControl *segmentController=[[DoubleTapSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"上一页",@"下一页",nil]];
//    segmentController.delegate=self;
//    segmentController.segmentedControlStyle=UISegmentedControlStyleBar;
//    segmentController.selectedSegmentIndex=0;
//    segmentController.frame=CGRectMake(0, 0, 100, 30);
//    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithCustomView:segmentController]autorelease];
//    [segmentController release];
//    [self getItemCats];
    
//	if (_refreshHeaderView == nil) {
//        NSLog(@"self.view.frame.size.width = %f",self.view.frame.size.width);
//		NSLog(@"self.tableView.bounds.size.height = %f",self.tableView.bounds.size.height);
//        
//		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
//		view.delegate = self;
//		[self.tableView addSubview:view];
//		_refreshHeaderView = view;
//		[view release];
//		
//	}
//	
//	//  update the last update date
//	[_refreshHeaderView refreshLastUpdatedDate];
    
//    _refreshView = [[CWRefreshTableView alloc]initWithTableView:self.tableView pullDirection:CWRefreshTableViewDirectionAll];
//    _refreshView.delegate = self;
//    self.array = [NSMutableArray arrayWithObjects:@"1",@"2",nil];
    
    
    // Do any additional setup after loading the view, typically from a nib.
    
	tableData = [[NSMutableArray alloc] initWithObjects:@"One",@"Two",@"Three",@"Four",@"One",@"Two",@"Three",@"Four",@"One",@"Two",@"Three",@"Four",nil];
    
	tableMoreData = [[NSMutableArray alloc] initWithObjects:@"BAIDU",@"GOOGLE",@"FACEBOOK",@"YAHOO",@"BAIDU",@"GOOGLE",@"FACEBOOK",@"YAHOO",@"BAIDU",@"GOOGLE",@"FACEBOOK",@"YAHOO",@"BAIDU",@"GOOGLE",@"FACEBOOK",@"YAHOO",@"BAIDU",@"GOOGLE",@"FACEBOOK",@"YAHOO",@"BAIDU",@"GOOGLE",@"FACEBOOK",@"YAHOO",@"BAIDU",@"GOOGLE",@"FACEBOOK",@"YAHOO",@"BAIDU",@"GOOGLE",@"FACEBOOK",@"YAHOO",@"BAIDU",@"GOOGLE",@"FACEBOOK",@"YAHOO",@"BAIDU",@"GOOGLE",@"FACEBOOK",@"YAHOO",@"BAIDU",@"GOOGLE",@"FACEBOOK",@"YAHOO",nil];
    
    [self createTableFooter];
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView=nil;
    self.overLayer=nil;
    //_refreshHeaderView=nil;
    //self.array=nil;
    //[_refreshView release];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma 解析XML，获取淘宝商品类别
//2.遍例xml的节点  发现元素开始符的处理函数  （即报告元素的开始以及元素的属性）
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElement=elementName;
    if([self.currentElement isEqualToString:@"item_cat"])
    {
         //self.itemCat=[[ItemCategoryModel alloc] init];
    }
}

//3.当xml节点有值时，则进入此句
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //商品类别
    if(![self.currentElement compare:@"cid"])
    {
        //self.itemCat.cid=string;
    }
    if(![self.currentElement compare:@"name"])
    {
        //self.itemCat.name=string;
    }
    
    if(self.isLoadProlist)
    {
        //类别下的商品
        if(![self.currentElement compare:@"num_iid"])
        {
            //self.itemPro=[[ItemProductModel alloc] init];
            //self.itemPro.num_iid=string;
        }
        if(![self.currentElement compare:@"title"])
        {
            //self.itemPro.title=string;
        }
        if(![self.currentElement compare:@"pic_url"])
        {
            //self.itemPro.pic_url=string;
        }
        if(![self.currentElement compare:@"price"])
        {
            //self.itemPro.price=string;
        }
        if(![self.currentElement compare:@"score"])
        {
            //self.itemPro.score=string;
            //[self.itemProlist addObject:self.itemPro];
            //[self.itemPro release];
        }
    }
}

//4.当遇到结束标记时，进入此句
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"item_cat"])
    {
        //[self.itemCatlist addObject:self.itemCat];
        //[self.itemCat release];
    }
    if([elementName isEqualToString:@"itemcats_get_response"])
    {
        [self reloadTableInPage:1];
    }
}

//5.报告解析的结束
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
//    if(self.isLoadProlist)
//    { 
//        Productlist *productlistView=[[Productlist alloc] init];
//        ItemCategoryModel *selectedItemCat=[self.itemCatlist objectAtIndex:rowIndex];
//        productlistView.itemCat=selectedItemCat;
//        productlistView.itemProlist=self.itemProlist;
//        [selectedItemCat release];
//        [self.itemProlist release];
//        
//        [self.navigationController pushViewController:productlistView animated:YES];
//        self.isLoadProlist=NO;
//    }
}

#pragma 表格数据源和委托
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentCatlist count];   
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"ItemCatCell";
    UITableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
    }
    //ItemCategoryModel *cellItemCat=[self.currentCatlist objectAtIndex:indexPath.row];
    //cell.textLabel.text=cellItemCat.name;
    cell.imageView.image=[UIImage imageNamed:@"ItemCat.png"];
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

-(void)startAnimation
{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    self.overLayer.alpha=0.4f;
    UIActivityIndicatorView *activityIndicator=(UIActivityIndicatorView *)[self.overLayer viewWithTag:222];
    [activityIndicator startAnimating];
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.4f];
    [self.view addSubview:self.overLayer];
    self.overLayer.alpha=1.0f;
    [UIView commitAnimations];
    [pool release];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    PLAYERALERTSOUND;
//    [NSThread detachNewThreadSelector:@selector(startAnimation) toTarget:self withObject:nil];
//    self.isLoadProlist=YES;
//    rowIndex=indexPath.row;
//    self.itemProlist=[[NSMutableArray alloc] init];
//    ItemCategoryModel *selectedItemCat=[self.itemCatlist objectAtIndex:indexPath.row];
//    
//    NSMutableDictionary *params=[[[NSMutableDictionary alloc] init] autorelease];
//    [params setObject:@"taobao.items.get" forKey:@"method"];
//    [params setObject:@"num_iid,title,pic_url,price,score" forKey:@"fields"];
//    [params setObject:selectedItemCat.cid forKey:@"cid"];
//    NSData *resultData=[Utility getResultData:params];
//
//    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData:resultData];
//    [xmlParser setDelegate:self];
//    [xmlParser parse];
//    [xmlParser release];
}

//自定义双击Tab事件
//-(void)performSegmentAction:(DoubleTapSegmentedControl *)sender
//{
//    if([self.itemCatlist count]>0)//获取淘宝的数据后加载
//    {
//        maxPage=[self.itemCatlist count]/[self.currentCatlist count];
//        if([sender selectedSegmentIndex]==0)//上一页
//        {
//            if(currentPage>1)
//            {
//                PLAYEPAGESOUND;
//                CGContextRef context=UIGraphicsGetCurrentContext();
//                [UIView beginAnimations:nil context:context];
//                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//                [UIView setAnimationDuration:1.0f];
//                [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.tableView cache:YES];
//                currentPage--;
//                [self reloadTableInPage:currentPage];
//                 [UIView commitAnimations];
//            }
//            else
//            {
//                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"Sorry!已经是第一页了！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                [alert release];
//            }
//        }
//        else
//        {
//            if(currentPage<maxPage)
//            {
//                PLAYEPAGESOUND;
//                CGContextRef context=UIGraphicsGetCurrentContext();
//                [UIView beginAnimations:nil context:context];
//                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//                [UIView setAnimationDuration:1.0f];
//                [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.tableView cache:YES];
//                currentPage++;
//                [self reloadTableInPage:currentPage];
//                 [UIView commitAnimations];
//            }
//            else
//            {
//                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"Sorry!已经是最后一页了！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//                [alert release];
//            }
//        }
//    }
//}


- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    currentPage++;
    [self reloadTableInPage:currentPage];
	//_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	//_reloading = NO;
	//[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	//[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    //[_refreshView scrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	//[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    //[_refreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    // 下拉到最底部时显示更多数据
	if(!_loadingMore && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)))
	{
        [self loadDataBegin];
	}
    
}

//#pragma mark -
//#pragma mark EGORefreshTableHeaderDelegate Methods

//- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
//	
//	[self reloadTableViewDataSource];
//	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
//	
//}
//
//- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
//	
//	return _reloading; // should return if data source model is reloading
//	
//}
//
//- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
//	
//	return [NSDate date]; // should return date data source was last changed
//	
//}

/*
-(BOOL)CWRefreshTableViewReloadTableViewDataSource:(CWRefreshTableViewPullType)refreshType
{
    NSString *strIndex;
    switch (refreshType) {
        case CWRefreshTableViewPullTypeReload:
            self.array=nil;
            self.array = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
            break;
            
        case CWRefreshTableViewPullTypeLoadMore:
            strIndex = [NSString stringWithFormat:@"%d",[self.array count]+1];
            [self.array addObject:strIndex];
            break;
    }
    [self performSelector:@selector(reloadOK) withObject:nil afterDelay:3];
    return YES;
}

-(void)reloadOK
{
    currentPage++;
    [self reloadTableInPage:currentPage];
    
    [self.tableView reloadData];
    [_refreshView DataSourceDidFinishedLoading];
}
*/

// 开始加载数据
- (void) loadDataBegin
{
    if (_loadingMore == NO) 
    {
        _loadingMore = YES;
        UIActivityIndicatorView *tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(75.0f, 10.0f, 20.0f, 20.0f)];
        [tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [tableFooterActivityIndicator startAnimating];
        [self.tableView.tableFooterView addSubview:tableFooterActivityIndicator];
        
        [self loadDataing];
    }
}

// 加载数据中
- (void) loadDataing
{	
//	dataNumber = [tableData count];
//    
//	for (int x = 0; x < [tableMoreData count]; x++) 
//	{
//		[tableData addObject:[tableMoreData objectAtIndex:x]];
//	}
    if([self.itemCatlist count]>0)//获取淘宝的数据后加载
    {
        maxPage=[self.itemCatlist count]/[self.currentCatlist count];
    }
    NSLog(@"itemCatlist=%d",[self.itemCatlist count]);
    NSLog(@"currentCatlist=%d",[self.currentCatlist count]);
    NSLog(@"maxPage=%d",maxPage);
    NSLog(@"currentPage=%d",currentPage);
    currentPage++;
    if(currentPage<=maxPage){
        
        [self reloadTableInPage:currentPage];
    }
	//[[self tableView] reloadData];
    
	[self loadDataEnd];
}

// 加载数据完毕
- (void) loadDataEnd
{
    _loadingMore = NO;
	[self createTableFooter];
}

// 创建表格底部
- (void) createTableFooter
{
    self.tableView.tableFooterView = nil;
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 40.0f)]; 
    UILabel *loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 116.0f, 40.0f)];
    [loadMoreText setCenter:tableFooterView.center];
    [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [loadMoreText setText:@"上拉显示更多数据"];
    [tableFooterView addSubview:loadMoreText];    
    
    self.tableView.tableFooterView = tableFooterView;
}

@end
