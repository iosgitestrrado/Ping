//
//  PGSuggessionTableViewController.m
//  Ping
//
//  Created by Monish M S on 05/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import "PGSuggessionTableViewController.h"
#import "PGsuggessionTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PGEvent.h"
#import "PGUser.h"
#import <FVCustomAlertView/FVCustomAlertView.h>

@interface PGSuggessionTableViewController ()
{
    NSMutableArray *arraySuggesion, *arraySgtCount, *arraySgtCount1, *arraySgtCount2, *arraySgtCount3;
    
}
@end

@implementation PGSuggessionTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    arraySuggesion = [NSMutableArray new];
    arraySgtCount = [NSMutableArray new];
    arraySgtCount1 = [[NSMutableArray alloc]init];
    arraySgtCount2 = [[NSMutableArray alloc]init];
    arraySgtCount3 = [[NSMutableArray alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(receiveTestNotification:) name:@"eventInfo" object:nil];
   
}

-(void) receiveTestNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"eventInfo"])
    {
        NSDictionary* userInfo = notification.userInfo;
        arraySuggesion = (NSMutableArray *)userInfo[@"arrayMainEvent"];
      //  NSLog (@"Successfully received test notification! %@", arraySuggesion);
        [self tableShowSuggest];
    }
}

-(void)tableShowSuggestreedit
{
    int heightTotal = 60 * ((int)arraySgtCount.count + (int)arraySgtCount1.count  + (int)arraySgtCount2.count+ (int)arraySgtCount3.count);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:heightTotal] forKey:@"totalHeightSuggest"];
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"suggestHeightInfo" object:self userInfo:userInfo];
    [self.tableView reloadData];
}

