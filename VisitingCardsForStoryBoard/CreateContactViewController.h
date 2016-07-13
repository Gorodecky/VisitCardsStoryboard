//
//  CreateContactViewController.h
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 04.04.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Contact.h"



@interface CreateContactViewController : UIViewController

@property (strong, nonatomic) Contact *contact;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)saveButton:(id)sender;

- (void) createImageView;

@end
