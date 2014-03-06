//
//  HomeViewController.m
//  KonusanEvler
//
//  Created by Hadi Hatunoglu on 13/06/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ListOfPollsViewController.h"
#import "CallBackViewController.h"
#import "PointsViewController.h"
#import "GiftViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.view.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:(CGFloat)68/(CGFloat)255 green:(CGFloat)81/(CGFloat)255 blue:(CGFloat)143/(CGFloat)255 alpha:1.0]CGColor], (id)[[UIColor colorWithRed:(CGFloat)83/(CGFloat)255 green:(CGFloat)97/(CGFloat)255 blue:(CGFloat)166/(CGFloat)255 alpha:1.0]CGColor], nil];
        gradient.geometryFlipped = YES;
        [self.view.layer insertSublayer:gradient atIndex:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pollButton_clicked:(id)sender {
    
    [UIView animateWithDuration:0.5
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         pollsBar.transform =CGAffineTransformMakeScale(1.2, 1.2); 
                         //pollsBar.frame = CGRectMake(100, 197, 180, 40);
                         pollsymbol.transform = CGAffineTransformMakeScale(1.2, 1.2);
                         
                     }
                     completion:^(BOOL finished){
                         pollsBar.transform =CGAffineTransformMakeScale(1.0, 1.0);
                         //pollsBar.frame = CGRectMake(100, 197, 180, 40);
                         pollsymbol.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                         [userDefault setBool:NO forKey:@"pollDelete"];
                         [userDefault synchronize];
                         ListOfPollsViewController *lvc = [[ListOfPollsViewController alloc]initWithNibName:@"ListOfPollsViewController" bundle:nil];
                         UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lvc];
                         [self presentViewController:nav animated:NO completion:nil];
                         
                     }];
    
    
   
    
}

- (IBAction)phoneButton_clicked:(id)sender {
    
    [UIView animateWithDuration:0.5
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         phoneBar.transform =CGAffineTransformMakeScale(1.2, 1.2);
                         phoneSymbol.transform = CGAffineTransformMakeScale(1.2, 1.2);
                         
                     }
                     completion:^(BOOL finished){
                         phoneBar.transform =CGAffineTransformMakeScale(1.0, 1.0);
                         phoneSymbol.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         CallBackViewController *cvc = [[CallBackViewController alloc] initWithNibName:@"CallBackViewController" bundle:nil];
                         UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cvc];
                         [self presentViewController:nav animated:NO completion:nil];
                         
                     }];

}

- (IBAction)pointsButton_Clicked:(id)sender {
    
    [UIView animateWithDuration:0.5
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         pointsBar.transform =CGAffineTransformMakeScale(1.2, 1.2);
                         pointsSymbol.transform = CGAffineTransformMakeScale(1.2, 1.2);
                         
                     }
                     completion:^(BOOL finished){
                         pointsBar.transform =CGAffineTransformMakeScale(1.0, 1.0);
                         pointsSymbol.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         PointsViewController *pvc = [[PointsViewController alloc] initWithNibName:@"PointsViewController" bundle:nil];
                         UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pvc];
                         [self presentViewController:nav animated:NO completion:nil];
                         
                     }];

}

- (IBAction)giftButton_Clicked:(id)sender {
    
    [UIView animateWithDuration:0.5
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         giftBar.transform =CGAffineTransformMakeScale(1.2, 1.2);
                         giftSymbol.transform = CGAffineTransformMakeScale(1.2, 1.2);
                         
                     }
                     completion:^(BOOL finished){
                         giftBar.transform =CGAffineTransformMakeScale(1.0, 1.0);
                         giftSymbol.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         GiftViewController *gvc = [[GiftViewController alloc] initWithNibName:@"GiftViewController" bundle:nil];
                         UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:gvc];
                         [self presentViewController:nav animated:NO completion:nil];
                         
                     }];

}
- (void)viewDidUnload {
   // [self setGiftBitton_clicked:nil];
    [super viewDidUnload];
}
@end
