//
//  CMPayClientViewController.h
//  CMPayClient
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "Constants.h"
//#import "ItemCategoryModel.h"
//#import "Productlist.h"
//#import "ItemProductModel.h"
#import <QuartzCore/QuartzCore.h>
//#import "DoubleTapSegmentedControlDelegate.h"
//#import "DoubleTapSegmentedControl.h"
#import "EGORefreshTableHeaderView.h"
//#import "CWRefreshTableView.h"

@interface CMPayClientViewController : UIViewController 
</*EGORefreshTableHeaderDelegate,*/NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate/*,
DoubleTapSegmentedControlDelegate*/>{
    NSString *currentElement;
    //ItemCategoryModel *itemCat;
    //ItemProductModel *itemPro;
    NSMutableArray *itemCatlist;
    NSMutableArray *itemProlist;
    BOOL isLoadProlsit;         //是否是加载类别下的商品
    NSUInteger rowIndex;
    UITableView *tableView;
    UIView *overLayer;
    
    //分页变量
    NSMutableArray *currentCatlist;
    int pageSize;
    int currentPage;
    int maxPage;
    
	//EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	//BOOL _reloading;
    //NSMutableArray *_array;
    //CWRefreshTableView *_refreshView;
    
    // 表格数据数组，因为是演示代码，直接定义为数组
	NSMutableArray *tableData;
    // 下拉时显示的数据
	NSMutableArray *tableMoreData;
    
    // 数据数量
	NSUInteger dataNumber;
    
    // 加载状态
	BOOL _loadingMore;
    
}
@property(nonatomic,retain)NSMutableArray *array;

@property(nonatomic,retain)NSMutableArray *currentCatlist;
@property(nonatomic,retain)NSString *currentElement;
//@property(nonatomic,retain)ItemCategoryModel *itemCat;
//@property(nonatomic,retain)ItemProductModel *itemPro;
@property(nonatomic,retain)NSMutableArray *itemCatlist;
@property(nonatomic,retain)NSMutableArray *itemProlist;
@property(nonatomic)BOOL isLoadProlist;
@property(nonatomic,retain)IBOutlet UITableView *tableView;
@property(nonatomic,retain)IBOutlet UIView *overLayer;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

// 表格视图，需要与xib中的tableView关联
//@property(nonatomic, retain) IBOutlet UITableView *tableView;

// 创建表格底部
- (void) createTableFooter;

// 开始加载数据
- (void) loadDataBegin;
// 加载数据中
- (void) loadDataing;
// 加载数据完毕
- (void) loadDataEnd;

@end
