//
//  GRModel.h
//  AdressBook
//
//  Created by Exo-terminal on 7/15/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GRPerson;
@class GRGroup;

@interface GRModel : NSObject

@property(readonly, nonatomic)NSArray* allPersons;
@property(readonly, nonatomic)NSArray* groupsArray;
@property(readonly, nonatomic)NSArray* nameOfGroup;


+(id)initialization;

-(GRGroup*)getGroupFromIndex:(NSInteger)index;
-(GRPerson*)getPersonFromIndexPath:(NSIndexPath*)indexPath;

-(void)removePerson:(GRPerson*)person;
-(void)addPerson:(GRPerson*)person;
-(void)changePerson:(GRPerson*)person newPerson:(GRPerson*)newPerson;

-(void)generationSectionwithFilter:(NSString*)filterString;

@end
