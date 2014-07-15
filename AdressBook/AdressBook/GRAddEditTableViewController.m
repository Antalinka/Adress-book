//
//  GRAddEditTableViewController.m
//  AdressBook
//
//  Created by Exo-terminal on 7/13/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//


#import <MessageUI/MessageUI.h>
#import <EasyMailAlertSender.h>
#import "GRAddEditTableViewController.h"
#import "GRPerson.h"
#import "GREditTableViewCell.h"
#import "GRMainTableViewController.h"
#import "GRModel.h"

@interface GRAddEditTableViewController () <UITextFieldDelegate>

@property(strong, nonatomic)NSString* header;
@property(strong, nonatomic)GRPerson* person;
@property(strong, nonatomic)GRPerson* otherPerson;
@property(assign,nonatomic)BOOL isAddScreen;
@property(strong, nonatomic)NSArray* phoneArray;

@end

@implementation GRAddEditTableViewController


-(id)initWithTitle:(NSString*) title angPerson:(GRPerson*)person{
    
    self = [super init];
    if (self) {
        
        self.header = title;
        self.otherPerson = [[GRPerson alloc]init];
        
        if (person) {
            self.person = person;
            self.isAddScreen = NO;
            self.person = person;
            
        }else{
            self.isAddScreen = YES;

        }
    }
    return self;
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GREditTableViewCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"detailCell"];
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                               target:self
                                                                               action:@selector(doneEditButton:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                               target:self
                                                                               action:@selector(cancelEditButton:)];
    self.navigationItem.leftBarButtonItem = backButton;

    
    self.navigationItem.title = self.header;

}


#pragma mark - Action

-(void)doneEditButton:(UIBarButtonItem*)sender{
    
    
   GRModel* myModel = [GRModel initialization];
    
    if (self.isAddScreen) {
        
        if (self.otherPerson.firstName || self.otherPerson.lastName || self.otherPerson.phoneNumber) {
            
               [myModel addPerson:self.otherPerson];
            
        }        
    }else{
        
        [myModel changePerson:self.person newPerson:self.otherPerson];
    }
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
   

}

-(void)cancelEditButton:(UIBarButtonItem*)sender{
    
    [self.navigationController popToRootViewControllerAnimated:YES];

    
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.isAddScreen) {
         return 4;//+mail button
    }else{
          return 5;//+ delete button
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* identifier = @"detailCell";
    GREditTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (indexPath.row == 0) {
        cell.titleName.text = @"name";
        cell.customTextField.placeholder = @"name";
        cell.customTextField.text = self.person.firstName;
        cell.customTextField.tag = 0;
        cell.customTextField.delegate = self;
        
    }else if(indexPath.row == 1){
        cell.titleName.text = @"last name";
        cell.customTextField.placeholder = @"last name";
        cell.customTextField.text = self.person.lastName;
        cell.customTextField.tag = 1;
        cell.customTextField.delegate = self;
        
        
    } else if(indexPath.row == 2){
        
        cell.titleName.text = @"phone number";
        cell.customTextField.placeholder = @"phone number";
        NSString* string = self.person.phoneNumber;
        NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSArray* validComponents = [string componentsSeparatedByCharactersInSet:validationSet];
        string = [validComponents componentsJoinedByString:@""];
        cell.customTextField.text = string;
        cell.customTextField.tag = 2;
        cell.customTextField.delegate = self;
        
    } else if(indexPath.row == 3)
    {
            static NSString* addIdentifier = @"mail";
            UITableViewCell* cell1 = [self.tableView dequeueReusableCellWithIdentifier:addIdentifier];
            
            if (!cell1) {
                cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addIdentifier];
                cell1.textLabel.text = @"Shared mail";
                cell1.textLabel.textColor = [UIColor grayColor];
                cell1.textLabel.textAlignment = NSTextAlignmentCenter;
            }
            
            return cell1;
      
        
    }else if (indexPath.row == 4){
        
        static NSString* deleteIdentifier = @"deleteContact";
        UITableViewCell* cell1 = [self.tableView dequeueReusableCellWithIdentifier:deleteIdentifier];
        
        if (!cell1) {
            cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deleteIdentifier];
            cell1.textLabel.text = @"remove contact";
            cell1.textLabel.textColor = [UIColor redColor];
            cell1.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        return cell1;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    //mail
     if (indexPath.row == 3) {

         NSString *attachedText = @"contact";
         
         EasyMailAlertSender *mailSender = [EasyMailAlertSender easyMail:^(MFMailComposeViewController *controller) {
             // Setup
             [controller addAttachmentData:[attachedText dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"plain/text" fileName:@"contact"];
         } complete:^(MFMailComposeViewController *controller, MFMailComposeResult result, NSError *error) {
             // When Sent/Cancel - MFMailComposeViewControllerDelegate action
             [controller dismissViewControllerAnimated:YES completion:nil];
         }];
         
         [mailSender showFromViewController:self];
    }
    
    
    //delete contact
    if (!self.isAddScreen){
        
        if (indexPath.row == 4) {
            
            [[GRModel initialization] removePerson:self.person];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
           }
        
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 0) {
        
        NSString* firstName = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([self.otherPerson isValidName:firstName]) {
            [self.otherPerson setFirstName:firstName];
            
            return YES;
        }else{
            return NO;
        }
    }else if(textField.tag == 1){
        
        NSString* lastName = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([self.otherPerson isValidName:lastName]) {
            [self.otherPerson setLastName:lastName];
            
            return YES;
        }else{
            return NO;
        }
        
    }else if(textField.tag == 2){
        
        NSString* phoneNumber = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([self.otherPerson isValidPhoneNumber:phoneNumber]) {
            [self.otherPerson setPhoneNumber:phoneNumber];
            
            return YES;
        }else{
            return NO;
        }
    }
    
    return YES;
}
@end
