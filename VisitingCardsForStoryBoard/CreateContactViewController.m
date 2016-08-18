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

@interface CreateContactViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate,
UITextFieldDelegate,
ImageButtonDelegate,
ChangesStatusTextField,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

{
    UITextField* activeField;
    
    UIImage* tempImageFirst;
    UIImage* tempImageSecond;
    
    NSInteger tempTagForImageButton;
    
    StatusViewType screenType;
    
    
    }

@property (strong, nonatomic) Contact* tmpContact;

@property (assign, nonatomic) StatusViewType viewType;

@property (weak,nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;


@end

@implementation CreateContactViewController

//@synthesize contact;

#pragma mark - keyboard textField

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.


- (void)keyboardWasShown:(NSNotification*)aNotification {
  
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    self.tableView.contentInset = contentInsets;
    //self.tableView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        
        [self.tableView scrollRectToVisible:activeField.frame animated:YES];
    }
    
    
    /*
    CGRect keyboardBounds;
    [[aNotification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // Detect orientation
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect frame = self.tableView.frame;
    
    // Start animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    // Reduce size of the Table view
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
        frame.size.height -= keyboardBounds.size.height;
    else
        frame.size.height -= keyboardBounds.size.width;
    
    // Apply new size of table view
    self.tableView.frame = frame;
    
    // Scroll the table view to see the TextField just above the keyboard
    if (activeField)
    {
        CGRect textFieldRect = [self.tableView convertRect:activeField.bounds fromView:self.tableView];
        [self.tableView scrollRectToVisible:textFieldRect animated:NO];
    }
    
    [UIView commitAnimations];*/
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
}

- (void) keyboardIsSow:(UITextField *)tf {
    
    if (tf) {
        activeField = tf;
        
    } else {
        
        activeField = nil;
    }
}

#pragma mark - UIBarBatton

-(void) createRightBarButtonItem {
    
    if (screenType == reviewContact) {
        
        UIBarButtonItem* editItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                     target:self
                                     action:@selector(editAction:)];
        
        [self.navigationItem setRightBarButtonItem:editItem];
        
    } else {
        
        UIBarButtonItem* saveItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                     target:self
                                     action:@selector(saveButton:)];
        
        [self.navigationItem setRightBarButtonItem:saveItem];
        
    }
}

-(IBAction)editAction:(id)sender {
    
    screenType = editContact;
    
    [self createRightBarButtonItem];
    
    [self.tableView reloadData];
}


#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
       //Back Button Item//
    
    activeField = nil;

    
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Back"
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
    /*UINib * nibSecondaryContactCell = [UINib
                                       nibWithNibName:@"SecondaryContactCell"
                                       bundle:nil];
    
    [[self tableView] registerNib:nibSecondaryContactCell
           forCellReuseIdentifier:secondCellIdentifier];
    */
    
    // перевіряє чи слід створювати новий контакт чи використовувати існуючий
    
    
    if (self.contact) {
        
        screenType = reviewContact;
        
        
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
    
    [self createRightBarButtonItem];    //create rightBarButtonItem
    
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self registerForKeyboardNotifications];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //[self deregisterForKeyboardNotification];
}

- (void) deregisterForKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return 123.0;
        
    } else {//if (indexPath.row == 1) {
        
        return 160.0;
        
    }/* else {
      
      return 44.0;
      }*/
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        //повертає першу комірку з фото
        
        ImagesCardTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:imageCardCellIdentifier];
        //cell.userInteractionEnabled = NO;
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor clearColor];
        [cell setSelectedBackgroundView:bgColorView];
        
        
        cell.contact = self.tmpContact;
        cell.viewType = screenType;
        cell.delegate = self;
        
        [cell updateUIImage];
        
        return cell;
        
    } else { //if (indexPath.row == 1) {
        //повертає другу комірку з головними даними
        PrimaryContactCell* cell = [tableView dequeueReusableCellWithIdentifier:primaryContactCellIdentifier];
        //cell.userInteractionEnabled = NO;
        
        
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor clearColor];
        [cell setSelectedBackgroundView:bgColorView];

        cell.contact = self.tmpContact;
        cell.viewType = screenType;
        [cell updateUI];
        
        cell.delegate = self;
        
        return cell;
    }
    /*
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
     }*/
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {//убирает клаватуру с екрана
    
    [self.view endEditing:YES] ;
}

