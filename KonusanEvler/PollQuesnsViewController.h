//
//  PollQuesnsViewController.h
//  Polls
//
//  Created by Hadi Hatunoglu on 31/01/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBCOnnectClass.h"

#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>


@interface PollQuesnsViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>{
    
    NSMutableArray *quesArray;
    NSMutableArray *ansArray;
    UILabel *qnoLabel;
    UIButton *prevButton;
    UIButton *nextButton;
       
   IBOutlet UIView *submitView;
}
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *questionLabel;
@property(nonatomic,strong)NSString *pollId;

- (BOOL)connected ;
- (IBAction)submit_ClickedAction:(id)sender;
//- (IBAction)previousInSubmitScreen_Clicked:(id)sender;

@end
