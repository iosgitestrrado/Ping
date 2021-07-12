//
//  MSWeekViewDecoratorDragable.m
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 1/9/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecoratorDragable.h"
#import "NSDate+Easy.h"
#import "RVCollection.h"
#import "NSDate+DateTools.h"

@interface MSWeekViewDecoratorDragable () <UIGestureRecognizerDelegate>{
    CGPoint preOrigin;
    double dx;
    double dy;
    NSString * str;
    NSString * ystr;
}
@end

@implementation MSWeekViewDecoratorDragable

+(__kindof MSWeekView*)makeWith:(MSWeekView*)weekView andDelegate:(id<MSWeekViewDragableDelegate>)delegate{
    MSWeekViewDecoratorDragable * weekViewDecorator = [super makeWith:weekView];
    weekViewDecorator.dragDelegate = delegate;
    return weekViewDecorator;
}

//=========================================================
#pragma mark - Collection view datasource
//=========================================================
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell                   = (MSEventCell*)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    if(![self isGestureAlreadyAdded:cell]){
        UILongPressGestureRecognizer* lpgr  = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onEventCellLongPress:)];
        lpgr.delegate                       = self;
        lpgr.minimumPressDuration = 0.2;
        [cell addGestureRecognizer:lpgr];
    }
    
    return cell;
}

//=========================================================
#pragma mark - Gesture recognizer delegate
//=========================================================


//
//- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGPoint currentOffset = scrollView.contentOffset;
//    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
//
//    NSTimeInterval timeDiff = currentTime - lastOffsetCapture;
//    if(timeDiff > 0.1) {
//        CGFloat distance = currentOffset.y - lastOffset.y;
//        //The multiply by 10, / 1000 isn't really necessary.......
//        CGFloat scrollSpeedNotAbs = (distance * 10) / 1000; //in pixels per millisecond
//
//        CGFloat scrollSpeed = fabsf(scrollSpeedNotAbs);
//        if (scrollSpeed > 0.5) {
//            isScrollingFast = YES;
//            NSLog(@"Fast");
//        } else {
//            isScrollingFast = NO;
//            NSLog(@"Slow");
//        }
//
//        lastOffset = currentOffset;
//        lastOffsetCapture = currentTime;
//    }
//}















- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    MSEventCell* eventCell = (MSEventCell*)gestureRecognizer.view;
     UIViewController *currentTopVC = [self currentTopViewController];
    NSDictionary *dict = [eventCell.event.eventDict mutableCopy];
  
    
    if( dict!= nil){
        if(eventCell.event.eventSTATUS)
            
        {
            
      
        
        if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"repeat_event"]] isEqualToString:@"1"] ) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"Unable to push or swap a recurring ping." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:nil];
            [alertController addAction:ok];
            [currentTopVC presentViewController:alertController animated:YES completion:nil];
            
            
            return NO;
        }
        
        
        
   else  if ([[dict objectForKey:@"meeting_type"] isEqualToString:@"ios_event"]||[[dict objectForKey:@"meeting_type"] isEqualToString:@"google_event"]||[[dict objectForKey:@"meeting_type"] isEqualToString:@"block_event"])
        {
            
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"This event was created by an external application. Please select a ping and try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:nil];
            [alertController addAction:ok];
            [currentTopVC presentViewController:alertController animated:YES completion:nil];
            
            return NO;
            
            
            
        }
       
        
        
        
        NSComparisonResult result;
        NSDate *today = [NSDate date];
        
        result = [today compare:eventCell.event.StartDate];
        
        if(result==NSOrderedAscending)
            NSLog(@"today is less");
        else if(result==NSOrderedDescending)
            NSLog(@"newDate is less");
        else
            NSLog(@"Both dates are same");
        
        if(result==NSOrderedDescending)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"This event was created by an external application. Please select a ping and try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:nil];
            [alertController addAction:ok];
            [currentTopVC presentViewController:alertController animated:YES completion:nil];
            
            return NO;
            
        }
            
        
    }
    else{
        
         return NO;
    }
        
