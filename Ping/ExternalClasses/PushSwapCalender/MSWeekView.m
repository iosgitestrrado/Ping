//
//  RVWeekView.m
//  RVCalendarWeekView
//
//  Created by Badchoice on 22/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekView.h"

#import "NSDate+Easy.h"
#import "RVCollection.h"

#define MAS_SHORTHAND
#import "Masonry.h"
#import "NSDate+DateTools.h"

// Collection View Reusable Views
#import "MSGridline.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSDayColumnHeaderBackground.h"
#import "MSEventCell.h"
#import "MSDayColumnHeader.h"
#import "MSTimeRowHeader.h"
#import "MSCurrentTimeIndicator.h"
#import "MSCurrentTimeGridline.h"
#import "MSUnavailableHour.h"
#import "MSWeekendBackground.h"

#define MSEventCellReuseIdentifier        @"MSEventCellReuseIdentifier"
#define MSDayColumnHeaderReuseIdentifier  @"MSDayColumnHeaderReuseIdentifier"
#define MSTimeRowHeaderReuseIdentifier    @"MSTimeRowHeaderReuseIdentifier"

@implementation MSWeekView

//================================================
#pragma mark - Init
//================================================
-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}







-(void)setup{
    
    self.daysToShowOnScreen = 6;
    self.daysToShow         = 30;
    self.weekFlowLayout     = [MSCollectionViewCalendarLayout new];
    self.weekFlowLayout.delegate = self;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.weekFlowLayout];
    self.collectionView.dataSource                      = self;
    self.collectionView.delegate                        = self;
    self.collectionView.directionalLockEnabled          = YES;
    self.collectionView.showsVerticalScrollIndicator    = NO;
    self.collectionView.showsHorizontalScrollIndicator  = NO;
  

   
    [self.collectionView registerClass:[MSEventCell class] forCellWithReuseIdentifier:@"Cell"];
    
    reload = true;
    
    
    /*if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        self.collectionView.pagingEnabled = YES;
    }*/
    
    [self addSubview:self.collectionView];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.height);
        make.width.equalTo(self.width);
        make.left.equalTo(self.left);
        make.top.equalTo(self.top);
    }];
    
    self.weekFlowLayout.sectionLayoutType = MSSectionLayoutTypeHorizontalTile;
    self.collectionView.backgroundColor   = [UIColor whiteColor];
    
    [self setupSupplementaryViewClasses];
    [self registerSupplementaryViewClasses];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"eventpushstart"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"eventpushlocation"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"eventpushend"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"eventpushtitle"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"eventmoniteringstart"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"eventmoniteringend"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"eventmoniteringlocation"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"eventmoniteringtitle"];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(mainArrayEventInfoNotification:) name:@"forceReloaded" object:nil];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(mainArrayEventInfoNotification:) name:@"swapreloaded" object:nil];
    
    
    
    
}



//-(void)SwapEventInfoNotification:(NSNotification*)notification
//{
//    if ([notification.name isEqualToString:@"swapreloaded"])
//    {
//
//        for (int i= 0;i<mEvents.count;i++ ) {
//
//                    MSEvent*mse =  mEvents[i];
//
//
//
//
//
//
//
//
//
//            int duration = mse.durationInSeconds;
//                                MSEvent *tempEvent1 = [MSEvent make:[[NSUserDefaults standardUserDefaults] objectForKey:@"eventpushstart"] end:[[[NSUserDefaults standardUserDefaults] objectForKey:@"eventpushstart"] dateByAddingSeconds:duration] title:mse.title subtitle:mse.location] ;
//                                mEvents = [self replaceObjectAtIndex:i inArray:mEvents withObject:tempEvent1];
//
//
//
//
//
//
//        [self forceReload:YES];
//    }
//}
//
//
//}
//









-(void)mainArrayEventInfoNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"forceReloaded"])
    {
        
        NSLog(@"%@",notification.userInfo);
        
        NSMutableArray *allKeys = [[notification.userInfo allKeys] mutableCopy];
        for (NSString *key in allKeys) {
            MSEvent *event = [notification.userInfo objectForKey: key];
           [self addEvent:event];
            
            
        }
        

        
        
        [self forceReload:YES];
    }
}




