//
//  ChatListViewController.m
//  Ping
//
//  Created by Monish M S on 19/03/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatlistTableViewCell.h"
#import <FVCustomAlertView/FVCustomAlertView.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "PGChat.h"
#import "AppDelegate.h"
#import "UIBarButtonItem+Badge.h"


@interface ChatListViewController ()
{
    NSMutableArray *arrayChatsList;
    UIButton *button1;
    AppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UIButton *notifyBtn;


@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    arrayChatsList    = [[NSMutableArray alloc]init];
    
   
    
    
    UIImage *image = [UIImage imageNamed:@"notification"];
  button1 = [UIButton buttonWithType:UIButtonTypeCustom];
   [button1 setFrame:CGRectMake(0, 0, 34, 34)];
    [button1 addTarget:self action:@selector(notificationViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setBackgroundImage:image forState:UIControlStateNormal];
    
    // Make BarButton Item
    UIBarButtonItem *navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = navLeftButton;
   

    _chatsTableVIew.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(chatNotification:) name:@"chatAction" object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(badgeNotification:) name:@"badgeAction" object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(tabNotification:) name:@"tabHidden" object:nil];
}
-(void)tabNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"tabHidden"])
    {
  self.tabBarController.tabBar.hidden= NO;
    }
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
   //[self fetchChatList];
    }
}

-(void)chatNotification:(NSNotification*)notification
{
    
    NSMutableArray *controllers = [self.navigationController.viewControllers mutableCopy];
    
    UIViewController * controllerTest = [controllers lastObject];
    
    if([controllerTest isKindOfClass:[ChatListViewController class]]){
    }else{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }

    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Pushchat_id"] != nil)
    {
        DemoMessagesViewController *vc = [DemoMessagesViewController messagesViewController];
        vc.chatIdVc = [[NSUserDefaults standardUserDefaults]valueForKey:@"Pushchat_id"];
        [self.navigationController pushViewController:vc animated:NO];
    }else {
        [self fetchChatList];
    }
    
    
   
}
- (IBAction)notificationViewAction:(id)sender
{

    NotificationViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    [self.navigationController pushViewController:profileVC animated:true];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    appDelegate.indexValue = 5;
    self.navigationItem.rightBarButtonItem.badgeValue = appDelegate.badgeValue;
   self.tabBarItem.badgeValue = nil;
self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor colorWithRed:203.0/255.0 green:84.0/255.0 blue:124.0/255.0 alpha:1.0];
    
    
   
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Pushchat_id"] != nil)
    {
        DemoMessagesViewController *vc = [DemoMessagesViewController messagesViewController];
        vc.chatIdVc = [[NSUserDefaults standardUserDefaults]valueForKey:@"Pushchat_id"];
        [self.navigationController pushViewController:vc animated:NO];
    }else {
        [self fetchChatList];
    }
    
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
        
        
        [picImageView sd_setImageWithURL:url
                        placeholderImage:nil
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   if (error) {
                                       
                                       picImageView.image = [UIImage imageNamed:@"UserProfile"];
                                   }
                               }];
        
       // [picImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"UserProfile"] options:SDWebImageRefreshCached];
    }
    [button addSubview:picImageView];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    self.tabBarController.tabBar.hidden= NO;
}


- (IBAction)profileViewAction:(id)sender
{
    
    PGProfileTableViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PGProfileTableViewController"];
    profileVC.passString = nil;
    [self.navigationController pushViewController:profileVC animated:true];
    
}
-(void)fetchChatList
{
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
    
    [PGChat callChatList:params withCompletionBlock:^(bool success, id result, NSError *error)
     {
         
        self.tabBarController.tabBar.userInteractionEnabled = YES;
         if (success)
         {
             
             [arrayChatsList removeAllObjects];
             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
        
             arrayChatsList = [[result valueForKey:@"data"]mutableCopy];
              [self.chatsTableVIew reloadData];
             if (arrayChatsList.count>0){
                 NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                 [self.chatsTableVIew scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
             }
           
            
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
      return 70;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    
    if (arrayChatsList.count>0) {
     
        
        CGRect newFrame = CGRectMake( tableView.frame.origin.x, tableView.frame.origin.y, 0, 0);
        
        self.noChatimageView.frame = newFrame;
        _noChatimageView.hidden = YES;
         tableView.scrollEnabled = YES;
        return arrayChatsList.count;
        
        
        
    }
    else{
        
        
      
        
            tableView.scrollEnabled = NO;
       
     
        
        
        
        self.noChatimageView.frame = tableView.frame;
        _noChatimageView.hidden = false;
        
        
        
        
        
        
         return 0 ;
        
    }
    
    
    
    
    

    }

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        ChatlistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatlistCell" forIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[ChatlistTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ChatlistCell"];
        }
    
    cell.chatUserName.text =[[arrayChatsList valueForKey:@"name"] objectAtIndex:indexPath.row];
    
    if([[NSString stringWithFormat:@"%@",[[arrayChatsList valueForKey:@"unread"] objectAtIndex:indexPath.row]] isEqualToString:@"0"]){
        cell.chatCount.hidden = TRUE;
    }else{
        cell.chatCount.hidden = false;
        cell.chatCount.text =[NSString stringWithFormat:@"%@",[[arrayChatsList valueForKey:@"unread"] objectAtIndex:indexPath.row]];
    }

    cell.vwAvatarView.hidden = YES;
     cell.chatImage.hidden = YES;
    cell.memberOverCount.hidden = YES;
    
    
    NSArray *arr = [[arrayChatsList valueForKey:@"avthar"] objectAtIndex:indexPath.row];
    if (arr.count>1) {
        
        cell.vwAvatarView.hidden = NO;
       
        [cell setChatByCall:arr];
    }else{
        
        NSString *urlString = arr[0] ;
        NSURL *url = [NSURL URLWithString:urlString];
       cell.chatImage.hidden = NO;
        
        
        [cell.chatImage sd_setImageWithURL:url
                                  placeholderImage:nil
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                             if (error) {
                                                 
                                                 cell.chatImage.image = [UIImage imageNamed:@"UserProfile"];
                                             }
                                         }];
        
      //  [cell.chatImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Userimage"] options:SDWebImageRefreshCached];
        
    }
    
        return cell;
   
   
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemoMessagesViewController *vc = [DemoMessagesViewController messagesViewController];
    vc.chatIdVc = [[arrayChatsList valueForKey:@"chat_id"] objectAtIndex:indexPath.row];
    vc.titleName = [[arrayChatsList valueForKey:@"name"] objectAtIndex:indexPath.row];
     [self.navigationController pushViewController:vc animated:YES];
}


@end
