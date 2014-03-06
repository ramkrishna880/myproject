//
//  PollsClass.m
//  NewPolls
//
//  Created by Hadi Hatunoglu on 30/01/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import "PollsClass.h"

@implementation PollsClass

@synthesize surveyId,surveyTopic,surveyDefination,surveyStrtdate,surveyExpiredate,surveyPoints;

-(id)init{
    self=[super init];
    if (self) {
        
        surveyId=surveyTopic=surveyDefination=surveyStrtdate=surveyExpiredate=surveyPoints=@"";
    }
    return self;
}
@end
