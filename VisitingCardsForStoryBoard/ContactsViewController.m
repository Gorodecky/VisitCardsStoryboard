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
#import "Section.h"


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
    
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self segmentControlContactList];
    
}

/*
 - (NSArray*) generateSectionsFromArray: (NSArray*) array withFilter:(NSString*) filterString {
 
 NSMutableArray* sectionArray = [NSMutableArray array];
 
 NSString* currentLeter = nil;
 
 for (NSString* string in self.groupsArray) {
 
 if ([filterString length] && [string rangeOfString:filterString].location == NSNotFound) {
 continue;
 }
 
 NSString* firstLeter = [string substringToIndex:1];
 
 Section* section = nil;
 
 if (![currentLeter isEqualToString:firstLeter]) {
 section = [[Section alloc] init];
 section.sectionName = firstLeter;
 section.itemsArray = [NSMutableArray array];
 currentLeter = firstLeter;
 [sectionArray addObject:section];
 
 } else {
 
 section = [sectionArray lastObject];
 }
 
 [section.itemsArray addObject:string];
 }
 return sectionArray;
 
 
 }
 */
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
        
    } else if (self.contactSegment.selectedSegmentIndex == sortSegmentDateOfCreation) {
        
        NSString* sortString = @"dateOfCreationContact";
        [self sortContactsArray:sortString];
    }
    
}

- (void) sortContactsArray: (NSString*) sortString {
    
    NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc]
                                    initWithEntityName:@"Contact"];
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:sortString ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    self.groupsArray = [[managedObjectContext executeFetchRequest:fetchRequest
                                                            error:nil]mutableCopy];
    
    [self.tableView reloadData];
    
    //self.groupsArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
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

#pragma mark - UISearchBarDelegate

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar { // called when text starts editing
    
    [self.serchContactBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {  // called when cancel button pressed
    
    [self.serchContactBar resignFirstResponder];
    
    [self.serchContactBar setShowsCancelButton:NO animated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {   // called when text changes (including clear)
    [self filterContentForSearchText:searchText];
    
    [self.tableView reloadData];
    
}
#pragma  mark - SearchBar

- (void)filterContentForSearchText:(NSString*)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Contact" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    if (self.searchResults != nil) {
        [self.searchResults removeAllObjects];
    }
    
    NSArray *fields = @[@"name", @"lastName"];
    
    NSMutableArray *predicates = [NSMutableArray array];
    
    for (NSString *field in fields) {
        
        [predicates addObject:[NSPredicate predicateWithFormat:@"%@ contains[cd] %@", field, searchText]];
    }
    
    NSPredicate *search = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    
    NSError *error;
    
    fetchRequest.predicate = search;
    
    self.searchResults = [NSMutableArray arrayWithArray:[[self managedObjectContext] executeFetchRequest:fetchRequest error:&error]];
    
}

#pragma mark - UITableViewDataSource
/*
 
 - (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
 // return list of section titles to display in section index view (e.g. "ABCD...Z#")
 
 
 
 }
 
 - (NSArray*) sectionIndexTitlesForTableView:(UITableView *)tableView {
 
 NSMutableArray* array = [NSMutableArray array];
 for (Section* section in self.sectionsArray) {
 [array addObject:section.sectionName];
 }
 return array;
 }
 */
/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
 return [self.sectionsArray count];
 
 }
 
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 return [[self.sectionsArray objectAtIndex:section] sectionName];
 }
 */

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
    
    NSManagedObject* contact = nil;
    
    if (self.serchContactBar.text.length == 0) {
        
        contact = [self.groupsArray objectAtIndex:indexPath.row];
        
    } else {
        
        contact = [self.searchResults objectAtIndex:indexPath.row];
        
    }
    
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
@end
