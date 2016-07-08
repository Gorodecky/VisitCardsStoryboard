//
//  ContactsViewController.h
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 16.03.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@interface ContactsViewController : UIViewController

@property (strong, nonatomic) Contact *contact;


@property (weak, nonatomic) IBOutlet UISearchBar *serchContactBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *contactSegment;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
