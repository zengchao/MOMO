//
//  ImageLoader.m
//  FromTable
//
//  Created by hu zhen on 12-3-12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//  QQ:1490724

#import "ImageLoader.h"

@implementation ImageLoader
@synthesize imgPath;
@synthesize toView;
@synthesize dictionary;
@synthesize rw;

-(ImageLoader *)initWithInfo:(NSString *)path view:(UIView *)tv dict:(NSMutableDictionary *)dict row:(NSString *)row{
	
	if (self=[super init]) {
		self.imgPath=path;
		self.toView=tv;
		self.dictionary=dict;
		self.rw=row;
        activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activity.hidesWhenStopped=YES;
        activity.color=[UIColor blackColor];
		[activity startAnimating];
		activity.center=[toView viewWithTag:4].center;
		[toView addSubview:activity];
	}
	return self;
	
}


- (void)main{
	//NSLog(@"main方法被执行了");
	NSData *imgData=[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imgPath]];
	UIImage *image=[UIImage imageWithData:imgData];
    [imgData release];
	NSString *documentPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSString *fullPath=[NSString stringWithFormat:@"%@/%@.png",documentPath,rw];
	//NSLog(@"===%@",fullPath);
	[imgData writeToFile:fullPath atomically: YES];
	UIImageView *imgView=(UIImageView *)[toView viewWithTag:4];
	imgView.image=image;
	[activity stopAnimating];
	[dictionary setObject:fullPath forKey:rw];	
}

- (void)dealloc{
    [super dealloc];
	NSLog(@"imageLoader对象释放了");
	[imgPath release];
	[toView release];
	[dictionary release];
	[rw release];
	[activity release];	
}
@end
