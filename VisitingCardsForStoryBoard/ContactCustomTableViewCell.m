//
//  ContactCustomTableViewCell.m
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 08.04.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import "ContactCustomTableViewCell.h"

#import "Contact.h"

@implementation ContactCustomTableViewCell


- (void)awakeFromNib {
    // Initialization code
    self.visitingCardImage.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) updateCustomCell {
    
    self.firstNameLable.text = self.contact.name;
    self.lastNameLable.text = self.contact.lastName;
    self.companyNameLable.text = self.contact.companyName;
    self.telephoneContactLable.text = self.contact.contactTelephone1;
    
    
}

@end
