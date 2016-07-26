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

-(void)prepareForReuse {
    
    [super prepareForReuse];
    self.visitingCardImage.image =  [UIImage imageNamed:@"placeholder.png"];
    self.firstNameLable.text =     @"";
    self.lastNameLable.text =      @"";
    self.companyNameLable.text =   @"";
    self.phoneContactLable.text =  @"";
    
}

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
    self.phoneContactLable.text = self.contact.contactTelephone1;
    
    
    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Images"];
    
    // New Folder is your folder name
    
    NSString *fullFileName = [stringPath stringByAppendingString:
                              [NSString stringWithFormat:@"/%@",
                               [self.contact valueForKey:@"kardPhotoFront"]]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullFileName]) {
        UIImage *image = [UIImage imageWithContentsOfFile:fullFileName];
        
        [self.visitingCardImage setImage:image];
        
    }
}

@end