# pragma mark - Action

- (IBAction)saveButton:(id)sender {
    
    if (screenType == newContact) {
        if ([self.tmpContact isEqualContact:self.contact]) {
            
            [[Utilite managedObjectContext] deleteObject:self.contact];
            [self.navigationController popViewControllerAnimated:YES];

            return;
        }
    }
    
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
        [self.navigationController popViewControllerAnimated:YES];
        
        //NSLog(@"Save ERROR %@, %@", error, [error localizedDescription]);
        
    } else {
       
        [self saveAlert];
    }
    
}

- (void) back:(UIBarButtonItem *)sender {
    
    if (screenType == newContact) {
        
        if ([self.tmpContact isEqualContact:self.contact]) {
            
            [[Utilite managedObjectContext] deleteObject:self.contact];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            [self alertAction];
            
                }
    } else {
        
        if ([self.tmpContact isEqualContact:self.contact]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            [self alertAction];
            
        }
    }
}

#pragma mark - AlertAction

- (void) saveAlert {
    UIAlertController* saveAlert = [UIAlertController
                                    alertControllerWithTitle:@"Save"
                                    message:@"Saved contact?"
                                    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction* actionCancel = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *  action) {
                                       
                                       return ;
                                       
                                   }];
    
    [saveAlert addAction:actionOk];
    [saveAlert addAction:actionCancel];
    
    
    [self presentViewController:saveAlert
                       animated:YES
                     completion:nil];
    
}

- (void) actionSheet {
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil preferredStyle:
                                 UIAlertControllerStyleActionSheet];
    
    UIAlertAction* actionCamera = [UIAlertAction
                                   actionWithTitle:@"Camera"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
                                       
                                       UIImagePickerController *imagePicker =
                                       [[UIImagePickerController alloc] init];
                                       
                                       imagePicker.delegate = self;
                                       
                                       imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                       
                                       imagePicker.mediaTypes = @[(NSString*)kUTTypeImage];
                                       
                                       
                                       imagePicker.allowsEditing = YES;
                                       
                                       [self presentViewController:imagePicker
                                                          animated:YES
                                                        completion:nil];
                                       
                                   }];
    
    UIAlertAction* actionDirectiory = [UIAlertAction
                                       actionWithTitle:@"Galery"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action) {
                                           
                                           //создаем UIImagePickerController для фотоальбома
                                           
                                           UIImagePickerController *imagePicker =
                                           [[UIImagePickerController alloc] init];
                                           
                                           imagePicker.modalPresentationStyle = UIModalPresentationPopover;
                                           
                                           imagePicker.delegate = self;
                                           
                                           imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                           
                                           imagePicker.mediaTypes = @[(NSString*)kUTTypeImage];
                                           
                                           imagePicker.allowsEditing = YES;
                                           
                                           
                                           [self presentViewController:imagePicker
                                                              animated:YES
                                                            completion:nil];
                                           
                                       }];
    
    UIAlertAction* actionCancel = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *  action) {
                                       
                                       [self deleteTag:tempTagForImageButton];
                                       
                                   }];
    
    [alert addAction:actionCamera];
    [alert addAction:actionDirectiory];
    [alert addAction:actionCancel];
    
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
    
}

- (void) deleteTag: (NSInteger) tag {
    
    if (tag != 0) {
        tempTagForImageButton = 0;
    }
    
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
                                     //[self.navigationController popViewControllerAnimated:YES];
                                 }];
    
    UIAlertAction* actionCancel = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *  action) {
                                       
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
    
    [alert addAction:actionCancel];
    [alert addAction:actionSave];
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    return NO;
}

#pragma mark - imagesCartTableViewCellDelegate

- (void) imagesCartTableViewCell:(NSInteger)tag {
    
    tempTagForImageButton = tag;
    
    if (screenType == reviewContact) {
        
        if (tag == LEFT_IMAGE_BUTTON_TAG && self.contact.kardPhotoFront != nil) {
            [self createImageView];
            return;
        }
        if (tag == RIGHT_IMAGE_BUTTON_TAG && self.contact.kardPhotoBack != nil) {
            [self createImageView];
            
            return;
            
        } else {
            screenType = editContact;
            [self createRightBarButtonItem];

            
            [self actionSheet];
        }
        
    } else if (screenType == editContact)  {
        
        [self actionSheet];
        
    } else {
        
        [self actionSheet];
    }
    
    
}