-(void)tableShowSuggest
{
    arraySgtCount = [arraySuggesion valueForKey:@"remind_msg"];
    
    
    
    
    
    arraySgtCount1 = [[arraySuggesion valueForKey:@"suggLocation"]mutableCopy];
    

    
    for (int i = arraySgtCount1.count-1 ; i >= 0 ; i--)
    {
        NSDictionary *test = arraySgtCount1[i];
        if ([[NSString stringWithFormat:@"%@",[test objectForKey:@"disable"]] isEqualToString:@"1"]) {
            [arraySgtCount1 removeObject:test];
        }
    }
    
    arraySgtCount2 = [[arraySuggesion valueForKey:@"suggPush"] mutableCopy];

    for (int i = arraySgtCount2.count-1 ; i >= 0 ; i--)
    {
        NSDictionary *test = arraySgtCount2[i];
        if ([[NSString stringWithFormat:@"%@",[test objectForKey:@"disable"]] isEqualToString:@"1"]) {
            [arraySgtCount2 removeObject:test];
        }
    }
    
    
    
    
       arraySgtCount3 = [[arraySuggesion valueForKey:@"prt_notify"]mutableCopy];
    

    
    for (int i = arraySgtCount3.count-1 ; i >= 0 ; i--)
    {
        NSDictionary *test = arraySgtCount3[i];
        if ([[NSString stringWithFormat:@"%@",[test objectForKey:@"disable"]] isEqualToString:@"1"]) {
            [arraySgtCount3 removeObject:test];
        }
    }
    
    
    
    if (arraySgtCount.count + arraySgtCount1.count + arraySgtCount2.count + arraySgtCount3.count> 0)
    {
        int heightTotal = 60 * ((int)arraySgtCount.count + (int)arraySgtCount1.count + (int)arraySgtCount2.count +  (int)arraySgtCount3.count);
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:heightTotal] forKey:@"totalHeightSuggest"];
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"suggestHeightInfo" object:self userInfo:userInfo];
        [self.tableView reloadData];
    }else{
        
       
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"totalHeightSuggest"];
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        [nc postNotificationName:@"suggestHeightInfo" object:self userInfo:userInfo];
        [self.tableView reloadData];
        
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arraySgtCount.count+arraySgtCount1.count+arraySgtCount2.count+arraySgtCount3.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PGsuggessionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SuggessionCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[PGsuggessionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SuggessionCell"];
    }
    
    if (indexPath.row <= arraySgtCount.count - 1 && arraySgtCount.count>0 ) {
        
      
       
        
        
        cell.suggestLabel.text = [arraySgtCount objectAtIndex:indexPath.row];
        cell.widthConstraint.constant = 0;
        cell.hiddenstack.hidden = true;
        cell.suggestRejectButton.hidden = true;
        cell.suggestAcceptButton.hidden = true;
        NSString *urlString = [arraySuggesion valueForKey:@"avthar"];
        NSURL *url = [NSURL URLWithString:urlString];
      //  [cell.suggestPic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
        [cell.suggestPic sd_setImageWithURL:url
                              placeholderImage:nil
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         if (error) {
                                             
                                             cell.suggestPic.image = [UIImage imageNamed:@"UserProfile"];
                                         }
                                     }];
    }else if(indexPath.row <= (arraySgtCount.count + arraySgtCount1.count)-1 && arraySgtCount1.count>0){
        
        NSLog(@"%ld",(long)indexPath.row);
        int value = indexPath.row - arraySgtCount.count ;
        
        cell.widthConstraint.constant = 110;
        cell.suggestRejectButton.hidden = false;
        cell.suggestAcceptButton.hidden = false;
        cell.suggestRejectButton.tag = value;
        cell.suggestAcceptButton.tag = value;
     
        [cell.suggestAcceptButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.suggestRejectButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.hiddenstack.hidden = false;
        NSDictionary *dict = [[arraySgtCount1 objectAtIndex:value]mutableCopy];
        
        cell.suggestLabel.text = [dict objectForKey:@"message"];
        
        NSString *urlString = [arraySuggesion valueForKey:@"avthar"];
        NSURL *url = [NSURL URLWithString:urlString];
      //  [cell.suggestPic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
        
        [cell.suggestPic sd_setImageWithURL:url
                           placeholderImage:nil
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      if (error) {
                                          
                                          cell.suggestPic.image = [UIImage imageNamed:@"UserProfile"];
                                      }
                                  }];
        
    }else if(indexPath.row <= (arraySgtCount.count + arraySgtCount1.count +arraySgtCount2.count)-1 && arraySgtCount2.count>0){
        
        
        
        NSLog(@"%ld",(long)indexPath.row);
        int value = indexPath.row - (arraySgtCount.count+arraySgtCount1.count) ;
        
        cell.widthConstraint.constant = 110;
        cell.suggestRejectButton.hidden = false;
        cell.suggestAcceptButton.hidden = false;
        cell.suggestRejectButton.tag = value;
        cell.suggestAcceptButton.tag = value;
        [cell.suggestAcceptButton addTarget:self action:@selector(submitActionPush:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.suggestRejectButton addTarget:self action:@selector(cancelActionPush:) forControlEvents:UIControlEventTouchUpInside];
        cell.hiddenstack.hidden = false;
        NSDictionary *dict = [[arraySgtCount2 objectAtIndex:value]mutableCopy];
        
        cell.suggestLabel.text = [dict objectForKey:@"message"];
        
        NSString *urlString = [arraySuggesion valueForKey:@"avthar"];
        NSURL *url = [NSURL URLWithString:urlString];
       // [cell.suggestPic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
        
        [cell.suggestPic sd_setImageWithURL:url
                           placeholderImage:nil
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      if (error) {
                                          
                                          cell.suggestPic.image = [UIImage imageNamed:@"UserProfile"];
                                      }
                                  }];
        
        
        
        
        
    }
    else{

        
        
        if (arraySgtCount3.count>0) {
       
        
        NSLog(@"%ld",(long)indexPath.row);
         int value = indexPath.row - (arraySgtCount.count+arraySgtCount1.count+arraySgtCount2.count) ;

       cell.widthConstraint.constant = 110;
        cell.suggestRejectButton.hidden = false;
        cell.suggestAcceptButton.hidden = false;
        cell.suggestRejectButton.tag = value;
        cell.suggestAcceptButton.tag = value;
        [cell.suggestAcceptButton addTarget:self action:@selector(submitActionPRORITY:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.suggestRejectButton addTarget:self action:@selector(cancelActionPRORITY:) forControlEvents:UIControlEventTouchUpInside];
        cell.hiddenstack.hidden = false;
        NSDictionary *dict = [[arraySgtCount3 objectAtIndex:value]mutableCopy];

        cell.suggestLabel.text = [dict objectForKey:@"message"];

     NSString *urlString = [arraySuggesion valueForKey:@"avthar"];
        NSURL *url = [NSURL URLWithString:urlString];
       // [cell.suggestPic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
         
            [cell.suggestPic sd_setImageWithURL:url
                               placeholderImage:nil
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          if (error) {
                                              
                                              cell.suggestPic.image = [UIImage imageNamed:@"UserProfile"];
                                          }
                                      }];
            
            
        }
    }
   
  
    
    return cell;
}

