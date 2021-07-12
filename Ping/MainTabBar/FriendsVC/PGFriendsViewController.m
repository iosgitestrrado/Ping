//
//  PGFriendsViewController.m
//  Ping
//
//  Created by Monish M S on 11/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import "PGFriendsViewController.h"
#import "PGAddFriendsViewController.h"
#import "PGFriendsTableViewCell.h"
#import "PGFriendRequestTableViewCell.h"
#import "PGFriends.h"
#import <FVCustomAlertView/FVCustomAlertView.h>
#import "PGEvent.h"
#import "AppDelegate.h"


@interface PGFriendsViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arrayFriendsList, *arrayFriendRequests, *scheduleArrayFriends, *newFilteredArray,*sortedArray,*duplicateArray;
    BOOL isSearchStarted;
     NSArray *alphabeticalArray;
    AppDelegate *appDelegate;
     UIButton *button1;
    
}

@property (weak, nonatomic) IBOutlet UITableView *friendsTableVIew;

@end

@implementation PGFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    arrayFriendsList    = [[NSMutableArray alloc]init];
    newFilteredArray    = [[NSMutableArray alloc]init];
 
    
    arrayFriendRequests = [[NSMutableArray alloc]init];
      alphabeticalArray = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];

    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(friendNotification:) name:@"friendAction" object:nil];
    isSearchStarted = false;
     [self addDoneToolBarToKeyboard:self.addFriendsSearch];
    
    UIImage *image = [UIImage imageNamed:@"notification"];
   button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(0, 0, 34, 34)];
    [button1 addTarget:self action:@selector(notificationViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setBackgroundImage:image forState:UIControlStateNormal];
    
    // Make BarButton Item
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = navLeftButton;
    
    _friendsTableVIew.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(badgeNotification:) name:@"badgeAction" object:nil];
}
-(void)badgeNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"badgeAction"])
    {
    
    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor colorWithRed:203.0/255.0 green:84.0/255.0 blue:124.0/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem.badgeValue = appDelegate.badgeValue;
    
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:-M_PI/18];
    animation.toValue = [NSNumber numberWithFloat: M_PI/18];
    animation.duration = 0.2;
    animation.repeatCount = 5;
    [animation setAutoreverses:YES];
    [button1.layer addAnimation:animation forKey:@"SpinAnimation"];
    
   // [self  fetchFriendsLists];
    }
}

-(void)addDoneToolBarToKeyboard:(UISearchBar *)textView
{
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.friendsTableVIew.frame.size.width, 50)];
    doneToolbar.barStyle = UIBarStyleBlackTranslucent;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)],
                         nil];
    [doneToolbar sizeToFit];
    textView.inputAccessoryView = doneToolbar;
}


-(void)doneButtonClickedDismissKeyboard
{
    [self.addFriendsSearch resignFirstResponder];
    if (self.addFriendsSearch.text.length == 0)
    {
        isSearchStarted = false;
        [self.friendsTableVIew reloadData];
    }
}
#pragma mark - UISearchBar Delegates

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    isSearchStarted = true;
    return true;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length >0 )
    {
        [self updateSearchResults:searchText];
    }
    else
    {
        //tableViewDataArray = [[DatabaseHelper Developer_masterFetchAllDeveloper] mutableCopy];
    }
}
-(void)friendNotification:(NSNotification*)notification
{
    
    NSMutableArray *controllers = [self.navigationController.viewControllers mutableCopy];
    
    UIViewController * controllerTest = [controllers lastObject];
    
    if([controllerTest isKindOfClass:[PGFriendsViewController class]]){
    }else{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    
    
    [self fetchFriendsLists];
}
- (IBAction)notificationViewAction:(id)sender
{
    
    NotificationViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    [self.navigationController pushViewController:profileVC animated:true];
    
}
-(void) showTutorial{
    

    
  
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                   CGRect coachmark = CGRectMake(self.view.frame.size.width-78,self.view.frame.size.height- 64,66,66);
                    
                    
                    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
                    if (screenSize.height == 812){
                        
                   
                       coachmark = CGRectMake(self.view.frame.size.width-78,self.view.frame.size.height-74,66,66);
                    }
                   
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CHATTUTORIAL"];
                    
                    
                    NSArray *coachMarks = @[
                                            @{
                                                @"rect": [NSValue valueWithCGRect:coachmark],
                                                @"caption": @"Make your phone contact friends  your ping friends.",
                                                @"shape": [NSNumber numberWithInteger:SHAPE_CIRCLE],
                                                @"position":[NSNumber numberWithInteger:LABEL_POSITION_TOP],
                                                @"alignment":[NSNumber numberWithInteger:LABEL_ALIGNMENT_CENTER],
                                                @"showArrow":[NSNumber numberWithBool:NO]
                                                }
                                            ];
                    
                    MPCoachMarks *coachMarksView = [[MPCoachMarks alloc] initWithFrame:self.navigationController.view.bounds coachMarks:coachMarks];
                    [self.navigationController.view addSubview:coachMarksView];
                    [coachMarksView start];
                    
                    
                    
                    
                }
    
    
    
    
    
    
    
   
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    
  
    
    
    
    
    
    
    
    
    
    
    
    self.navigationItem.rightBarButtonItem.badgeValue = appDelegate.badgeValue;
    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor colorWithRed:203.0/255.0 green:84.0/255.0 blue:124.0/255.0 alpha:1.0];
    appDelegate.indexValue = 2;
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(profileViewAction:)forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 34, 34)];
    button.layer.cornerRadius = 17;
    button.layer.masksToBounds = YES;
    
    UIImageView *picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 34, 34)];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"avthar"] == nil)
    {
        picImageView.layer.cornerRadius = 17;
        picImageView.layer.masksToBounds = YES;
        picImageView.image = [UIImage imageNamed:@"UserProfile"];
    }
    else
    {
        picImageView.layer.cornerRadius = 17;
        picImageView.layer.masksToBounds = YES;
        NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"avthar"]];
       // [picImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserProfile"] options:SDWebImageRefreshCached];
        
        
        [picImageView sd_setImageWithURL:url
                          placeholderImage:nil
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if (error) {
                                         
                                         picImageView.image = [UIImage imageNamed:@"UserProfile"];
                                     }
                                 }];
        
        
