//
//  ViewController.h
//  ananthuInappTest
//
//  Created by Monish M S on 20/06/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import "PGUser.h"
#import <FVCustomAlertView/FVCustomAlertView.h>

@interface PaymentViewController : UIViewController<
SKProductsRequestDelegate,SKPaymentTransactionObserver,SKStoreProductViewControllerDelegate>{
    SKProductsRequest *productsRequest;
    NSArray *validProducts;
      PGUser *newUser;
    
    IBOutlet UITextField *promotextFd;
    IBOutlet UILabel *productPriceLabel;
    IBOutlet UIButton *purchaseButton;

}

- (void)fetchAvailableProducts;
- (BOOL)canMakePurchases;
- (void)purchaseMyProduct:(SKProduct*)product;
- (IBAction)purchase:(id)sender;

@end

