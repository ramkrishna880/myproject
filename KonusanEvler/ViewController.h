//
//  ViewController.h
//  KonusanEvler
//
//  Created by Hadi Hatunoglu on 13/06/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
{
       IBOutlet UILabel *errorLabel;
}
@property (strong, nonatomic) IBOutlet UITextField *activationTextFld;
- (IBAction)Submit_Clicked:(id)sender;
- (BOOL)connected ;
@end
