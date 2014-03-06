//
//  DBCOnnectClass.m
//  CanadaQbankPart1
//
//  Created by Don Andhra on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DBCOnnectClass.h"
static sqlite3 *database=nil;
@implementation DBCOnnectClass

 - (void) copyDatabaseIfNeeded
{
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [DBCOnnectClass getSqlitePath];
	BOOL success = [fileManager fileExistsAtPath:dbPath]; 
	if(success)
     NSLog(@" copied the database");
    
	if(!success)
	{
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"PollsDB.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success) 
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        
        
	NSLog(@"did not copied the database");
    }	
}
+ (NSString *) getSqlitePath
{
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
    NSLog(@"%@",documentsDir);
	return [documentsDir stringByAppendingPathComponent:@"PollsDB.sqlite"];
    
}


-(NSMutableArray *)getPollsFromDatabase:(NSString *)SqlQuery{
    
    if (dataArray==nil) {
        
        dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    }else{
        
        [dataArray removeAllObjects];
    }
    
    database=nil;
    
    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database)==SQLITE_OK)
        	{
        		const char *sql = [SqlQuery UTF8String];
        		sqlite3_stmt *selectstmt;
        		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt,NULL) == SQLITE_OK)
        		{
        			while(sqlite3_step(selectstmt) == SQLITE_ROW)
        			{
        
        				PollsClass *polls =[[PollsClass alloc]init];
                   
                        
                        //objclass.primaryKey =	sqlite3_column_int(selectstmt, 0);
                        //cases.category_id=sqlite3_column_int(selectstmt, 1);
        
                        polls.surveyId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                        
                        polls.surveyTopic=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
                        polls.surveyDefination=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
                        polls.surveyStrtdate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)];
        
                        polls.surveyExpiredate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 5)];
                        polls.surveyPoints=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 6)];
                        
        
                    [dataArray addObject:polls];
//                        for (int j=0; j<dataArray.count; j++) {
//                                                   }
        
                }
        			
        		}
        		else 
        		{
        			NSAssert1(0,@"Error : %s",sqlite3_errmsg(database));
        		}
        		sqlite3_finalize(selectstmt);
        	}
        	sqlite3_close(database);


return dataArray;
}


-(NSMutableArray *)getQuestionsFromDatabase:(NSString *)SqlQuery{
    
    if (quesarray==nil) {
        
        quesarray=[[NSMutableArray alloc]initWithCapacity:0];
    }else{
        
        [quesarray removeAllObjects];
    }
    
    database=nil;
    
    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database)==SQLITE_OK)
    {
        const char *sql = [SqlQuery UTF8String];
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt,NULL) == SQLITE_OK)
        {
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                
                Questions *q =[[Questions alloc]init];
                
                q.surveyId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                
                q.qOrder=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
                q.question=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
                q.quesType=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)];
                //q.pollId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 5)];
                    [quesarray addObject:q];
                for (int j=0; j<quesarray.count; j++) {
//                    q=[quesarray objectAtIndex:j];
//                     NSLog(@"in for loop %@,%@,%@, %@",q.quesId,q.question,q.quesSeqNo,q.pollId);
                }
                
                
            }
            
        }
        else
        {
            NSAssert1(0,@"Error : %s",sqlite3_errmsg(database));
        }
        sqlite3_finalize(selectstmt);
    }
    sqlite3_close(database);
    
    
    return quesarray;
}


-(NSMutableArray *)getOptionsFromDatabase:(NSString *)SqlQuery{
    if (dataArray==nil) {
        
        dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    }else{
        
        [dataArray removeAllObjects];
    }
    
    database=nil;
    
    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database)==SQLITE_OK)
    {
        const char *sql = [SqlQuery UTF8String];
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt,NULL) == SQLITE_OK)
        {
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                
                Options *op =[[Options alloc]init];
                
                op.questionOrder=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                op.optionOrder=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
                op.option=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
                op.surveyId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)];
                op.next=sqlite3_column_int(selectstmt, 5);
                
                [dataArray addObject:op];
                for (int j=0; j<dataArray.count; j++) {
                    //objclass=[dataArray objectAtIndex:j];
                    // NSLog(@"in for loop %@,%@,%@, %@",objclass.userName,objclass.password,objclass.emailId,objclass.phoneNumber);
                }
                
                
            }
            
        }
        else
        {
            NSAssert1(0,@"Error : %s",sqlite3_errmsg(database));
        }
        sqlite3_finalize(selectstmt);
    }
    sqlite3_close(database);
    return dataArray;
}


