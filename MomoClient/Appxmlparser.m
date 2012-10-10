//
//  Appxmlparser.m
//  MOMO
//
//  Created by apple on 12-7-2.
//  Copyright (c) 2012年 My Company. All rights reserved.
//  QQ:1490724

#import "Appxmlparser.h"
@implementation Entry
@synthesize updated,appid;
@synthesize summary,image,title;
@end

@implementation Appxmlparser
@synthesize entry;
@synthesize array,stringBuffer;
//title;summary id im:image
-(void)parserXmlForString:(NSString *)xml{
	NSData *data=[xml dataUsingEncoding:NSUTF8StringEncoding];
	NSXMLParser *parserXml=[[NSXMLParser alloc] initWithData:data];
	[parserXml setDelegate:self];
	[parserXml parse];
}
- (void)parserDidStartDocument:(NSXMLParser *)parser{
	NSLog(@"解析文档开始");
    array=[[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([elementName isEqualToString:@"entry"]){
		self.entry=[[[Entry alloc] init] autorelease];
	}else if ([elementName isEqualToString:@"updated"]) {
		self.stringBuffer=[NSMutableString string];
	}else if ([elementName isEqualToString:@"id"]) {
		self.stringBuffer=[NSMutableString string];
	}else if ([elementName isEqualToString:@"im:name"]) {
		self.stringBuffer=[NSMutableString string];
	}else if ([elementName isEqualToString:@"summary"]) {
		self.stringBuffer=[NSMutableString string];
	}else if ([elementName isEqualToString:@"im:image"]) {
		self.stringBuffer=[NSMutableString string];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	[self.stringBuffer appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"entry"]){
		[array addObject:entry];
		//使entry对象指针为空
		//entry=nil;
	}else if ([elementName isEqualToString:@"updated"]) {
		entry.updated=[stringBuffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}else if ([elementName isEqualToString:@"id"]) {
		entry.appid=[stringBuffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}else if ([elementName isEqualToString:@"im:name"]) {
		entry.title=[stringBuffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}else if ([elementName isEqualToString:@"summary"]) {
		entry.summary=[stringBuffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	}else if ([elementName isEqualToString:@"im:image"]) {
		entry.image=[stringBuffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
	}
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{
	NSLog(@"解析文档结束");
}



- (void)dealloc{
	[entry release];
	[stringBuffer release];
    [array release];
	[super dealloc];
}



@end
