//
//  HeaderFiles.h
//  KonusanEvler
//
//  Created by Hadi Hatunoglu on 19/06/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#ifndef KonusanEvler_HeaderFiles_h
#define KonusanEvler_HeaderFiles_h
//
//#define kactivationurl @"KonusanEvlers/rest/application/Activate"
//#define kpollsUrl @"KonusanEvlers/rest/application/getPolls"
//#define kgetQuestionsUrl @"KonusanEvlers/rest/application/getQuestions"
//#define kgetOptionsurl  @"KonusanEvlers/rest/application/getOptions"
//#define ksubmitAnswersUrl @"KonusanEvlers/rest/application/giveAnswers"

#define kactivationurl @"PollService.svc/rest/Survey/Activate"
#define kpollsUrl @"PollService.svc/rest/Survey/getActSurveys"
#define kgetQuestionsUrl @"PollService.svc/rest/Survey/getSurveyQues"
#define kgetOptionsurl  @"PollService.svc/rest/Survey/getSurveyOpts"
#define ksubmitAnswersUrl @"PollService.svc/rest/Survey/postAnswers"
#define kRegIdTypeOs @"PollService.svc/rest/Survey/RegIDTypeOS"
#define ksubmitInBeneAra @"PollService.svc/rest/Survey/setLookupTicket"
#define kpanelList @"PollService.svc/rest/Survey/getPaneList"
#define kGiftUrl @"PollService.svc/rest/Survey/GetURl"
#define kGetimagesUrl @"PollService.svc/rest/Survey/GetPageLink"

//#define kactivationurl @"http://eksen2.sbtanaliz.com:8084/PollService.svc/rest/Survey/Activate"
//#define kpollsUrl @"PollService.svc/rest/Survey/getActSurveys"
//#define kgetQuestionsUrl @"PollService.svc/rest/Survey/getSurveyQues"
//#define kgetOptionsurl  @"PollService.svc/rest/Survey/getSurveyOpts"
//#define ksubmitAnswersUrl @"PollService.svc/rest/Survey/postAnswers"
//#define kRegIdTypeOs @"http://eksen2.sbtanaliz.com:8084/PollService.svc/rest/Survey/RegIDTypeOS"
//#define ksubmitInBeneAra @"PollService.svc/rest/Survey/setLookupTicket"
//#define kpanelList @"PollService.svc/rest/Survey/getPaneList"


//#define kactivationurl @"PollService.svc/Activate"
//#define kpollsUrl @"PollService.svc/getPolls"
//#define kgetQuestionsUrl @"PollService.svc/getQuestions"
//#define kgetOptionsurl  @"PollService.svc/getOptions"
//#define ksubmitAnswersUrl @"PollService.svc/giveAnswers"

/* for (int i = 0; i<imageurlsarr.count; i++) {
 
 imageUrls *objClass=[[imageUrls alloc]init];
 objClass.imageName=[[imageurlsarr objectAtIndex:i] valueForKey:@"pageLink"];
 objClass.rowDate=[[imageurlsarr objectAtIndex:i] valueForKey:@"rowDate"];
 
 NSArray *c =[db getimageUrlsFromDatabase:[NSString stringWithFormat:@"select * from imageUrls where pageLink='%@'",objClass.imageName]];
 if (c.count==0) {
 [db insertimages:objClass];
 }
 
 }
 
 imgUrls=[db getimageUrlsFromDatabase:@"select * from imageUrls"];*/

#endif
