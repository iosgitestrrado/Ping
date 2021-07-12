//
//  MapViewAnnotation.h
//  Ping
//
//  Created by Softnotions Technologies Pvt Ltd on 2/5/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface MapViewAnnotation : NSObject<MKAnnotation>
@property(nonatomic,copy) NSString *title;
@property(nonatomic,readonly) CLLocationCoordinate2D coordinates;
-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate;

@end
