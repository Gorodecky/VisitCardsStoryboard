//
//  CreateContactViewController.h
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 04.04.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CreateContactViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyNameTextField;
@property (strong, nonatomic) NSManagedObject *contact;


- (IBAction)saveButton:(id)sender;


@end
