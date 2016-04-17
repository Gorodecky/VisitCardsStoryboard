//
//  ContactsViewController.m
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 16.03.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import "ContactsViewController.h"
#import "Contact.h"
#import "CreateContactViewController.h"
#import "ContactCustomTableViewCell.h"


@interface ContactsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray* groupsArray;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSManagedObjectContext* managedObjectContext= [self managedObjectContext];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Contact"];
    self.groupsArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [self.tableView reloadData];
    
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
#pragma mark UITableViewDelegate

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES; // функция разрешает выделять ячейки в таблице
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSManagedObjectContext* context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [context deleteObject:[self.groupsArray objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        
        if (![context save:&error]) {
            NSLog(@"Delete error! %@, %@", error, [error localizedDescription]);
            return;
        }
        
        [self.groupsArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    
}
/*
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {//Отклик ячейки на кликанье
    
    
    //1. oneValue отримати цей обєкт з масива =
    //2. стоврити контроллер
    //3, viewController.someValue = oneValue
    //4. пуш self.navigationController pushViewController:viewController
    
    CreateContactViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"12"];
    
    
        [self.navigationController pushViewController:vc
                                             animated:YES];
        
    
}
*/
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.groupsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"customCell";
    
    ContactCustomTableViewCell* customCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!customCell) {
        customCell = [[ContactCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:identifier];
    }
    
    NSManagedObject* contact = [self.groupsArray objectAtIndex:indexPath.row];
    
    [customCell.firstNameLable setText:[NSString stringWithFormat:@"%@",[contact valueForKey:@"name"]]];
    [customCell.lastNameLable setText:[NSString stringWithFormat:@"%@", [contact valueForKey:@"lastName"]]];
    [customCell.companyNameLable setText:[NSString stringWithFormat:@"%@", [contact valueForKey:@"companyName"]]];
    
    
    return customCell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"updateContact"]) {
        
        NSManagedObject* selectedContact = [self.groupsArray
                                            objectAtIndex:[[self.tableView indexPathForSelectedRow]row]];
        
        CreateContactViewController* destViewController = segue.destinationViewController;
        
        destViewController.contact = selectedContact;
    }
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 
    return [NSString stringWithFormat:@"Section %ld Heder", section];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    return [NSString stringWithFormat:@"Section %ld Footer", section];

}
*/
@end
