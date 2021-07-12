//
//  SettingsViewController.m
//  Ping
//
//  Created by Monish M S on 08/06/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "SettingsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PGEditProfileTableViewController.h"
#import "HelpViewController.h"
#import "PGEvent.h"
#import "termsAndPrivacyViewController.h"

@interface SettingsViewController ()
{
    NSMutableArray *arrayProfile;
}

@property (weak, nonatomic) IBOutlet UIImageView *profilePicImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *sleepingLabel;

@property (nonatomic, strong) IBOutlet UIView *noChatimageView;
@end

@implementation SettingsViewController


- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if (error != nil) {
        [self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
    } else {
        
       self.service.authorizer = user.authentication.fetcherAuthorizer;
        [self fetchEvents];
    }
}


- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    NSLog(@"%@",error.description);
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    //present view controller
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    //dismiss view controller
}


// Construct a query and get a list of upcoming events from the user calendar. Display the
// start dates and event summaries in the UITextView.
- (void)fetchEvents {
    
    tempdata = [[NSMutableArray alloc]init];
    
    
    GTLRCalendarQuery_EventsList *query =
    [GTLRCalendarQuery_EventsList queryWithCalendarId:@"primary"];
    query.maxResults = 10;
    query.timeMin = [GTLRDateTime dateTimeWithDate:[NSDate date]];
    
    query.singleEvents = YES;
    query.orderBy = kGTLRCalendarOrderByStartTime;
    
    [self.service executeQuery:query
                      delegate:self
             didFinishSelector:@selector(displayResultWithTicket:finishedWithObject:error:)];
}

- (void)displayResultWithTicket:(GTLRServiceTicket *)ticket
             finishedWithObject:(GTLRCalendar_Events *)events
                          error:(NSError *)error {
    if (error == nil) {
      
        if (events.items.count > 0) {
        
            
            [tempdata  removeAllObjects];
            for (GTLRCalendar_Event *event in events) {
           
                GTLRDateTime *starttime =  event.start.dateTime;
                GTLRDateTime *startend =  event.end.dateTime;
                
                
                
                
         
                NSString *startTimeString =
                [NSDateFormatter localizedStringFromDate:[starttime date]
                                               dateStyle:NSDateFormatterShortStyle
                                               timeStyle:NSDateFormatterShortStyle];
                NSString *endTimeString =
                [NSDateFormatter localizedStringFromDate:[startend date]
                                               dateStyle:NSDateFormatterShortStyle
                                               timeStyle:NSDateFormatterShortStyle];
                
                
                
                
                
                
                
                NSLog(@"%@  %@   %@   %@",startTimeString,endTimeString,event.summary,event.location);
              
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd/MM/yyyy, h:mm a"];
                NSDate *dateEventStart = [ dateFormatter   dateFromString:startTimeString];
                NSDate *dateEventend = [ dateFormatter   dateFromString:endTimeString];
                
                [dateFormatter setDateFormat:@"HH:mm"];
                NSString *formattedStratDateString = [dateFormatter stringFromDate:dateEventStart];
                NSString *formattedEndDateString = [dateFormatter stringFromDate:dateEventend];
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *formattedDateString = [dateFormatter stringFromDate:[starttime date]];

                NSDictionary* dictNum = @{@"title":[NSString stringWithFormat:@"%@", event.summary] ,@"location": [NSString stringWithFormat:@"%@",event.location],@"date": formattedDateString,@"startTime": formattedStratDateString,@"endTime": formattedEndDateString,@"fullEvent": @"0"};

                [tempdata addObject:dictNum];
                NSLog(@"%@",dictNum);
                
                
                
                
                
                
                
            }
            
            
            [self fetchEventsIos];
        }
        
   
    } else {
        [self showAlert:@"Error" message:error.localizedDescription];
    }
}
-(void) fetchEventsIos{







                     NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                     [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];

                     NSArray *array = [[NSArray alloc] initWithArray:tempdata];


                     NSData *jsonDataFriendsAdd = [NSJSONSerialization dataWithJSONObject:array
                                                                                  options:NSJSONWritingPrettyPrinted error:nil];
                     NSString *jsonStringFriendsAdd = [[NSString alloc] initWithData:jsonDataFriendsAdd encoding:NSUTF8StringEncoding];


                     [params setObject:jsonStringFriendsAdd forKey:@"events"];


                     [PGEvent fetchGoogleEventWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
                      {

                          if (success) {

                       [self showAlert:@"Google Calendar" message:@"Synchronization successfully"];
                             
                          }else{
                              
                              [self showAlert:@"Google Calendar" message:@"Error in synchronization"];
                          }
                      }];
 }