//        [picImageView startLoaderWithTintColor:[UIColor colorWithRed:85.0/255.0 green:82./255.0 blue:93.0/255.0 alpha:1.0]];
//
//        [picImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserProfile"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            [picImageView updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            [picImageView reveal];
//        }];
        
        
        
        
        
    }
    [button addSubview:picImageView];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    
    [super viewWillAppear:animated];
    [self fetchFriendsLists];
    // self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    self.tabBarController.tabBar.hidden= NO;
    
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CHATTUTORIAL"]) {
        
        [self showTutorial];
    }
    
    
    
    
}

-(void)fetchFriendsLists
{
    
 
        self.tabBarController.tabBar.userInteractionEnabled = NO;
  
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
 duplicateArray = [NSMutableArray new];
sortedArray = [NSMutableArray new];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    
    [PGFriends friendsListWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
    {
        self.tabBarController.tabBar.userInteractionEnabled = YES;
         [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
       
        if (success)
        {
           
            arrayFriendRequests = [[result valueForKey:@"request"] mutableCopy];
            
            
            
            
            arrayFriendsList = [[result valueForKey:@"data"]mutableCopy];
          
            
            
            
           
            duplicateArray = [[result valueForKey:@"data"] mutableCopy];
           
            
            if ((!arrayFriendRequests || !arrayFriendRequests.count) && (!arrayFriendsList || !arrayFriendsList.count))
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"There are no friend requests available at this time. Please try again later." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:nil];
                [alertController addAction:ok];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            [self.friendsTableVIew reloadData];
         
            if (arrayFriendRequests.count>0){
            NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.friendsTableVIew scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                  }
        }
        else
        {
           
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addFriendsAction:(id)sender
{
    PGAddFriendsViewController *addFriendVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PGAddFriendsViewController"];
    [self.navigationController pushViewController:addFriendVC animated:true];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;

    
    
    
}


- (void)updateSearchResults:(NSString *)string
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name contains[c] %@", string];
    if (duplicateArray == nil || [duplicateArray count] == 0)
    {
        return;
    }
    NSArray *filteredArr = [duplicateArray filteredArrayUsingPredicate:pred];
    
    
    [newFilteredArray removeAllObjects];
    
    newFilteredArray = filteredArr.mutableCopy;
    [self.friendsTableVIew reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}











- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
    {
        if (section == 0){
            
            if (!arrayFriendRequests || !arrayFriendRequests.count)
            {
                return 1;
                
                
                
            }else{
                return 32;
            }
            
        }
        return 32.0f;
    }







-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        if (!arrayFriendRequests || !arrayFriendRequests.count)
        {
           return 0;
            
            
            
        }else{
        return 75;
        }
    }
    else

    {
      return 60;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        
        if (!arrayFriendRequests || !arrayFriendRequests.count)
        {
             return nil;
        }
        
        else{
        CGRect frame = tableView.frame;
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
        title.text = @"Requests";
        title.font = [UIFont fontWithName:@"Lato-Regular" size:16.0];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [headerView setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:243.0/255.0 alpha:1.0]];
        [headerView addSubview:title];
        
        return headerView;
        
        }
        
        
       
    }
    else
    {
        CGRect frame = tableView.frame;
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
        title.text = @"Friends List";
        title.font = [UIFont fontWithName:@"Lato-Regular" size:16.0];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [headerView setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:243.0/255.0 alpha:1.0]];
        [headerView addSubview:title];
        
        return headerView;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
         if (!arrayFriendRequests || !arrayFriendRequests.count)
         {
             return 0;
         }
         else
         {
            return arrayFriendRequests.count;
         }
    }
    else
    {
        
        
        
//
//        if (!arrayFriendsList || !arrayFriendsList.count)
//        {
//            return 1;
//        }
//        else
//        {
//            return arrayFriendsList.count;
//        }
        
        if (isSearchStarted == true)
        {
            return newFilteredArray.count;
        }
        else
        {
            if (!arrayFriendsList || !arrayFriendsList.count)
            {
                return 1;
            }
            else
            {
                return arrayFriendsList.count;
            }
        }
        
        
        
        
        
        
        
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        PGFriendRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendRequestCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[PGFriendRequestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendRequestCell"];
        }
//        if (!arrayFriendRequests || !arrayFriendRequests.count)
//        {
//            cell.requestLabel.text = @"No Friend Requests";
//            cell.requestImgView.image = [UIImage imageNamed:@"NoFriendIcon"];
//            [cell.acceptBtn setHidden:true];
//            [cell.rejectBtn setHidden:true];
//        }
//        else
//        {
           cell.requestLabel.text = [[arrayFriendRequests valueForKey:@"message"] objectAtIndex:indexPath.row];
           [cell.acceptBtn setHidden:false];
           [cell.rejectBtn setHidden:false];
           NSString *urlString = [[arrayFriendRequests valueForKey:@"avthar"] objectAtIndex:indexPath.row];
           NSURL *url = [NSURL URLWithString:urlString];
          // [cell.requestImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
      
        
        [cell.requestImgView sd_setImageWithURL:url
                                  placeholderImage:nil
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                             if (error) {
                                                 
                                                 cell.requestImgView.image = [UIImage imageNamed:@"UserProfile"];
                                             }
                                         }];
        
        
        
        
        
        
           [cell.acceptBtn addTarget:self
                              action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
           [cell.rejectBtn addTarget:self
                              action:@selector(rejectAction:) forControlEvents:UIControlEventTouchUpInside];
//        }
        return cell;
    }
    else
    {
        PGFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsListCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[PGFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendsListCell"];
        }
//        if (isSearchStarted == true)
//        {
//            if (!newFilteredArray || !newFilteredArray.count)
//            {
//
//            }
//            else
//            {
//                cell.labelCntAdd.text = [[newFilteredArray valueForKey:@"name"] objectAtIndex:indexPath.row];
//            }
//        }
//        else
//        {
        
        if (isSearchStarted == true)
        {
            if (!newFilteredArray || !newFilteredArray.count)
            {
                cell.friendLabel.text = @"No Friends";
                cell.friendImgView.image = [UIImage imageNamed:@"NoFriendIcon"];
                [cell.friendBtn setHidden:true];
            }
            else
            {
                cell.friendLabel.text = [[newFilteredArray valueForKey:@"name"] objectAtIndex:indexPath.row];
                [cell.friendBtn setHidden:true];
                NSString *urlString = [[newFilteredArray valueForKey:@"avthar"] objectAtIndex:indexPath.row];
                NSURL *url = [NSURL URLWithString:urlString];
                
                [cell.friendImgView sd_setImageWithURL:url
                                       placeholderImage:nil
                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                  if (error) {
                                                      
                                                      cell.friendImgView.image = [UIImage imageNamed:@"UserProfile"];
                                                  }
                                              }];
                
              //  [cell.friendImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
            }
        }else{
        
        
        
        if (!arrayFriendsList || !arrayFriendsList.count)
        {
            cell.friendLabel.text = @"No Friends";
            cell.friendImgView.image = [UIImage imageNamed:@"NoFriendIcon"];
            [cell.friendBtn setHidden:true];
        }
        else
        {
            cell.friendLabel.text = [[arrayFriendsList valueForKey:@"name"] objectAtIndex:indexPath.row];
            [cell.friendBtn setHidden:true];
            NSString *urlString = [[arrayFriendsList valueForKey:@"avthar"] objectAtIndex:indexPath.row];
            NSURL *url = [NSURL URLWithString:urlString];
            [cell.friendImgView sd_setImageWithURL:url
                                  placeholderImage:nil
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                             if (error) {
                                                 
                                                 cell.friendImgView.image = [UIImage imageNamed:@"UserProfile"];
                                             }
                                         }];
          //  [cell.friendImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
        }
        }
        return cell;
    }
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    // Detemine if it's in editing mode
//    if (self.friendsTableVIew.editing)
//    {
//        if (indexPath.section == 0)
//        {
//            return UITableViewCellEditingStyleDelete;
//        }
//    }
//    return UITableViewCellEditingStyleNone;
//}
//
//-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0)
//    {
//        UITableViewRowAction *rejectAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Reject" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
//             [self rejectFriend:[[arrayFriendRequests valueForKey:@"number"] objectAtIndex:indexPath.row]];
//        }];
//        rejectAction.backgroundColor = [UIColor redColor];
//
//        UITableViewRowAction *accpetAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Accept" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
//                                              {
//                                                  // user_id, friendNumber
//                                                  [self acceptFriend:[[arrayFriendRequests valueForKey:@"number"] objectAtIndex:indexPath.row]];
//
//                                              }];
//        accpetAction.backgroundColor = [UIColor greenColor];
//        return @[rejectAction,accpetAction];
//    }
//    else
//    {
//        [self.friendsTableVIew setEditing:false];
//        return nil;
//    }
//}

