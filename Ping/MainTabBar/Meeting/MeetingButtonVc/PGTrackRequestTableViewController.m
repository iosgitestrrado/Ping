//
//  PGTrackRequestTableViewController.m
//  Ping
//
//  Created by Softnotions Technologies Pvt Ltd on 2/12/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "PGTrackRequestTableViewController.h"
#import "PGTrackRequestTableViewCell.h"
#import "PGsuggessionTableViewCell.h"
#import "PGEvent.h"
#import "PGUser.h"
#import "PGMeetingTableViewController.h"
#import "PGMeetingViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface PGTrackRequestTableViewController ()
{
    NSDictionary* userInfo;
}
@end

@implementation PGTrackRequestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"eRXReceived"
                                               object:nil];
   
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
   

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return [trackRequestArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PGTrackRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PGTrackRequestCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[PGTrackRequestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PGTrackRequestCell"];
    }
  
    NSDictionary *testDictionary = [[NSDictionary alloc]init];
    testDictionary = [trackRequestArray objectAtIndex:indexPath.row];
        

        
        cell.suggestLabel.text = [testDictionary valueForKey:@"message"];
    
        NSString *urlString = @"http://13.232.170.55:8080/ping/uploads/avthar/group.png";
        NSURL *url = [NSURL URLWithString:urlString];
     //   [cell.suggestPic sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
 
    
    [cell.suggestPic sd_setImageWithURL:url
                       placeholderImage:nil
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  if (error) {
                                      
                                      cell.suggestPic.image = [UIImage imageNamed:@"UserProfile"];
                                  }
                              }];
    
    
        cell.suggestRejectButton.hidden = false;
        cell.suggestAcceptButton.hidden = false;
        cell.suggestRejectButton.tag =indexPath.row ;
        cell.suggestAcceptButton.tag =indexPath.row ;
        
        [cell.suggestAcceptButton addTarget:self action:@selector(acceptTrackNotification:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.suggestRejectButton addTarget:self action:@selector(rejectTrackNotification:) forControlEvents:UIControlEventTouchUpInside];

    
   
    
    
    return cell;
}

-(IBAction)rejectTrackNotification:(id)sender{
    NSLog(@"rejectTrackNotification");
    
    UIButton *selectedButton = (UIButton *)sender;
    NSLog(@"Selected button tag is %ld", (long)selectedButton.tag);
    
    
     NSMutableDictionary *testDictionary = [[NSMutableDictionary alloc]init];
    testDictionary = [[trackRequestArray objectAtIndex:selectedButton.tag]mutableCopy];
    
    
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:[NSString stringWithFormat:@"%@",[testDictionary objectForKey:@"track_id"]] forKey:@"trackId"];
    [PGEvent rejectTrackRequest:params withCompletionBlock:^(bool success, id result, NSError *error){
        if (success) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"firefromsuggession" object:self userInfo:userInfo];
            
            
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"PING"
                                         message:@"You have rejected the follow request"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            //Add Buttons
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Ok"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                           
                                            if (trackRequestArray.count>0) {
                                                [trackRequestArray removeObjectAtIndex:selectedButton.tag];
                                            }
                                            
                                            [self.tableView reloadData];
                                            
                                           
                                        }];
            
            
            
            //Add your buttons to alert controller
            
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }];
}

-(IBAction)acceptTrackNotification:(id)sender{
    NSLog(@"acceptTrackNotification");
    
    UIButton *selectedButton = (UIButton *)sender;
    NSLog(@"Selected button tag is %ld", (long)selectedButton.tag);
    NSMutableDictionary *testDictionary = [[NSMutableDictionary alloc]init];
    testDictionary = [[trackRequestArray objectAtIndex:selectedButton.tag]mutableCopy];
    
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:[NSString stringWithFormat:@"%@",[testDictionary objectForKey:@"track_id"]] forKey:@"trackId"];
      
    
    
    
    
    
    [PGEvent acceptTrackRequest:params withCompletionBlock:^(bool success, id result, NSError *error){
        
        if (success) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"firefromsuggession" object:self userInfo:userInfo];
            
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"PING"
                                         message:@"You have accepted the follow request"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            //Add Buttons
            
            
            
            
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Ok"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            
                                            
                                            if (trackRequestArray.count>0) {
                                                [trackRequestArray removeObjectAtIndex:selectedButton.tag];
                                            }
                                            
                                            [self.tableView reloadData];
                                            
                                            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[result valueForKey:@"meeting_id"]] forKey:@"DateeventmeetingId"];
                                            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloaddataDateMeetingID" object:self userInfo:nil];
                                            
                                      
                                            
                                            
                                            
                                            
                                            
                                            
                                           [self.navigationController.view setNeedsDisplay];
                                        }];
            
            
            
            //Add your buttons to alert controller
            
            [alert addAction:yesButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
       
        
        
        
    }];
}
-(void) receiveTestNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"eRXReceived"])
    {
        userInfo = notification.userInfo;
       
        
        NSMutableArray * trackArray = [NSMutableArray array];
        trackArray = [userInfo valueForKey:@"total"] ;
        
        NSLog(@"trackArray------- %@",[trackArray valueForKey:@"trackRequest"]);
        
        trackRequestArray = [[NSMutableArray alloc]init];
        trackRequestArray = [[trackArray valueForKey:@"trackRequest"]mutableCopy];

        for (int i=0; i<[trackRequestArray count]; i++) {
             NSDictionary *testDictionary = [[NSDictionary alloc]init];
            testDictionary = [trackRequestArray objectAtIndex:i];
            NSLog (@"Successfully received test notification! %@", [testDictionary valueForKey:@"message"]   );
        }
        [self.tableView reloadData];
    }
}



@end
