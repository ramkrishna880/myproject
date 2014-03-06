    //
//  PollQuesnsViewController.m
//  Polls
//
//  Created by Hadi Hatunoglu on 31/01/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import "PollQuesnsViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Questions.h"
#import "Options.h"
#import "HUD.h"
#import "UIImageView+ForScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import "HeaderFiles.h"

@interface PollQuesnsViewController (){
    
    NSString *userid;
    DBCOnnectClass *db;
    UITextField *field;
    NSMutableArray *butArray,*opbuttonArr;
   // NSMutableArray *checkAnswered;
    UIView *questionView;
    
    //NSString *ansStr;
    NSString *mainpath;
    UIProgressView *progressViewStyleProgressView;
        
    float progress;
    float currentProgressValue;
    
    BOOL isMultipleAnsrType;
    int tag;
    int next,from;
    __weak IBOutlet UILabel *moreLbl;
    BOOL isPrevious;
}

@end



int count=0;

@implementation PollQuesnsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"Sorular";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    next=0;
    from=1;
    isPrevious=NO;
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)83/(CGFloat)255 green:(CGFloat)97/(CGFloat)255 blue:(CGFloat)166/(CGFloat)255 alpha:1.0];
    //self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationBar.png"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 7.0)
    {
        self.navigationController.navigationBar.translucent = NO;
    }

    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
    // Do any additional setup after loading the view from its nib.
   // [[UIBarButtonItem appearance]setTintColor:[UIColor colorWithRed:(float)197/(float)255 green:(float)0/(float)255 blue:(float)89/(float)255 alpha:1.0]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 82, 30);
    [backButton setBackgroundImage:[UIImage imageNamed:@"navbarbutton.png"] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:13.0];
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [backButton setTitle:@"Anketlerim" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    NSLog(@"pollid is %d",[self.pollId intValue]);
    
    NSLog(@"%@",self.pollId);
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    mainpath=[def valueForKey:@"mainpath"];
    userid=[def objectForKey:@"userId"];
    
    quesArray =[[NSMutableArray alloc]init];
    ansArray =[[NSMutableArray alloc]init];
    opbuttonArr=[[NSMutableArray alloc]init];
    //checkAnswered=[[NSMutableArray alloc]init];
    db=[[DBCOnnectClass alloc]init];
    
    progressViewStyleProgressView = [[UIProgressView alloc] init];
    progressViewStyleProgressView.frame = CGRectMake(20, 10, 285, 11);
    progressViewStyleProgressView.progressViewStyle = UIProgressViewStyleDefault;
    //progressViewStyleProgressView.t
    [self.view addSubview:progressViewStyleProgressView];
    currentProgressValue =0;
    
    
    
    self.scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 42, 320, 320)]; //CGRectMake(0, 128, 320, 200)];  290
    self.scrollView.scrollEnabled=YES;
    self.scrollView.userInteractionEnabled=YES;
    self.scrollView.bounces=YES;
    self.scrollView.showsVerticalScrollIndicator=YES;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.backgroundColor=[UIColor clearColor];//colorWithRed:0.22 green:0.62 blue:0.74 alpha:.8];
    self.scrollView.contentSize = CGSizeMake(320, 320);
    [_scrollView setTag:836913];
    self.scrollView.indicatorStyle=UIScrollViewIndicatorStyleDefault;
   // [self.scrollView flashScrollIndicators];
    [self.view addSubview:self.scrollView];
    
        
    
    prevButton=[UIButton buttonWithType:UIButtonTypeCustom];
    prevButton.frame=CGRectMake(45, 376, 67, 30); //340
    //[prevButton setImage:[UIImage imageNamed:@"previous.png"] forState:UIControlStateNormal];
    [prevButton setBackgroundImage:[UIImage imageNamed:@"previouspink.png"] forState:UIControlStateNormal];
    [prevButton setBackgroundImage:[UIImage imageNamed:@"previousblue.png"] forState:UIControlStateSelected||UIControlStateHighlighted];
    [prevButton setTitle:@"Geri" forState:UIControlStateNormal];
    [prevButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    prevButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [prevButton addTarget:self action:@selector(Previous_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    [prevButton setUserInteractionEnabled:YES];
    [self.view addSubview:prevButton];
    
    
    nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(208, 376, 67, 30);
    //[nextButton setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"nextpink.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"nextblue.png"] forState:UIControlStateSelected||UIControlStateHighlighted];
    [nextButton setTitle:@"İleri" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [nextButton addTarget:self action:@selector(Next_clicked:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setUserInteractionEnabled:YES];
    [self.view addSubview:nextButton];

    
    UISwipeGestureRecognizer *leftRecognizer;
    leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [leftRecognizer setDirection: UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:leftRecognizer];
       
    UISwipeGestureRecognizer *rightRecognizer;
    rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [rightRecognizer setDirection: UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:rightRecognizer];
    
   
    NSString *query=[NSString stringWithFormat:@"select *from QuestionsTable where survey_Id='%@'",_pollId];
    NSArray *tempQues=[db getQuestionsFromDatabase:query];
    NSLog(@"array count is =%d, %@",tempQues.count,tempQues);
        
    
    if (tempQues.count==0) {
    
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    userid=[def objectForKey:@"userId"];
        
        if (![self connected]) {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Lütfen internet bağlantınızı kontrol ediniz" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }else{

        
           NSString *urlStr=[NSString stringWithFormat:@"%@/%@/%@/%d",mainpath,kgetQuestionsUrl,userid,[_pollId intValue]];
            NSLog(@"url is %@",urlStr);
           NSURL *url=[NSURL URLWithString:urlStr];
          //ASIHTTPRequest *req=[[ASIHTTPRequest alloc]init];
          //[self loadQuestionsFromService:req withUrl:url];
            [HUD showUIBlockingIndicator];
            __block __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            [request setCompletionBlock:^{
                
                NSError *error;
                NSArray *arr=[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:&error];
                
                for (int i=0; i<[arr count]; i++) {
                    
                    Questions *q=[[Questions alloc] init];
                    q.surveyId=[[arr objectAtIndex:i] valueForKey:@"surveyID"];
                    q.qOrder=[[arr objectAtIndex:i] valueForKey:@"qOrder"];
                    q.question=[[arr  objectAtIndex:i] valueForKey:@"question"];
                    q.quesType=[[arr objectAtIndex:i] valueForKey:@"qType"];
                    
                    NSLog(@"question name in request finished is is %@",q.question);
                    //[quesArray addObject:q];
                    
                    NSString *query=[NSString stringWithFormat:@"select * from QuestionsTable where survey_Id='%@' and q_Order='%@' ",q.surveyId,q.qOrder];
                    NSArray *qarr=[db getQuestionsFromDatabase:query];
                    if (qarr.count==0) {
                        //.[quesArray addObject:q];
                        [db insertQuestions:q];
                    }
                    
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loadques" object:self];
                
            }];
            [request setFailedBlock:^{
                NSError *error = [request error];
                NSLog(@"Error : %@", error.localizedDescription);
            }];
            [request startAsynchronous];

            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAnswers:) name:@"loadques" object:nil];
         
        }
     
    }else{
        quesArray=(NSMutableArray *)tempQues;
//        for (int i=0; i<quesArray.count; i++) {
//            [checkAnswered addObject:[NSString stringWithFormat:@"NO"]];
//        }
        
        progress = (float)1/(float)quesArray.count;
        currentProgressValue = currentProgressValue+progress;
        progressViewStyleProgressView.progress=currentProgressValue;
        [self loadMyViewWithindexCount:count];
        
    }

}


-(void)loadAnswers:(NSNotificationCenter *)notif{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@",mainpath,kgetOptionsurl,userid,_pollId]];
    __block __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        
        NSError *error;
        NSArray *ansArr=[NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"options are ***************** \n %@ \n**************************** and count is =%d",ansArr,ansArr.count);
        if (ansArr==0) {
            
            NSLog(@"do nothing ");
        }else{
            
            for (int i=0; i<ansArr.count; i++) {
                
                Options *op=[[Options alloc]init];
                
                op.questionOrder=[[ansArr objectAtIndex:i] valueForKey:@"questionOrder"];
                op.optionOrder=[[ansArr objectAtIndex:i] valueForKey:@"optionOrder"];
                op.option=[[ansArr objectAtIndex:i] valueForKey:@"options"];
                op.surveyId=[[ansArr objectAtIndex:i] valueForKey:@"surveyID"];
                op.next=[[[ansArr objectAtIndex:i] valueForKey:@"nextJump"] intValue];
                
                
                NSLog(@"option is  %@",op.option);
                
                NSString *query=[NSString stringWithFormat:@"select * from OptionsTable where question_Order='%@' and option_Order='%@' and survey_Id='%@'",op.questionOrder,op.optionOrder,op.surveyId];
                NSArray *oparr=[db getOptionsFromDatabase:query];
                
                if (oparr.count==0) {
                    
                    [db insertOptions:op];
                    
                }
                
            }
            
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadview" object:self];
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error : %@", error.localizedDescription);
    }];
    [request startAsynchronous];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadViewwithQuesandOptions:) name:@"loadview" object:nil];
    
}

