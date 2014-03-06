//
//  GiftViewController.h
//  KonusanEvler
//
//  Created by Hadi Hatunoglu on 15/06/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate>{
    
    __weak IBOutlet UIButton *privousButton;
    __weak IBOutlet UIButton *nextButton;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//@property (weak, nonatomic) IBOutlet UIButton *clicked;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)Clicked:(id)sender;
@end
