//
//  Contact.h
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 14.03.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Contact :  NSManagedObject

@property (nonatomic, retain) NSString * categoryContactList;
@property (nonatomic, retain) NSString * companyAddressCity;
@property (nonatomic, retain) NSString * companyAddressCountry;
@property (nonatomic, retain) NSString * companyAddressNumberHouse;
@property (nonatomic, retain) NSString * companyAddressNumberOffice;
@property (nonatomic, retain) NSString * companyAddresStreet;
@property (nonatomic, retain) NSString * companyAddressURL;
@property (nonatomic, retain) NSString * companyName;
@property (nonatomic, retain) NSString * companyTelephone1;
@property (nonatomic, retain) NSString * companyTelephone2;
@property (nonatomic, retain) NSString * companyTelephoneFax;
@property (nonatomic, retain) NSString * contactID;
@property (nonatomic, retain) NSString * contactNotes;
@property (nonatomic, retain) NSString * contactPosition;
@property (nonatomic, retain) NSString * contactPrivateURL;
@property (nonatomic, retain) NSString * contactTelephone1;
@property (nonatomic, retain) NSString * contactTelephone2;
@property (nonatomic, retain) NSString * contactTelephone3;
@property (nonatomic, retain) NSDate * dateOfCreationContact;
@property (nonatomic, retain) NSString * emailPrivate;
@property (nonatomic, retain) NSString * emailWork;
@property (nonatomic, retain) NSString * kardPhotoBack;
@property (nonatomic, retain) NSString * kardPhotoFront;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * skype;
@property (nonatomic, retain) NSString * surName;

@end