-(void)setupSupplementaryViewClasses{
    self.eventCellClass                 = MSEventCell.class;
    self.dayColumnHeaderClass           = MSDayColumnHeader.class;
    self.timeRowHeaderClass             = MSTimeRowHeader.class;
    
    self.currentTimeIndicatorClass      = MSCurrentTimeIndicator.class;
    self.currentTimeGridlineClass       = MSCurrentTimeGridline.class;
    self.verticalGridlineClass          = MSGridline.class;
    self.horizontalGridlineClass        = MSGridline.class;
    self.timeRowHeaderBackgroundClass   = MSTimeRowHeaderBackground.class;
    self.dayColumnHeaderBackgroundClass = MSDayColumnHeaderBackground.class;
    self.unavailableHourClass           = MSUnavailableHour.class;
    self.weekendBackgroundClass         = MSWeekendBackground.class;
}

-(void)registerSupplementaryViewClasses{
    [self.collectionView registerClass:self.eventCellClass forCellWithReuseIdentifier:MSEventCellReuseIdentifier];
    [self.collectionView registerClass:self.dayColumnHeaderClass forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:MSDayColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:self.timeRowHeaderClass forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:MSTimeRowHeaderReuseIdentifier];
    
    // These are optional. If you don't want any of the decoration views, just don't register a class for them.
    [self.weekFlowLayout registerClass:self.currentTimeIndicatorClass       forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
    [self.weekFlowLayout registerClass:self.currentTimeGridlineClass        forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.weekFlowLayout registerClass:self.verticalGridlineClass           forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.weekFlowLayout registerClass:self.horizontalGridlineClass         forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.weekFlowLayout registerClass:self.timeRowHeaderBackgroundClass    forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    [self.weekFlowLayout registerClass:self.dayColumnHeaderBackgroundClass  forDecorationViewOfKind:MSCollectionElementKindDayColumnHeaderBackground];
    
    [self.weekFlowLayout registerClass:self.unavailableHourClass            forDecorationViewOfKind:MSCollectionElementKindUnavailableHour];
    [self.weekFlowLayout registerClass:self.weekendBackgroundClass          forDecorationViewOfKind:MSCollectionElementKindWeekendBackground];
    
    
    
    
    

}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.weekFlowLayout.sectionWidth = self.layoutSectionWidth;
}





-(void)forceReload:(BOOL)reloadEvents{
    
   
    
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(reloadEvents)
            
            
            
            
            [self groupEventsBySection];
        [self.weekFlowLayout invalidateLayoutCache];
        

      

            
            
       
        [self.collectionView reloadData];
     
        
        if (reload)
        {
            reload = false;
            
            NSDateFormatter *dateFormatter  =   [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString * strdatepass =   [_checkDate format:@"yyyy-MM-dd" timezone:@"device"];
            NSString * strdatepass1 =   [[NSDate date] format:@"yyyy-MM-dd" timezone:@"device"];
            NSDate *dateFromString = [dateFormatter dateFromString:strdatepass];
            NSDate *CurrentdateFromString = [dateFormatter dateFromString:strdatepass1];
            
            
            
            
            
            
            NSTimeInterval secondsBetween = [dateFromString timeIntervalSinceDate:CurrentdateFromString];
            
            int numberOfDays = secondsBetween / 86400;
            
            
            dispatch_async (dispatch_get_main_queue (), ^{
            
                NSIndexPath *myIP = [NSIndexPath indexPathForRow:_myValue inSection:numberOfDays] ;
            
            
            
            
            
            
          [self.collectionView scrollToItemAtIndexPath:myIP atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                
         [self.collectionView scrollToItemAtIndexPath:myIP atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
                
        });
        
        
        
        }
        
        
        
    });
}

- (CGFloat)layoutSectionWidth{
    return (self.frame.size.width - 50) / self.daysToShowOnScreen;
}
-(BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}



-(NSDate*)firstDay{
    return [self.weekFlowLayout dateForDayColumnHeaderAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

//================================================
#pragma mark - Set Events
//================================================
-(void)setEvents:(NSArray *)events{
    mEvents = events;
    [self forceReload:YES];
}

-(void)addEvent:(MSEvent *)event{
    [self addEvents:@[event]];
}

-(void)addEvents:(NSArray*)events{
    self.events = [mEvents arrayByAddingObjectsFromArray:events];
    [self forceReload:YES];
}

-(void)removeEvent:(MSEvent*)event{
    self.events = [mEvents reject:^BOOL(MSEvent* arrayEvent) {
        return [arrayEvent isEqual:event];;
    }];
    [self forceReload:YES];
}

/**
 * Note that in the standard calendar, each section is a day"
 */
-(void)groupEventsBySection{
    
//  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"eventpushstart"]!= nil)
//    {
//
//        for (int i= 0;i<mEvents.count;i++ ) {
//            
//        MSEvent*mse =  mEvents[i];
////        NSLog(@"A%@",mse.title);
////        NSLog(@"B%@",mse.StartDate);
////        NSLog(@"C%@",mse.EndDate);
////        NSLog(@"D%@",mse.location);
//  
//            
//            
//            
//           
//            
//            
//            
//            
//            
//            
//            
//NSString *string = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"eventmoniteringstart"]];
//    NSString *string1 = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"eventmoniteringend"]];
//    
//    if(![string isEqualToString:[NSString stringWithFormat:@"%@",mse.StartDate]] && ![string1 isEqualToString:[NSString stringWithFormat:@"%@",mse.EndDate]])
//    {
//      if(![string isEqualToString:@""] && ![string1 isEqualToString:@""])
//        {
//        
//            NSString * strdatepass =   [[[NSUserDefaults standardUserDefaults] objectForKey:@"eventmoniteringstart"] format:@"yyyy-MM-dd" timezone:@"device"];
//            NSString * strdatepass1 =   [mse.StartDate format:@"yyyy-MM-dd" timezone:@"device"];
//            
//            if ([strdatepass isEqualToString:strdatepass1]) {
//                
//                if( [self date:mse.StartDate isBetweenDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"eventmoniteringstart"] andDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"eventmoniteringend"]]||[self date:mse.EndDate isBetweenDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"eventmoniteringstart"] andDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"eventmoniteringend"]]||[self date:[[NSUserDefaults standardUserDefaults] objectForKey:@"eventmoniteringstart"] isBetweenDate:mse.StartDate andDate:mse.EndDate]||[self date:[[NSUserDefaults standardUserDefaults] objectForKey:@"eventmoniteringend"] isBetweenDate:mse.StartDate andDate:mse.EndDate])
//                    
//                {
//                
//                    int duration = mse.durationInSeconds;
//                    MSEvent *tempEvent1 = [MSEvent make:[[NSUserDefaults standardUserDefaults] objectForKey:@"eventpushstart"] end:[[[NSUserDefaults standardUserDefaults] objectForKey:@"eventpushstart"] dateByAddingSeconds:duration] title:mse.title subtitle:mse.location] ;
//                    mEvents = [self replaceObjectAtIndex:i inArray:mEvents withObject:tempEvent1];
//             
//                
//                }//time overlap check
//
//            }// same date check
//        
//        }//string value check @""
//        
//    }//same value check
//    }//forloop check
//    
//    }//nil check
    
    
    
    //TODO : Improve this to make it faster
    _eventsBySection = [mEvents groupBy:@"StartDate.toDeviceTimezoneDateString"].mutableCopy;
    
    
    
    
    
    
    
    
  /*  [sharedAppDelegate.reserveDict removeAllObjects];
    
    
    for (int i = 0; i<_eventsBySection.count; i++) {
        
        NSString* day      = [_eventsBySection.allKeys.sort objectAtIndex:i];
        
        NSArray *tempArray = _eventsBySection[day];
        
        
        
        if (tempArray.count>0) {
            NSMutableArray *INTARRAY = [[NSMutableArray alloc  ]init];
            for (int j = 0; j<tempArray.count; j++) {
                MSEvent *tempEvent = tempArray[j];
                
                
                int time = [[tempEvent.StartDate format:@"HH" timezone:@"device"] intValue];
                int time1 = [[tempEvent.EndDate format:@"HH" timezone:@"device"] intValue];
                NSRange r = NSMakeRange(time,time1);
                [INTARRAY addObject:[NSValue valueWithRange:r]];
       
                
            }
            
            [sharedAppDelegate.reserveDict setObject:INTARRAY forKey:day];
            
        }else{
            
            [sharedAppDelegate.reserveDict setObject:@"" forKey:day];
        }
        
        
        
        
        
    }
    */
    
    
    //NSDate* date = [NSDate today:@"device"];                                      //Why does it crash on some configurations?
    NSDate* date = [NSDate parse:NSDate.today.toDateTimeString timezone:@"device"];  //If it crashes here, comment the previous line and uncomment this one
    if(self.daysToShow == 1 && _eventsBySection.count == 1){
        date = [NSDate parse:_eventsBySection.allKeys.firstObject];
    }
    for(int i = 0; i< self.daysToShow; i++){
        if(![_eventsBySection.allKeys containsObject:date.toDeviceTimezoneDateString]){
            [_eventsBySection setObject:@[] forKey:date.toDeviceTimezoneDateString];
        }
        date = [date addDay];
    }    
}




-(NSArray *)replaceObjectAtIndex:(int)index inArray:(NSArray *)array withObject:(id)object {
    NSMutableArray *mutableArray = [array mutableCopy];
    mutableArray[index] = object;
    return [NSArray arrayWithArray:mutableArray];
}





//================================================
#pragma mark - CollectionView Datasource
//================================================
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{   
    return _eventsBySection.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSString* day = [_eventsBySection.allKeys.sort objectAtIndex:section];
    return [_eventsBySection[day] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSString* day      = [_eventsBySection.allKeys.sort objectAtIndex:indexPath.section];
    cell.event         = [_eventsBySection[day] objectAtIndex:indexPath.row];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == MSCollectionElementKindDayColumnHeader) {
        MSDayColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSDayColumnHeaderReuseIdentifier forIndexPath:indexPath];
        NSDate *day                 = [self.weekFlowLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        NSDate *currentDay          = [self currentTimeComponentsForCollectionView:self.collectionView layout:self.weekFlowLayout];
        
        NSDate *startOfDay          = [NSCalendar.currentCalendar startOfDayForDate:day];
        NSDate *startOfCurrentDay   = [NSCalendar.currentCalendar startOfDayForDate:currentDay];
        
        dayColumnHeader.day         = day;
        dayColumnHeader.currentDay  = [startOfDay isEqualToDate:startOfCurrentDay];
        
        view = dayColumnHeader;
    } else if (kind == MSCollectionElementKindTimeRowHeader) {
        MSTimeRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSTimeRowHeaderReuseIdentifier forIndexPath:indexPath];
        timeRowHeader.time = [self.weekFlowLayout dateForTimeRowHeaderAtIndexPath:indexPath];
        view = timeRowHeader;
    }
    return view;
}


//================================================
#pragma mark - Week Flow Delegate
//================================================






- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout dayForSection:(NSInteger)section
{
    NSString* day = [_eventsBySection.allKeys.sort objectAtIndex:section];
    return [NSDate parse:day timezone:@"device"];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* day   = [_eventsBySection.allKeys.sort objectAtIndex:indexPath.section];
    MSEvent* ev     = [_eventsBySection[day] objectAtIndex:indexPath.row];
    return ev.StartDate;
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* day   = [_eventsBySection.allKeys.sort objectAtIndex:indexPath.section];
    MSEvent* ev     = [_eventsBySection[day] objectAtIndex:indexPath.row];
    return ev.EndDate;
}

-(NSArray*)unavailableHoursPeriods:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout section:(int)section{
    if([self.delegate respondsToSelector:@selector(weekView:unavailableHoursPeriods:)]){
        NSDate* date = [self collectionView:collectionView layout:collectionViewLayout dayForSection:section];
        
//        NSString * text = @"Sleeping Time";
//        
//        
//        
//        UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 50, 100, 20)];
//        fromLabel.text = text;
//        
//        fromLabel.numberOfLines = 1;
//        fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
//        fromLabel.adjustsFontSizeToFitWidth = YES;
//        
//        fromLabel.minimumScaleFactor = 6.0f/12.0f;
//        fromLabel.clipsToBounds = YES;
//        fromLabel.backgroundColor = [UIColor clearColor];
//        fromLabel.textColor = [UIColor blackColor];
//        fromLabel.textAlignment = NSTextAlignmentLeft;
//        [collectionView addSubview:fromLabel];
        
        
        
        return [self.delegate weekView:self unavailableHoursPeriods:date];
    }
    return @[];
}

- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout
{
    return NSDate.date;
}


//================================================
#pragma mark - Collection view delegate
//================================================
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.delegate){
        MSEventCell* cell = (MSEventCell*)[collectionView cellForItemAtIndexPath:indexPath];
        [self.delegate weekView:self eventSelected:cell];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollView.frame.size.height)];
    }
    
    if (scrollView.contentOffset.y <= 0) {
       // [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
    }
    
    if (scrollView.contentOffset.x <= 0) {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];
    }
    
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat cellWidth = self.weekFlowLayout.sectionWidth;
    CGFloat cellPadding = 0;
    
    NSInteger page = (scrollView.contentOffset.x - cellWidth / 2) / (cellWidth + cellPadding) + 1;
    
    if (velocity.x > 0) page++;
    if (velocity.x < 0) page--;
    page = MAX(page,0);
    
    CGFloat newOffset = page * (cellWidth + cellPadding);
    targetContentOffset->x = newOffset;
}





//================================================
#pragma mark - Dealloc
//================================================
-(void)dealloc{
    self.collectionView.dataSource  = nil;
    self.collectionView.delegate    = nil;
    self.collectionView             = nil;
    self.weekFlowLayout.delegate    = nil;
    self.weekFlowLayout             = nil;
    _eventsBySection                = nil;
}

@end