-(void)insertPolls:(PollsClass *)objClass{

    database=nil;

    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database)==SQLITE_OK)
	{
        NSString *query=nil;

     query=[NSString stringWithFormat:@"INSERT INTO PollsTable  (survey_Id,survey_Topic,survey_Defination,start_Date,end_Date,survey_Points) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",objClass.surveyId,objClass.surveyTopic,objClass.surveyDefination,objClass.surveyStrtdate,objClass.surveyExpiredate,objClass.surveyPoints];

        char *error;
        if ( sqlite3_exec(database, [query UTF8String], NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"success");
        }
        else {
            NSLog(@"fail");
        }


    }
    sqlite3_close(database);

}


-(void)insertQuestions:(Questions *)objClass{
    
    database=nil;
    
    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database)==SQLITE_OK)
	{
        NSString *query=nil;
        
        query=[NSString stringWithFormat:@"INSERT INTO QuestionsTable  (survey_Id,q_Order,question,q_Type) values (\"%@\",\"%@\",\"%@\",\"%@\")",objClass.surveyId,objClass.qOrder,objClass.question,objClass.quesType];
        
        char *error;
        if ( sqlite3_exec(database, [query UTF8String], NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"success");
        }
        else {
            NSLog(@"fail");
        }
        
        
    }
    sqlite3_close(database);
    
}

-(void)insertOptions:(Options *)objClass{
    
    database=nil;
    
    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database)==SQLITE_OK)
	{
        NSString *query=nil;
        
        query=[NSString stringWithFormat:@"INSERT INTO OptionsTable  (question_Order,option_Order,option,survey_Id,next) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%d\")",objClass.questionOrder,objClass.optionOrder,objClass.option,objClass.surveyId,objClass.next];
        NSLog(@"%d",objClass.next);
        
        char *error;
        if ( sqlite3_exec(database, [query UTF8String], NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"success");
        }
        else {
            NSLog(@"fail");
        }
        
        
    }
    sqlite3_close(database);
    
}


-(void)insertimages:(imageUrls *)objClass{
    
    database=nil;
    
    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database)==SQLITE_OK)
	{
        NSString *query=nil;
        
        query=[NSString stringWithFormat:@"INSERT INTO imageUrls  (pageLink,rowDate) values (\"%@\",\"%@\")",objClass.imageName,objClass.rowDate];
       // NSLog(@"%d",objClass.next);
        
        char *error;
        if ( sqlite3_exec(database, [query UTF8String], NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"success");
        }
        else {
            NSLog(@"fail");
        }
        
        
    }
    sqlite3_close(database);
    
}

-(NSMutableArray *)getimageUrlsFromDatabase:(NSString *)SqlQuery{
    
    if (dataArray==nil) {
        
        dataArray=[[NSMutableArray alloc]initWithCapacity:0];
    }else{
        
        [dataArray removeAllObjects];
    }
    
    database=nil;
    
    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database)==SQLITE_OK)
    {
        const char *sql = [SqlQuery UTF8String];
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt,NULL) == SQLITE_OK)
        {
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                
                imageUrls *urlClass =[[imageUrls alloc]init];
                
                
                //objclass.primaryKey =	sqlite3_column_int(selectstmt, 0);
                //cases.category_id=sqlite3_column_int(selectstmt, 1);
                
                urlClass.imageName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                urlClass.rowDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
                //double date = sqlite3_column_double(selectstmt, 4);
                
                //urlClass.rowDate = [NSDate dateWithTimeIntervalSinceNow:date];
                //polls.surveyTopic=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
                
                
                [dataArray addObject:urlClass];
               
            }
            
        }
        else
        {
            NSAssert1(0,@"Error : %s",sqlite3_errmsg(database));
        }
        sqlite3_finalize(selectstmt);
    }
    sqlite3_close(database);
    
    
    return dataArray;
}


//********* answers quires  *********************************************************//