return [self.dragDelegate weekView:self.weekView canStartMovingEvent:eventCell.event];
        
    }else{
        
        return NO;
        
    }
   
    
}
float roundToTwo(float num)
{
    return round(100 * num) / 100;
}
//=========================================================
#pragma mark - Drag & Drop
//=========================================================
-(void)onEventCellLongPress:(UILongPressGestureRecognizer*)gestureRecognizer{
    MSEventCell* eventCell = (MSEventCell*)gestureRecognizer.view;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
      //  NSLog(@"Star drag: %@",eventCell.event.title);
       
        
        isScrollingFastx = true;
        ystr = @"";
        str = @"";
        NSLog(@"I*nteial only%@%@",ystr,str);
        preOrigin = [gestureRecognizer locationInView:self.baseWeekView];
        
        CGPoint touchOffsetInCell = [gestureRecognizer locationInView:gestureRecognizer.view];
        mDragableEvent = [MSDragableEvent makeWithEventCell:eventCell andOffset:self.weekView.collectionView.contentOffset touchOffset:touchOffsetInCell];
        [[NSUserDefaults standardUserDefaults] setObject:eventCell.event.StartDate forKey:@"eventpushstart"];
        [[NSUserDefaults standardUserDefaults] setObject:eventCell.event.EndDate forKey:@"eventpushend"];
        [[NSUserDefaults standardUserDefaults] setObject:eventCell.event.location forKey:@"eventpushlocation"];
        [[NSUserDefaults standardUserDefaults] setObject:eventCell.event.title forKey:@"eventpushtitle"];
        
        
         NSLog(@"I*nteial only%@%@",eventCell.event.StartDate,eventCell.event.EndDate);
        
        
        
        
        [self.baseWeekView addSubview:mDragableEvent];
            
        
     
        
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged){
        CGPoint cp = [gestureRecognizer locationInView:self.baseWeekView];
 
       
        
      double  dlocx = cp.x - preOrigin.x;
      double  dlocy = cp.y - preOrigin.y;
        
        
        
        CGPoint newOrigin;
        float xOffset   = ((int)self.collectionView.contentOffset.x % (int)self.weekFlowLayout.sectionWidth) - self.weekFlowLayout.timeRowHeaderWidth;
        
        
        
        cp.x           += xOffset;
        float x         = [self round:cp.x toLowest:self.weekFlowLayout.sectionWidth] - xOffset;
        newOrigin       = CGPointMake(x, cp.y);

     
        
        
        
         if (dy != dlocy && ((dy > 15) ||(dy < -15))  ) {


          ystr= @"ok";
            
             
             
             
             if (dy != dlocy && ((dy > 100) ||(dy < -100))  ) {
                 
                
                 
                 
                 
                 
                 
                 
                 
                 if (dy > 100  && self.collectionView.contentOffset.y < 2000 ) {
                     
                     
                     
                     self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y+10);
                     
                     
                     
                 }
                 else if (dy < -100  && self.collectionView.contentOffset.y > 15) {
                     
                     
                     
                     self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x,self.collectionView.contentOffset.y-10);        }
                 
                 
                 
             }
             
             
             
             
             
             
            else if (dy != dlocy && ((dy > 80) ||(dy < -80))  ) {
                 
                 if (dy > 80  && self.collectionView.contentOffset.y < 2000 ) {
                     
                     
                     
                     self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y+8);
                     
                     
                     
                 }
                 else if (dy < -80  && self.collectionView.contentOffset.y > 15) {
                     
                     
                     
                     self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x,self.collectionView.contentOffset.y-8);        }
                 
                 
                 
             }
             
             
             
             
             
             
             
        else     if (dy != dlocy && ((dy > 60) ||(dy < -60))  ) {
                 
                 if (dy > 60  && self.collectionView.contentOffset.y < 2000 ) {
                     
                     
                     
                     self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y+6);
                     
                     
                     
                 }
                 else if (dy < -60  && self.collectionView.contentOffset.y > 15) {
                     
                     
                     
                     self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x,self.collectionView.contentOffset.y-6);        }
                 
                 
                 
             }
             
             
             
             
             
             
       else if (dy != dlocy && ((dy > 40) ||(dy < -40))  ){
                if (dy > 40  && self.collectionView.contentOffset.y < 2000 ) {
                    
                    
                    
                    self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y+4);
                    
                    
                    
                }
                else if (dy < -40  && self.collectionView.contentOffset.y > 15) {
                    
                    
                    
                    self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x,self.collectionView.contentOffset.y-4);        }
                
            }
            else if (dy != dlocy && ((dy > 15) ||(dy < -15))  ){
                if (dy > 15  && self.collectionView.contentOffset.y < 2000 ) {
                    
                    
                    
                    self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y+3);
                    
                    
                    
                }
                else if (dy < -15  && self.collectionView.contentOffset.y > 15) {
                    
                    
                    
                    self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x,self.collectionView.contentOffset.y-3);
                    
                }
                
            }
            else if (dy != dlocy && ((dy > 8) ||(dy < -8))  ){
                if (dy > 8  && self.collectionView.contentOffset.y < 2000 ) {
                    
                    
                    
                    self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y+2);
                    
                    
                    
                }
                else if (dy < -8  && self.collectionView.contentOffset.y > 15) {
                    
                    
                    
                    self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x,self.collectionView.contentOffset.y-2);
                    
                }
                
            }
            else {
                if (dy > 5  && self.collectionView.contentOffset.y < 2000 ) {
                    
                    
                    
                    self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y+1);
                    
                    
                    
                }
                else if (dy < -5  && self.collectionView.contentOffset.y > 15) {
                    
                    
                    
                    self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x,self.collectionView.contentOffset.y-1);
                    
                }
                
            }
             
             
             
            

        }
         else  if (dx != dlocx &&(dx > 20 || dx < -20) ) {
             
             

             
            
             
             
             if (dx > 100) {


                 str= @"ok";


                 self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x+10, self.collectionView.contentOffset.y);





             }else if(dx > 75) {


                 str= @"ok";


                 self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x+11, self.collectionView.contentOffset.y);





             }else if(dx > 50) {


                 str= @"ok";


                 self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x+10, self.collectionView.contentOffset.y);





             }else if(dx > 20) {


                 str= @"ok";


                 self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x+8, self.collectionView.contentOffset.y);





             }
             else if(dx > 5) {


                 str= @"ok";


                 self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x+5, self.collectionView.contentOffset.y);





             }

             else if (dx < -100 &&  self.collectionView.contentOffset.x > 0) {

                 str= @"wrong";


                 self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x-13, self.collectionView.contentOffset.y);



             }
             else if (dx < -75 &&  self.collectionView.contentOffset.x > 0) {

                 str= @"wrong";


                 self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x-17, self.collectionView.contentOffset.y);



             }
             else if (dx < -50 &&  self.collectionView.contentOffset.x > 0) {

                 str= @"wrong";


                 self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x-14, self.collectionView.contentOffset.y);



             }
             else if (dx < -20 &&  self.collectionView.contentOffset.x > 0) {

                 str= @"wrong";


                 self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x-10, self.collectionView.contentOffset.y);



             }
             else if (dx < -5 &&  self.collectionView.contentOffset.x > 0) {

                 str= @"wrong";


                 self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x-5, self.collectionView.contentOffset.y);



             }

             
  
        
         }
         else  if (( dy < 2 || dy > -2) && (dx > 5 || dx < -5) ) {
             if(dx > 2) {
                 
                 
                 str= @"ok";
                 
                 
                 self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x+5, self.collectionView.contentOffset.y);
                 
                 
                 
                 
                 
             }
             else if (dx < -2 &&  self.collectionView.contentOffset.x > 0) {
                 
                 str= @"wrong";
                 
                 
                 self.collectionView.contentOffset =   CGPointMake(self.collectionView.contentOffset.x-5, self.collectionView.contentOffset.y);
                 
                 
                 
             }
             
            
             
             
             
         }
        
     
        
        
        
        
        
        
        
         dx = dlocx;
        
        dy = dlocy;
        
        newOrigin       = CGPointMake(newOrigin.x /*+ mDragableEvent.touchOffset.x*/,
                                      newOrigin.y - mDragableEvent.touchOffset.y);
        
        
        [UIView animateWithDuration:0.1 animations:^{
            mDragableEvent.frame = (CGRect) { .origin = newOrigin, .size = mDragableEvent.frame.size };
        }];
        
      
        
        
        
        NSDate* date                  = [self dateForDragable];
        mDragableEvent.timeLabel.text = [date format:@"HH:mm" timezone:@"device"];
        
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        //NSLog(@"Long press ended: %@",eventCell.akEvent.title);
        
        
        NSArray *visiblePaths = [self.collectionView indexPathsForVisibleItems];
        
        NSLog(@"%@",visiblePaths);
    //     MSEventCell* eventCell = [self.collectionView cellForItemAtIndexPath:visiblePaths[0]];//E
      

        
        
        
        
       
        
        
        
        
        
        
        [self onDragEnded:eventCell];
    }
}

