//
//  CreateContactViewController.m
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 04.04.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
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

@interface CreateContactViewController () <UITableViewDataSource,
                                           UITableViewDelegate,
                                           UIActionSheetDelegate,
                                           UITextFieldDelegate,
                                           ImageButtonDelegate,
                                           UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
    UIImage* tempImageFirst;
    UIImage* tempImageSecond;
    
    NSInteger tempTagForImageButton;
    
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
    
    UINib * nibImageCardCell = [UINib
                                nibWithNibName:@"ImagesCardTableViewCell"
                                bundle:nil];
    [[self tableView] registerNib:nibImageCardCell
           forCellReuseIdentifier:imageCardCellIdentifier];
    //////////
    UINib * nibPrimaryConactCell = [UINib
                                    nibWithNibName:@"PrimaryContactCell"
                                    bundle:nil];
    [[self tableView] registerNib:nibPrimaryConactCell
           forCellReuseIdentifier:primaryContactCellIdentifier];
    /////////////
    UINib * nibSecondaryContactCell = [UINib
                                       nibWithNibName:@"SecondaryContactCell"
                                       bundle:nil];
    [[self tableView] registerNib:nibSecondaryContactCell
           forCellReuseIdentifier:secondCellIdentifier];
    
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return 119.0;
        
    } else if (indexPath.row == 1) {
        
        return 163.0;
        
    } else {
        
        return 44.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        //повертає першу комірку з фото
        
        ImagesCardTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:imageCardCellIdentifier];
        
        cell.delegate = self;
        
        cell.aversImagesVisitingCard.image = [UIImage imageWithContentsOfFile:self.tmpContact.kardPhotoFront];
        cell.reversImagesVisitingCard.image = [UIImage imageWithContentsOfFile:self.tmpContact.kardPhotoBack];
        
        return cell;
        
    } else if (indexPath.row == 1) {
        //повертає другу комірку з головними даними
        PrimaryContactCell* cell = [tableView dequeueReusableCellWithIdentifier:primaryContactCellIdentifier];
        
        cell.contact = self.tmpContact;
        [cell updateUI];
        
        return cell;
        
    } else if (indexPath.row == 2) {
        //повертає інші комірки
        SecondaryContactCell* cell = [tableView
                                      dequeueReusableCellWithIdentifier:secondCellIdentifier];
        return cell;
    } else {
        
        static NSString * buttonAddSecondaryContact = @"addSecondaryCellIdentifier";
        
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:buttonAddSecondaryContact ];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:buttonAddSecondaryContact];
            
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"Add the contact information"];
        cell.textLabel.textColor = [UIColor greenColor];
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {//убирает клаватуру с екрана
        
    
        [self.view endEditing:YES] ;
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
            
            [self alertAction];
            //[self.contact updateWithContactInformation:self.tmpContact];

            //[self saveButton:nil];
            //[self.navigationController popViewControllerAnimated:YES];

            
        }
    } else {
        
        if ([self.tmpContact isEqualContact:self.contact]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            //UIAlertController!!!
            [self alertAction];
            
        }
    }
}

#pragma mark - AlertAction

- (void) actionSheet {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil preferredStyle:
                                 UIAlertControllerStyleActionSheet];
    
    UIAlertAction* actionCamera = [UIAlertAction
                                   actionWithTitle:@"Camera"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
                                       
                                       //создеме UIImagePickerController для камеры

                                       
                                       NSLog(@"camera");

                                       
                                       UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                       
                                       imagePicker.delegate = self;
                                       
                                       imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                       
                                       imagePicker.mediaTypes = @[(NSString*)kUTTypeImage];
                                       
                                       
                                       imagePicker.allowsEditing = YES;
                                       
                                       [self presentViewController:imagePicker animated:YES completion:nil];
                                       
                                   }];
    
    UIAlertAction* actionDirectiory = [UIAlertAction
                                       actionWithTitle:@"Galery"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action) {
                                           
                                           //создеме UIImagePickerController для фотоальбома
                                           
                                           UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                           
                                           imagePicker.modalPresentationStyle = UIModalPresentationPopover;
                                           
                                           imagePicker.delegate = self;
                                           
                                           imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                           
                                           imagePicker.mediaTypes = @[(NSString*)kUTTypeImage];
                                           
                                           imagePicker.allowsEditing = YES;
                                           
                                           
                                           
                                           [self presentViewController:imagePicker animated:YES completion:nil];
                                           
                                           NSLog(@"%@", imagePicker);
                                           
                                           

                                       }];
    
    UIAlertAction* actionCancel = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *  action) {
                                       
                                       // необхідно видалити тег!!!
                                       //[self createTag:];
                                       [self.navigationController popViewControllerAnimated:YES];
                                   
                                   }];
    
    [alert addAction:actionCamera];
    [alert addAction:actionDirectiory];
    [alert addAction:actionCancel];
    
    
    [self presentViewController:alert animated:YES completion:nil];


}

- (void) alertAction {
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    return NO;
}
#pragma mark - imagesCartTableViewCellDelegate

- (void) imagesCartTableViewCell:(NSInteger)tag {
    
    tempTagForImageButton = tag;
    
    [self actionSheet];
    
}
/*- (void) createTag:(int) tag {
    
    if (tag) {
        
        tag = nil;

    }
    
}*/

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage* image;
    
    if([info valueForKey:@"UIImagePickerControllerEditedImage"]) //isEqualToString:@"public.image"
    {
        
        image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
        
        //
        
        
        NSString *stringPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"Images"];
        
        // New Folder is your folder name
        
        NSError *error = nil;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath])
            
            [[NSFileManager defaultManager] createDirectoryAtPath:stringPath withIntermediateDirectories:NO attributes:nil error:&error];
        
        
        NSDate *today = [NSDate date];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        
        [dateFormat setDateFormat:@"MMddyyyy_HHmmssSS"];
        
        NSString *dateString = [dateFormat stringFromDate:today];
        
        NSString *fileName = [stringPath stringByAppendingFormat:@"/%@.png", dateString];
        
        NSData *data =  UIImagePNGRepresentation(image);//UIImagePNGRepresentation(image, 1.0);
        
        [data writeToFile:fileName atomically:YES];
        
        
        switch (tempTagForImageButton) {
            case LEFT_IAGE_BUTTON_TAG:
                self.tmpContact.kardPhotoFront = fileName;
                break;
            case RIGHT_IAGE_BUTTON_TAG:
                self.tmpContact.kardPhotoBack = fileName;
                break;
            default:
                break;
        }
                
        [self.tableView reloadData];
        
        
        NSLog(@"файл зображення %@", stringPath);
        
        
        


       
        
        NSLog(@"%@", self.tmpContact.kardPhotoFront);
        
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    NSLog(@"%@", picker);
}




@end