-(NSMutableArray *)getAnswersFromDatabase:(NSString *)SqlQuery{
    
    if (ansarray==nil) {
        
        ansarray=[[NSMutableArray alloc]initWithCapacity:0];
    }else{
        
        [ansarray removeAllObjects];
    }
    
    database=nil;
    
    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database)==SQLITE_OK)
    {
        const char *sql = [SqlQuery UTF8String];
        sqlite3_stmt *selectstmt;
        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt,NULL) == SQLITE_OK)
        {
            while(sqlite3_step(selectstmt) == SQLITE_ROW)
            {
                
                Answers *ans =[[Answers alloc]init];
                
                ans.ansId = sqlite3_column_int(selectstmt, 0);
                ans.surveyId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
                
                ans.questionOrder=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 2)];
                ans.answerOrder=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 3)];
                ans.userId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 4)];
                
                [ansarray addObject:ans];
                for (int j=0; j<dataArray.count; j++) {
                    
                }
            }
            
        }
        else
        {
            NSAssert1(0,@"Error : %s",sqlite3_errmsg(database));
        }
        sqlite3_finalize(selectstmt);
    }
    sqlite3_close(database);
    
    
    return ansarray;
}


-(void)insertAnswers:(Answers *)objClass{
    
    database=nil;
    
    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database)==SQLITE_OK)
	{
        NSString *query=nil;
        
        query=[NSString stringWithFormat:@"INSERT INTO Answers (survey_Id,question_Order,answer_Order,userId) values (\"%@\",\"%@\",\"%@\",\"%@\")",objClass.surveyId,objClass.questionOrder,objClass.answerOrder,objClass.userId];
        
        char *error;
        if ( sqlite3_exec(database, [query UTF8String], NULL, NULL, &error) == SQLITE_OK)
        {
            NSLog(@"success");
        }
        else {
            NSLog(@"fail");
        }
        
        
    }
    sqlite3_close(database);
    
}

-(void)updateAnswers:(NSString *)SqlQuery{

    database=nil;

    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database)==SQLITE_OK)
	{
        const char *sql = [SqlQuery UTF8String];
        sqlite3_stmt* updateStatement;
        if(sqlite3_prepare_v2(database, sql, -1, &updateStatement,NULL) == SQLITE_OK)
		{
			while(sqlite3_step(updateStatement) == SQLITE_ROW)
			{
                Answers *ans =[[Answers alloc]init];
                
                ans.surveyId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(updateStatement, 1)];
                ans.questionOrder=[NSString stringWithUTF8String:(char *)sqlite3_column_text(updateStatement, 2)];
                ans.answerOrder=[NSString stringWithUTF8String:(char *)sqlite3_column_text(updateStatement, 3)];
                ans.userId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(updateStatement, 4)];
            }
        }else
		{
			NSAssert1(0,@"Error : %s",sqlite3_errmsg(database));
		}
		sqlite3_finalize(updateStatement);
    }
    sqlite3_close(database);

}


//****************** delete statements ************************************************

-(void)deletePolls
{
    database=nil;
    
    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database)==SQLITE_OK)
	{
    sqlite3_stmt* deleteStatement;
    
    const char* sql = "delete from PollsTable";
    
    if (sqlite3_prepare_v2(database, sql, -1, &deleteStatement, NULL) != SQLITE_OK)
    {
        NSAssert1(0, @"Error: failed to prepare delete statement with message '%s'.", sqlite3_errmsg(database));
    }
    
    
    //sqlite3_bind_int(deleteStatement, 1, sId);
    
    sqlite3_step(deleteStatement);
	
	sqlite3_finalize(deleteStatement);
    }
    
}

-(void)deleteQuestions
{
    database=nil;
    
    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database)==SQLITE_OK)
	{
        sqlite3_stmt* deleteStatement;
        
        const char* sql = "delete from QuestionsTable";
        
        if (sqlite3_prepare_v2(database, sql, -1, &deleteStatement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error: failed to prepare delete statement with message '%s'.", sqlite3_errmsg(database));
        }
        
        
        //sqlite3_bind_int(deleteStatement, 1, sId);
        
        sqlite3_step(deleteStatement);
        
        sqlite3_finalize(deleteStatement);
    }
    
}


-(void)deleteOptions
{
    database=nil;
    
    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database)==SQLITE_OK)
	{
        sqlite3_stmt* deleteStatement;
        
        const char* sql = "delete from OptionsTable";
        
        if (sqlite3_prepare_v2(database, sql, -1, &deleteStatement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error: failed to prepare delete statement with message '%s'.", sqlite3_errmsg(database));
        }
        
        
        //sqlite3_bind_int(deleteStatement, 1, sId);
        
        sqlite3_step(deleteStatement);
        
        sqlite3_finalize(deleteStatement);
    }
    
}

