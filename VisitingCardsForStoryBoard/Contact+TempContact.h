//
//  Contact+TempContact.h
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 05.06.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import "Contact.h"

@interface Contact (TempContact)

+ (Contact*) tempContact:(Contact*) contact;
- (BOOL) isEqualContact:(Contact*) contact;
- (void) updateWithContactInformation:(Contact*) contact;
@end
