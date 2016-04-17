//
//  CreateContactViewController.m
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 04.04.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import "CreateContactViewController.h"
#import "Contact.h"

@interface CreateContactViewController ()

@end

@implementation CreateContactViewController
@synthesize contact;


- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.contact) {
        
        
        [self.nameTextField setText:[self.contact valueForKey:@"name"]];
        [self.lastNameTextField setText:[self.contact valueForKey:@"lastName"]];
        [self.companyNameTextField setText:[self.contact valueForKey:@"companyName"]];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - NSManagedObjectContext
- (NSManagedObjectContext*) managedObjectContext {
    
    NSManagedObjectContext* context = nil;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

# pragma mark - Action

- (IBAction)saveButton:(id)sender {
   
    NSManagedObjectContext* context = [self managedObjectContext];
    
    if (self.contact) {
        
        [self.contact setValue:self.nameTextField.text forKey:@"name"];
        [self.contact setValue:self.lastNameTextField.text forKey:@"lastName"];
        [self.contact setValue:self.companyNameTextField.text forKey:@"companyName"];
        
    } else {
        NSManagedObject* newContact = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Contact"
                                       inManagedObjectContext:context];
        
        [newContact setValue:self.nameTextField.text forKey:@"name"];
        [newContact setValue:self.lastNameTextField.text forKey:@"lastName"];
        [newContact setValue:self.companyNameTextField.text forKey:@"companyName"];
        
    }
    
    NSError* error = nil;
    
    if (![context save:&error]) {
        NSLog(@"Save ERROR %@, %@", error, [error localizedDescription]);
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Save is complit" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }
    
}
@end