-(void)deleteAnswers{
    
    database=nil;
    
    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database)==SQLITE_OK)
	{
        sqlite3_stmt* deleteStatement;
        
        const char* sql = "delete from Answers";
        
        if (sqlite3_prepare_v2(database, sql, -1, &deleteStatement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error: failed to prepare delete statement with message '%s'.", sqlite3_errmsg(database));
        }
        
        
        //sqlite3_bind_int(deleteStatement, 1, sId);
        
        sqlite3_step(deleteStatement);
        
        sqlite3_finalize(deleteStatement);
    }

}


-(void)deleteParticularPoll:(NSString *)pollId
{
    sqlite3_stmt* deleteStatement;
    
    const char* sql = "delete from PollsTable where survey_Id = ?";
    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database) == SQLITE_OK) {
    
    if (sqlite3_prepare_v2(database, sql, -1, &deleteStatement, NULL) != SQLITE_OK)
    {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
    
    sqlite3_bind_text(deleteStatement, 1, [pollId UTF8String], -1, SQLITE_TRANSIENT);
   // sqlite3_bind_int(deleteStatement, 1, pollId);
    
    sqlite3_step(deleteStatement);
    
    sqlite3_finalize(deleteStatement);
    }
    sqlite3_close(database);
    
}


-(void)deleteAnswerWithsID:(NSInteger)ansId
{
    sqlite3_stmt* deleteStatement;
    
    const char* sql = "delete from Answers where ansId = ?";
    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database) == SQLITE_OK) {
    
    if (sqlite3_prepare_v2(database, sql, -1, &deleteStatement, NULL) != SQLITE_OK)
    {
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
    }
        
    sqlite3_bind_int(deleteStatement, 1, ansId);
    
    sqlite3_step(deleteStatement);
    
    sqlite3_finalize(deleteStatement);
    }
    sqlite3_close(database);
    
}

-(void)deleteAnswersForsurveyID:(NSString *)surveyId
{
    sqlite3_stmt* deleteStatement;
    
    const char* sql = "delete from Answers where survey_Id = ?";
    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database) == SQLITE_OK) {
        
        if (sqlite3_prepare_v2(database, sql, -1, &deleteStatement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_text(deleteStatement, 1, [surveyId UTF8String], -1, SQLITE_TRANSIENT);
        // sqlite3_bind_int(deleteStatement, 1, pollId);
        
        sqlite3_step(deleteStatement);
        
        sqlite3_finalize(deleteStatement);
    }
    sqlite3_close(database);
    
}

-(void)deleteAnswersGreaterThanQuestionId:(NSString *)qId andsurveyid:(NSString *)surveyId{
    
    sqlite3_stmt* deleteStatement;
    
    const char* sql = "delete from Answers where survey_Id = ? and question_Order >= ?";
    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database) == SQLITE_OK) {
        
        if (sqlite3_prepare_v2(database, sql, -1, &deleteStatement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
        
        sqlite3_bind_text(deleteStatement, 1, [surveyId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(deleteStatement, 2, [qId UTF8String], -1, SQLITE_TRANSIENT);
        // sqlite3_bind_int(deleteStatement, 1, pollId);
        
        sqlite3_step(deleteStatement);
        
        sqlite3_finalize(deleteStatement);
    }
    sqlite3_close(database);
    
}


-(void)deleteimageUrls
{
    database=nil;
    
    if(sqlite3_open([[DBCOnnectClass getSqlitePath] UTF8String], &database)==SQLITE_OK)
	{
        sqlite3_stmt* deleteStatement;
        
        const char* sql = "delete from imageUrls";
        
        if (sqlite3_prepare_v2(database, sql, -1, &deleteStatement, NULL) != SQLITE_OK)
        {
            NSAssert1(0, @"Error: failed to prepare delete statement with message '%s'.", sqlite3_errmsg(database));
        }
        
        
        //sqlite3_bind_int(deleteStatement, 1, sId);
        
        sqlite3_step(deleteStatement);
        
        sqlite3_finalize(deleteStatement);
    }
    
}


@end
