//
//  Section.h
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 12.05.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Section : NSObject

@property (strong, nonatomic) NSString* sectionName;
@property (strong, nonatomic) NSMutableArray* itemsArray;

@end
