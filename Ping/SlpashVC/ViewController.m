//
//  ViewController.m
//  RCPageControlExample
//
//  Created by Looping on 14/9/15.
//  Copyright (c) 2017 Looping. All rights reserved.
//

#import "ViewController.h"
#import "PGLoginTableViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    REPagedScrollView *scrollView = [[REPagedScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:scrollView];
    
    UIImageView *test = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [test setImage:[UIImage imageNamed:@"Intro1"]];
    test.backgroundColor = [UIColor lightGrayColor];
    [scrollView addPage:test];
    
    test = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [test setImage:[UIImage imageNamed:@"Intro2"]];
    test.backgroundColor = [UIColor blueColor];
    [scrollView addPage:test];
    
    test = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [test setImage:[UIImage imageNamed:@"Intro3"]];
    test.backgroundColor = [UIColor greenColor];
    [scrollView addPage:test];
    
    test = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [test setImage:[UIImage imageNamed:@"Intro4"]];
    test.backgroundColor = [UIColor redColor];
    [scrollView addPage:test];
    
    //[self.view bringSubviewToFront:_loginButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(loginInfoNotification:) name:@"loginInfo" object:nil];
}

-(void) loginInfoNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"loginInfo"])
    {
        PGLoginTableViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PGLoginTableViewController"];
        [self.navigationController pushViewController:loginVC animated:true];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
