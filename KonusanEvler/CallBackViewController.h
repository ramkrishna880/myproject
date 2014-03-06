//
//  CallBackViewController.h
//  KonusanEvler
//
//  Created by Hadi Hatunoglu on 15/06/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallBackViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *customText;
@property (strong, nonatomic) IBOutlet UIView *afterSubmitView;
- (IBAction)submitClicked:(id)sender;

@end
