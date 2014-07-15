//
//  GREditTableViewCell.h
//  AdressBook
//
//  Created by Exo-terminal on 7/13/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GREditTableViewCell : UITableViewCell  

@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UITextField *customTextField;

@end