- (IBAction)profileViewAction:(id)sender
{
    
    PGProfileTableViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PGProfileTableViewController"];
    profileVC.passString = nil;
    [self.navigationController pushViewController:profileVC animated:true];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
    }else{
        
        NSDictionary *dict ;
        
        if (isSearchStarted == true)
        {
            
            
            
            
            
            dict = [newFilteredArray  objectAtIndex:indexPath.row];
            
        }else{
            
            dict = [arrayFriendsList  objectAtIndex:indexPath.row];
            
            
        }
        
        if (dict != nil) {
       
        
        
PGProfileTableViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PGProfileTableViewController"];
        if (isSearchStarted == true)
        {
            
            
            
            
            
        profileVC.passString = [newFilteredArray  objectAtIndex:indexPath.row];
            
        }else{

        profileVC.passString = [arrayFriendsList  objectAtIndex:indexPath.row];

            
        }
        [self.navigationController pushViewController:profileVC animated:true];
        }
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSearchStarted == true)
    {
        if (!newFilteredArray || !newFilteredArray.count)
        {
return NO;
        }
        
    }else{
        
        
        
        if (!arrayFriendsList || !arrayFriendsList.count)
        {
            return NO;
        }
        
    }
    
    return YES;
}


-(void)deleteRow{
    
    
   
    
        
        
        if (isSearchStarted == true)
        {
            NSDictionary *dict = [newFilteredArray objectAtIndex:indexpath];
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
            [params setObject:[dict objectForKey:@"number"] forKey:@"friendNumber"];
            
            [PGFriends removeFriendsWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
             {
                 
                 if (success)
                 {
                     [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"That user has been removed successfully." preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    
                                                                    for(NSDictionary * item in arrayFriendsList) {
                                                                        if([item isEqual:dict]) {
                                                                            
                                                                            
                                                                                if (arrayFriendsList.count>0) {
                                                                            [arrayFriendsList removeObject:item];
                                                                                }
                                                                        }
                                                                    }
                                                                    
                                                                    
                                                                    
                                                                    
                                                                    
                                                                    
                                                                    if (newFilteredArray.count>0) {
                                                                        
                                                                        [newFilteredArray removeObjectAtIndex:indexpath];
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                    }
                                                                    
                                                                    
                                                                    
                                                                    
                                                                    [_friendsTableVIew reloadData];
                                                                    
                                                                }];
                     [alertController addAction:ok];
                     [self presentViewController:alertController animated:YES completion:nil];
                 }
                 else
                 {
                     [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                handler:nil];
                     [alertController addAction:ok];
                     [self presentViewController:alertController animated:YES completion:nil];
                 }
             }];
            
            
            
            
        }else{
            
            
            
            NSDictionary *dict = [arrayFriendsList objectAtIndex:indexpath];
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
            [params setObject:[dict objectForKey:@"number"] forKey:@"friendNumber"];
            
            [PGFriends removeFriendsWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
             {
                 
                 if (success)
                 {
                     [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"That user has been removed successfully." preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    
                                                                  
                                                                    
                                                                    if (arrayFriendsList.count>0) {
                                                                        
                                                                        [arrayFriendsList removeObjectAtIndex:indexpath];
                                                                        
                                                                        
                                                                        
                                                                        
                                                                        
                                                                    }
                                                                    
                                                                    
                                                                    
                                                                    
                                                                    [_friendsTableVIew reloadData];
                                                                    
                                                                }];
                     [alertController addAction:ok];
                     [self presentViewController:alertController animated:YES completion:nil];
                 }
                 else
                 {
                     [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                handler:nil];
                     [alertController addAction:ok];
                     [self presentViewController:alertController animated:YES completion:nil];
                 }
             }];
            
        }
        
        
    }














- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0)
    {
    }else
    
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"PING"
                                     message:@"Are you sure you want to remove this contact?"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        //Add Buttons
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"YES"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        indexpath = indexPath.row;
                                        [self deleteRow];
                                        
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"NO"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
      
    }
 
}



- (IBAction)acceptAction:(id)sender
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];

    scheduleArrayFriends = [NSMutableArray new];
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.friendsTableVIew];
    NSIndexPath *indexPath = [self.friendsTableVIew indexPathForRowAtPoint:buttonPosition];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:[[arrayFriendRequests valueForKey:@"number"]objectAtIndex:indexPath.row] forKey:@"friendNumber"];
    
    [PGFriends acceptFriendWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         if (success)
         {
             
             if (arrayFriendRequests.count>0) {
                 
                 [arrayFriendRequests removeObjectAtIndex:indexPath.row];
                 
                 
                 
                 
                 
             }
       
           
       
             [_friendsTableVIew reloadData];
             
             
             
             
             
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];

             scheduleArrayFriends = [result valueForKey:@"data"];
            
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:[result valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            [self schedulePingMeeting];
                                                        }];
             [alertController addAction:ok];
             
             UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"May be later" style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
//                                                                [self schedulePingMeeting];
                                                            }];
             [alertController addAction:cancel];
             [self presentViewController:alertController animated:YES completion:nil];
             
         }
         else
         {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                        handler:nil];
             [alertController addAction:ok];
             [self presentViewController:alertController animated:YES completion:nil];
         }
     }];
}

