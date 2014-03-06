//
//  Questions.m
//  NewPolls
//
//  Created by Hadi Hatunoglu on 30/01/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import "Questions.h"

@implementation Questions

@synthesize surveyId,qOrder,question,quesType;

-(id)init{
    self=[super init];
    if (self) {
        
        surveyId=qOrder=question=quesType=@"";
    }
    return self;
}


@end
