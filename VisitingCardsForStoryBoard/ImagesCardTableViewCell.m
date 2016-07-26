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
    self.aversImageButton.tag = LEFT_IMAGE_BUTTON_TAG;
    self.reversImageButton.tag = RIGHT_IMAGE_BUTTON_TAG;
    
}

- (void) updateUIImage {
    
    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains
                             (NSDocumentDirectory, NSUserDomainMask, YES)
                             objectAtIndex:0]stringByAppendingPathComponent:@"Images"];
    
    NSString *fullFileName1 = [stringPath stringByAppendingString:
                               [NSString stringWithFormat:@"/%@",self.contact.kardPhotoFront]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullFileName1]) {
        
        UIImage *image = [UIImage imageWithContentsOfFile:fullFileName1];
        self.aversImagesVisitingCard.image = image;
        
    }
    
    //////////////
    
    NSString* fullFileName2 = [stringPath stringByAppendingString:
                               [NSString stringWithFormat:@"/%@", self.contact.kardPhotoBack]];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:fullFileName2]) {
        
        UIImage* image = [UIImage imageWithContentsOfFile:fullFileName2];
        self.reversImagesVisitingCard.image = image;
        
    }
    
    NSString *string1 =self.contact.kardPhotoFront;
    
    if (string1 != nil) {
        
        [self.aversImageButton setTitle:@"" forState:UIControlStateNormal];
    } else {
        [self.aversImageButton setTitle:@"Add image" forState:UIControlStateNormal];
    }
    
    NSString *string2 =self.contact.kardPhotoBack;
    
    if (string2 != nil) {
        
        [self.reversImageButton setTitle:@"" forState:UIControlStateNormal];
        
    } else {
        
        [self.reversImageButton setTitle:@"Add image" forState:UIControlStateNormal];
    }
    
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
