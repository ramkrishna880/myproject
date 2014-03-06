//
//  Options.h
//  Polls
//
//  Created by Hadi Hatunoglu on 01/02/13.
//  Copyright (c) 2013 Hadi Hatunoglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Options : NSObject

@property(nonatomic,strong)NSString *questionOrder;
@property(nonatomic,strong)NSString *optionOrder;
@property(nonatomic,strong)NSString *option;
@property(nonatomic,strong)NSString *surveyId;
@property(nonatomic,assign)int next;
@end
