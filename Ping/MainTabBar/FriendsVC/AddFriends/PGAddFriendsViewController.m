//
//  PGAddFriendsViewController.m
//  Ping
//
//  Created by Monish M S on 11/12/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import "PGAddFriendsViewController.h"
#import "ContactList.h"
#import "PGAddFriendsTableViewCell.h"
#import "PGFriends.h"
#import <FVCustomAlertView/FVCustomAlertView.h>
#import "PGAddPingFriendsTableViewCell.h"
#import "PGFriendsViewController.h"

@interface PGAddFriendsViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *contactArray, *arrayContactPass, *addfriendsArray, *newFilteredArray,*arrayContactPassLast;
    NSMutableArray *contactListArray, *pingListArray,*duplicateArray,*sortedArray;
    NSMutableArray *selectedFriendsArray;
    BOOL isSearchStarted,isFirstSection;
    NSTimer *_timer;
    NSArray *alphabeticalArray;
    NSString *codeAppend;
}
@property (strong, nonatomic) NSArray *dataRows;
@property (weak, nonatomic) IBOutlet UIButton *fbBtn;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (weak, nonatomic) IBOutlet UITableView *friendsTableVIew;
@property (weak, nonatomic) IBOutlet UISearchBar *addFriendsSearch;
@property (weak, nonatomic) IBOutlet UIButton *addFriendBtn;

@end

@implementation PGAddFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self parseJSON];
    contactArray     = [NSMutableArray new];
    arrayContactPass = [NSMutableArray new];
    arrayContactPassLast = [[NSMutableArray alloc]init];
    contactListArray = [NSMutableArray new];
    pingListArray    = [NSMutableArray new];
    sortedArray      = [NSMutableArray new];
    addfriendsArray  = [NSMutableArray new];
    newFilteredArray = [NSMutableArray new];
    selectedFriendsArray = [NSMutableArray new];
    
    self.title = @"Add Friends";
    alphabeticalArray = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    [[ContactList sharedContacts] fetchAllContacts]; //fetch all contacts by calling single to method
    
    isSearchStarted = false;
    isFirstSection = false;
    
    [self addDoneToolBarToKeyboard:self.addFriendsSearch];
    
   // [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:106.0/255.0 green:103.0/255.0 blue:122.0/255.0 alpha:1.0]];
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    NSLog(@"countryCode: %@", countryCode);
    
    for (NSDictionary *item in _dataRows){
        
        
        
        if ([[item objectForKey:@"code"] isEqualToString:countryCode])
        {
            codeAppend =[item objectForKey:@"dial_code"];
            
        }
        
    }
    
    [self.navigationController setNavigationBarHidden:false];
    self.tabBarController.tabBar.hidden = true;
    [self setStartUpDesign];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    [self fetchContacts];
}
- (void)parseJSON {
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    _dataRows = (NSArray *)parsedObject;
}