-(void)loadViewwithQuesandOptions:(NSNotificationCenter *)notif{
    [self performSelector:@selector(stopanimafterLoading) withObject:nil afterDelay:1.0f];
    quesArray=[db getQuestionsFromDatabase:[NSString stringWithFormat:@"select *from QuestionsTable where survey_Id='%@'",_pollId]];
//    for (int i=0; i<quesArray.count; i++) {
//        [checkAnswered addObject:[NSString stringWithFormat:@"NO"]];
//    }
    //[self performSelector:@selector(stopanim) withObject:nil afterDelay:1.0f];
    progress = (float)1/(float)quesArray.count;
    currentProgressValue = currentProgressValue+progress;
    progressViewStyleProgressView.progress=currentProgressValue;
    [self loadMyViewWithindexCount:count];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

- (void)viewDidAppear:(BOOL)animate
{
    [super viewDidAppear:animate];
    [self.scrollView flashScrollIndicators];
}


-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    NSLog(@"get gesture");
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"get gesture right");
        
        if (count>0 & count!=quesArray.count) {
             [self Previous_Clicked:nil];
        }
                                  
    }
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"get gesture Left");
       
        if (count<quesArray.count) {
             [self Next_clicked:nil];
        }
    
    }
}


-(void)loadMyViewWithindexCount:(int)index{
    [nextButton setEnabled:NO];
    self.scrollView.contentSize=CGSizeMake(320, 320);
    if (!butArray.count==0) {
        for (UIButton *b in butArray) {
            [b removeFromSuperview];
        }
        
        [butArray removeAllObjects];
        
    }else{
        
        butArray=[[NSMutableArray alloc] init];
    }
    
    if (!opbuttonArr.count==0) {
        for (UIButton *b in opbuttonArr) {
            [b removeFromSuperview];
        }
        
        [opbuttonArr removeAllObjects];
        
    }else{
        
        opbuttonArr=[[NSMutableArray alloc] init];
    }
    
    NSArray *subViews=[self.scrollView subviews];
    
    for (UIView *view in subViews) {
        
        if (view==self.questionLabel) {
            [view removeFromSuperview];
        }else if(view == qnoLabel){
        [view removeFromSuperview];
        }else if (view==questionView)
            [view removeFromSuperview];
        }
    
    if (count==quesArray.count-1) {
        [nextButton setTitle:@"Bitir" forState:UIControlStateNormal];
    }
    
    if (quesArray.count!=0) {
        
    
    if (index==0) {
        [prevButton setHidden:YES];
    }
    if (quesArray.count==1) {
        [prevButton setHidden:YES];
        [nextButton setHidden:NO];
        [nextButton setTitle:@"Bitir" forState:UIControlStateNormal];
        
    }
        //return;
    Questions *q=[[Questions alloc]init];
    q=(Questions *)[quesArray objectAtIndex:index];
        
        if ([q.quesType isEqualToString:@"0"]) {
            isMultipleAnsrType=YES;
        } else if([q.quesType isEqualToString:@"1"]){
            isMultipleAnsrType=NO;
        }
        
        Options *op=[[Options alloc]init];
    NSString *queryAns=[NSString stringWithFormat:@"select * from OptionsTable where question_Order='%@' and survey_Id='%@'",q.qOrder,_pollId];
    ansArray=[db getOptionsFromDatabase:queryAns];
    NSArray *oparr=ansArray;   //[db getOptionsFromDatabase:queryAns];
    NSLog(@"array values %@",ansArray);
    NSLog(@"answeraray count is =%d",oparr.count);
    
        int noOfCharectersInQuestion = [q.question length];
        float qLblHeight;
        if (noOfCharectersInQuestion<27) {
            qLblHeight = 50;
        }else{
            qLblHeight = (ceilf((float)noOfCharectersInQuestion/(float)23)+1)*22;
         
        }
        
        questionView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, qLblHeight)];
        questionView.backgroundColor=[UIColor colorWithRed:.54 green:.57 blue:.75 alpha:1];
        [self.scrollView addSubview:questionView];
    
        qnoLabel=[[UILabel alloc] init];  //WithFrame:CGRectMake(13, 6, 40, 40)];
        qnoLabel.frame =CGRectMake(13, ((qLblHeight/2)-20), 40, 40);
        qnoLabel.font=[UIFont boldSystemFontOfSize:17.0];
        qnoLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"qnoimg.png"]];
        qnoLabel.textColor=[UIColor whiteColor];
        qnoLabel.textAlignment=NSTextAlignmentCenter;
        //[self.scrollView addSubview:qnoLabel];
        [questionView addSubview:qnoLabel];
        
        self.questionLabel=[[UILabel alloc]initWithFrame:CGRectMake(63, 0, 255, qLblHeight)];
        self.questionLabel.textColor=[UIColor whiteColor];
        self.questionLabel.backgroundColor = [UIColor clearColor];
        self.questionLabel.numberOfLines=0;
        self.questionLabel.lineBreakMode=UILineBreakModeWordWrap;
       // self.questionLabel.font=[UIFont boldSystemFontOfSize:18.0];
        self.questionLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18.0];
        [_questionLabel setBackgroundColor:[UIColor colorWithRed:.54 green:.57 blue:.75 alpha:1]];  //138,145,191

        ///[self.scrollView addSubview:self.questionLabel];
        [questionView addSubview:_questionLabel];
        
        self.questionLabel.text=q.question;
        qnoLabel.text = q.qOrder;

        float scrollViewHeight;
        scrollViewHeight = self.questionLabel.frame.size.height+21+(oparr.count)*50;
        if (scrollViewHeight>320) {
            self.scrollView.contentSize = CGSizeMake(320, scrollViewHeight);
        }[self.scrollView flashScrollIndicators];

        NSLog(@"question id =%@",q.qOrder);
  
          
        int buttonwidth=290;
        int butheight=50;
        //int minimumsep=2;
        float y= self.questionLabel.frame.size.height+21;
        
        
        NSArray *checkAnsweredOrNot=[db getAnswersFromDatabase:[NSString stringWithFormat:@"select * from Answers where question_Order='%@' and survey_Id='%@'",q.qOrder,_pollId]];
        if (checkAnsweredOrNot.count!=0) {
            if (from>=count) {
                next=0;
            }
            //next=0;
        }
        
        
        if (next==0) {
            
            //*************************************  do normal *******************************************************
            
            
            
            for (int i=0; i<oparr.count; i++) {
                NSLog(@"in for loop");
                op=[oparr objectAtIndex:i];
                
                NSString *str=[NSString stringWithFormat:@"select * from Answers where question_Order='%@' and answer_Order='%@' and survey_Id='%@'",q.qOrder,op.optionOrder,_pollId];
                NSArray *sltdAnsArr=[db getAnswersFromDatabase:str];
                Answers *ans;
                if (!sltdAnsArr.count==0) {
                    
                    ans=[sltdAnsArr objectAtIndex:0];
                    
                }
                
                int noOfCharectersInQuestion = [op.option length];
                //float qLblHeight;
                if (noOfCharectersInQuestion<27) {
                    butheight = 50;
                }else{
                    butheight = (ceilf((float)noOfCharectersInQuestion/(float)23)+1)*25;
                    
                }
                
                
                UIButton *optionDisplay=[UIButton buttonWithType:UIButtonTypeCustom];
                optionDisplay.frame=CGRectMake(15, y, buttonwidth, butheight);
                [optionDisplay setUserInteractionEnabled:YES];
                optionDisplay.tag=i;
                [optionDisplay setTitle:op.option forState:UIControlStateNormal];
                optionDisplay.titleLabel.numberOfLines=0;
                [optionDisplay setBackgroundImage:[UIImage imageNamed:@"optionblue.png"] forState:UIControlStateNormal];
                [optionDisplay addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                
                UIButton *checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
                checkBox.frame = CGRectMake(3, 5, 40, 40);
                checkBox.center=CGPointMake(23, optionDisplay.frame.size.height/2);
                checkBox.tag =i;
                [checkBox setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                //[checkBox setTitle:op.optionOrder forState:UIControlStateNormal];
                [checkBox addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                if ([op.optionOrder isEqualToString:ans.answerOrder]) {
                    [nextButton setEnabled:YES];
                    //[checkAnswered replaceObjectAtIndex:count withObject:[NSString stringWithFormat:@"YES"]];
                    if (op.next!=0) {
                        next=op.next;
                        from=count+1;
                    }else{
                        if (from>count) {
                            next=0;
                        }
                    }
                    
                    if (isMultipleAnsrType==YES) {
                        [checkBox setBackgroundImage:[UIImage imageNamed:@"checkMultiple.png"] forState:UIControlStateNormal];
                        [checkBox setTitle:@"checkMultiple" forState:UIControlStateNormal];
                    }else{
                        [checkBox setBackgroundImage:[UIImage imageNamed:@"checkSingle.png"] forState:UIControlStateNormal];
                        [checkBox setTitle:@"checkSingle" forState:UIControlStateNormal];
                    }
                    
                }else{
                    
                    if (isMultipleAnsrType==YES) {
                        [checkBox setBackgroundImage:[UIImage imageNamed:@"uncheckMultiple.png"] forState:UIControlStateNormal];
                        [checkBox setTitle:@"uncheckMultiple" forState:UIControlStateNormal];
                    }else{
                        [checkBox setBackgroundImage:[UIImage imageNamed:@"uncheckSingle.png"] forState:UIControlStateNormal];
                        [checkBox setTitle:@"uncheckSingle" forState:UIControlStateNormal];
                    }
                    //[optionDisplay setBackgroundImage:[UIImage imageNamed:@"tableCellBar.png"] forState:UIControlStateNormal];
                }
                
                
                [optionDisplay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                optionDisplay.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                optionDisplay.titleEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
                //optionDisplay.titleLabel.text=op.option;
                optionDisplay.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
                [self.scrollView addSubview:optionDisplay];
                [optionDisplay addSubview:checkBox];
                [butArray addObject:checkBox];
                [opbuttonArr addObject:optionDisplay];
                
                y=y+butheight;//+minimumsep;
                if (butheight>50) {
                    float scrollViewHeight=self.scrollView.contentSize.height+(butheight-50);
                    self.scrollView.contentSize=CGSizeMake(320, scrollViewHeight);
                    [self.scrollView flashScrollIndicators];
                }
                if (self.scrollView.contentSize.height>340) {
                    [moreLbl setHidden:NO];
                }else{
                    [moreLbl setHidden:YES];
                }
                
            }

        }else{
            if (count+1>=next || from==count+1) {
                
                //****************************  do normal ******************************************
                
                for (int i=0; i<oparr.count; i++) {
                    NSLog(@"in for loop");
                    op=[oparr objectAtIndex:i];
                    
                    NSString *str=[NSString stringWithFormat:@"select * from Answers where question_Order='%@' and answer_Order='%@' and survey_Id='%@'",q.qOrder,op.optionOrder,_pollId];
                    NSArray *sltdAnsArr=[db getAnswersFromDatabase:str];
                    Answers *ans;
                    if (!sltdAnsArr.count==0) {
                        
                        ans=[sltdAnsArr objectAtIndex:0];
                    }
                    
                    int noOfCharectersInQuestion = [op.option length];
                    //float qLblHeight;
                    if (noOfCharectersInQuestion<27) {
                        butheight = 50;
                    }else{
                        butheight = (ceilf((float)noOfCharectersInQuestion/(float)23)+1)*25;
                        
                    }
                    
                    
                    UIButton *optionDisplay=[UIButton buttonWithType:UIButtonTypeCustom];
                    optionDisplay.frame=CGRectMake(15, y, buttonwidth, butheight);
                    [optionDisplay setUserInteractionEnabled:YES];
                    optionDisplay.tag=i;
                    [optionDisplay setTitle:op.option forState:UIControlStateNormal];
                    optionDisplay.titleLabel.numberOfLines=0;
                    [optionDisplay setBackgroundImage:[UIImage imageNamed:@"optionblue.png"] forState:UIControlStateNormal];
                    [optionDisplay addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                
                    UIButton *checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
                    checkBox.frame = CGRectMake(3, 5, 40, 40);
                    checkBox.center=CGPointMake(23, optionDisplay.frame.size.height/2);
                    checkBox.tag =i;
                    [checkBox setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    //[checkBox setTitle:op.optionOrder forState:UIControlStateNormal];
                    [checkBox addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if ([op.optionOrder isEqualToString:ans.answerOrder]) {
                        [nextButton setEnabled:YES];
                        //[checkAnswered replaceObjectAtIndex:count withObject:[NSString stringWithFormat:@"YES"]];
                        if (op.next!=0) {
                            next=op.next;
                            from=count+1;
                        }else{
                            if (from>count) {
                                next=0;
                            }
                        }
                        if (isMultipleAnsrType==YES) {
                            [checkBox setBackgroundImage:[UIImage imageNamed:@"checkMultiple.png"] forState:UIControlStateNormal];
                            [checkBox setTitle:@"checkMultiple" forState:UIControlStateNormal];
                        }else{
                            [checkBox setBackgroundImage:[UIImage imageNamed:@"checkSingle.png"] forState:UIControlStateNormal];
                            [checkBox setTitle:@"checkSingle" forState:UIControlStateNormal];
                        }
                        
                    }else{
                        
                        if (isMultipleAnsrType==YES) {
                            [checkBox setBackgroundImage:[UIImage imageNamed:@"uncheckMultiple.png"] forState:UIControlStateNormal];
                            [checkBox setTitle:@"uncheckMultiple" forState:UIControlStateNormal];
                        }else{
                            [checkBox setBackgroundImage:[UIImage imageNamed:@"uncheckSingle.png"] forState:UIControlStateNormal];
                            [checkBox setTitle:@"uncheckSingle" forState:UIControlStateNormal];
                        }
                        //[optionDisplay setBackgroundImage:[UIImage imageNamed:@"tableCellBar.png"] forState:UIControlStateNormal];
                    }
                    
                    
                    [optionDisplay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    optionDisplay.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    optionDisplay.titleEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
                    //optionDisplay.titleLabel.text=op.option;
                    optionDisplay.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
                    [self.scrollView addSubview:optionDisplay];
                    [optionDisplay addSubview:checkBox];
                    [butArray addObject:checkBox];
                    [opbuttonArr addObject:optionDisplay];
                    
                    y=y+butheight;//+minimumsep;
                    if (butheight>50) {
                        float scrollViewHeight=self.scrollView.contentSize.height+(butheight-50);
                        self.scrollView.contentSize=CGSizeMake(320, scrollViewHeight);
                        [self.scrollView flashScrollIndicators];
                    }
                    if (self.scrollView.contentSize.height>340) {
                        [moreLbl setHidden:NO];
                    }else{
                        [moreLbl setHidden:YES];
                    }
                    
                }
                
                //previousNext=next;
                //next=0;
            }else{
                NSLog(@"count %d",count);
                
                //*************************************  pasive the things ******************************
                [nextButton setEnabled:YES];
                
                self.questionLabel.textColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
                qnoLabel.textColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
                for (int i=0; i<oparr.count; i++) {
                    NSLog(@"in for loop");
                    op=[oparr objectAtIndex:i];
                    
                    NSString *str=[NSString stringWithFormat:@"select * from Answers where question_Order='%@' and answer_Order='%@' and survey_Id='%@'",q.qOrder,op.optionOrder,_pollId];
                    NSArray *sltdAnsArr=[db getAnswersFromDatabase:str];
                    Answers *ans;
                    if (!sltdAnsArr.count==0) {
                        
                        ans=[sltdAnsArr objectAtIndex:0];
                    }
                    
                    int noOfCharectersInQuestion = [op.option length];
                    //float qLblHeight;
                    if (noOfCharectersInQuestion<27) {
                        butheight = 50;
                    }else{
                        butheight = (ceilf((float)noOfCharectersInQuestion/(float)23)+1)*25;
                        
                    }
                    
                    
                    UIButton *optionDisplay=[UIButton buttonWithType:UIButtonTypeCustom];
                    optionDisplay.frame=CGRectMake(15, y, buttonwidth, butheight);
                    [optionDisplay setUserInteractionEnabled:YES];
                    optionDisplay.tag=i;
                    [optionDisplay setTitle:op.option forState:UIControlStateNormal];
                    optionDisplay.titleLabel.numberOfLines=0;
                    [optionDisplay setBackgroundImage:[UIImage imageNamed:@"optionblue.png"] forState:UIControlStateNormal];
                    [optionDisplay addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [optionDisplay setUserInteractionEnabled:NO];
                    
                    UIButton *checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
                    checkBox.frame = CGRectMake(3, 5, 40, 40);
                    checkBox.center=CGPointMake(23, optionDisplay.frame.size.height/2);
                    checkBox.tag =i;
                    [checkBox setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    //[checkBox setTitle:op.optionOrder forState:UIControlStateNormal];
                    [checkBox addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [checkBox setUserInteractionEnabled:NO];
                    
                    if ([op.optionOrder isEqualToString:ans.answerOrder]) {
                        //[nextButton setEnabled:YES];
                        //[checkAnswered replaceObjectAtIndex:count withObject:[NSString stringWithFormat:@"YES"]];
                        if (op.next!=0) {
                            next=op.next;
                            from=count+1;
                        }else{
                            if (from>count) {
                                next=0;
                            }
                        }
                        if (isMultipleAnsrType==YES) {
                            [checkBox setBackgroundImage:[UIImage imageNamed:@"checkMultiple.png"] forState:UIControlStateNormal];
                            [checkBox setTitle:@"checkMultiple" forState:UIControlStateNormal];
                        }else{
                            [checkBox setBackgroundImage:[UIImage imageNamed:@"checkSingle.png"] forState:UIControlStateNormal];
                            [checkBox setTitle:@"checkSingle" forState:UIControlStateNormal];
                        }
                        
                    }else{
                        
                        if (isMultipleAnsrType==YES) {
                            [checkBox setBackgroundImage:[UIImage imageNamed:@"uncheckMultiple.png"] forState:UIControlStateNormal];
                            [checkBox setTitle:@"uncheckMultiple" forState:UIControlStateNormal];
                        }else{
                            [checkBox setBackgroundImage:[UIImage imageNamed:@"uncheckSingle.png"] forState:UIControlStateNormal];
                            [checkBox setTitle:@"uncheckSingle" forState:UIControlStateNormal];
                        }
                        //[optionDisplay setBackgroundImage:[UIImage imageNamed:@"tableCellBar.png"] forState:UIControlStateNormal];
                    }
                    
                    
                    [optionDisplay setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] forState:UIControlStateNormal];
                    optionDisplay.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    optionDisplay.titleEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
                    //optionDisplay.titleLabel.text=op.option;
                    optionDisplay.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
                    [self.scrollView addSubview:optionDisplay];
                    [optionDisplay addSubview:checkBox];
                    [butArray addObject:checkBox];
                    [opbuttonArr addObject:optionDisplay];
                    
                    y=y+butheight;//+minimumsep;
                    if (butheight>50) {
                        float scrollViewHeight=self.scrollView.contentSize.height+(butheight-50);
                        self.scrollView.contentSize=CGSizeMake(320, scrollViewHeight);
                        [self.scrollView flashScrollIndicators];
                    }
                    if (self.scrollView.contentSize.height>340) {
                        [moreLbl setHidden:NO];
                    }else{
                        [moreLbl setHidden:YES];
                    }
                    
                }

            }
        }

    
        
//        for (int i=0; i<oparr.count; i++) {
//            NSLog(@"in for loop");
//            op=[oparr objectAtIndex:i];
//            
//            NSString *str=[NSString stringWithFormat:@"select * from Answers where question_Order='%@' and answer_Order='%@'",q.qOrder,op.optionOrder];
//            NSArray *sltdAnsArr=[db getAnswersFromDatabase:str];
//            Answers *ans;
//            if (!sltdAnsArr.count==0) {
//                
//                ans=[sltdAnsArr objectAtIndex:0];
//            }
//            
//            int noOfCharectersInQuestion = [op.option length];
//            //float qLblHeight;
//            if (noOfCharectersInQuestion<27) {
//                butheight = 50;
//            }else{
//                butheight = (ceilf((float)noOfCharectersInQuestion/(float)23)+1)*25;
//                
//            }
//            
//            
//            UIButton *optionDisplay=[UIButton buttonWithType:UIButtonTypeCustom];
//            optionDisplay.frame=CGRectMake(15, y, buttonwidth, butheight);
//            [optionDisplay setUserInteractionEnabled:YES];
//             optionDisplay.tag=i;
//            [optionDisplay setTitle:op.option forState:UIControlStateNormal];
//            optionDisplay.titleLabel.numberOfLines=0;
//            [optionDisplay setBackgroundImage:[UIImage imageNamed:@"optionblue.png"] forState:UIControlStateNormal];
//            [optionDisplay addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//            
//
//            UIButton *checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
//            checkBox.frame = CGRectMake(3, 5, 40, 40);
//            checkBox.center=CGPointMake(23, optionDisplay.frame.size.height/2);
//            checkBox.tag =i;
//            [checkBox setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//            //[checkBox setTitle:op.optionOrder forState:UIControlStateNormal];
//            [checkBox addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//            
//            if ([op.optionOrder isEqualToString:ans.answerOrder]) {
//                [nextButton setEnabled:YES];
//                [checkAnswered replaceObjectAtIndex:count withObject:[NSString stringWithFormat:@"YES"]];
//                
//                if (isMultipleAnsrType==YES) {
//                  [checkBox setBackgroundImage:[UIImage imageNamed:@"checkMultiple.png"] forState:UIControlStateNormal];
//                    [checkBox setTitle:@"checkMultiple" forState:UIControlStateNormal];
//                }else{
//                    [checkBox setBackgroundImage:[UIImage imageNamed:@"checkSingle.png"] forState:UIControlStateNormal];
//                    [checkBox setTitle:@"checkSingle" forState:UIControlStateNormal];
//                }
//                
//            }else{
//                
//                if (isMultipleAnsrType==YES) {
//                    [checkBox setBackgroundImage:[UIImage imageNamed:@"uncheckMultiple.png"] forState:UIControlStateNormal];
//                    [checkBox setTitle:@"uncheckMultiple" forState:UIControlStateNormal];
//                }else{
//                    [checkBox setBackgroundImage:[UIImage imageNamed:@"uncheckSingle.png"] forState:UIControlStateNormal];
//                    [checkBox setTitle:@"uncheckSingle" forState:UIControlStateNormal];
//                }
//                //[optionDisplay setBackgroundImage:[UIImage imageNamed:@"tableCellBar.png"] forState:UIControlStateNormal];
//            }
//            
//            
//            [optionDisplay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            optionDisplay.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//            optionDisplay.titleEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
//            //optionDisplay.titleLabel.text=op.option;
//            optionDisplay.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:15.0];
//            [self.scrollView addSubview:optionDisplay];
//            [optionDisplay addSubview:checkBox];
//            [butArray addObject:checkBox];
//            [opbuttonArr addObject:optionDisplay];
//                        
//            y=y+butheight;//+minimumsep;
//            if (butheight>50) {
//                float scrollViewHeight=self.scrollView.contentSize.height+(butheight-50);
//                self.scrollView.contentSize=CGSizeMake(320, scrollViewHeight);
//                [self.scrollView flashScrollIndicators];
//            }
//            if (self.scrollView.contentSize.height>340) {
//                [moreLbl setHidden:NO];
//            }else{
//                [moreLbl setHidden:YES];
//            }
//            
//        }
    
    }
    
}



- (void)Next_clicked:(id)sender {
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    self.scrollView.showsVerticalScrollIndicator=YES;
    
    [prevButton setHidden:NO];
    isPrevious=NO;
    count++;
    currentProgressValue=currentProgressValue+progress;
    progressViewStyleProgressView.progress=currentProgressValue;
     [nextButton setTitle:@"İleri" forState:UIControlStateNormal];
    if (count<quesArray.count) {
        //count++;
        if (count==quesArray.count-1) {
            [nextButton setTitle:@"Bitir" forState:UIControlStateNormal];
        }
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDidStopSelector:@selector(animationDidStop:animationIDfinished:finished:context:)];
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.6];
//        
//        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
//         
//                               forView:self.view cache:YES];
//        
//      
//        [UIView commitAnimations];
        
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.2];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromRight];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        [[self.view layer] addAnimation:animation forKey:@"SwitchToView1"];

        [self loadMyViewWithindexCount:count];
    }else if (count==quesArray.count){
        
           // qnoLabel.hidden=YES;
           // self.questionLabel.hidden = YES;
            //self.scrollView.hidden = YES;
        nextButton.hidden=YES;
        prevButton.hidden=YES;
        self.scrollView.hidden=YES;
        //[self.scrollView removeFromSuperview];
        progressViewStyleProgressView.hidden=YES;
        
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.2];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromRight];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        [[self.view layer] addAnimation:animation forKey:@"SwitchToView1"];
        
         submitView.frame=CGRectMake(0, 0, 320, 435);
         self.title =@"Teşekkürler";
         [self.view addSubview:submitView];
          
    }
}

- (void)Previous_Clicked:(id)sender {
    self.scrollView.showsVerticalScrollIndicator=YES;
    NSString *nextbuttonTitle = nextButton.titleLabel.text;    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    [nextButton setHidden:NO];
    currentProgressValue=currentProgressValue-progress;
    progressViewStyleProgressView.progress=currentProgressValue;

    Questions *q=[quesArray objectAtIndex:count];
    [db deleteAnswersGreaterThanQuestionId:q.qOrder andsurveyid:_pollId];
    isPrevious=YES;
    if(count>0){
        
        count--;
        [prevButton setHidden:NO];
       
        if ([nextbuttonTitle isEqualToString:@"Bitir"])  {
            [nextButton setTitle:@"İleri" forState:UIControlStateNormal];
        }
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.2];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromLeft];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        
        [[self.view layer] addAnimation:animation forKey:@"SwitchToView1"];
        
         [self loadMyViewWithindexCount:count];

    }else if(count==0){
        
        [prevButton setHidden:YES];
        [self loadMyViewWithindexCount:count];
        if ([nextbuttonTitle isEqualToString:@"Bitir"])  {
            [nextButton setTitle:@"İleri" forState:UIControlStateNormal];
        }
    }
    if (count == quesArray.count) {
        [nextButton setHidden:NO];
        [prevButton setHidden:NO];
        [self.questionLabel setHidden:NO];
        [self.questionLabel setHidden:NO];
    }
    
    
    
}




