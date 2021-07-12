//
//  ViewController.m
//  ananthuInappTest
//
//  Created by Monish M S on 20/06/18.
//  Copyright © 2018 Monish M S. All rights reserved.
//
#import "PaymentViewController.h"
#import <StoreKit/StoreKit.h>
#define kRemoveAdsProductIdentifier @"com.pingeffects.ping.pingplus"


@interface PaymentViewController ()<
SKProductsRequestDelegate,SKPaymentTransactionObserver>
@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Adding activity indicator
    [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
     self.tabBarController.tabBar.hidden = true;
    //Hide purchase button initially
    purchaseButton.hidden = YES;
    [self fetchAvailableProducts];
    self.title = @"Upgrade to Ping+";
    UITapGestureRecognizer *singleLogTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleLogTap:)];
    [self.view addGestureRecognizer:singleLogTap];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (void)handleSingleLogTap:(UITapGestureRecognizer *)recognizer
{
    [promotextFd resignFirstResponder];
    
}
- (IBAction)promoCodeAction:(id)sender
{
    @try {
        
        if (promotextFd.text.length>5) {
            
            [self pingPlusUpdation:promotextFd.text];
            
            
        }else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"PING" message:@"This promo code is invalid. Please check and try again." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        
        
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"NSException login page-------%@",exception);
    } @finally {
        
    }
    
        
        
        
 
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchAvailableProducts {
    
 
    
    
    
    if([SKPaymentQueue canMakePayments]){
        NSLog(@"User can make payments");
        
        //If you have more than one in-app purchase, and would like
        //to have the user purchase a different product, simply define
        //another function and replace kRemoveAdsProductIdentifier with
        //the identifier for the other product
        
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier]];
        productsRequest.delegate = self;
        [productsRequest start];
        
    }
    else{
        NSLog(@"User cannot make payments due to parental controls");
        //this is called the user cannot make payments, most likely due to parental controls
    }
    
    
    
    
    
    
    
}

- (BOOL)canMakePurchases {
    return [SKPaymentQueue canMakePayments];
}

- (void)purchaseMyProduct:(SKProduct*)product {
    if ([self canMakePurchases]) {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"Purchases are disabled in your device" message:nil delegate:
                                  self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
}
-(IBAction)purchase:(id)sender {
    
    if (![purchaseButton.titleLabel.text isEqualToString:@"PURCHASING"]) {
        
        if (![purchaseButton.titleLabel.text isEqualToString:@"PURCHASED SUCCESSFULLY"]){
        
        [self purchaseMyProduct:[validProducts objectAtIndex:0]];
        }
        
    }
    
    
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:(BOOL)animated];    // Call the super class implementation.
    // Usually calling super class implementation is done before self class implementation, but it's up to your application.
    
   [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
#pragma mark StoreKit Delegate

-(void)paymentQueue:(SKPaymentQueue *)queue
updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing");
               [ purchaseButton setTitle:@"PURCHASING" forState:UIControlStateNormal];
                
                
                break;
                
            case SKPaymentTransactionStatePurchased:
                if ([transaction.payment.productIdentifier
                     isEqualToString:kRemoveAdsProductIdentifier]) {
                    NSLog(@"Purchased ");
                     [ purchaseButton setTitle:@"PURCHASED SUCCESSFULLY" forState:UIControlStateNormal];
                    
                    [self pingPlusUpdation:@""];
                 
               
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"Restored ");
                [ purchaseButton setTitle:@"MAKE PAYMENT" forState:UIControlStateNormal];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred:
                NSLog(@"Restored ");
                [ purchaseButton setTitle:@"MAKE PAYMENT" forState:UIControlStateNormal];
                
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"Purchase failed ");
                [ purchaseButton setTitle:@"MAKE PAYMENT" forState:UIControlStateNormal];
                
               
                break;
            default:
                break;
            
        }
    }
}

-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response {
    SKProduct *validProduct = nil;
    int count = [response.products count];
    
    if (count>0) {
        validProducts = response.products;
        validProduct = [response.products objectAtIndex:0];
        
        if ([validProduct.productIdentifier
             isEqualToString:kRemoveAdsProductIdentifier]) {
            
            purchaseButton.hidden = NO;
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

            [numberFormatter setLocale:validProduct.priceLocale];
            
            NSString *priceString= [numberFormatter stringFromNumber:validProduct.price];
            
            
            
           /* [productTitleLabel setText:[NSString stringWithFormat:
                                        @"Product Title: %@",validProduct.localizedTitle]];
            [productDescriptionLabel setText:[NSString stringWithFormat:
                                              @"%@",validProduct.priceLocale]];
            [productPriceLabel setText:[NSString stringWithFormat:
                                        @"$ 4.86(%@)",priceString]];*/
        }
    } else {
        UIAlertView *tmp = [[UIAlertView alloc]
                            initWithTitle:@"Not Available"
                            message:@"No products to purchase"
                            delegate:self
                            cancelButtonTitle:nil
                            otherButtonTitles:@"Ok", nil];
        [tmp show];
    }
    
[FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
    
}

- (void)pingPlusUpdation:(NSString *)promocode {
    
    
    
    
    
    
    
    
    
            @try {
    
    
                        [FVCustomAlertView showDefaultLoadingAlertOnView:self.navigationController.view withTitle:@"Loading..." withBlur:NO allowTap:NO];
    
                        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
                       [params setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"user_id"];
                if (![promocode isEqualToString:@""]) {
                      [params setObject:promocode forKey:@"promo_code"];
                    
                }else{
                     [params setObject:@"" forKey:@"promo_code"];
                }
                
                
                
    
                        newUser = [[PGUser alloc]init];
    
    
                        [newUser upgradetoPingPlusWithuserid:params withCompletionBlock:^(BOOL success, id result, NSError *error)
    
    
    
                         {
                             [FVCustomAlertView hideAlertFromView:self.navigationController.view fading:true];
    
                             if (success)
                             {
    
                                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ping+"];
    
                                 [[UIApplication sharedApplication] setAlternateIconName:@"Icon2" completionHandler:^(NSError * _Nullable error) {
                                     NSLog(@"error = %@", error.localizedDescription);
                                 }];
    
                                 [self.navigationController    popViewControllerAnimated:YES];
    
    
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
            } @catch (NSException *exception) {
                NSLog(@"NSException login page-------%@",exception);
            } @finally {
    
            }
    
    
    
}



- (IBAction)showStoreView:(id)sender {
    
    SKStoreProductViewController *storeViewController =
    [[SKStoreProductViewController alloc] init];
    
    storeViewController.delegate = self;
    
    NSDictionary *parameters =
    @{SKStoreProductParameterITunesItemIdentifier:
          [NSNumber numberWithInteger:1413652722]};
    
    [storeViewController loadProductWithParameters:parameters
                                   completionBlock:^(BOOL result, NSError *error) {
                                       if (result)
                                           [self presentViewController:storeViewController
                                                              animated:YES
                                                            completion:nil];
                                   }];
    
}


-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