// Helper for showing an alert
- (void)showAlert:(NSString *)title message:(NSString *)message {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:title
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
         [alert dismissViewControllerAnimated:YES completion:nil];
     }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}








- (IBAction)notificationAction:(id)sender {
 
    GIDSignIn *signin = [GIDSignIn sharedInstance];
    signin.shouldFetchBasicProfile = true;
    signin.scopes = [NSArray arrayWithObjects:kGTLRAuthScopeCalendarReadonly, nil];
    signin.delegate = self;
    signin.uiDelegate = self;
    
    
    
    if ([signin hasAuthInKeychain]) {
        
        [signin signInSilently];
    }else{
        
        
        [signin signIn];
    }
   
    self.service = [[GTLRCalendarService alloc] init];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    


        self.title = @"Settings";

  
    
    
    
    
    
    arrayProfile = [NSMutableArray new];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = true;
    
    
    
    NSString *start =  [[NSUserDefaults standardUserDefaults] objectForKey:@"sleepStart"];
    NSString *end = [[NSUserDefaults standardUserDefaults] objectForKey:@"sleepEnd"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSDate *date = [dateFormatter dateFromString:start];
    NSDate *date1 = [dateFormatter dateFromString:end];
    [dateFormatter setDateFormat:@"h.mma"];
    
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    NSString *formattedDate1 = [dateFormatter stringFromDate:date1];
    NSLog(@"%@",formattedDate);
    
    _sleepingLabel.text = [[NSString stringWithFormat:@"%@ - %@",formattedDate,formattedDate1]lowercaseString];
    
    
    
   
    NSString *urlString = [[NSUserDefaults standardUserDefaults] objectForKey:@"avthar"];
    NSURL *url = [NSURL URLWithString:urlString];
    //[self.profilePicImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserProfile"] options:SDWebImageRefreshCached];
    
    [self.profilePicImgView sd_setImageWithURL:url
                               placeholderImage:nil
                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                          if (error) {
                                              
                                              self.profilePicImgView.image = [UIImage imageNamed:@"UserProfile"];
                                          }
                                      }];
    
    
    
    
    NSString *fullName = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"fname"],[[NSUserDefaults standardUserDefaults] objectForKey:@"lname"]];
    self.nameLabel.text = fullName;
    self.statusLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"ping_status"];
    
    [self HEIGHTCHANGE:[[NSUserDefaults standardUserDefaults] objectForKey:@"ping_status"]];
  
    
    
}


    
    
    
    
    
    
    








-(void)HEIGHTCHANGE:(NSString *)str{
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:str
                                    attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.view.frame.size.width-40, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    
    CGFloat labelHeight = size.height;
    
    
    if (labelHeight>20) {
        CGRect newFrame = CGRectMake( _noChatimageView.frame.origin.x, _noChatimageView.frame.origin.y, _noChatimageView.frame.size.width, 200 + labelHeight);
        
       // self.noChatimageView.frame = newFrame;
    }else{
        
        CGRect newFrame = CGRectMake( _noChatimageView.frame.origin.x, _noChatimageView.frame.origin.y, _noChatimageView.frame.size.width, 210);
        
       // self.noChatimageView.frame = newFrame;
    }
    
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"helpaction"])
    {
        // Get reference to the destination view controller
        HelpViewController *vc = [segue destinationViewController];
        vc.passString = @"help" ;
    }else if  ([[segue identifier] isEqualToString:@"aboutaction"])
    {
        // Get reference to the destination view controller
        HelpViewController *vc = [segue destinationViewController];
        vc.passString = @"about" ;
    }
}
-(IBAction)PrivacyButton:(id)sender
{
    
    
    
    
    
    
    termsAndPrivacyViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"termsAndPrivacyViewController"];
    profileVC.passString = @"Privacy Policy";
    [self.navigationController pushViewController:profileVC animated:true];
}
-(IBAction)termsButton:(id)sender
{
    
    
    
    
    
    
    termsAndPrivacyViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"termsAndPrivacyViewController"];
    profileVC.passString = @"Terms & Conditions";
    [self.navigationController pushViewController:profileVC animated:true];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section      {
 
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ping+"]) {
          return 6;
    } else {
         return 7;
    }

  
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    return 60;
    
    
}





@end