-(void)saveOrUpdateAnswerswithIndex:(int)index{
       
    Questions *q=[quesArray objectAtIndex:index];
    
    //NSLog(@"answer selected is %@",ansStr);
    if (isMultipleAnsrType) {   //[q.quesType isEqualToString:@"1"]
        Options *option = [ansArray objectAtIndex:tag];
        NSString *str=[NSString stringWithFormat:@"select * from Answers where question_Order='%@' and answer_Order='%@' and survey_Id='%@'",q.qOrder,option.optionOrder,_pollId];
        NSArray *oparr=[db getAnswersFromDatabase:str];
        
        
        Answers *ans=[[Answers alloc]init];
        if (oparr.count==0) {
            
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
            
            
            ans.surveyId=self.pollId;
            ans.questionOrder=q.qOrder;
            ans.answerOrder=option.optionOrder;
            ans.userId=[def valueForKey:@"userId"];
            
            [db insertAnswers:ans];
        }else{
            ans=[oparr objectAtIndex:0];
            [db deleteAnswerWithsID:ans.ansId];
        }
    }else{
             Options *option = [ansArray objectAtIndex:tag];
    
        NSString *str=[NSString stringWithFormat:@"select * from Answers where question_Order='%@' and survey_Id='%@'",q.qOrder,_pollId];
        NSArray *oparr=[db getAnswersFromDatabase:str];
    
        Answers *ans=[[Answers alloc]init];
        if (oparr.count==0) {
            
            NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
             
            ans.surveyId=self.pollId;
            ans.questionOrder=q.qOrder;
            ans.answerOrder=option.optionOrder;
            ans.userId=[def valueForKey:@"userId"];
            
            [db insertAnswers:ans];
            
        }else{
            ans=(Answers *)[oparr objectAtIndex:0];
            NSLog(@"answers %@",ans.answerOrder);
    
            NSString *quiry=[NSString stringWithFormat:@"update Answers set answer_Order='%@' where ansId='%d' and question_Order='%@'",option.optionOrder,ans.ansId,q.qOrder];
            [db updateAnswers:quiry];
        }
    }
    //}

       //ansStr=@"";
}