- (IBAction)submitAction:(UIButton *)sender
{
   
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    NSInteger value = sender.tag;
    
    
     NSDictionary *dict = [[arraySgtCount1 objectAtIndex:value]mutableCopy];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:[dict objectForKey:@"sugg_id"] forKey:@"suggId"];
    
    [PGEvent acceptLocationSuggesion:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         
      
         
         if (success)
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];

             
             [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"meeting_id"]] forKey:@"DateeventmeetingId"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"reloaddataDateMeetingID" object:self userInfo:nil];
             
             
             
             
             
             
             
             
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
                     categoryName = @"Error in Action";
                 }
                 
            
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:[NSString stringWithFormat:@"%@",categoryName] preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
             [alert addAction:cancelButton];
             
             [self presentViewController:alert animated:YES completion:nil];
             }else{
                 
                 [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
                 [alert addAction:cancelButton];
                 
                 [self presentViewController:alert animated:YES completion:nil];
             }
                 
                 
         }
     }];
    
    
    
    
    
}

- (IBAction)cancelAction:(UIButton *)sender
{
   
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    NSInteger value = sender.tag;
    
    
    NSDictionary *dict = [[arraySgtCount1 objectAtIndex:value]mutableCopy];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:[dict objectForKey:@"sugg_id"] forKey:@"suggId"];
    
    [PGEvent rejectLocationSuggesion:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         
        
         
         if (success)
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             // arrayMainMeeting = [result valueForKey:@"data"];
             if (arraySgtCount1.count>0) {
                 [arraySgtCount1 removeObjectAtIndex:value];
                  }
             [self  tableShowSuggestreedit];
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
                     categoryName = @"Error in Action";
                 }
            
             
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:[NSString stringWithFormat:@"%@",categoryName] preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
             [alert addAction:cancelButton];
             
             [self presentViewController:alert animated:YES completion:nil];
             
             
         }else{
             
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
             [alert addAction:cancelButton];
             
             [self presentViewController:alert animated:YES completion:nil];
         }
             
             
             
             
             
         }
     }];
    
}


- (IBAction)submitActionPush:(UIButton *)sender
{
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    NSInteger value = sender.tag;
    
    
    NSDictionary *dict = [[arraySgtCount2 objectAtIndex:value]mutableCopy];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:[dict objectForKey:@"sugg_id"] forKey:@"suggId"];
    
    [PGEvent acceptPushSuggesion:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         
         
         
         if (success)
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             // arrayMainMeeting = [result valueForKey:@"data"];
             NSDateFormatter *format = [[NSDateFormatter alloc] init];
             [format setDateFormat:@"yyyy-MM-dd"];
             
             
             NSDate * strdateon =   [format dateFromString:[result objectForKey:@"date"]];
             
             if ([strdateon isKindOfClass: [NSDate class]]) {
                 
                 
                 
                 [[NSUserDefaults standardUserDefaults] setObject:strdateon forKey:@"DateValueChange"];
                 [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"meeting_id"]] forKey:@"DateeventmeetingId"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"CalldateEventAction" object:self userInfo:nil];
             }else{
                 
                 if (arraySgtCount2.count>0) {
                     [arraySgtCount2 removeObjectAtIndex:value];
                 }
                 [self  tableShowSuggestreedit];
                 
             }
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
                     categoryName = @"Error in Action";
                 }
               
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:[NSString stringWithFormat:@"%@",categoryName] preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
             [alert addAction:cancelButton];
             
             [self presentViewController:alert animated:YES completion:nil];
             
             
         }else{
             
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
             [alert addAction:cancelButton];
             
             [self presentViewController:alert animated:YES completion:nil];
         }
             
             
             
         }
     }];
    
    
    
    
    
}