#pragma mark - UIImageView

- (void) createImageView {
    
    UIImage* image;
    
    NSString *stringPath = [[NSSearchPathForDirectoriesInDomains
                             (NSDocumentDirectory, NSUserDomainMask, YES)
                             objectAtIndex:0]
                            stringByAppendingPathComponent:@"Images"];
    
    NSString* fullFileName1;
    
    NSString* fullFileName2;
    
    if (tempTagForImageButton == LEFT_IMAGE_BUTTON_TAG) {
        
        fullFileName1 = [stringPath stringByAppendingString:
                         [NSString stringWithFormat:@"/%@",self.contact.kardPhotoFront]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullFileName1]) {
            
            image = [UIImage imageWithContentsOfFile:fullFileName1];
        }
        
    } else if (tempTagForImageButton == RIGHT_IMAGE_BUTTON_TAG) {
        
        fullFileName2 = [stringPath stringByAppendingString:
                         [NSString stringWithFormat:@"/%@",self.contact.kardPhotoBack]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullFileName2]) {
            
            image = [UIImage imageWithContentsOfFile:fullFileName2];
        }
    }
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setBackgroundColor:[UIColor blackColor]];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(tapDetected:)];
    
    singleTap.numberOfTapsRequired = 1;
    [imageView setUserInteractionEnabled:YES];
    [imageView addGestureRecognizer:singleTap];
    
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    [window addSubview:imageView];
    
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [window addConstraint:
     [NSLayoutConstraint constraintWithItem:imageView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:window
                                  attribute:NSLayoutAttributeWidth
                                 multiplier:1.0
                                   constant:0]];
    
    [window addConstraint:
     [NSLayoutConstraint constraintWithItem:imageView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:window
                                  attribute:NSLayoutAttributeHeight
                                 multiplier:1.0
                                   constant:0]];
    
    [window addConstraint:
     [NSLayoutConstraint constraintWithItem:imageView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:window
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1.0
                                   constant:0]];
    
    [window addConstraint:
     [NSLayoutConstraint constraintWithItem:imageView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:window
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0
                                   constant:0]];
    
    
}

-(void)tapDetected:(UITapGestureRecognizer *)gestureRecognizer{
    
    [gestureRecognizer.view removeFromSuperview];
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage* image;
    
    if([info valueForKey:@"UIImagePickerControllerEditedImage"]) {//isEqualToString:@"public.image"
        
        image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
        
        NSString *stringPath = [[NSSearchPathForDirectoriesInDomains
                                 (NSDocumentDirectory, NSUserDomainMask, YES)
                                 objectAtIndex:0]stringByAppendingPathComponent:@"Images"];
        
        // New Folder is your folder name
        
        NSError *error = nil;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:stringPath]) {
            
            [[NSFileManager defaultManager] createDirectoryAtPath:stringPath
                                      withIntermediateDirectories:NO
                                                       attributes:nil
                                                            error:&error];
        }
        
        NSDate *today = [NSDate date];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        
        [dateFormat setDateFormat:@"MMddyyyy_HHmmssSS"];
        
        NSString *dateString = [dateFormat stringFromDate:today];
        
        NSString *fileName = [NSString stringWithFormat:@"%@.png", dateString];
        
        NSString *fullFileName = [stringPath stringByAppendingString:
                                  [NSString stringWithFormat:@"/%@",fileName]];
        
        NSData *data =  UIImagePNGRepresentation(image);
        
        [data writeToFile:fullFileName atomically:YES];
        
        switch (tempTagForImageButton) {
            case LEFT_IMAGE_BUTTON_TAG:
                self.tmpContact.kardPhotoFront = fileName;
                break;
            case RIGHT_IMAGE_BUTTON_TAG:
                self.tmpContact.kardPhotoBack = fileName;
                break;
            default:
                break;
        }
        
        [self.tableView reloadData];
        
        //NSLog(@"файл зображення %@", stringPath);
        
        //NSLog(@"%@", self.tmpContact.kardPhotoFront);
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    //NSLog(@"%@", picker);
}

@end
