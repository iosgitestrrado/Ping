//
//  MapViewAnnotation.m
//  Ping
//
//  Created by Softnotions Technologies Pvt Ltd on 2/5/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation
@synthesize coordinate=_coordinate;

@synthesize title=_title;
-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate

{
    
    self = [super init];
    
    _title = title;
    
    _coordinate = coordinate;
    
    return self;
    
}
@end
