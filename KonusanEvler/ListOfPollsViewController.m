//
//  ListOfPollsViewController.m
//  Polls
//
//  Created by Hadi Hatunoglu on 31/01/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import "ListOfPollsViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "PollsClass.h"
#import "PollQuesnsViewController.h"
#import "SVPullToRefresh.h"
#import "HUD.h"
#import "DBCOnnectClass.h"
#import "HeaderFiles.h"
#import <dispatch/dispatch.h>
#import <QuartzCore/QuartzCore.h>

@interface ListOfPollsViewController (){
    
     NSMutableArray *pollArray;
     DBCOnnectClass *db;
     NSString *mainpath;
     PollsClass *pollclass;
     NSUserDefaults *defaults;
     BOOL isPullToRefresh;
}


@end

@implementation ListOfPollsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
//        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.frame = self.view.bounds;
//        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:(CGFloat)68/(CGFloat)255 green:(CGFloat)81/(CGFloat)255 blue:(CGFloat)143/(CGFloat)255 alpha:1.0]CGColor], (id)[[UIColor colorWithRed:(CGFloat)83/(CGFloat)255 green:(CGFloat)97/(CGFloat)255 blue:(CGFloat)166/(CGFloat)255 alpha:1.0]CGColor], nil];
//        gradient.geometryFlipped = YES;
//        [self.view.layer insertSublayer:gradient atIndex:0];

    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Anketlerim";
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)83/(CGFloat)255 green:(CGFloat)97/(CGFloat)255 blue:(CGFloat)166/(CGFloat)255 alpha:1.0];
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
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
   
    // Do any additional setup after loading the view from its nib.
    isPullToRefresh =NO;
    db=[[DBCOnnectClass alloc]init];
    pollArray=[[NSMutableArray alloc]init];
    defaults=[NSUserDefaults standardUserDefaults];
    mainpath=[defaults valueForKey:@"mainpath"];
 
    NSString *query=[NSString stringWithFormat:@"select * from pollsTable"];
    NSArray *checkForPolls=[db getPollsFromDatabase:query];
    NSLog(@"array count is %d",checkForPolls.count);
    if (checkForPolls.count==0) {
        [self sendingRequestForPolls];
    }else{
        pollArray = (NSMutableArray *)checkForPolls;
        //[self checkForExpireDates];
    }


    __weak ListOfPollsViewController *weakSelf = self;
    [self.tableview addPullToRefreshWithActionHandler:^{
        isPullToRefresh=YES;
        [weakSelf sendingRequestForPolls];
    }];
   
}

-(void)checkForExpireDates{
    
    NSMutableIndexSet *indexesToDelete = [NSMutableIndexSet indexSet];
    for (int i=0; i<pollArray.count; i++) {
        pollclass =[pollArray objectAtIndex:i];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.z"];
        NSDate *date=[dateFormatter dateFromString:pollclass.surveyExpiredate];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *expireDate=[dateFormatter dateFromString:[dateFormatter stringFromDate:date]];
        NSString *str=[dateFormatter stringFromDate:[NSDate date]];
        NSDate *currentDate=[dateFormatter dateFromString:str];
        
        if ([expireDate compare:currentDate]==NSOrderedDescending) {
            [db deleteParticularPoll:pollclass.surveyId];
            [indexesToDelete addIndex:i];
        }
        
    }
    [pollArray removeObjectsAtIndexes:indexesToDelete];
}

-(void)viewWillAppear:(BOOL)animated{
    
    BOOL pollToDelete = [defaults boolForKey:@"pollDelete"];
    if (pollToDelete==YES) {
        
    
    NSString *query =[NSString stringWithFormat:@"select * from PollsTable"];
    NSArray *polArray =[db getPollsFromDatabase:query];
    pollArray = (NSMutableArray *)polArray;
    [self.tableview reloadData];
    }
    
}



-(void)sendingRequestForPolls
{
                
        if (![self connected]) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Lütfen internet bağlantınızı kontrol ediniz" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
        }else{
           
            if (pollArray.count!=0) {
                
                [pollArray removeAllObjects];
                pollArray=[[NSMutableArray alloc]init];
            }

            NSLog(@"user is is %@",[defaults objectForKey:@"userId"]);
            NSNumber *uid=[defaults objectForKey:@"userId"];
            
            NSString *urlstr=[NSString stringWithFormat:@"%@/%@/%@",mainpath,kpollsUrl,uid];
            NSURL *url=[NSURL URLWithString:urlstr];
            
            
            __block __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            [request setCompletionBlock:^{
                
                NSError *error;
                NSArray *arr=[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:&error];
                
                NSLog(@"array is %@",arr);
                if (isPullToRefresh&& arr.count==0) {
                    //[db deletePolls];
                }
                [pollArray removeAllObjects];
                for (int i=0; i<arr.count; i++) {
                    
                    PollsClass *polls=[[PollsClass alloc]init];
                    polls.surveyId=[[arr objectAtIndex:i] valueForKey:@"id"];
                    polls.surveyTopic=[[arr objectAtIndex:i] valueForKey:@"surveyTopic"];
                    polls.surveyDefination=[[arr objectAtIndex:i] valueForKey:@"surveyDefinition"];
                    polls.surveyStrtdate=[[arr objectAtIndex:i] valueForKey:@"startDate"];
                    polls.surveyExpiredate=[[arr objectAtIndex:i] valueForKey:@"endDate"];
                    ;
                    polls.surveyPoints=[[arr objectAtIndex:i] valueForKey:@"surveyPoints"];
                    
                    [pollArray addObject:polls];
                    
                    NSString *query=[NSString stringWithFormat:@"select * from pollsTable where survey_Id='%@'",polls.surveyId];
                    NSArray *arr=[db getPollsFromDatabase:query];
                    
                    if (arr.count==0) {
                        
                        [db insertPolls:polls];
                        
                            }
                    
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"load" object:self];
                
            }];
            [request setFailedBlock:^{
                NSError *error = [request error];
                NSLog(@"Error : %@", error.localizedDescription);
            }];
            [request startAsynchronous];
            
        }
    
    if (isPullToRefresh) {
        __weak ListOfPollsViewController *weakSelf = self;
        int64_t delayInSeconds = 4.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self.tableview reloadData];
            [weakSelf.tableview.pullToRefreshView stopAnimating];
        });

    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageUpdated:) name:@"load" object:nil];
}




