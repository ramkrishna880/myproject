//
//  Questions.h
//  NewPolls
//
//  Created by Hadi Hatunoglu on 30/01/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Questions : NSObject

@property(nonatomic,strong)NSString *surveyId;
@property(nonatomic,strong)NSString *qOrder;
@property(nonatomic,strong)NSString *question;
//@property(nonatomic,strong)NSString *pollId;
@property(nonatomic,strong)NSString *quesType;
@end