- (IBAction)submit_ClickedAction:(id)sender {
    
    //BOOL isunanswered =[self checkCheckAnsweredArray];
//    if (isunanswered==YES) {
//        [submitView removeFromSuperview];
//        self.scrollView.hidden=NO;
//        [progressViewStyleProgressView setHidden:NO];
//        currentProgressValue=progress*(count+1);
//        progressViewStyleProgressView.progress=currentProgressValue;
//        nextButton.hidden=NO;
//        prevButton.hidden=NO;
//        self.title=@"Sorular";
//        [self loadMyViewWithindexCount:count];
//        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"" message:@"lütfen bütün sorular eksiksiz cevaplayın" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//    }else{
    
        
        [HUD showUIBlockingIndicator];
        
    NSString *query=[NSString stringWithFormat:@"select * from Answers where survey_Id='%@'",_pollId];
    NSArray *submitArr=[db getAnswersFromDatabase:query];

    
    NSMutableArray *ar=[[NSMutableArray alloc]init];
    
    for (int i=0; i<submitArr.count; i++) {
        
        Answers *a=[submitArr objectAtIndex:i];
        NSLog(@"object class is %@",a);
      
       NSDictionary *dic=[NSDictionary dictionaryWithObjects:@[a.surveyId,a.questionOrder,a.answerOrder,a.userId] forKeys:@[@"surveyID",@"questionOrder",@"answerOrder",@"smartUserID"]];
      
       [ar addObject:dic];
    }
    
       NSData *jsonData=[NSJSONSerialization dataWithJSONObject:ar options:NSJSONWritingPrettyPrinted error:nil];
    //jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *string1 = [[NSMutableString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonData: %@", string1);
    
    NSString *str=[NSString stringWithFormat:@"%@/%@",mainpath,ksubmitAnswersUrl];
        
    NSURL *url=[NSURL URLWithString:str];
    ASIFormDataRequest *request=[[ASIFormDataRequest alloc]initWithURL:url];
    [request setRequestMethod:@"Post"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request appendPostData:jsonData];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(answersUploaded:)];
    [request setDidFailSelector:@selector(answersUploadRequestFailed:)];
    [request startSynchronous];
        
    
   
    [self performSelector:@selector(stopanimafterLoading) withObject:nil afterDelay:0.f];
        [db deleteParticularPoll:_pollId];
        [db deleteAnswersForsurveyID:_pollId];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:YES forKey:@"pollDelete"];
        [userDefault synchronize];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:NO];
    //}
}

