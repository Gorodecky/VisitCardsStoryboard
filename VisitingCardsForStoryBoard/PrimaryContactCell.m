//
//  PrimaryContactCell.m
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 19.05.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import "PrimaryContactCell.h"
#import "Contact.h"

@interface PrimaryContactCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@end

@implementation PrimaryContactCell

- (void)awakeFromNib {
    // Initialization code
    
    [_nameTextField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    
    [_lastNameTextField addTarget:self
                           action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
    
    [_companyNameTextField addTarget:self
                              action:@selector(textFieldDidChange:)
                    forControlEvents:UIControlEventEditingChanged];
    
    _nameTextField.tag = 1000;
    _lastNameTextField.tag = 1001;
    _companyNameTextField.tag = 1002;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateUI {
    
    self.nameTextField.text = self.contact.name;
    self.lastNameTextField.text = self.contact.lastName;
    self.companyNameTextField.text = self.contact.companyName;
        
}


-(void)textFieldDidChange :(UITextField *)theTextField{
    
    NSLog( @"text changed: %@", theTextField.text);
    
    if (theTextField.tag == 1000) {

        self.contact.name = theTextField.text;
        
    }
    
    if (theTextField.tag == 1001) {
        self.contact.lastName = theTextField.text;
    }
    
    if (theTextField.tag == 1002 ) {
        self.contact.companyName = theTextField.text;
    }
    
}


@end
