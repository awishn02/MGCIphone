//
//  AddressAnnotation.h
//  mgc
//
//  Created by Aaron Wishnick on 6/23/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AddressAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *name;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)c withTitle:(NSString *)title;

@end
