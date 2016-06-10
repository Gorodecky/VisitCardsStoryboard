//
//  PrimaryContactCell.h
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 19.05.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contact;

@interface PrimaryContactCell : UITableViewCell

@property (nonatomic, strong) Contact *contact;

- (void) updateUI;


@end

static NSString * const primaryContactCellIdentifier = @"primaryContactCellIdentifier";