- (IBAction)cancelActionPush:(UIButton *)sender
{
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    NSInteger value = sender.tag;
    
    
    NSDictionary *dict = [[arraySgtCount2 objectAtIndex:value]mutableCopy];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:[dict objectForKey:@"sugg_id"] forKey:@"suggId"];
    
    [PGEvent rejectPushSuggesion:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         if (success)
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             // arrayMainMeeting = [result valueForKey:@"data"];
               if (arraySgtCount2.count>0) {
             [arraySgtCount2 removeObjectAtIndex:value];
               }
             [self  tableShowSuggestreedit];
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
                     categoryName = @"Error in Action";
                 }

              
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:[NSString stringWithFormat:@"%@",categoryName] preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
             [alert addAction:cancelButton];
             
             [self presentViewController:alert animated:YES completion:nil];
             
             
         }else{
             
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
             [alert addAction:cancelButton];
             
             [self presentViewController:alert animated:YES completion:nil];
         }
         }
     }];
    
}
- (IBAction)submitActionPRORITY:(UIButton *)sender
{
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    NSInteger value = sender.tag;
    
    
    NSDictionary *dict = [[arraySgtCount3 objectAtIndex:value]mutableCopy];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:[dict objectForKey:@"priority_id"] forKey:@"priority_id"];
    
    [PGEvent acceptPrioritySuggesion:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         
        if (success)
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             // arrayMainMeeting = [result valueForKey:@"data"];
             
             NSDateFormatter *format = [[NSDateFormatter alloc] init];
             [format setDateFormat:@"yyyy-MM-dd"];
             
             
             NSDate * strdateon =   [format dateFromString:[result objectForKey:@"date"]];
             
             if ([strdateon isKindOfClass: [NSDate class]]) {
                 
                 
                 
                 [[NSUserDefaults standardUserDefaults] setObject:strdateon forKey:@"DateValueChange"];
                 [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"meeting_id"]] forKey:@"DateeventmeetingId"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"CalldateEventAction" object:self userInfo:nil];
             }else{
                 
                 if (arraySgtCount3.count>0) {
                     [arraySgtCount3 removeObjectAtIndex:value];
                 }
                 [self  tableShowSuggestreedit];
                 
             }

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
                     categoryName = @"Error in Action";
                 }
             
             
             
             
            
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:[NSString stringWithFormat:@"%@",categoryName] preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
             [alert addAction:cancelButton];
             
             [self presentViewController:alert animated:YES completion:nil];
                 
             }else{
                 
                 [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
                 [alert addAction:cancelButton];
                 
                 [self presentViewController:alert animated:YES completion:nil];
             }
         }
     }];
    
    
    
    
    
}

- (IBAction)cancelActionPRORITY:(UIButton *)sender
{
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    NSInteger value = sender.tag;
    
    
    NSDictionary *dict = [[arraySgtCount3 objectAtIndex:value]mutableCopy];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:[dict objectForKey:@"priority_id"] forKey:@"priority_id"];
    
    [PGEvent rejectPrioritySuggesion:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         
         
         
         if (success)
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             // arrayMainMeeting = [result valueForKey:@"data"];
             
             
             
             if (arraySgtCount3.count>0) {
              
             [arraySgtCount3 removeObjectAtIndex:value];
             }
             [self  tableShowSuggestreedit];
         }
         else
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             
             if (result) {
                 
                 NSString* categoryName =@"";
                 if ([result isKindOfClass:[NSString class]]) {
                     categoryName = [NSString stringWithFormat:@"%@",result];
                 }else{
                     categoryName = [NSString stringWithFormat:@"%@",[result valueForKey:@"responseMessage"]];
                 }
                 
                 
                 if (categoryName == nil || categoryName == (id)[NSNull null]) {
                     categoryName = @"Error in Action";
                 }

             
             
             UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:categoryName preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
             [alert addAction:cancelButton];
             
             [self presentViewController:alert animated:YES completion:nil];
                 
                 
             }else{
                 
                 
                 UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:nil];
                 [alert addAction:cancelButton];
                 
                 [self presentViewController:alert animated:YES completion:nil];
             }
         }
     }];
    
}




@end