-(void)onDragEnded:(MSEventCell*)eventCell{
    
    NSDate* newStartDate = [self dateForDragable];
    NSDate* endStartDate = [newStartDate dateByAddingSeconds:eventCell.event.durationInSeconds];
  
    
    NSInteger num = (NSInteger) self.weekFlowLayout.sectionWidth;
    
    UIViewController *currentTopVC = [self currentTopViewController];
  
    NSTimeInterval secondsBetween = [newStartDate timeIntervalSinceDate:[NSDate date]];
    
    int numberOfDays = secondsBetween / 86400;
  
    
    if (numberOfDays== 0) {
           self.collectionView.contentOffset =   CGPointMake(0, self.collectionView.contentOffset.y);
    }else{
    
     self.collectionView.contentOffset =   CGPointMake(num*(numberOfDays+1), self.collectionView.contentOffset.y);
    }
    if (  self.collectionView.contentOffset.x <= 0){
                      self.collectionView.contentOffset =   CGPointMake(0, self.collectionView.contentOffset.y);
        
    }
    
    
 
    

    
    int timeStart = [[newStartDate format:@"HH" timezone:@"device"] intValue];
    int timeEnd = [[endStartDate format:@"HH" timezone:@"device"] intValue];
    
    NSString *timeStartStr = [newStartDate format:@"HH:mm" timezone:@"device"] ;
    
     NSString *timeEndStr = [endStartDate format:@"HH:mm" timezone:@"device"] ;
    
    NSString *code1 = [timeStartStr substringFromIndex: [timeStartStr length] - 2];
    
    
    
    NSString *code2 = [timeEndStr substringFromIndex: [timeEndStr length] - 2];
    
    
    if (![code1  isEqualToString:@"00"]) {
        timeStart = timeStart+1;
    }
    if (![code2  isEqualToString:@"00"]) {
        timeEnd = timeEnd+1;
    }
    
    
   
    
    
    
    
    
    
 /*   int timedragStart = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"eventpushstart"] format:@"HH" timezone:@"device"] intValue];
    int timedragEnd = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"eventpushend"] format:@"HH" timezone:@"device"] intValue];
    
    NSLog(@"%d%d%d%d%d",timeStart,timeEnd,timedragStart,timedragEnd,(int)eventCell.event.durationInHours);
    
    
    
    
    NSArray *valueArray = [sharedAppDelegate.reserveDict objectForKey:strdatepass];
    
    
    
   */
    
    NSMutableArray *myIntegers = [NSMutableArray array];
    [myIntegers removeAllObjects];
    
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    NSLog(@"cotain%ldb      %ld",(long)appDelegate.starttimeApp,(long)appDelegate.endtimeApp);
    
    if (appDelegate.endtimeApp>appDelegate.starttimeApp)
    {
        for (NSInteger i = appDelegate.starttimeApp; i < appDelegate.endtimeApp; i++){
            
            if (i+1 == 24) {
                
                    [myIntegers addObject:[NSNumber numberWithInteger:0]];
                    
                
                
                
                
            }else{
                
                
                    [myIntegers addObject:[NSNumber numberWithInteger:i+1]];
                
                }
        }
        
    }else {
        
        for (NSInteger i = appDelegate.starttimeApp; i < 24; i++){
            
            
            if (i+1 == 24) {
                [myIntegers addObject:[NSNumber numberWithInteger:0]];
                
            }else{
            [myIntegers addObject:[NSNumber numberWithInteger:i+1]];
                }
        }
        
        for (NSInteger i = 0; i < appDelegate.endtimeApp; i++)
        {
            
            [myIntegers addObject:[NSNumber numberWithInteger:i+1]];
        }
    }
    
    
    
    NSNumber *myNum = [NSNumber numberWithInt:timeStart];
    NSNumber *myNumend = [NSNumber numberWithInt:timeEnd];
    
    NSLog(@"cotain%@%ld%@",eventCell.event.StartDate,(long)appDelegate.endtimeApp,myIntegers);
    
    
    NSComparisonResult result;
    NSDate *today = [NSDate date];
    
    result = [today compare:newStartDate];
    
    if(result==NSOrderedAscending)
        NSLog(@"today is less");
    else if(result==NSOrderedDescending)
        NSLog(@"newDate is less");
    else
        NSLog(@"Both dates are same");
    
    if(result==NSOrderedDescending)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"The ping has expired. Please swap or push upcoming pings." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alertController addAction:ok];
        [currentTopVC presentViewController:alertController animated:YES completion:nil];
        
        
    }else{
    
    
    
    if ( ![myIntegers containsObject:myNum]  && ![myIntegers containsObject:myNumend] ){
        
        
        
     //    NSLog(@"%@",eventCell.event.eventDict);
        
        NSArray *visiblePaths = [self.collectionView indexPathsForVisibleItems];
        
       
        
        if (visiblePaths.count==1) {
            
            MSEventCell* eventCellSwap = [self.collectionView cellForItemAtIndexPath:visiblePaths[0]];
            
           // NSLog(@"%@",eventCellSwap.event.eventDict);
            
            if ([[eventCellSwap.event.eventDict objectForKey:@"meeting_id"] isEqualToString:[eventCell.event.eventDict objectForKey:@"meeting_id"]] ) {
               
                if( [self canMoveToNewDate:eventCell.event newDate:newStartDate]){
                    
                    int duration = eventCell.event.durationInSeconds;
                    eventCell.event.StartDate = newStartDate;
                    eventCell.event.EndDate = [eventCell.event.StartDate dateByAddingSeconds:duration];
                    if(self.dragDelegate){
                                    [self.dragDelegate weekView:self.baseWeekView event:eventCell.event moved:newStartDate];
                    
                    }
                    
                     [self push:eventCell];
                    
                 
                }
                
            }else{
                
                NSLog(@"%@%@%@%@",eventCell.event.StartDate,eventCellSwap.event.StartDate,eventCell.event.EndDate,eventCellSwap.event.EndDate);
                
                
                
                
                if( [self date:newStartDate isBetweenDate:eventCellSwap.event.StartDate andDate:eventCellSwap.event.EndDate]||[self date:endStartDate isBetweenDate:eventCellSwap.event.StartDate andDate:eventCellSwap.event.EndDate]||[self date:eventCellSwap.event.StartDate isBetweenDate:newStartDate andDate:endStartDate]||[self date:eventCellSwap.event.EndDate isBetweenDate:newStartDate andDate:endStartDate])
                    
                {
                      NSDictionary *dict = [eventCell.event.eventDict mutableCopy];
                    
                    
                    if ([[NSString stringWithFormat:@"%@", [dict valueForKey:@"created_by"]] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]])
                    {
                        
                    
                    
                    
                    NSLog(@"upadate only%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"eventpushstart"],eventCellSwap.event.StartDate);
                    
                    
                    if(  [self canMoveToNewDate:eventCellSwap.event newDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"eventpushstart"]])
                        
                    {
                        int duration = eventCellSwap.event.durationInSeconds;
                        eventCellSwap.event.StartDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"eventpushstart"];
                        eventCellSwap.event.EndDate = [[[NSUserDefaults standardUserDefaults] objectForKey:@"eventpushstart"] dateByAddingSeconds:duration];
                        if(self.dragDelegate){
                            [self.dragDelegate weekView:self.baseWeekView event:eventCellSwap.event moved:[[NSUserDefaults standardUserDefaults] objectForKey:@"eventpushstart"]];
                            
                        }
                        
                    }
                    if( [self canMoveToNewDate:eventCell.event newDate:newStartDate]){
                        
                        int duration = eventCell.event.durationInSeconds;
                        eventCell.event.StartDate = newStartDate;
                        eventCell.event.EndDate = [eventCell.event.StartDate dateByAddingSeconds:duration];
                        if(self.dragDelegate){
                            [self.dragDelegate weekView:self.baseWeekView event:eventCell.event moved:newStartDate];
                            
                        }
                        
                    }
                    
                        
                          NSDictionary *dict = [eventCellSwap.event.eventDict mutableCopy];
                        
                        if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"repeat_event"]] isEqualToString:@"1"] ) {
                            
                        
                             //   UIViewController *currentTopVC = [self currentTopViewController];
                                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:@"We are unable to push or swap this recurring ping. "preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                [alert addAction:cancelButton];
                                
                                
                                [currentTopVC presentViewController:alert animated:YES completion:nil];
                                
                                
                                
                            }else{
                          [self swap:eventCell :eventCellSwap];
                                
                            }
                    
                    
                    
                    
                    }else{
                        
                        
                      //  UIViewController *currentTopVC = [self currentTopViewController];
                        UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:@"Only the administrator can swap/push this ping."preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alert addAction:cancelButton];
                        
                        
                        [currentTopVC presentViewController:alert animated:YES completion:nil];
                    }
                    
                }else{
                    
                    if( [self canMoveToNewDate:eventCell.event newDate:newStartDate]){
                        
                        int duration = eventCell.event.durationInSeconds;
                        eventCell.event.StartDate = newStartDate;
                        eventCell.event.EndDate = [eventCell.event.StartDate dateByAddingSeconds:duration];
                        if(self.dragDelegate){
                            [self.dragDelegate weekView:self.baseWeekView event:eventCell.event moved:newStartDate];
                            
                        }
                        
                        [self push:eventCell];
                    }
                    
                    
                }
                
                
            }
            
            
        }else if(visiblePaths.count>1) {
            
            
            BOOL valueCheck = false;
            
            for (int i = 0; i < visiblePaths.count; i++) {
                
                
                MSEventCell* eventCellSwap = [self.collectionView cellForItemAtIndexPath:visiblePaths[i]];
                
             //   NSLog(@"%@%@",eventCellSwap.event.eventDict,eventCell.event.eventDict);
                
                
                if ([[eventCellSwap.event.eventDict objectForKey:@"meeting_id"] isEqualToString:[eventCell.event.eventDict objectForKey:@"meeting_id"]] ) {
                    
                }
                
                
                else{
                    
                    NSLog(@"%@%@%@%@",newStartDate,eventCellSwap.event.StartDate,endStartDate,eventCellSwap.event.EndDate);
                    
                    
                    
                    
                    if( [self date:newStartDate isBetweenDate:eventCellSwap.event.StartDate andDate:eventCellSwap.event.EndDate]||[self date:endStartDate isBetweenDate:eventCellSwap.event.StartDate andDate:eventCellSwap.event.EndDate]||[self date:eventCellSwap.event.StartDate isBetweenDate:newStartDate andDate:endStartDate]||[self date:eventCellSwap.event.EndDate isBetweenDate:newStartDate andDate:endStartDate])
                        
                    {
                        NSDictionary *dict = [eventCell.event.eventDict mutableCopy];
                        
                        
                        if ([[NSString stringWithFormat:@"%@", [dict valueForKey:@"created_by"]] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]])
                        {
                            
                            
                            
                            
                            NSLog(@"upadate only%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"eventpushstart"],eventCellSwap.event.StartDate);
                            
                            
                            if(  [self canMoveToNewDate:eventCellSwap.event newDate:[[NSUserDefaults standardUserDefaults] objectForKey:@"eventpushstart"]])
                                
                            {
                                int duration = eventCellSwap.event.durationInSeconds;
                                eventCellSwap.event.StartDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"eventpushstart"];
                                eventCellSwap.event.EndDate = [[[NSUserDefaults standardUserDefaults] objectForKey:@"eventpushstart"] dateByAddingSeconds:duration];
                                if(self.dragDelegate){
                                    [self.dragDelegate weekView:self.baseWeekView event:eventCellSwap.event moved:[[NSUserDefaults standardUserDefaults] objectForKey:@"eventpushstart"]];
                                    
                                }
                                
                            }
                            if( [self canMoveToNewDate:eventCell.event newDate:newStartDate]){
                                
                                int duration = eventCell.event.durationInSeconds;
                                eventCell.event.StartDate = newStartDate;
                                eventCell.event.EndDate = [eventCell.event.StartDate dateByAddingSeconds:duration];
                                if(self.dragDelegate){
                                    [self.dragDelegate weekView:self.baseWeekView event:eventCell.event moved:newStartDate];
                                    
                                }
                                
                            }
                            
                            
                            
                            valueCheck = true;
                            
                            
                            
                            NSDictionary *dict = [eventCellSwap.event.eventDict mutableCopy];
                            
                            if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"repeat_event"]] isEqualToString:@"1"] ) {
                                
                                
                              //  UIViewController *currentTopVC = [self currentTopViewController];
                                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:@"We are unable to push or swap this recurring ping. "preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                [alert addAction:cancelButton];
                                
                                
                                [currentTopVC presentViewController:alert animated:YES completion:nil];
                                
                                
                                
                            }else{
                                [self swap:eventCell :eventCellSwap];
                                
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            break;
                        }else{
                            
                            // UIViewController *currentTopVC = [self currentTopViewController];
                            UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:@"Only the administrator can swap/push this ping."preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                            [alert addAction:cancelButton];
                            
                            
                            [currentTopVC presentViewController:alert animated:YES completion:nil];
                            valueCheck = true;
                            
                            
                            
                            
                            break;
                            
                        }
                        
                    }
                    
                    
                }
            
                
            }
            
            if (!valueCheck) {
             
            
            if( [self canMoveToNewDate:eventCell.event newDate:newStartDate]){
                
                int duration = eventCell.event.durationInSeconds;
                eventCell.event.StartDate = newStartDate;
                eventCell.event.EndDate = [eventCell.event.StartDate dateByAddingSeconds:duration];
                if(self.dragDelegate){
                    [self.dragDelegate weekView:self.baseWeekView event:eventCell.event moved:newStartDate];
                    
                }
                
                [self push:eventCell];
            }
            
            
            
            }
            
            
            
            
            
        }
        else{
            if( [self canMoveToNewDate:eventCell.event newDate:newStartDate]){
                
                int duration = eventCell.event.durationInSeconds;
                eventCell.event.StartDate = newStartDate;
                eventCell.event.EndDate = [eventCell.event.StartDate dateByAddingSeconds:duration];
                if(self.dragDelegate){
                    [self.dragDelegate weekView:self.baseWeekView event:eventCell.event moved:newStartDate];
                    
                }
                
                [self push:eventCell];
            }
            
            
            
        }
       
        

    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"You have selected an unavailable time slot. Please check and try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alertController addAction:ok];
        [currentTopVC presentViewController:alertController animated:YES completion:nil];
    }
    
    }
    
      [self.baseWeekView forceReload:YES];
    [mDragableEvent removeFromSuperview];
    mDragableEvent = nil;
    
  
    

    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
    
    
    -(BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
    {
        if ([date compare:beginDate] == NSOrderedAscending)
            return NO;
        
        if ([date compare:endDate] == NSOrderedDescending)
            return NO;
        
        return YES;
    }
-(void)exit{
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"exitCalendar" object:self userInfo:nil];
}

