//
//  Answers.m
//  Polls
//
//  Created by Hadi Hatunoglu on 02/02/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import "Answers.h"

@implementation Answers
@synthesize surveyId,ansId,questionOrder,answerOrder,userId;

-(id)init{
    self=[super init];
    if (self) {
        
        surveyId=questionOrder=answerOrder=userId=@"";
    }
    return self;
}
@end
