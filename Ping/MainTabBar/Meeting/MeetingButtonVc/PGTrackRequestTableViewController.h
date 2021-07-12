//
//  PGTrackRequestTableViewController.h
//  Ping
//
//  Created by Softnotions Technologies Pvt Ltd on 2/12/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGTrackRequestTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray * trackRequestArray ;
}
-(IBAction)acceptTrackNotification:(id)sender;
-(IBAction)rejectTrackNotification:(id)sender;
@end
