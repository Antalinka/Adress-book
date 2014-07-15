//
//  GRGroup.h
//  AdressBook
//
//  Created by Exo-terminal on 7/12/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GRPerson;

@interface GRGroup : NSObject

@property(readonly, nonatomic)NSString* name;
@property(readonly, nonatomic)NSArray* groupArray;


-(void)setName:(NSString *)newName;
-(void)addPerson:(GRPerson*)person;
-(GRPerson*)getPersonAtIndex:(int)index;

@end
