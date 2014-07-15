//
//  GRAddEditTableViewController.h
//  AdressBook
//
//  Created by Exo-terminal on 7/13/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GRPerson;

@interface GRAddEditTableViewController : UITableViewController

//@property(strong, nonatomic)NSMutableDictionary* dictionary;

-(id)initWithTitle:(NSString*) title angPerson:(GRPerson*)person;

@end