-(void)fetchContacts
{
    if ([[ContactList sharedContacts]totalPhoneNumberArray].count !=0)
    {
      
        contactArray = [[ContactList sharedContacts]totalPhoneNumberArray];
    }
    [arrayContactPassLast removeAllObjects];
    for (id item in contactArray)
    {
        NSDictionary *dict = item;
        
        
        
        
        
     
        NSMutableArray *res =[[NSMutableArray alloc]init];
        NSString *strPhone;
        res =  [[dict valueForKey:@"phone"] mutableCopy];
        if (res.count>5) {
         
        NSRange r;
        r.location = 5;
        r.length = [res count]-5;
        
        [res removeObjectsInRange:r];
        
        }
        
        
        
        
        
        
        if (res.count>0) {
            
            
            
            
            NSInteger value = res.count;
         
            
            for (int i= 0; i<res.count; i++) {
                if (![[[NSString stringWithFormat:@"%@",[res objectAtIndex:i]]substringToIndex:1] isEqualToString:@"+"] ) {
                    strPhone  = [NSString stringWithFormat:@"%@%@", codeAppend,
                                 [NSString stringWithFormat:@"%@",[res objectAtIndex:i]]];
                    
                    
                    [res replaceObjectAtIndex:i withObject:strPhone];
                    
                    
                }
            }
            
            
            
            
            NSDictionary* dictNum = @{@"number": res,@"name": [dict valueForKey:@"name"]};
            
            if (arrayContactPass.count<1300) {
             
                      [arrayContactPass addObject:dictNum];
              
                
        
            
            }else{
             
                
              
                    [arrayContactPassLast addObject:dictNum];
               
                
            }
        }
        
        
        
        
        
      
        
    }
    
    [self passContactList];
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

- (void)updateSearchResults:(NSString *)string
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"name contains[c] %@", string];
    if (sortedArray == nil || [sortedArray count] == 0)
    {
        return;
    }
    NSArray *filteredArr = [sortedArray filteredArrayUsingPredicate:pred];
    
    newFilteredArray = filteredArr.mutableCopy;
    [self.friendsTableVIew reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)passContactList
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
    duplicateArray = [NSMutableArray new];
    NSError *error;
    
    NSData *jsonDataContacts = [NSJSONSerialization dataWithJSONObject:arrayContactPass
                                                               options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonStringContacts = [[NSString alloc] initWithData:jsonDataContacts encoding:NSUTF8StringEncoding];
    
   
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    [params setObject:jsonStringContacts forKey:@"contactList"];
    if (arrayContactPassLast.count>0) {
        
        NSData *jsonDataContactsLast = [NSJSONSerialization dataWithJSONObject:arrayContactPassLast
                                                                       options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonStringContactsLast = [[NSString alloc] initWithData:jsonDataContactsLast encoding:NSUTF8StringEncoding];
        
        [params setObject:jsonStringContactsLast forKey:@"contactList1"];
        
    }
    
    
    
    [PGFriends contactsWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         if (success)
         {
             contactListArray = [result valueForKey:@"contacts"];
             pingListArray = [result valueForKey:@"ping"];
             
             //             if (!contactListArray || !contactListArray.count)
             //             {
             //                // [self passContactList];
             //             }
             //             else
             //             {
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
             NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
             duplicateArray = [contactListArray sortedArrayUsingDescriptors:@[sort]].mutableCopy;
             [self filterObjectsByKey:@"name"];
             [self.friendsTableVIew reloadData];
             //             }
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

- (NSArray *) filterObjectsByKey:(NSString *) key
{
    [sortedArray removeAllObjects];
    NSMutableSet *tempValues = [[NSMutableSet alloc] init];
    for(id obj in duplicateArray)
    {
        if(! [tempValues containsObject:[obj valueForKey:key]])
        {
            [tempValues addObject:[obj valueForKey:key]];
            [sortedArray addObject:obj];
        }
    }
    
    return sortedArray;
}

-(void)setStartUpDesign
{
    UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackArrow"]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(previousField:)];
    self.navigationItem.leftBarButtonItem = previousButton;
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Skip" style:UIBarButtonItemStylePlain target:self action:@selector(nextField:)];
    self.navigationItem.rightBarButtonItem = nextButton;
}

-(IBAction)previousField:(id)sender
{
    self.tabBarController.tabBar.hidden = false;
    if (![_otp isEqualToString:@"otp"]){
        
        _otp = @"";
        
        [self.navigationController popViewControllerAnimated:true];
        
        
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           
                           _otp = @"";
                           
                           
                           UINavigationController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainNav"];
                           [UIApplication sharedApplication].keyWindow.rootViewController = homeVC;
                       });
        
        
        
        
        
    }
}

-(IBAction)nextField:(id)sender
{
    if (![_otp isEqualToString:@"otp"]){
        
        _otp = @"";
        
        [self.navigationController popViewControllerAnimated:true];
        
        
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^(void)
                       {
                           
                           _otp = @"";
                           
                           
                           UINavigationController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainNav"];
                           [UIApplication sharedApplication].keyWindow.rootViewController = homeVC;
                       });
        
        
        
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(void) playAction:(UIButton*)sender
{
    if (!pingListArray || !pingListArray.count)
    {
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"Would you like to send a friend request to all your friends?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                       
                                                       
                                                       
                                                       [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
                                                       
                                                       NSMutableArray *arrayAddFriends = [NSMutableArray new];
                                                       
                                                       for (id item in pingListArray)
                                                       {
                                                           NSDictionary *dict = item;
                                                           
                                                           NSDictionary* dictNum = @{@"number": [dict valueForKey:@"number"]};
                                                           [arrayAddFriends addObject:dictNum];
                                                       }
                                                       
                                                       NSError *error;
                                                       NSData *jsonDataAddFriends = [NSJSONSerialization dataWithJSONObject:arrayAddFriends
                                                                                                                    options:NSJSONWritingPrettyPrinted error:&error];
                                                       NSString *jsonStringAddFriends = [[NSString alloc] initWithData:jsonDataAddFriends encoding:NSUTF8StringEncoding];
                                                       
                                                       NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                                                       [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
                                                       [params setObject:jsonStringAddFriends forKey:@"friends"];
                                                       
                                                       [PGFriends addFriendsWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
                                                        {
                                                           
                                                            
                                                            if (success)
                                                            {
                                                                [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                                                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"Friend request sent successfully." preferredStyle:UIAlertControllerStyleAlert];
                                                                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                                                                               if (![_otp isEqualToString:@"otp"]){
                                                                                                                   
                                                                                                                   _otp = @"";
                                                                                                                   
                                                                                                                   [self.navigationController popViewControllerAnimated:true];
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }else{
                                                                                                                   dispatch_async(dispatch_get_main_queue(), ^(void)
                                                                                                                                  {
                                                                                                                                      
                                                                                                                                      _otp = @"";
                                                                                                                                      
                                                                                                                                      
                                                                                                                                      UINavigationController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainNav"];
                                                                                                                                      [UIApplication sharedApplication].keyWindow.rootViewController = homeVC;
                                                                                                                                  });
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                                   
                                                                                                               }
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
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                       
                                                   }];
        [alertController addAction:ok];
        UIAlertAction* ok1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                    handler:nil];
        [alertController addAction:ok1];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        
        if (!pingListArray || !pingListArray.count)
        {
            return 1;
       
        }else{
            return 32;
        }
        
    }
    return 32.0f;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        
        
        if (!pingListArray || !pingListArray.count)
        {
            return nil;
        }
        
        else{
        
        
        
        CGRect frame = tableView.frame;
        
        
        
        
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
        playButton.frame = CGRectMake(frame.size.width-115, 0, 100, 28);
        [playButton setTitle:@"Request All" forState:UIControlStateNormal];
        playButton.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16.0];
        playButton.backgroundColor = [UIColor colorWithRed:106.0/255.0 green:103.0/255.0 blue:122.0/255.0 alpha:1.0] ;
        [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        
        [playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        
        
        
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
        title.text = @"Ping";
        title.font = [UIFont fontWithName:@"Lato-Regular" size:16.0];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [headerView setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:243.0/255.0 alpha:1.0]];
        [headerView addSubview:title];
        [headerView addSubview:playButton];
        
        
        return headerView;
        }
    }
    else
    {
        CGRect frame = tableView.frame;
        
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-110, 0, 100, 30)];
        [addButton setTitle:@"Invite All" forState:UIControlStateNormal];
        [addButton setTitleColor:[UIColor colorWithRed:106.0/255.0 green:103.0/255.0 blue:122.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        addButton.backgroundColor = [UIColor clearColor];
         addButton.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16.0];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
        title.text = @"Others";
        title.font = [UIFont fontWithName:@"Lato-Regular" size:16.0];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [headerView setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:243.0/255.0 alpha:1.0]];
        [headerView addSubview:title];
        [headerView addSubview:addButton];
        
        return headerView;
    }
    
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//    {
//        return @"Ping";
//    }
//    else
//    {
//        return @"Others";
//    }
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (!pingListArray || !pingListArray.count)
        {
            return 0;
        }
        else
        {
        return pingListArray.count;
            
        }
        //Return the number of sections you want in each row
    }
    else
    {
        if (isSearchStarted == true)
        {
            return newFilteredArray.count;
        }
        else
        {
            return sortedArray.count;
        }
    }
}





-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        PGAddPingFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddPingFriendsCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[PGAddPingFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddPingFriendsCell"];
        }
//        if (!pingListArray || !pingListArray.count)
//        {
//
//            cell.addLabelPG.text = @"No Ping Friends";
//            cell.addImgviewPG.image = [UIImage imageNamed:@"NoFriendIcon"];
//            cell.addPGBtn.hidden = YES;
//        }
//        else
//        {
            cell.addLabelPG.text = [[pingListArray valueForKey:@"name"] objectAtIndex:indexPath.row];
            
            cell.addImgviewPG.image = [UIImage imageNamed:@"NoFriendIcon"];
            
              cell.addPGBtn.hidden = NO;
            
            
//        }
        return cell;
    }
    else
    {
        PGAddFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddFriendsCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[PGAddFriendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddFriendsCell"];
        }
        if (isSearchStarted == true)
        {
            if (!newFilteredArray || !newFilteredArray.count)
            {
                
            }
            else
            {
                cell.labelCntAdd.text = [[newFilteredArray valueForKey:@"name"] objectAtIndex:indexPath.row];
            }
        }
        else
        {
            if (!sortedArray || !sortedArray.count)
            {
                
            }
            else
            {
                cell.labelCntAdd.text = [[sortedArray valueForKey:@"name"] objectAtIndex:indexPath.row];
            }
        }
        return cell;
    }
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return alphabeticalArray;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [tableView setContentOffset:CGPointZero animated:YES];
    
    NSInteger newRow = [self indexForFirstChar:title inArray:[sortedArray valueForKey:@"name"]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        
        
        if (!pingListArray || !pingListArray.count)
        {
            
            
        }else{
            
            
            
      //      checkedOn
            
            
            
            
            
            
            
            
            
            
            
            isFirstSection = true;
            
            PGAddPingFriendsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
              UIImage* selectedImg=[UIImage imageNamed:@"checkedOn"];
            if ([cell.addPGBtn.currentImage isEqual:selectedImg])
            {
                
                if (selectedFriendsArray.count == 0)
                {
                   [cell.addPGBtn setImage:[UIImage imageNamed:@"checkedOn"] forState:UIControlStateNormal];
                    [selectedFriendsArray addObject:[pingListArray objectAtIndex:indexPath.row]];
                }
                else
                {
                    
                    [cell.addPGBtn setImage:[UIImage imageNamed:@"checkedOff"] forState:UIControlStateNormal];
                    
                       if (selectedFriendsArray.count>0) {
                    
                    [selectedFriendsArray removeObject:[pingListArray objectAtIndex:indexPath.row]];
                           
                       }
                    
                }
            }
            else
            {
                
                
                [cell.addPGBtn setImage:[UIImage imageNamed:@"checkedOn"] forState:UIControlStateNormal];
                
                
                [selectedFriendsArray addObject:[pingListArray objectAtIndex:indexPath.row]];
            }
        }
        
        
        
        
        
        
        
        
        
    }else{
        

       
        
    
        
        NSString *url=@"http://www.pingeffect.com";
        NSString * title =[NSString stringWithFormat:@"Hi! I just downloaded a cool new app that allows us to meet, even when things don’t go as planned. Try it out now and I’ll see you soon! %@",url];

        
        UIImage *imageData = [UIImage imageNamed:@"PingMe"];
        
        NSArray* sharedObjects=[NSArray arrayWithObjects:title,imageData, nil];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                            initWithActivityItems:sharedObjects applicationActivities:nil];
        
        activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
        
        
        activityViewController.popoverPresentationController.sourceView = self.view;
        [self presentViewController:activityViewController animated:YES completion:nil];
        

        
        
        
        
        
        
        
        
        
    }
}
















