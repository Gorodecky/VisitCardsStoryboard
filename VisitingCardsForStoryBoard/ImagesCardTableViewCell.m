//
//  TableViewCell.m
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 18.05.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import "ImagesCardTableViewCell.h"


@implementation ImagesCardTableViewCell


- (void)awakeFromNib {
    self.aversImageButton.tag = 2001;
    self.reversImageButton.tag = 2002;
     
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
