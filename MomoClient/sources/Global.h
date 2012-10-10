//  曾超
//  QQ:1490724


#import "Utility.h"
#import "NSObject+SBJson.h"

#ifndef _DEBUG_
    #define _DEBUG_ 0
#endif
#define kOAuthConsumerKey				@"4029251963"		//REPLACE ME
#define kOAuthConsumerSecret			@"48f062721b7c974ae4dfb4936fb7d712"		//REPLACE ME
#define tencentAppKey @"27d1186230a443d1ac7f514a96376ada"
#define tencentAppSecret @"eff11cc20a1d582b81f1affe3e754889"



static NSString *host_url=@"http://www.iplayfun.com/rides/";


#define RecordsPerPage 10
#define kLeftMargin				100.0
#define kTopMargin				 20.0
#define kRightMargin			 20.0
#define kTweenMargin			  6.0
#define kTextFieldHeight		 30.0
#define kTextFieldWidth	        180.0


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// iPhone CONSTANTS
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Width (or length before rotation) of the table view embedded within another table view's row
#define kTableLength                                320

// Width of the cells of the embedded table view (after rotation, which means it controls the rowHeight property)
#define kCellWidth                                  82
// Height of the cells of the embedded table view (after rotation, which would be the table's width)
#define kCellHeight                                 82

// Padding for the Cell containing the article image and title
#define kArticleCellVerticalInnerPadding            3
#define kArticleCellHorizontalInnerPadding          3

// Padding for the title label in an article's cell
#define kArticleTitleLabelPadding                   4

// Vertical padding for the embedded table view within the row
#define kRowVerticalPadding                         0
// Horizontal padding for the embedded table view within the row
#define kRowHorizontalPadding                       0

// The background color of the vertical table view
#define kVerticalTableBackgroundColor               [UIColor colorWithRed:0.58823529 green:0.58823529 blue:0.58823529 alpha:1.0]

// Background color for the horizontal table view (the one embedded inside the rows of our vertical table)
#define kHorizontalTableBackgroundColor             [UIColor colorWithRed:0.6745098 green:0.6745098 blue:0.6745098 alpha:1.0]

// The background color on the horizontal table view for when we select a particular cell
#define kHorizontalTableSelectedBackgroundColor     [UIColor colorWithRed:0.0 green:0.59607843 blue:0.37254902 alpha:1.0]

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// iPad CONSTANTS
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Width (or length before rotation) of the table view embedded within another table view's row
#define kTableLength_iPad                               768

// Height for the Headlines section of the main (vertical) table view
#define kHeadlinesSectionHeight_iPad                    65

// Height for regular sections in the main table view
#define kRegularSectionHeight_iPad                      36

// Width of the cells of the embedded table view (after rotation, which means it controls the rowHeight property)
#define kCellWidth_iPad                                 192
// Height of the cells of the embedded table view (after rotation, which would be the table's width)
#define kCellHeight_iPad                                192

// Padding for the Cell containing the article image and title
#define kArticleCellVerticalInnerPadding_iPad           4
#define kArticleCellHorizontalInnerPadding_iPad         4

// Vertical padding for the embedded table view within the row
#define kRowVerticalPadding_iPad                        0
// Horizontal padding for the embedded table view within the row
#define kRowHorizontalPadding_iPad                      0


#define TAG_USERNAME 1 //会员名
#define TAG_ZHIYE    2 //职业
#define TAG_QIANMING 3 //签名
#define TAG_AGE      4 //年龄
#define TAG_AIHAO    5 //爱好
#define TAG_GONGSI   6 //公司
#define TAG_XUEXIAO  7 //学校
#define TAG_DIFANG   8 //常出没的地方
#define TAG_ZHUYE    9 //个人主页
#define TAG_ZUOJIA  10 //座驾
#define TAG_JIALING 11 //驾龄
#define TAG_WEIHAO  12 //车牌尾号
#define TAG_LUXIAN  13 //常走的路线
#define TAG_SINA    14 //sina微博
#define TAG_RENREN  15 //人人帐号
#define TAG_DOUBAN  16 //豆瓣帐号
#define TAG_MAIL    17 //验证邮箱



#define kHeadlineSectionHeight  26
#define kRegularSectionHeight   18