//-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0)
//    {
//        if (!pingListArray || !pingListArray.count)
//        {
//
//
//        }else{
//
//
//
//            isFirstSection = true;
//
//            PGAddPingFriendsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//
//            if ([cell.addPGBtn.titleLabel.text isEqualToString:@"checkmark"])
//            {
//                [cell.addPGBtn setTitle:@"" forState:UIControlStateNormal];
//                if (selectedFriendsArray.count == 0)
//                {
//                    [cell.addPGBtn setTitle:@"checkmark" forState:UIControlStateNormal];
//                    [selectedFriendsArray addObject:[pingListArray objectAtIndex:indexPath.row]];
//                }
//                else
//                {
//                    [selectedFriendsArray removeObject:[pingListArray objectAtIndex:indexPath.row]];
//
//                }
//            }
//            else
//            {
//                [cell.addPGBtn setTitle:@"checkmark" forState:UIControlStateNormal];
//                [selectedFriendsArray addObject:[pingListArray objectAtIndex:indexPath.row]];
//            }
//        }
//    }
////    else
////    {
////        PGAddFriendsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
////        isFirstSection = false;
////
////        if (isSearchStarted == true)
////        {
////            if ([cell.addCntBtn.titleLabel.text isEqualToString:@"checkmark"])
////            {
////                [cell.addCntBtn setTitle:@"" forState:UIControlStateNormal];
////                if (selectedFriendsArray.count == 0)
////                {
////                    [cell.addCntBtn setTitle:@"checkmark" forState:UIControlStateNormal];
////                    [selectedFriendsArray addObject:[newFilteredArray objectAtIndex:indexPath.row]];
////                }
////                else
////                {
////                    [selectedFriendsArray removeObject:[newFilteredArray objectAtIndex:indexPath.row]];
////                }
////            }
////            else
////            {
////                [cell.addCntBtn setTitle:@"checkmark" forState:UIControlStateNormal];
////                [selectedFriendsArray addObject:[newFilteredArray objectAtIndex:indexPath.row]];
////            }
////        }
////        else
////        {
////            if ([cell.addCntBtn.titleLabel.text isEqualToString:@"checkmark"])
////            {
////                [cell.addCntBtn setTitle:@"" forState:UIControlStateNormal];
////                if (selectedFriendsArray.count == 0)
////                {
////                    [cell.addCntBtn setTitle:@"checkmark" forState:UIControlStateNormal];
////                    [selectedFriendsArray addObject:[sortedArray objectAtIndex:indexPath.row]];
////                }
////                else
////                {
////                    [selectedFriendsArray removeObject:[sortedArray objectAtIndex:indexPath.row]];
////
////                }
////            }
////            else
////            {
////                [cell.addCntBtn setTitle:@"checkmark" forState:UIControlStateNormal];
////                [selectedFriendsArray addObject:[sortedArray objectAtIndex:indexPath.row]];
////            }
////        }
////    }
//    return indexPath;
//}

