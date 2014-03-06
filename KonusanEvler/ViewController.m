//
//  ViewController.m
//  KonusanEvler
//
//  Created by Hadi Hatunoglu on 13/06/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HUD.h"
#import "HeaderFiles.h"

@interface ViewController (){
    ASIHTTPRequest *req;
    NSString *mainPath;
    NSString *userId;
    NSUserDefaults *defaults;
}

@end


CGFloat animatedDistance;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib. incredibles2
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:(CGFloat)68/(CGFloat)255 green:(CGFloat)81/(CGFloat)255 blue:(CGFloat)143/(CGFloat)255 alpha:1.0]CGColor], (id)[[UIColor colorWithRed:(CGFloat)83/(CGFloat)255 green:(CGFloat)97/(CGFloat)255 blue:(CGFloat)166/(CGFloat)255 alpha:1.0]CGColor], nil];
    gradient.geometryFlipped = YES;
    [self.view.layer insertSublayer:gradient atIndex:0];
   
    defaults=[NSUserDefaults standardUserDefaults];
    NSString *mainpathStr = [NSString stringWithFormat:@"http://eksen2.sbtanaliz.com:8084"];    //http://eksen2.sbtanaliz.com:8084 //http://192.168.2.21:8082
    [defaults setObject:mainpathStr forKey:@"mainpath"];    //    183.82.2.227:8080
    [defaults synchronize];
   
}


//check internet connection
- (IBAction)Submit_Clicked:(id)sender {
    [self ActivateClicked_action];
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}


- (void)ActivateClicked_action {
        
    [errorLabel setHidden:YES];
    mainPath=[defaults objectForKey:@"mainpath"];
    
    if (![self connected]) {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Lütfen internet bağlantınızı kontrol ediniz" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else{
        if ([self.activationTextFld.text isEqualToString:@""]) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Activation" message:@"Enter Activation Code" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }else{
        
        [HUD showUIBlockingIndicator];
        
        NSString *urlstr=[NSString stringWithFormat:@"%@/%@/%@",mainPath,kactivationurl,_activationTextFld.text];
        
        NSLog(@"url str is *********** \n%@\n",urlstr);
        NSURL *url=[NSURL URLWithString:urlstr];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                                 (unsigned long)NULL), ^(void) {
            req=[[ASIHTTPRequest alloc]initWithURL:url];
            [req addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
            [req setDelegate:self];
            [req setDidFinishSelector:@selector(UploadRequestFinished:)];
            [req startSynchronous];
            
        });
        }
        
    }
    
}

-(void)UploadRequestFinished:(ASIHTTPRequest *)response{
    
    [self performSelector:@selector(stopAnim) withObject:nil afterDelay:0.f];
    
     userId=[[response responseString] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    NSLog(@"%d",[userId intValue]);
    
            if (![userId intValue]==0) {
            [errorLabel setHidden:YES];
            [defaults setObject:[NSNumber numberWithInt:[userId intValue]] forKey:@"userId"];
            [defaults synchronize];
            
            
            [self sendDeviceId];
            
            HomeViewController *hvc=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
            [self presentViewController:hvc animated:NO completion:nil];
            
        }else{
            [errorLabel setHidden:NO];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Activation Failed" message:@"Invalid Code \n Enter Proper Code " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
        }
    
    
    self.activationTextFld.text=@"";
    
    
}

-(void)sendDeviceId{
    
    NSString *deviceToken=[defaults objectForKey:@"token"];
    // NSString *urlstr=[NSString stringWithFormat:@"http://%@/KonusanEvlers/rest/application/call/%@/%@?regid=%@",mainPath,activationCode,[NSString stringWithFormat:@"Iphone"],deviceToken];
    
    NSString *urlstr=[NSString stringWithFormat:@"%@/%@/%@/%@?%@",mainPath,kRegIdTypeOs,userId,[NSString stringWithFormat:@"1"],[NSString stringWithFormat:@"regID=%@",deviceToken]];
    
    NSURL *url=[NSURL URLWithString:urlstr];
    req=[[ASIHTTPRequest alloc]initWithURL:url];
    [req addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [req setDelegate:self];
    [req setDidFinishSelector:@selector(UploadRequestFinished2:)];
    [req startSynchronous];
    
}

-(void)UploadRequestFinished2:(ASIHTTPRequest *)response{
    
    NSLog(@"response string is %@",[response responseString]);
    
}

-(void)stopAnim{
    
    [HUD hideUIBlockingIndicator];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    self.activationTextFld.text=@"";
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --textfield Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    //[self ActivateClicked_action];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
    
    
	CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
	
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
	
	if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
	
	animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
	
	CGRect viewFrame = self.view.frame;
	viewFrame.origin.y -= animatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
	CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
	[UIView commitAnimations];
    
}


- (void)viewDidUnload {
    [self setActivationTextFld:nil];
    [super viewDidUnload];
}
@end
