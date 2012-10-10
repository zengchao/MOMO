//
//  sendLocViewController.h
//  sendLoc
//
//  Created by Gao Semaus on 11-9-20.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import <MessageUI/MessageUI.h>
#import "NSString+URLEncoding.h"
#import "SLMkMapView.h"

@interface sendLocViewController : UIViewController<UIActionSheetDelegate,UIAlertViewDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate> {
    SLMkMapView *mapview;
    CLLocationCoordinate2D loc;
    NSString *clickString;
    MFMessageComposeViewController *messageVC;
    MFMailComposeViewController *mailVC;
    IBOutlet UISearchBar *searchBar;
    IBOutlet UISearchDisplayController *searchDisplayController;
    
    NSMutableArray *myArray;
    
    NSString *searchText;
    BOOL NotShouldLoc;
    BOOL NotFirstRun;
    NSString *isStartpos;
    
    NSString *in_latitude;
    NSString *in_longitude;
    NSString *in_title;
    NSString *in_subtitle;
    
}
- (void)saveAnn;
- (void)addAnn:(CLLocationCoordinate2D)coor withTitle:(NSString *)_t subTitle:(NSString *)_subtitle;
@property (nonatomic, retain) IBOutlet SLMkMapView *mapview;
@property (nonatomic, retain) NSString *isStartpos;
@property (nonatomic, retain) NSString *in_latitude;
@property (nonatomic, retain) NSString *in_longitude;
@property (nonatomic, retain) NSString *in_title;
@property (nonatomic, retain) NSString *in_subtitle;
@property (nonatomic, retain) UIBarButtonItem *leftBtn;

@end