-(void)push:(MSEventCell *)cell {
    
    NSDate* newStartDate = [self dateForDragable];
 NSDictionary *mainEvent =   [[NSUserDefaults standardUserDefaults] objectForKey:@"eventMain"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *demoDate1 = [dateFormatter stringFromDate:newStartDate];
 
    
    
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSString *demoTime1 = [dateFormatter stringFromDate:newStartDate];
    
    

    int b = [[mainEvent objectForKey:@"Duration"] intValue];
    
    NSDate *dateend =   [newStartDate dateByAddingSeconds:b*60];
    
    NSString *demoTime2 = [dateFormatter stringFromDate:dateend];
    
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:[mainEvent objectForKey:@"meeting_id"] forKey:@"meetingId"];
    [params setObject:demoDate1 forKey:@"date"];
    [params setObject:demoTime1 forKey:@"startTime"];
    [params setObject:demoTime2 forKey:@"endTime"];
    
    NSLog(@"911------- %@",params );
    UIViewController *currentTopVC = [self currentTopViewController];
  
    
    [PGEvent pushActionWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         
         [dateFormatter setDateFormat:@"yyyy-MM-dd"];
         
         
         if (success)
         {
             if ([[NSString stringWithFormat:@"%@", [mainEvent valueForKey:@"created_by"]] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]])
             {
             
             NSDate * strdateon =   [dateFormatter dateFromString:demoDate1];
                 
                 
                 [[NSUserDefaults standardUserDefaults]setObject:strdateon forKey:@"DateValueChange"];
                   [[NSUserDefaults standardUserDefaults]setObject:[mainEvent objectForKey:@"meeting_id"] forKey:@"DateeventmeetingId"];
                
             }else{
                 
                 NSDate * strdateon =   [dateFormatter dateFromString:[mainEvent objectForKey:@"start_date"]];
                  [[NSUserDefaults standardUserDefaults]setObject:[mainEvent objectForKey:@"meeting_id"] forKey:@"DateeventmeetingId"];
                 [[NSUserDefaults standardUserDefaults]setObject:strdateon forKey:@"DateValueChange"];
             }
            
             
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:[NSString stringWithFormat:@"%@",[result valueForKey:@"message"]] preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                 [self exit];
             }];
             [alert addAction:cancelButton];
             
             
             [currentTopVC presentViewController:alert animated:YES completion:nil];
             
             
         }
         else
         {
             if (result) {
                 NSString* categoryName =@"";
                 if ([result isKindOfClass:[NSString class]]) {
                      categoryName = [NSString stringWithFormat:@"%@",result];
                 }else{
          categoryName = [NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]];
                 }
             
             if (categoryName == nil || categoryName == (id)[NSNull null]) {
                 categoryName = @"Error in pushing";
             }
             
                
                 
                 NSDate * strdateon =   [dateFormatter dateFromString:[mainEvent objectForKey:@"start_date"]];
                 [[NSUserDefaults standardUserDefaults]setObject:strdateon forKey:@"DateValueChange"];
                 [[NSUserDefaults standardUserDefaults]setObject:[mainEvent objectForKey:@"meeting_id"] forKey:@"DateeventmeetingId"];
             
             
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message" message:[NSString stringWithFormat:@"%@",categoryName] preferredStyle:UIAlertControllerStyleAlert];
             
                 UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                     [self exit];
                 }];
             [alert addAction:cancelButton];
             
             [currentTopVC presentViewController:alert animated:YES completion:nil];
             
             
             
             
             
             
             
         }else{
           
             
             NSDate * strdateon =   [dateFormatter dateFromString:[mainEvent objectForKey:@"start_date"]];
             [[NSUserDefaults standardUserDefaults]setObject:strdateon forKey:@"DateValueChange"];
             [[NSUserDefaults standardUserDefaults]setObject:[mainEvent objectForKey:@"meeting_id"] forKey:@"DateeventmeetingId"];
             
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                 [self exit];
             }];
             [alert addAction:cancelButton];
             
             [currentTopVC presentViewController:alert animated:YES completion:nil];
             
         }
         }
     }];
    
    
    
    
    
    
    
}


