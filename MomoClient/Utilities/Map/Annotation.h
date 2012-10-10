//
//  Annotation.h
//  sendLoc
//
//  Created by Gao Semaus on 11-9-20.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface Annotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;    
    NSString *title;   
    NSString *subtitle;
    int tag;
    
    id delegate;
}
- (void)setDelegate:(id)_delegate;
- (int)tag;
- (void)setTag:(int)_tag;
- (void)startLoc;
@property (nonatomic, assign)CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@end
