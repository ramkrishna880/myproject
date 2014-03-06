//
//  SettingsViewController.h
//  Polls
//
//  Created by Hadi Hatunoglu on 05/02/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    
    
    IBOutlet UIButton *clearPollsButton;
}

@property (strong, nonatomic) IBOutlet UITextField *urlTxtField;
- (IBAction)ClearPolls_Action:(id)sender;
//@property (strong, nonatomic) IBOutlet UIButton *SetUrl_action;
- (IBAction)SetUrl_Action:(id)sender;
@property(nonatomic,assign)BOOL forFirsttime;
@end
