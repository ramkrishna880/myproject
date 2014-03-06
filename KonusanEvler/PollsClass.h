//
//  PollsClass.h
//  NewPolls
//
//  Created by Hadi Hatunoglu on 30/01/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PollsClass : NSObject

@property(nonatomic,strong)NSString *surveyId;
@property(nonatomic,strong)NSString *surveyTopic;
@property(nonatomic,strong)NSString *surveyDefination;
@property(nonatomic,strong)NSString *surveyStrtdate;
@property(nonatomic,strong)NSString *surveyExpiredate;
@property(nonatomic,strong)NSString *surveyPoints;
@end
