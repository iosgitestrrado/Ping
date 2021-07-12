//
//  HelpViewController.m
//  Ping
//
//  Created by Monish M S on 08/06/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textDisplay;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([_passString isEqualToString:@"help"]) {
        self.title = @"Help";
        
        _textDisplay.text = @"";
        
        
        
    }else{
             self.title = @"About";
        _textDisplay.text = @"They say that time is precious. In fact, time is invaluable. And we measure it by moments.\nMostly, it’s the people we spent time with. Yet if we’re not careful, we let other people take our time. Once lost, It can never be regained So we decided to focus the way we use time, got together and created, Ping your social productivity assistant.\nAll of us are in control of our own time but trust us, when it involves other people, heh that’s where it gets crazy. First, we made spending time with one another much easier. From the moment we want to meet, to actually, meet.\nWe’ve made arranging for a perfect time, at a perfect place and with the people you want to meet, all within clicks.\n It helps us stay connected, by understanding what’s good for all of us, makes those connections, and keep us informed, so no more shocking changes. We’ve also striped down the waiting time, all the waiting time.\n\nOur story \n\n Ping becomes exceptionally helpful when someone is running late, needs to postpone, even to cancel altogether or simply, just forgets. After all, it goes back, reconnect the dots, and starts that instantaneous process of making yet another connection. Perfectly made for you and your loved ones, friends, colleagues and business meetings.\n Plus, we added a cooler way to discover new people around you. So they say, with great powers come great responsibility We then realized, what greater power, than putting more control of time, back in your hands.\n\nPing becomes exceptionally helpful when someone is running late, needs to postpone, even to cancel altogether or simply, just forgets. After all, it goes back, reconnect the dots, and starts that instantaneous process of making yet another connection. Perfectly made for you and your loved ones, friends, colleagues and business meetings.\n\nPlus, we added a cooler way to discover new people around you. So they say, with great powers come great responsibility We then realized, what greater power, than putting more controlof time, back in your hands.";

       
        }
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.textDisplay setScrollEnabled:true];
    });}


@end
