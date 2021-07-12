//
//  PGMeetingTableViewController.h
//  Ping
//
//  Created by Monish M S on 27/11/17.
//  Copyright © 2017 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "DemoMessagesViewController.h"
@interface PGMeetingTableViewController : UITableViewController <SWTableViewCellDelegate,UICollectionViewDelegateFlowLayout>
{
    
    NSArray  *ArrImages;
    BOOL reloadOnly;
}
@end
