//
//  imageUrls.m
//  KonusanEvler
//
//  Created by Baraansoft on 18/02/14.
//  Copyright (c) 2014 Hadi Hatunoglu. All rights reserved.
//

#import "imageUrls.h"

@implementation imageUrls
@synthesize imageName,rowDate;

-(id)init{
    self=[super init];
    if (self) {
        
      rowDate=imageName=@"";
       
    }
    return self;
}
@end
