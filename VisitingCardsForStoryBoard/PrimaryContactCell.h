//
//  PrimaryContactCell.h
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 19.05.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilite.h"

#define kOFFSET_FOR_KEYBOARD 80.0

@class Contact;

@interface PrimaryContactCell : UITableViewCell


@property (nonatomic, strong) Contact *contact;
@property (assign, nonatomic) StatusViewType viewType;


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

- (void) updateUI;

@end

static NSString * const primaryContactCellIdentifier = @"primaryContactCellIdentifier";
