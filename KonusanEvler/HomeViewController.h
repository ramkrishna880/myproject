//
//  HomeViewController.h
//  KonusanEvler
//
//  Created by Hadi Hatunoglu on 13/06/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController{
    
    IBOutlet UIButton *pollsymbol;
    IBOutlet UIButton *pollsBar;
    
    IBOutlet UIButton *phoneSymbol;
    IBOutlet UIButton *phoneBar;
    IBOutlet UIButton *pointsSymbol;
    IBOutlet UIButton *pointsBar;
    IBOutlet UIButton *giftSymbol;
    IBOutlet UIButton *giftBar;
}

- (IBAction)pollButton_clicked:(id)sender;
- (IBAction)phoneButton_clicked:(id)sender;
- (IBAction)pointsButton_Clicked:(id)sender;
- (IBAction)giftButton_Clicked:(id)sender;
@end
