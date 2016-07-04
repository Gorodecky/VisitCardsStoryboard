//
//  TableViewCell.m
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 18.05.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import "ImagesCardTableViewCell.h"
#import "Contact.h"

@implementation ImagesCardTableViewCell


- (void)awakeFromNib {
    
    self.aversImageButton.tag = LEFT_IAGE_BUTTON_TAG;
    self.reversImageButton.tag = RIGHT_IAGE_BUTTON_TAG;
    
    

}
/*
- (void)updateUI {
    
    self.nameTextField.text = self.contact.name;
*/

- (void) updateUIImage {
    
    self.aversImagesVisitingCard.image = [UIImage imageWithContentsOfFile:self.contact.kardPhotoFront];
    self.reversImagesVisitingCard.image = [UIImage imageWithContentsOfFile:self.contact.kardPhotoBack];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    // Configure the view for the selected state
}


- (IBAction)touchButton:(id)sender {// при натисканні
    
    UIButton* button = (UIButton *)sender;
    
    [self.delegate imagesCartTableViewCell:button.tag];
    
    
       NSLog(@"%@", sender);
    

}
@end