-(void)swap:(MSEventCell *)cell1 :(MSEventCell *)cell2 {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
 NSDictionary *mainEvent =   [[NSUserDefaults standardUserDefaults] objectForKey:@"eventMain"];
    
    NSDictionary *dict1 = [cell2.event.eventDict mutableCopy];
  
 
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:[mainEvent objectForKey:@"meeting_id"] forKey:@"meetingId1"];
    [params setObject:[dict1 objectForKey:@"meeting_id"] forKey:@"meetingId2"];
  
    
    NSLog(@"911------- %@",params );
    UIViewController *currentTopVC = [self currentTopViewController];
    
    
    [PGEvent swapActionWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         
         
         
         if (success)
         {
             
             
             
             
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:[NSString stringWithFormat:@"%@",[result valueForKey:@"message"]] preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                 
                 
                 NSDate * strdateon =   [dateFormatter dateFromString:[mainEvent objectForKey:@"start_date"]];
                 [[NSUserDefaults standardUserDefaults]setObject:strdateon forKey:@"DateValueChange"];
                 [[NSUserDefaults standardUserDefaults]setObject:[dict1 objectForKey:@"meeting_id"] forKey:@"DateeventmeetingId"];
                 
                 
                 
                 
                 
                 
                 [self exit];
             }];
             [alert addAction:cancelButton];
             
             
             [currentTopVC presentViewController:alert animated:YES completion:nil];
         }
         else
         {
             
             if (result) {
              
                 NSString* categoryName =@"";
                 if ([result isKindOfClass:[NSString class]]) {
                     categoryName = [NSString stringWithFormat:@"%@",result];
                 }else{
                     categoryName = [NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]];
                 }
             
             
             if (categoryName == nil || categoryName == (id)[NSNull null]) {
                 categoryName = @"Error in swapping";
             }
       
             
             
             
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message" message:[NSString stringWithFormat:@"%@",categoryName] preferredStyle:UIAlertControllerStyleAlert];
             
                 UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                     
                     
                     NSDate * strdateon =   [dateFormatter dateFromString:[mainEvent objectForKey:@"start_date"]];
                     [[NSUserDefaults standardUserDefaults]setObject:strdateon forKey:@"DateValueChange"];
                     [[NSUserDefaults standardUserDefaults]setObject:[mainEvent objectForKey:@"meeting_id"] forKey:@"DateeventmeetingId"];
                     
                     
                     
                     
                     
                     [self exit];
                 }];
             [alert addAction:cancelButton];
             
             [currentTopVC presentViewController:alert animated:YES completion:nil];
             }else{
                 
               
                 NSDate * strdateon =   [dateFormatter dateFromString:[mainEvent objectForKey:@"start_date"]];
                 [[NSUserDefaults standardUserDefaults]setObject:strdateon forKey:@"DateValueChange"];
                 [[NSUserDefaults standardUserDefaults]setObject:[mainEvent objectForKey:@"meeting_id"] forKey:@"DateeventmeetingId"];
                 
                 
                 
                 
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
                     [self exit];
                 }];
                 [alert addAction:cancelButton];
                 
                 [currentTopVC presentViewController:alert animated:YES completion:nil];
                 
             }
             
             
         }
     }];
    
    
    
    
    
    
    
}






- (UIViewController *)currentTopViewController
{
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController)
    {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


-(NSDate*)dateForDragable{
    CGPoint dropPoint = CGPointMake(mDragableEvent.frame.origin.x + mDragableEvent.touchOffset.x,
                                    mDragableEvent.frame.origin.y);
    
    
    
    
    return [self dateForPoint:dropPoint];
}

//=========================================================
#pragma mark - Can move to new date?
//=========================================================
-(BOOL)canMoveToNewDate:(MSEvent*)event newDate:(NSDate*)newDate{
    if (! self.dragDelegate) return true;
    return [self.dragDelegate weekView:self canMoveEvent:event to:newDate];
}

-(BOOL)isPortrait{
    return (UIDevice.currentDevice.orientation == UIDeviceOrientationPortrait || UIDevice.currentDevice.orientation == UIDeviceOrientationFaceUp);
}

//=========================================================
#pragma mark - Gesture Recongnizer Delegate
//=========================================================
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer  shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer  *)otherGestureRecognizer
{
    return otherGestureRecognizer.view == gestureRecognizer.view;
}

@end