-(void)backAction{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

//check internet connection
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}


- (void)imageUpdated:(NSNotification *)notif {
    
    __weak ListOfPollsViewController *weakSelf = self;
    //[self checkForExpireDates];
    
    NSString *query=[NSString stringWithFormat:@"select * from pollsTable"];
    NSArray *checkForPolls=[db getPollsFromDatabase:query];
    pollArray=(NSMutableArray *)checkForPolls;
    [self performSelector:@selector(stopAnim) withObject:nil afterDelay:0.5f];
    [self.tableview reloadData];
    [weakSelf.tableview.pullToRefreshView stopAnimating];
}




#pragma - tableview methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"array count %d",pollArray.count);
    return pollArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:PlaceholderCellIdentifier] ;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tableCellBar.png"]]];
    UILabel *rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(245, 5, 70, 31)];
    rightLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"points.png"]];
    rightLabel.textColor=[UIColor blackColor];
    rightLabel.textColor = [UIColor whiteColor];
    rightLabel.textAlignment=NSTextAlignmentCenter;
    [cell.contentView addSubview:rightLabel];
    //cell.imageView.image = [UIImage imageNamed:@"tableCellBar.png"];
    
    pollclass=(PollsClass *)[pollArray objectAtIndex:indexPath.row];
    cell.textLabel.text=pollclass.surveyTopic;
    cell.textLabel.textColor = [UIColor whiteColor];
    NSString *str=[NSString stringWithFormat:@"Expire Date: %@",pollclass.surveyExpiredate];
    cell.detailTextLabel.text=str;
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    NSLog(@"shkhsdjdsc %@",pollclass.surveyTopic);
    rightLabel.text=[NSString stringWithFormat:@"%@ Puan",pollclass.surveyPoints];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    pollclass=(PollsClass *)[pollArray objectAtIndex:indexPath.row];
    
    PollQuesnsViewController *pvc=[[PollQuesnsViewController alloc]initWithNibName:@"PollQuesnsViewController" bundle:nil];
    pvc.pollId=pollclass.surveyId;
    [self.navigationController pushViewController:pvc animated:NO];
    
    
}

-(void)stopAnim{
    
    //[HUD hideUIBlockingIndicator];
}

//-(void)loadPollsPullToRefresh{
//
//
//    if (![self connected]) {
//
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Connection Failure" message:@"You are not Connected To Internet.Check Your Internet Connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//
//    }else{
//
//            NSLog(@"user is is %@",[defaults objectForKey:@"userId"]);
//            NSNumber *uid=[defaults objectForKey:@"userId"];
//
//            NSString *urlstr=[NSString stringWithFormat:@"%@/%@/%@",mainpath,kpollsUrl,uid];
//            NSURL *url=[NSURL URLWithString:urlstr];
//
//
//            __block __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//            [request setCompletionBlock:^{
//
//                NSLog(@"complition block");
//
//                __weak ListOfPollsViewController *weakSelf = self;
//                //                [weakSelf.tableview.pullToRefreshView stopAnimating];
//                int64_t delayInSeconds = 4.0;
//                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//
//
//                    [weakSelf.tableview.pullToRefreshView stopAnimating];
//                });
//
//
//                NSError *error;
//                NSArray *arr=[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:&error];
//
//                if (!arr.count==0) {
//                    [db deletePolls];
//                }
//                [pollArray removeAllObjects];
//                pollArray = [[NSMutableArray alloc]init];
//                for (int i=0; i<arr.count; i++) {
//
//                    PollsClass *polls=[[PollsClass alloc]init];
//                    polls.surveyId=[[arr objectAtIndex:i] valueForKey:@"ID"];
//                    polls.surveyTopic=[[arr objectAtIndex:i] valueForKey:@"surveyTopic"];
//                    polls.surveyDefination=[[arr objectAtIndex:i] valueForKey:@"surveyDefinition"];
//                    polls.surveyStrtdate=[[arr objectAtIndex:i] valueForKey:@"startDate"];
//                    polls.surveyExpiredate=[[arr objectAtIndex:i] valueForKey:@"endDate"];
//                    polls.surveyPoints=[[arr objectAtIndex:i] valueForKey:@"surveyPoints"];
//
//                    [pollArray addObject:polls];
//
//
//                    NSString *query=[NSString stringWithFormat:@"select * from pollsTable where survey_Id='%@'",polls.surveyId];
//                    NSArray *arr=[db getPollsFromDatabase:query];
//
//                    if (arr.count==0) {
//
//                        [db insertPolls:polls];
//
//                    }
//
//                }
//
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"load" object:self];
//
//            }];
//            [request setFailedBlock:^{
//                NSError *error = [request error];
//                NSLog(@"Error downloading zip file: %@", error.localizedDescription);
//            }];
//            [request startAsynchronous];
//
//       }
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageUpdated:) name:@"load" object:nil];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
