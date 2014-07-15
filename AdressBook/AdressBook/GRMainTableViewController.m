//
//  GRMainTableViewController.m
//  AdressBook
//
//  Created by Exo-terminal on 7/12/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import "GRMainTableViewController.h"
#import "GRMainTableViewCell.h"
#import "GRPerson.h"
#import "GRGroup.h"
#import "GRAddEditTableViewController.h"
#import "GRModel.h"


@interface GRMainTableViewController () <UISearchBarDelegate>

@end

@implementation GRMainTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GRMainTableViewCell"
                                               bundle:[NSBundle mainBundle]]
                                       forCellReuseIdentifier:@"customCell"];
    
     self.navigationItem.title = @"address book";
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                               target:self
                                                                               action:@selector(actionEditButton:)];
    self.navigationItem.leftBarButtonItem = editButton;
    
    UIBarButtonItem* addSectionButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                     target:self
                                                                                     action:@selector(actionAddButton:)];
    self.navigationItem.rightBarButtonItem = addSectionButton;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [self.tableView reloadData];

    
   
}

#pragma mark - Edit

#pragma mark - Actions

-(void)actionEditButton:(UIBarButtonItem*)sender{
    
    BOOL isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if (!isEditing) {
        item = UIBarButtonSystemItemDone;
    }
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:item
                                                                               target:self
                                                                               action:@selector(actionEditButton:)];
    [self.navigationItem setLeftBarButtonItem:editButton animated:YES];
    
}
-(void)actionAddButton:(UIBarButtonItem*)sender{
    
    GRAddEditTableViewController *detailViewController = [[GRAddEditTableViewController alloc]initWithTitle:@"Add" angPerson:nil];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}


#pragma mark - UITableViewDataSource

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{

    
    GRModel* myModel = [GRModel initialization];
    NSMutableArray* array = [NSMutableArray arrayWithArray:myModel.nameOfGroup];
    
    return array;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    GRModel* myModel = [GRModel initialization];
    
    return [myModel.groupsArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    GRModel* myModel = [GRModel initialization];
    GRGroup* group = [myModel getGroupFromIndex:section];
    
    return group.name;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GRModel* myModel = [GRModel initialization];
    GRGroup* group = [myModel getGroupFromIndex:section];

    return [group.groupArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString* identifier = @"customCell";
    
    GRMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[GRMainTableViewCell alloc]init];
    }
    
    GRModel* myModel = [GRModel initialization];
    GRPerson* person = [myModel getPersonFromIndexPath:indexPath];
    
    if (person.lastName) {
         cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",person.firstName, person.lastName];
    }else{
        cell.nameLabel.text =person.firstName;
    }
    
    if (person.phoneNumber) {
         cell.mobileLabel.text = person.phoneNumber;
    }else{
        cell.mobileLabel.text = nil;
    }
    
    if ([person.phoneArray count] > 0) {
        NSString* workPhone = [person.phoneArray firstObject];
        cell.workLabel.text = workPhone;
    }
   
    
    return cell;

}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        GRModel* myModel = [GRModel initialization];
        
        GRGroup* group = [myModel getGroupFromIndex:indexPath.section];
        GRPerson* person = [myModel getPersonFromIndexPath:indexPath];
        
        BOOL deleteSection;
        if ([group.groupArray count] == 1) {
             deleteSection = YES;
        }else{
            deleteSection = NO;
        }
        
        [myModel removePerson:person];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        if (deleteSection) {
            NSIndexSet* deleteSection = [NSIndexSet indexSetWithIndex:indexPath.section];
            [tableView deleteSections:deleteSection withRowAnimation:UITableViewRowAnimationLeft];
        }
        
        [tableView endUpdates];

    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GRModel* myModel = [GRModel initialization];
    GRPerson* person = [myModel getPersonFromIndexPath:indexPath];

    GRAddEditTableViewController *detailViewController = [[GRAddEditTableViewController alloc]initWithTitle:@"Edit" angPerson:person];

    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:YES animated:YES];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    GRModel* myModel = [GRModel initialization];

    [myModel generationSectionwithFilter:searchText];
    
    dispatch_async(dispatch_get_main_queue(), ^{
     [self.tableView reloadData];
     });
    
}

@end
