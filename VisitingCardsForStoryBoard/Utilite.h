//
//  Utilite.h
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 31.05.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface Utilite : NSObject

+ (NSManagedObjectContext*) managedObjectContext;

@end


typedef enum {
    
    newContact,
    editContact,
    reviewContact
    
} StatusViewType;