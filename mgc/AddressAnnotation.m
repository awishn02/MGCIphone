//
//  AddressAnnotation.m
//  mgc
//
//  Created by Aaron Wishnick on 6/23/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import "AddressAnnotation.h"

@implementation AddressAnnotation
@synthesize coordinate;

- (NSString *)subtitle{
	return nil;
}

- (NSString *)title{
	return name;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)c withTitle:(NSString *)title{
	coordinate=c;
	name = title;
	return self;
}

@end
