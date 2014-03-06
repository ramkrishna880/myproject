//
//  PointsViewController.m
//  KonusanEvler
//
//  Created by Hadi Hatunoglu on 15/06/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import "PointsViewController.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "HeaderFiles.h"

@interface PointsViewController (){
    NSUserDefaults *defaults;
}

@end

@implementation PointsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Puanlarım";
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)83/(CGFloat)255 green:(CGFloat)97/(CGFloat)255 blue:(CGFloat)166/(CGFloat)255 alpha:1.0];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0)
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 80, 30);
    [backButton setBackgroundImage:[UIImage imageNamed:@"navbarbutton.png"] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [backButton setTitle:@"Ana Menü" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(BackAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    defaults =[NSUserDefaults standardUserDefaults];
    
    if (![self connected]) {
        [self.totalPoints setTitle:@"0 Puan" forState:UIControlStateNormal];
        [self.consumedPoints setTitle:@"0 Puan" forState:UIControlStateNormal];
        [self.earnedPoints setTitle:@"0 Puan" forState:UIControlStateNormal];
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failure" message:@"Check Your Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else{
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",[defaults objectForKey:@"mainpath"],kpanelList,[defaults objectForKey:@"userId"]]]];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(UploadRequestFinished:)];
        [request startSynchronous];
    }
    
    
}

-(void)UploadRequestFinished:(ASIHTTPRequest *)response{
    
    NSLog(@"%@",[response responseString]);
    NSError *error;
    
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:[response responseData] options:NSJSONReadingMutableLeaves error:&error];
    
    if ([[dic valueForKey:@"smartUserID"] intValue]==0) {
        [self.totalPoints setTitle:@"0 Puan" forState:UIControlStateNormal];
        [self.consumedPoints setTitle:@"0 Puan" forState:UIControlStateNormal];
        [self.earnedPoints setTitle:@"0 Puan" forState:UIControlStateNormal];

//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failure" message:@"Check Your Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
    }else{
        [self.totalPoints setTitle:[NSString stringWithFormat:@"%@ puan",[dic valueForKey:@"totalPoint"]] forState:UIControlStateNormal];
        [self.consumedPoints setTitle:[NSString stringWithFormat:@"%@ puan",[dic valueForKey:@"consumedPoint"]] forState:UIControlStateNormal];
        [self.earnedPoints setTitle:[NSString stringWithFormat:@"%@ puan",[dic valueForKey:@"earnedPoint"]] forState:UIControlStateNormal];
//        self.totalPoints.titleLabel.text = [NSString stringWithFormat:@"%@ puan",[dic valueForKey:@"totalPoint"]];
//        self.consumedPoints.titleLabel.text =[NSString stringWithFormat:@"%@ puan",[dic valueForKey:@"consumedPoint"]];
//        self.earnedPoints.titleLabel.text = [NSString stringWithFormat:@"%@ puan",[dic valueForKey:@"earnedPoint"]];
    }
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

-(void)BackAction{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
