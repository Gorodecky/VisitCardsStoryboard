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
    
    tmpContact.name                          = contact.name;
    tmpContact.lastName                      = contact.lastName;
    tmpContact.surName                       = contact.surName;
    tmpContact.companyName                   = contact.companyName;
    tmpContact.contactTelephone1             = contact.contactTelephone1;
    
    tmpContact.categoryContactList           = contact.categoryContactList;
    tmpContact.companyAddressCity            = contact.companyAddressCity;
    tmpContact.companyAddressCountry         = contact.companyAddressCountry;
    tmpContact.companyAddressNumberHouse     = contact.companyAddressNumberHouse;
    tmpContact.companyAddressNumberOffice    = contact.companyAddressNumberOffice;
    tmpContact.companyAddresStreet           = contact.companyAddresStreet;
    tmpContact.companyAddressURL             = contact.companyAddressURL;
    tmpContact.companyName                   = contact.companyName;
    tmpContact.companyTelephone1             = contact.companyTelephone1;
    tmpContact.companyTelephone2             = contact.companyTelephone2;
    tmpContact.companyTelephoneFax           = contact.companyTelephoneFax;
    tmpContact.contactID                     = contact.contactID;
    tmpContact.contactNotes                  = contact.contactNotes;
    tmpContact.contactPosition               = contact.contactPosition;
    tmpContact.contactPrivateURL             = contact.contactPrivateURL;
    tmpContact.contactTelephone2             = contact.contactTelephone2;
    tmpContact.contactTelephone3             = contact.contactTelephone3;
    tmpContact.dateOfCreationContact         = contact.dateOfCreationContact;
    tmpContact.emailPrivate                  = contact.emailPrivate;
    tmpContact.emailWork                     = contact.emailWork;
    tmpContact.skype                         = contact.skype;
    tmpContact.kardPhotoFront                = contact.kardPhotoFront;
    tmpContact.kardPhotoBack                 = contact.kardPhotoBack;
    
    return tmpContact;
}

- (BOOL) isEqualContact:(Contact*) contact {
    
    if ([self isParametersEqual:self.name                        secondParameter:contact.name] &&
        [self isParametersEqual:self.lastName                    secondParameter:contact.lastName] &&
        [self isParametersEqual:self.companyName                 secondParameter:contact.companyName] &&
        
        [self isParametersEqual:self.contactTelephone1           secondParameter:contact.contactTelephone1] &&
        [self isParametersEqual:self.contactTelephone2           secondParameter:contact.contactTelephone2] &&
        [self isParametersEqual:self.contactTelephone3           secondParameter:contact.contactTelephone3] &&
        [self isParametersEqual:self.emailPrivate                secondParameter:contact.emailPrivate] &&
        [self isParametersEqual:self.emailWork                   secondParameter:contact.emailWork] &&
        [self isParametersEqual:self.surName                     secondParameter:contact.surName] &&
        [self isParametersEqual:self.skype                       secondParameter:contact.skype] &&
        [self isParametersEqual:self.companyTelephone1           secondParameter:contact.companyTelephone1] &&
        [self isParametersEqual:self.companyTelephone2           secondParameter:contact.companyTelephone2] &&
        [self isParametersEqual:self.companyTelephoneFax         secondParameter:contact.companyTelephoneFax] &&
        [self isParametersEqual:self.companyAddressCity          secondParameter:contact.companyAddressCity] &&
        [self isParametersEqual:self.companyAddressCountry       secondParameter:contact.companyAddressCountry] &&
        [self isParametersEqual:self.companyAddressNumberHouse   secondParameter:contact.companyAddressNumberHouse] &&
        [self isParametersEqual:self.companyAddressNumberOffice  secondParameter:contact.companyAddressNumberOffice] &&
        [self isParametersEqual:self.companyAddresStreet         secondParameter:contact.companyAddresStreet] &&
        [self isParametersEqual:self.companyAddressURL           secondParameter:contact.companyAddressURL] &&
        [self isParametersEqual:self.contactPrivateURL           secondParameter:contact.contactPrivateURL] &&
        [self isParametersEqual:self.contactNotes                secondParameter:contact.contactNotes] &&
        [self isParametersEqual:self.kardPhotoFront              secondParameter:contact.kardPhotoFront] &&
        [self isParametersEqual:self.kardPhotoBack               secondParameter:contact.kardPhotoBack]) {
        
        return YES;
    } else {
        
        return NO;
    }
}

- (BOOL) isParametersEqual:(NSString*)firstParameter secondParameter:(NSString*)secondParameter {
    
    if (firstParameter == nil && secondParameter == nil) {
        
        return YES;
        
        
    } else {
        
        if ([secondParameter isEqualToString:firstParameter] == NO) {
            
            return NO;
        }
        return YES;
    }
    return YES;
}

- (void) updateWithContactInformation:(Contact*) contact {
    self.name                          = contact.name;
    self.lastName                      = contact.lastName;
    self.surName                       = contact.surName;
    self.companyName                   = contact.companyName;
    self.contactTelephone1             = contact.contactTelephone1;
    
    self.categoryContactList           = contact.categoryContactList;
    self.companyAddressCity            = contact.companyAddressCity;
    self.companyAddressCountry         = contact.companyAddressCountry;
    self.companyAddressNumberHouse     = contact.companyAddressNumberHouse;
    self.companyAddressNumberOffice    = contact.companyAddressNumberOffice;
    self.companyAddresStreet           = contact.companyAddresStreet;
    self.companyAddressURL             = contact.companyAddressURL;
    self.companyName                   = contact.companyName;
    self.companyTelephone1             = contact.companyTelephone1;
    self.companyTelephone2             = contact.companyTelephone2;
    self.companyTelephoneFax           = contact.companyTelephoneFax;
    self.contactID                     = contact.contactID;
    self.contactNotes                  = contact.contactNotes;
    self.contactPosition               = contact.contactPosition;
    self.contactPrivateURL             = contact.contactPrivateURL;
    self.contactTelephone2             = contact.contactTelephone2;
    self.contactTelephone3             = contact.contactTelephone3;
    self.dateOfCreationContact         = contact.dateOfCreationContact;
    self.emailPrivate                  = contact.emailPrivate;
    self.emailWork                     = contact.emailWork;
    self.skype                         = contact.skype;
    self.kardPhotoBack                 = contact.kardPhotoBack;
    self.kardPhotoFront                = contact.kardPhotoFront;
}

@end
