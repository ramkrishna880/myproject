//
//  DBCOnnectClass.h

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "PollsClass.h"
#import "Questions.h"
#import "Options.h"
#import "Answers.h"
#import "imageUrls.h"

@interface DBCOnnectClass : NSObject{
    NSMutableArray *dataArray;
    NSMutableArray *quesarray;
    NSMutableArray *ansarray;
    //NSMutableArray *optionArray;
    
}

+(NSString *)getSqlitePath;
-(void)copyDatabaseIfNeeded;

-(NSMutableArray *)getPollsFromDatabase:(NSString *)SqlQuery;
-(NSMutableArray *)getQuestionsFromDatabase:(NSString *)SqlQuery;
-(NSMutableArray *)getOptionsFromDatabase:(NSString *)SqlQuery;

-(void)insertPolls:(PollsClass *)objClass;
-(void)insertQuestions:(Questions *)objClass;
-(void)insertOptions:(Options *)objClass;

-(NSMutableArray *)getAnswersFromDatabase:(NSString *)SqlQuery;
-(void)insertAnswers:(Answers *)objClass;
-(void)updateAnswers:(NSString *)SqlQuery;
-(void)deleteAnswers;

-(void)deletePolls;
-(void)deleteQuestions;
-(void)deleteOptions;

-(void)deleteParticularPoll:(NSString *)pollId;

-(void)deleteAnswerWithsID:(NSInteger)ansId;
-(void)deleteAnswersForsurveyID:(NSString *)surveyId;

-(void)deleteAnswersGreaterThanQuestionId:(NSString *)qId andsurveyid:(NSString *)surveyId;

-(void)insertimages:(imageUrls *)objClass;
-(NSMutableArray *)getimageUrlsFromDatabase:(NSString *)SqlQuery;
-(void)deleteimageUrls;

//-(NSMutableArray*)getTheStatisticsFromDatabase:(NSString *)SqlQuery;

//-(void)insertDetails:(NSString *)userName todaySunTime:(NSString *)todaySungazeTime  fstDay:(NSString *)firstDay sungazeCumu:(NSString *)sungazeCumulate sunriseCumTime:(NSString *)sunriseCumulateTime sunsetCumTime:(NSString *)sunsetCumulateTime fn:(NSString *)firstName ln:(NSString *)lastName pwd:(NSString *)password eid:(NSString *)emailId pno:(NSString *)phoneNumber;

//-(void)insertStudent:(ObjectClass *)aObj;
//-(void)insertDetails:(ObjectClass *)objClass;
//-(void)updateDetails:(ObjectClass *)objClass;

//-(void)updateDetails:(NSString *)SqlQuery;

//-(void)updateDetails:(NSString *)userName todaySunTime:(NSString *)todaySungazeTime  fstDay:(NSString *)firstDay sungazeCumu:(NSString *)sungazeCumulate sunriseCumTime:(NSString *)sunriseCumulateTime sunsetCumTime:(NSString *)sunsetCumulateTime;
@end