- (IBAction)addFriendAction:(id)sender
{
    if (!selectedFriendsArray || !selectedFriendsArray.count)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"Please select a friend before proceeding." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
        
        NSMutableArray *arrayAddFriends = [NSMutableArray new];
        
        for (id item in selectedFriendsArray)
        {
            NSDictionary *dict = item;
            
            NSDictionary* dictNum = @{@"number": [dict valueForKey:@"number"]};
            [arrayAddFriends addObject:dictNum];
        }
        
        NSError *error;
        NSData *jsonDataAddFriends = [NSJSONSerialization dataWithJSONObject:arrayAddFriends
                                                                     options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonStringAddFriends = [[NSString alloc] initWithData:jsonDataAddFriends encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
        [params setObject:jsonStringAddFriends forKey:@"friends"];
        
        [PGFriends addFriendsWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
         {
           
             
             if (success)
             {
                 [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"Friend request sent successfully." preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                if (![_otp isEqualToString:@"otp"]){
                                                                    
                                                                    _otp = @"";
                                                                    
                                                                    [self.navigationController popViewControllerAnimated:true];
                                                                    
                                                                    
                                                                    
                                                                }else{
                                                                    dispatch_async(dispatch_get_main_queue(), ^(void)
                                                                                   {
                                                                                       
                                                                                       _otp = @"";
                                                                                       
                                                                                       
                                                                                       UINavigationController *homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainNav"];
                                                                                       [UIApplication sharedApplication].keyWindow.rootViewController = homeVC;
                                                                                   });
                                                                    
                                                                    
                                                                    
                                                                    
                                                                    
                                                                }
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

@end
