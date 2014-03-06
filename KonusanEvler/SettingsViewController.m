//
//  SettingsViewController.m
//  Polls
//
//  Created by Hadi Hatunoglu on 05/02/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import "SettingsViewController.h"
#import "ViewController.h"
#import "DBCOnnectClass.h"

@interface SettingsViewController ()
{
    UIImageView *imageView;
}
@end

@implementation SettingsViewController

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
    // Do any additional setup after loading the view from its nib.
    
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    //[def setBool:NO forKey:@"first"];
    
    _forFirsttime= [def boolForKey:@"first"];
    
    if (_forFirsttime ==NO) {
     
        UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
        self.navigationItem.leftBarButtonItem = back;
        
    }
}

-(void)backAction{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUrlTxtField:nil];
    //[self setSetUrl_action:nil];
    clearPollsButton = nil;
    [super viewDidUnload];
}
- (IBAction)ClearPolls_Action:(id)sender {
    
    DBCOnnectClass *db=[[DBCOnnectClass alloc]init];
    [db deletePolls];
    [db deleteQuestions];
    [db deleteOptions];
    [db deleteAnswers];
//    ViewController *vc=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
//    [self presentViewController:vc animated:YES completion:nil];
    
    imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIImage *image = [UIImage imageNamed:@"Default.png"];
    if (!image) {
        NSLog(@"Something went wrong trying to get the UIImage. Check filenames");
    }
    imageView.image = image;
    [self.view addSubview:imageView];
    self.navigationController.navigationBarHidden=YES;
    [self performSelector:@selector(removeImage) withObject:self afterDelay:2.0];
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:@"cleared" forKey:@"clearclicked"];
    [def synchronize];
    

}

-(void)removeImage
{
    [imageView removeFromSuperview];
    //self.navigationController.navigationBarHidden=NO;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
//    if (_urlTxtField.text.length==0) {
//        
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"URL" message:@"Please Enter Url" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//        [alert show];
//    }else{
//        
//        NSLog(@"text field text %@",_urlTxtField.text);
//        
//        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//        [defaults setObject:_urlTxtField.text forKey:@"mainpath"];
//        [defaults synchronize];
//    }
//    
    
    
    return YES;
}

- (IBAction)SetUrl_Action:(id)sender {
    
    [_urlTxtField resignFirstResponder];
    
    if (_urlTxtField.text.length==0) {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"URL" message:@"Please Enter Url" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }else{
        
        NSLog(@"text field text %@",_urlTxtField.text);
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *mainpathStr=_urlTxtField.text;
        [defaults setObject:mainpathStr forKey:@"mainpath"];
        //[defaults setValue:_urlTxtField.text forKey:@"mainpath"];
        [defaults synchronize];
        
        _forFirsttime=[defaults boolForKey:@"first"];
        
        if (_forFirsttime) {
            
            [clearPollsButton setHidden:YES];
            
            _forFirsttime=NO;
            [defaults setBool:_forFirsttime forKey:@"first"];
            [defaults synchronize];
            

            
            ViewController *vc=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
            [self presentViewController:vc animated:NO completion:nil];
        }else{

            [clearPollsButton setHidden:NO];
            
            ViewController *vc=[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil];
            [self presentViewController:vc animated:NO completion:nil];
//            _forFirsttime=NO;
//            [defaults setBool:_forFirsttime forKey:@"first"];
//            [defaults synchronize];
        
            [defaults setObject:_urlTxtField.text forKey:@"mainpath"];
            [defaults synchronize];
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"URL" message:@"Url has been set" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];

            
        }
    }
    

}
@end
