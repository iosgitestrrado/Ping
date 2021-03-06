//
//  AKEvent.m
//  Example
//
//  Created by ak on 18.01.2016.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import "MSEvent.h"
#import "NSDate+Easy.h"

@implementation MSEvent

+(instancetype)make:(NSDate*)start title:(NSString*)title subtitle:(NSString*)subtitle{
    return [self.class make:start duration:60 title:title subtitle:subtitle];
}

+(instancetype)make:(NSDate*)start end:(NSDate*)end title:(NSString*)title subtitle:(NSString*)subtitle{
    MSEvent* event = [self.class new];
    event.StartDate = start;
    event.EndDate   = end;
    event.title     = title;
    event.location  = subtitle;
    return event;
}

+(instancetype)make:(NSDate*)start duration:(int)minutes title:(NSString*)title subtitle:(NSString*)subtitle{
    MSEvent* event  = [self.class new];
    event.StartDate = start;
    event.EndDate   = [start addMinutes:minutes];
    event.title     = title;
    event.location  = subtitle;
    return event;
}



+(instancetype)make:(NSDate*)start duration:(int)minutes title:(NSString*)title subtitle:(NSString*)subtitle completeDict:(NSDictionary*)subDict editable :(BOOL)status{
    MSEvent* event  = [self.class new];
    event.StartDate = start;
    event.EndDate   = [start addMinutes:minutes];
    event.title     = title;
    event.location  = subtitle;
    event.eventSTATUS = status;
    event.eventDict = subDict;
    return event;
}










- (NSDate *)day{
    return [NSCalendar.currentCalendar startOfDayForDate:self.StartDate];
}
@end
