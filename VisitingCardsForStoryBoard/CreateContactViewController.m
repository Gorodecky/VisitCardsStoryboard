//
//  CreateContactViewController.m
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 04.04.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import "CreateContactViewController.h"
#import "Contact.h"
#import "PrimaryContactCell.h"
#import "ImagesCardTableViewCell.h"
#import "SecondaryContactCell.h"
#import "Utilite.h"
#import "Contact+TempContact.h"

typedef enum {
    
    newContact,
    
    editContact,
    
} StatusViewType;

@interface CreateContactViewController () <UITableViewDataSource, UITableViewDelegate> {
    
    StatusViewType screenType;
}

@property (strong, nonatomic) Contact* tmpContact;

@end


@implementation CreateContactViewController

//@synthesize contact;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Back Button Item//
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(back:)];
    
    self.navigationItem.leftBarButtonItem = newBackButton;//Back Button Item
    
    // Підєднання комірок
    
    UINib * nibImageCardCell = [UINib nibWithNibName:@"ImagesCardTableViewCell" bundle:nil];
    [[self tableView] registerNib:nibImageCardCell forCellReuseIdentifier:imageCardCellIdentifier];
    
    UINib * nibPrimaryConactCell = [UINib nibWithNibName:@"PrimaryContactCell" bundle:nil];
    [[self tableView] registerNib:nibPrimaryConactCell forCellReuseIdentifier:primaryContactCellIdentifier];
    
    UINib * nibSecondaryContactCell = [UINib nibWithNibName:@"SecondaryContactCell" bundle:nil];
    [[self tableView] registerNib:nibSecondaryContactCell forCellReuseIdentifier:secondCellIdentifier];
    
    // перевіряє чи слід створювати новий контакт чи використовувати існуючий
    
    if (self.contact) {
        screenType = editContact;
        //self.tmpContact = [Contact tempContact:self.contact];
        
    } else {
        screenType = newContact;

    }
    
    if (screenType == newContact) {
        
        self.contact = [NSEntityDescription
                           insertNewObjectForEntityForName:@"Contact"
                           inManagedObjectContext:[Utilite managedObjectContext]];
        
        self.tmpContact = [Contact tempContact:self.contact];

        
    } else {
        
        self.tmpContact = [Contact tempContact:self.contact];

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        //повертає першу комірку з фото
        ImagesCardTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:imageCardCellIdentifier];
        
        return cell;
        
    } else if (indexPath.row == 1) {
        //повертає другу комірку з головними даними
        PrimaryContactCell* cell = [tableView dequeueReusableCellWithIdentifier:primaryContactCellIdentifier];
        
        cell.contact = self.tmpContact;
        [cell updateUI];
        
        return cell;
        
    } else {
        //повертає інші комірки
        SecondaryContactCell* cell = [tableView
                                      dequeueReusableCellWithIdentifier:secondCellIdentifier];
        return cell;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return 119.0;
        
    } else if (indexPath.row == 1) {
        
        return 163.0;
        
    } else {
        
        return 44.0;
    }
}

# pragma mark - Action

- (IBAction)saveButton:(id)sender {
    
    
    [self.contact updateWithContactInformation:self.tmpContact];

    NSManagedObjectContext* context = [Utilite managedObjectContext];
    
    NSError* error = nil;
    
    if (![context save:&error]) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert!!!"
                                                        message:@"Save is not complit!!!"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        
        NSLog(@"Save ERROR %@, %@", error, [error localizedDescription]);
        
    } else {
        
        
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Save is complit!"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (void) back:(UIBarButtonItem *)sender {
    
    if (screenType == newContact) {
        
        if ([self.tmpContact isEqualContact:self.contact]) {
            
            [[Utilite managedObjectContext] deleteObject:self.contact];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            //[self.contact updateWithContactInformation:self.tmpContact];

            [self saveButton:nil];
            //[self.navigationController popViewControllerAnimated:YES];

            
        }
    } else {
        
        if ([self.tmpContact isEqualContact:self.contact]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            //UIAlertController!!!
            
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"ALERT!!!"
                                        message:@"Contact changed!!!"
                                        preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* actionSave = [UIAlertAction
                                         actionWithTitle:@"Save"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction *  action) {
                                             //чи потрібна тут перевірка на відсутність тексту???
                                             //[self.contact updateWithContactInformation:self.tmpContact];
                                             [self saveButton:nil];
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }];
            
            UIAlertAction* actionCancel = [UIAlertAction
                                           actionWithTitle:@"Cancel"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *  action) {
                                               
                                               [self.navigationController popViewControllerAnimated:YES];
                                           }];
            
            [alert addAction:actionCancel];
            [alert addAction:actionSave];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}
@end
