//
//  SecondaryContactCell.h
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 23.05.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondaryContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *addContactButton;

@end


static NSString* const secondCellIdentifier = @"secondCellIdentifier";