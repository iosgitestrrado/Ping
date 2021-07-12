//
//  PrivactTermsViewController.m
//  Ping
//
//  Created by Monish M S on 16/08/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "PrivactTermsViewController.h"

@interface PrivactTermsViewController ()

@end

@implementation PrivactTermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  NSURL *targetURL ;
      [self.navigationController setNavigationBarHidden:false];
    //Check if the web view is linked correctly from the XIB
    self.title = _passString;

    if ([_passString isEqualToString:@"Privacy Policy"]) {
         targetURL = [NSURL URLWithString:@"http://pingeffect.com/privacy.html"];
    }else{
         targetURL = [NSURL URLWithString:@"http://pingeffect.com/terms.html"];
    }
    
 
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [_webView loadRequest:request];
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:true];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