//-(BOOL)checkCheckAnsweredArray{
//    BOOL isunanswered=NO;
//    for (int i=0; i<checkAnswered.count; i++) {
//        NSString *string=[checkAnswered objectAtIndex:i];
//        if ([string isEqualToString:@"NO"]) {
//            count=i;
//            isunanswered=YES;
//            break;
//        }
//    }
//    return isunanswered;
//}

-(void)answersUploaded:(ASIHTTPRequest *)response{
    
    NSLog(@"rseponse string is %@",[response responseString]);
    
//    if ([[response responseString] isEqualToString:@"true"]) {
//        [db deleteParticularPoll:_pollId];
//        [db deleteAnswersForsurveyID:_pollId];
//        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//        [userDefault setBool:YES forKey:@"pollDelete"];
//        [userDefault synchronize];
//        self.navigationController.navigationBarHidden = NO;
//        [self.navigationController popViewControllerAnimated:NO];
//    }else{
//        self.navigationController.navigationBarHidden = NO;
//        [self.navigationController popViewControllerAnimated:NO];
//
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Submit Failed" message:@"not submitted" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//        [alert show];
//    }
    
}

-(void)answersUploadRequestFailed:(ASIHTTPRequest *)request{
    
    NSLog(@"Error response == %@",[request responseString]);
}


