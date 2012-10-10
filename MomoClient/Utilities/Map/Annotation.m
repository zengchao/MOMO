//
//  Annotation.m
//  sendLoc
//
//  Created by Gao Semaus on 11-9-20.
//  Copyright 2011年 Chlova. All rights reserved.
//

#import "Annotation.h"
#import "GAPI.h"
#import "Global.h"

@implementation Annotation
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    if (delegate) {
        [delegate release];
        delegate = nil;
    }
    [title release];
    [subtitle release];
    [super dealloc];
}

- (void)setDelegate:(id)_delegate
{
    delegate = [_delegate retain];
}

- (int)tag
{
    return tag;
}

- (void)setTag:(int)_tag
{
    tag = _tag;
}

- (void)startLoc
{
    GAPI *api = [[GAPI alloc] init];
    [api setDelegate:self];
    [api requestURL:[NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",coordinate.latitude,coordinate.longitude] withSuccessSEL:@selector(apiSuccess:) errorSEL:@selector(apiError:)];
    [api release];
}

- (void)apiSuccess:(NSString *)_str
{
#if _DEBUG_
    NSLog(@"%@",_str);
#endif
    NSDictionary *dic = [_str JSONValue];
    if ([[dic valueForKey:@"status"] isEqualToString:@"OK"]) {
        NSArray *array = [dic valueForKey:@"results"];
        if ([array count] > 0) {
            NSArray *arr = [[array objectAtIndex:0] valueForKey:@"address_components"];
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
            NSString *result = [NSString stringWithFormat:@"%@",locality];
            self.title = result;
            self.subtitle = [[array objectAtIndex:0] valueForKey:@"formatted_address"];
            
            
            [delegate performSelector:@selector(annotationDidFinish:) withObject:self afterDelay:0.7];
        }
    }
    
}

- (void)apiError:(NSError *)_err
{
    
}



@end