-(void)schedulePingMeeting
{
    //  user_id, startTime, endTime, timeSlots, friendId
    
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];

    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:[scheduleArrayFriends valueForKey:@"startTime"] forKey:@"startTime"];
    [params setObject:[scheduleArrayFriends valueForKey:@"endTime"] forKey:@"endTime"];
    [params setObject:[scheduleArrayFriends valueForKey:@"timeSlots"] forKey:@"timeSlots"];
    [params setObject:[scheduleArrayFriends valueForKey:@"friendId"] forKey:@"friendId"];
    
    [PGEvent shedulePingMeetingWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
    {
        if (success)
        {
            [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
            dispatch_async(dispatch_get_main_queue(), ^(void)
                           {
                              [self fetchFriendsLists];
                           });
        }
        else
        {
            [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action)
            {
                                                           [self fetchFriendsLists];
                                                       }];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return alphabeticalArray;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [tableView setContentOffset:CGPointZero animated:YES];
    
    NSInteger newRow = [self indexForFirstChar:title inArray:[arrayFriendsList valueForKey:@"name"]];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:1];
    @try
    {
        [tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    @catch ( NSException *e )
    {
        NSLog(@"bummer: %@",e);
    }
    
    return index;
}

// Return the index for the location of the first item in an array that begins with a certain character
- (NSInteger)indexForFirstChar:(NSString *)character inArray:(NSArray *)array
{
    NSUInteger count = 0;
    for (NSString *str in array)
    {
        if ([str hasPrefix:character])
        {
            return count;
        }
        count++;
    }
    return 0;
}


- (IBAction)rejectAction:(id)sender
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.friendsTableVIew];
    NSIndexPath *indexPath = [self.friendsTableVIew indexPathForRowAtPoint:buttonPosition];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:[[arrayFriendRequests valueForKey:@"number"]objectAtIndex:indexPath.row] forKey:@"friendNumber"];

    [PGFriends rejectFriendWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
    {
        if (success)
        {
            [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
            if (arrayFriendRequests.count>0) {
                
               [arrayFriendRequests removeObjectAtIndex:indexPath.row];
                
                
                
                
                
            }
            
           
            
            
            
            [_friendsTableVIew reloadData];
            
        }
        else
        {
            [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

@end
