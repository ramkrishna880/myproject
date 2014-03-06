//
//  Answers.h
//  Polls
//
//  Created by Hadi Hatunoglu on 02/02/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Answers : NSObject

@property(nonatomic,assign)int ansId;
@property(nonatomic,strong)NSString *surveyId;
@property(nonatomic,strong)NSString *questionOrder;
@property(nonatomic,strong)NSString *answerOrder;
@property(nonatomic,strong)NSString *userId;
//@property(nonatomic,strong)NSString *optionId;

@end