-(void)optionButtonClicked:(id)sender{
    [nextButton setEnabled:YES];
    UIButton *tapped=(UIButton *)sender;
    UIButton *button=[butArray objectAtIndex:tapped.tag];
    NSLog(@"button tag is %@  \%d",button,button.tag);
    tag=button.tag;
    Options *optionNext=[ansArray objectAtIndex:button.tag];
    if (optionNext.next!=0) {
        next=optionNext.next;
        from=count+1;
    }else{
        if (from >count) {
            next=0;
        }
    }
    
    NSLog(@"****** %d ***",next);
    //[checkAnswered replaceObjectAtIndex:count withObject:[NSString stringWithFormat:@"YES"]];
    
    //Questions *q=[quesArray objectAtIndex:count];
    if (isMultipleAnsrType==YES) {
        
        for (UIButton *b in butArray) {
            
            if (b==button) {
                
                if ([button.titleLabel.text isEqualToString:@"checkMultiple"]) {
                    [b setBackgroundImage:[UIImage imageNamed:@"uncheckMultiple.png"] forState:UIControlStateNormal];
                    [b setTitle:@"uncheckMultiple" forState:UIControlStateNormal];
                }else{
                    [b setBackgroundImage:[UIImage imageNamed:@"checkMultiple.png"] forState:UIControlStateNormal];
                    [b setTitle:@"checkMultiple" forState:UIControlStateNormal];
                }
                }
        }
    }else {
        
            for (UIButton *b in butArray) {
        
                if (b==button) {
                    [b setBackgroundImage:[UIImage imageNamed:@"checkSingle.png"] forState:UIControlStateNormal];
        
                }else{
                    [b setBackgroundImage:[UIImage imageNamed:@"uncheckSingle.png"] forState:UIControlStateNormal];
                     }
            }
        
         }
    
    [self saveOrUpdateAnswerswithIndex:count];
}




-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    //if (count==quesArray.count-1) {
        
        //[self saveOrUpdateAnswerswithIndex:count];
   // }
    
    return YES;
}

-(void)stopanimafterLoading{
    
    [HUD hideUIBlockingIndicator];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewDidDisappear:(BOOL)animated{
    
    count=0;
}
    

@end
