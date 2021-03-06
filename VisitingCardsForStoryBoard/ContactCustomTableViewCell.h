//
//  ContactCustomTableViewCell.h
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 08.04.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contact;

@interface ContactCustomTableViewCell : UITableViewCell

@property (nonatomic, strong) Contact *contact;


@property (weak, nonatomic) IBOutlet UIImageView *visitingCardImage;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLable;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLable;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLable;
@property (weak, nonatomic) IBOutlet UILabel *phoneContactLable;

-(void) updateCustomCell;

@end
