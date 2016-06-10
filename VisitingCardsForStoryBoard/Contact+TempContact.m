//
//  Contact+TempContact.m
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 05.06.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import "Contact+TempContact.h"
#import "Utilite.h"


@implementation Contact (TempContact)


+ (Contact*) tempContact:(Contact*) contact {
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact"
                                              inManagedObjectContext:[Utilite managedObjectContext]];
    
    Contact *tmpContact = [[Contact alloc] initWithEntity:entity
                                           insertIntoManagedObjectContext:nil];
    tmpContact.name = contact.name;
    tmpContact.lastName = contact.lastName;
    tmpContact.companyName = contact.companyName;
    tmpContact.contactTelephone1 = contact.contactTelephone1;
    
    tmpContact.categoryContactList = contact.categoryContactList;
    tmpContact.companyAddressCity = contact.companyAddressCity;
    /*
    @dynamic companyAddressCountry;
    @dynamic companyAddressNumberHouse;
    @dynamic companyAddressNumberOffice;
    @dynamic companyAddresStreet;
    @dynamic companyAddressURL;
    @dynamic companyName;
    @dynamic companyTelephone1;
    @dynamic companyTelephone2;
    @dynamic companyTelephoneFax;
    @dynamic contactID;
    @dynamic contactNotes;
    @dynamic contactPosition;
    @dynamic contactPrivateURL;
    @dynamic contactTelephone1;
    @dynamic contactTelephone2;
    @dynamic contactTelephone3;
    @dynamic dateOfCreationContact;
    @dynamic emailPrivate;
    @dynamic emailWork;
    @dynamic kardPhotoBack;
    @dynamic kardPhotoFront;
    @dynamic lastName;
    @dynamic name;
    @dynamic skype;
    @dynamic surName;
    */
    return tmpContact;
}



- (BOOL) isEqualContact:(Contact*) contact {
    
    if ([self isParametersEqual:self.name secondParameter:contact.name]) {//[self isParametersEqual:self.lastName secondParameter:contact.lastName]
        
        return YES;
    } else {
    
    return NO;
    }
}

- (BOOL) isParametersEqual:(NSString*)firstParameter secondParameter:(NSString*)secondParameter {
    
    if (firstParameter == nil && secondParameter == nil) {
        //поля лдгпкові
    } else {
        
        if ([secondParameter isEqualToString:firstParameter] == NO) {
            
            return NO;
            
        }
        return YES;
    }
    
    return YES;

}

- (void) updateWithContactInformation:(Contact*) contact {
    
    self.name = contact.name;
    self.lastName = contact.lastName;
    self.companyName = contact.companyName;
}

@end
