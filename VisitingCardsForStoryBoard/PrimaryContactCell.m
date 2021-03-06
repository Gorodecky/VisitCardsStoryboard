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
    
    [self setBackgroundColor:[UIColor whiteColor]];

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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
   
    //NSLog(@"%u", self.viewType);

    
    if (self.viewType == reviewContact) {
        
        return NO;
        
    } else {
        
        return YES;
    }
    
}// return NO to disallow editing.


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_nameTextField resignFirstResponder];
    [_lastNameTextField resignFirstResponder];
    [_companyNameTextField resignFirstResponder];
    [_phoneTextField resignFirstResponder];
    
    return NO;
}
#pragma mark - keyboard
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //activeField = textField;
    
    [self.delegate keyboardIsSow:textField];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //activeField = nil;
    [self.delegate keyboardIsSow:textField];

    
}


@end
