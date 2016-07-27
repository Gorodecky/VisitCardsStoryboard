//
//  ContactsViewController.m
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 16.03.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import "ContactsViewController.h"
#import "CreateContactViewController.h"
#import "ContactCustomTableViewCell.h"
#import "Section.h"
#import "Utilite.h"


@interface ContactsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray* groupsArray;
@property (strong, nonatomic) NSMutableArray* sectionsArray;
@property (strong, nonatomic) NSMutableArray* searchResults;

@end

typedef enum {
    
    sortSegmentName,
    sortSegmentLastName,
    sortSegmentCompanyName,
    sortSegmentDateOfCreation
    
} sortSegment;

@implementation ContactsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.serchContactBar.delegate = self;
    
    self.contactSegment.selectedSegmentIndex = sortSegmentName;
    
    [self showAddContactView];
    
}

- (void) showAddContactView {
    
    if (self.groupsArray.count == 0) {
        
        self.addContactView.hidden = NO;
        [self.view bringSubviewToFront:self.addContactView];
        
    } else {
        
        self.addContactView.hidden = YES;
    }
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self segmentControlContactList];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (IBAction) segmentControlContactList {
    
    if (self.contactSegment.selectedSegmentIndex == sortSegmentName) {
        
        NSString* sortString = @"name";
        [self sortContactsArray:sortString];
        
    } else if (self.contactSegment.selectedSegmentIndex == sortSegmentLastName) {
        
        NSString* sortString = @"lastName";
        [self sortContactsArray:sortString];
        
    } else if (self.contactSegment.selectedSegmentIndex == sortSegmentCompanyName) {
        
        NSString* sortString = @"companyName";
        [self sortContactsArray:sortString];
        
    }
}

- (void) sortContactsArray: (NSString*) sortString {
    
    NSManagedObjectContext* managedObjectContext = [Utilite managedObjectContext];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc]
                                    initWithEntityName:@"Contact"];
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:sortString ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    self.groupsArray = [[managedObjectContext executeFetchRequest:fetchRequest
                                                            error:nil]mutableCopy];
    [self showAddContactView];

    [self.tableView reloadData];
    
}

#pragma mark UITableViewDelegate

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES; // функция разрешает выделять ячейки в таблице
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObjectContext* context = [Utilite managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete && self.serchContactBar.text.length == 0)  {
        
        [context deleteObject:[self.groupsArray objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        
        if (![context save:&error]) {
            NSLog(@"Delete error! %@, %@", error, [error localizedDescription]);
            return;
        }
        
        [self.groupsArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
        
        

    } else {
        
        [context deleteObject:[self.searchResults objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        
        if (![context save:&error]) {
            NSLog(@"Delete error! %@, %@", error, [error localizedDescription]);
            return;
        }
        
        [self.searchResults removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];

    }
    
    [self.tableView reloadData];
    [self showAddContactView];
}

#pragma mark - UISearchBarDelegate

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar { // called when text starts editing
    
    [self.serchContactBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {  // called when cancel button pressed
    
    [self.serchContactBar resignFirstResponder];
    
    [self.serchContactBar setShowsCancelButton:NO animated:YES];
    
    [self.serchContactBar setText:nil];
    
    self.tableView.hidden = NO;

    
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {   // called when text changes (including clear)
    
    [self filterContentForSearchText:searchText];
    
    [self searchResultIsNill];
    
    //[self.tableView reloadData];
    
}

#pragma  mark - SearchBar

- (void)filterContentForSearchText:(NSString*)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact"
                                              inManagedObjectContext:[Utilite managedObjectContext]];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate* predicateForName =        [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@",
                                            searchText];
    NSPredicate* predicateForLastName =    [NSPredicate predicateWithFormat:@"lastName CONTAINS[c] %@",
                                            searchText];
    NSPredicate* predicateForCompanyName = [NSPredicate predicateWithFormat:@"companyName CONTAINS[C] %@",
                                            searchText];
    
    NSPredicate* generalPredicate = [NSCompoundPredicate
                                     orPredicateWithSubpredicates:@[predicateForName,
                                                                    predicateForLastName,
                                                                    predicateForCompanyName]];
    
    [fetchRequest setPredicate:generalPredicate];
    
    NSError *error;
    
    NSArray* result = [[Utilite managedObjectContext] executeFetchRequest:fetchRequest
                                                                    error:&error];
    
    self.searchResults = [result mutableCopy];
    
    
    
}

- (void) searchResultIsNill {
    if (self.searchResults.count == 0 && self.serchContactBar.text.length != 0) {
        
        self.tableView.hidden = YES;
        //[self showViewNoResultsFound];
        
    } else if (self.searchResults.count != 0 && self.serchContactBar.text.length != 0){
    
    
    self.tableView.hidden = NO;
    [self.tableView reloadData];
        
    } else {
        
        self.tableView.hidden = NO;
        [self.tableView reloadData];

    }
}
/*
- (void) showViewNoResultsFound {
    
    
    UIView* noResultsView = [[UIView alloc]
                             initWithFrame:
                             CGRectMake
                             (8, 138,
                              self.tableView.frame.size.width,
                              self.tableView.frame.size.height)];
    
    [noResultsView setBackgroundColor:[UIColor redColor]];
    
    [self.view addSubview:noResultsView];
    
    
}*/


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.serchContactBar.text.length == 0) {
        
        return self.groupsArray.count;
        
    } else {
        
        return self.searchResults.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"customCell";
    
    ContactCustomTableViewCell* customCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!customCell) {
        
        customCell = [[ContactCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                       reuseIdentifier:identifier];
    }
    
    //NSManagedObject* contact = nil;
    
    if (self.serchContactBar.text.length == 0) {
        
        customCell.contact = [self.groupsArray objectAtIndex:indexPath.row];
        
        
        [customCell updateCustomCell];
        
        
        return customCell;
        
    } else {
        
        customCell.contact = [self.searchResults objectAtIndex:indexPath.row];
        
        
        [customCell updateCustomCell];
        
        
        return customCell;
    }
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"updateContact"]) {
        
        NSManagedObject* selectedContact = [self.groupsArray
                                            objectAtIndex:[[self.tableView indexPathForSelectedRow]row]];
        
        CreateContactViewController* destViewController = segue.destinationViewController;
        
        destViewController.contact = selectedContact;
    }
}
@end
