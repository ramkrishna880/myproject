//
//  Options.m
//  Polls
//
//  Created by Hadi Hatunoglu on 01/02/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import "Options.h"

@implementation Options

@synthesize questionOrder,optionOrder,option,surveyId,next;

-(id)init{
    self=[super init];
    if (self) {
        
        questionOrder=optionOrder=option=surveyId=@"";
        next=0;
    }
    return self;
}

@end
