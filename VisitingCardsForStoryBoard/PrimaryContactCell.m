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


@end

@implementation PrimaryContactCell

- (void)awakeFromNib {
    // Initialization code
    _nameTextField.delegate =
    _lastNameTextField.delegate =
    _companyNameTextField.delegate =
    _phoneTextField.delegate = self;
    
    [_nameTextField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    
    [_lastNameTextField addTarget:self
                           action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
    
    [_companyNameTextField addTarget:self
                              action:@selector(textFieldDidChange:)
                    forControlEvents:UIControlEventEditingChanged];
    [_phoneTextField addTarget:self
                        action:@selector(textFieldDidChange:)
              forControlEvents:UIControlEventEditingChanged];
    
    _nameTextField.tag        = 1000;
    _lastNameTextField.tag    = 1001;
    _companyNameTextField.tag = 1002;
    _phoneTextField.tag       = 1003;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)updateUI {
    
    self.nameTextField.text = self.contact.name;
    self.lastNameTextField.text = self.contact.lastName;
    self.companyNameTextField.text = self.contact.companyName;
    self.phoneTextField.text = self.contact.contactTelephone1;
        
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    
    if (theTextField.tag == 1000) {
        self.contact.name = theTextField.text;
    }
    
    if (theTextField.tag == 1001) {
        self.contact.lastName = theTextField.text;
    }
    
    if (theTextField.tag == 1002 ) {
        self.contact.companyName = theTextField.text;
    }
    
    if (theTextField.tag == 1003) {
        self.contact.contactTelephone1 = theTextField.text;
    }
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //[self.view endEditing:YES];
    
    [_nameTextField resignFirstResponder];
    [_lastNameTextField resignFirstResponder];
    [_companyNameTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    
    

    return NO;
}


@end
