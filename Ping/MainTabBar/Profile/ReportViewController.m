//
//  ReportViewController.m
//  Ping
//
//  Created by Monish M S on 16/08/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController  ()<KPDropMenuDelegate>

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _drop.items = @[@"Spamming", @"Abusive Content", @"Nudity", @"Graphic Violence", @"Fake Account", @"Intellectual Property Violation"];
    _drop.itemsFont = [UIFont fontWithName:@"Helvetica-Regular" size:12.0];
    _drop.titleTextAlignment = NSTextAlignmentLeft;
    _drop.delegate = self;
    self.title = @"Report";
    reportType = @"";
    _commentView.layer.cornerRadius = 5;
    _commentView.layer.masksToBounds = true;
    _comments.textColor = [UIColor lightGrayColor];
    _comments.text = @"Comments";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)didSelectItem : (KPDropMenu *) dropMenu atIndex : (int) atIntedex{
    if(dropMenu == _drop)
reportType = dropMenu.items[atIntedex];
 
}



-(void)textViewDidBeginEditing:(UITextView *)textView{
    

    if( [textView.text isEqualToString:@"Comments"] && [textView.textColor isEqual:[UIColor lightGrayColor]] ){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{


    
    
    if(textView.text.length == 0){
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"Comments";
    }
    
    
    
  
}

- (IBAction)addFriendAction:(id)sender
{
    
    if (![reportType isEqualToString:@""]) {
    
        if( [_comments.text isEqualToString:@"Comments"] && [_comments.textColor isEqual:[UIColor lightGrayColor]] ){
            _comments.text = @"";
            
        }
        
        [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
                                            
                                            
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
                                            [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
                                            [params setObject:[_passString valueForKey:@"number"] forKey:@"friendNumber"];
        
        [params setObject:reportType forKey:@"report_type"];
        [params setObject:_comments.text forKey:@"comments"];
        
        
                                            
    [PGFriends reportFriendsWithDetails:params withCompletionBlock:^(bool success, id result, NSError *error)
                                             {
                                                 
                                                 
                                                 if (success)
                                                 {
                                                     [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
                                                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"Friend Reported Successfully." preferredStyle:UIAlertControllerStyleAlert];
                                                     UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                                                    dispatch_async(dispatch_get_main_queue(), ^(void)
                                                                                                                   {
                                                                                                                       
id<ChildViewControllerDelegate> strongDelegate = self.delegate;
                                                                                                                       [strongDelegate childViewControllerFlagChange];
                                                                                                                       
                                                                                                                       
                                                                                                                       
     [self.navigationController popViewControllerAnimated:YES];
    
                                                                                                                       
                                                                                                                       
                                                                                                                   });
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
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:[NSString stringWithFormat:@"%@",@"Please select a report type."] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


@end
