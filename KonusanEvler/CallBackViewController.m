//
//  CallBackViewController.m
//  KonusanEvler
//
//  Created by Hadi Hatunoglu on 15/06/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import "CallBackViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "HeaderFiles.h"
#import "HUD.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface CallBackViewController ()
{
    NSArray *strings;
    NSMutableArray *checkButtons;
    NSUserDefaults *defaults;
    NSString *mainpath;
    NSString *ticketType,*requestDetails;
    NSUInteger tag;
    //__weak IBOutlet UILabel *falseLbl;
    __weak IBOutlet UILabel *submitLabel;
}
@end

float height=40;
float length= 306;
float y=10;



CGFloat animatedDistance;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;

@implementation CallBackViewController

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
    self.title=@"Beni Ara";
    
    defaults=[NSUserDefaults standardUserDefaults];
    mainpath=[defaults valueForKey:@"mainpath"];
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)83/(CGFloat)255 green:(CGFloat)97/(CGFloat)255 blue:(CGFloat)166/(CGFloat)255 alpha:1.0];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0)
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    //falseLbl.hidden=YES;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 80, 30);
    [backButton setBackgroundImage:[UIImage imageNamed:@"navbarbutton.png"] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    [backButton setTitle:@"Ana Menü" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(BackAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    strings =[[NSArray alloc]initWithObjects:@"Bilgi Güncelleme",@"Arıza Bildirimi",@"Eğitim İsteği",@"Bilgilendirme",@"Hediye İsteği",@"Anket Çıkış İsteği",@"Diğer",nil];
    checkButtons=[[NSMutableArray alloc]init];
    
    [self createcheckBox];
    
    
}


-(void)createcheckBox{
    
    for (int i=0; i<7; i++) {
        
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(5, y, length, height);
        button.tag=i;
        [button setTitle:[strings objectAtIndex:i] forState:UIControlStateNormal];
        button.titleLabel.numberOfLines=0;
        [button setBackgroundImage:[UIImage imageNamed:@"optionblue.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
        [self.view addSubview:button];
        
        UIButton *checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
        checkBox.frame = CGRectMake(3, 2, 35, 35);
        checkBox.tag =i;
        [checkBox addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [checkBox setBackgroundImage:[UIImage imageNamed:@"uncheckSingle.png"] forState:UIControlStateNormal];
        [checkButtons addObject:checkBox];
        [button addSubview:checkBox];
        
        y=y+height;
    }
    
    _customText =[[UITextField alloc]initWithFrame:CGRectMake(28, y+8, 264, 30)];
    [_customText setDelegate:self];
    [_customText setTextAlignment:NSTextAlignmentCenter];
    [_customText setTextColor:[UIColor whiteColor]];
    [_customText setBorderStyle:UITextBorderStyleLine];
    [_customText setBackgroundColor:[UIColor clearColor]];
    [_customText setPlaceholder:@"Açıklama girin"];
    [_customText setHidden:YES];
    [_customText setTextColor:[UIColor whiteColor]];
    [self.view addSubview:_customText];
}

-(void)checkButtonClicked:(id)sender{
    UIButton *tapped=(id)sender;
    UIButton *button=[checkButtons objectAtIndex:tapped.tag];
    
    ticketType=[NSString stringWithFormat:@"%d",button.tag+1];
    for (UIButton *checkBox in checkButtons) {
        if (checkBox==button) {
            [checkBox setBackgroundImage:[UIImage imageNamed:@"checkSingle.png"] forState:UIControlStateNormal];
            
        }else{
            [checkBox setBackgroundImage:[UIImage imageNamed:@"uncheckSingle.png"] forState:UIControlStateNormal];
        }
    }
    tag=button.tag;
    if (button.tag==6) {
        [_customText setHidden:NO];
        requestDetails=_customText.text;
    }else{
        [_customText setHidden:YES];
        requestDetails=@"";
    }
}
-(void)BackAction{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

- (IBAction)submitClicked:(id)sender {
    [_customText resignFirstResponder];
    if (![self connected]) {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Lütfen internet bağlantınızı kontrol ediniz" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }else{
        if (([_customText.text length]==0) &&(tag==6)) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"" message:@"Lütfen açıklama metni girin" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else{
            NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *rawDate=[formatter stringFromDate:[NSDate date]];
            NSString *smartUserId =[defaults valueForKey:@"userId"];
            NSString *isOpen =[NSString stringWithFormat:@"1"];
            requestDetails=_customText.text;
            
            NSDictionary *class=[NSDictionary dictionaryWithObjects:@[ticketType,rawDate,smartUserId,requestDetails,isOpen] forKeys:@[@"ticketType",@"rowDate",@"requestBy",@"requestDetails",@"isOpen"]];
            NSLog(@"%@",class);
            NSData *jsonData=[NSJSONSerialization dataWithJSONObject:class options:NSJSONWritingPrettyPrinted error:nil];
            
            [HUD showUIBlockingIndicator];
            
            NSString *str=[NSString stringWithFormat:@"%@/%@",mainpath,ksubmitInBeneAra];
            
            NSURL *url=[NSURL URLWithString:str];
            ASIFormDataRequest *request=[[ASIFormDataRequest alloc]initWithURL:url];
            [request setRequestMethod:@"Post"];
            [request addRequestHeader:@"Content-Type" value:@"application/json"];
            [request appendPostData:jsonData];
            [request setDelegate:self];
            [request setDidFinishSelector:@selector(UploadRequestFinishedForAnswers:)];
            [request setDidFailSelector:@selector(uploadRequestFailed:)];
            [request startSynchronous];
        }
    }
    
    _customText.text=@"";
}

-(void)UploadRequestFinishedForAnswers:(ASIHTTPRequest *)response{
    NSLog(@" ********** %@",[response responseString]);
    
    [self performSelector:@selector(stopAnim) withObject:nil afterDelay:0.5f];
    if ([[response responseString] isEqualToString:@"true"]) {
        [submitLabel setText:@"Aranma talebiniz alımıştır"];
    }else{
        [submitLabel setText:@"Önceden açılmış bir isteğiniz mevcut halen"];
        
    }
    [self.view addSubview:_afterSubmitView];
}

-(void)uploadRequestFailed:(ASIHTTPRequest *)response{
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    height=40;
    length= 306;
    y=10;
    tag=0;
    [_customText setText:@""];
}

-(void)stopAnim{
    
    [HUD hideUIBlockingIndicator];
}

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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}
@end
