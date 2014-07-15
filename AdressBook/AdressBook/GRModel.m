//
//  GRModel.m
//  AdressBook
//
//  Created by Exo-terminal on 7/15/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import "GRModel.h"
#import "GRPerson.h"
#import "GRGroup.h"
static GRModel *sharedSingleton;

@interface GRModel(){
    NSMutableArray* allPersons_;
    NSArray* groupsArray_;
    NSMutableArray* nameOfGroup_;
}
@property(strong, nonatomic)NSThread* thread;
@end

@implementation GRModel

@synthesize allPersons = allPersons_;
@synthesize groupsArray = groupsArray_;
@synthesize nameOfGroup = nameOfGroup_;

+(id)initialization{
    
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedSingleton = [[GRModel alloc] init];
    }
    return sharedSingleton;

}


-(GRGroup*)getGroupFromIndex:(NSInteger)index{
    
    return [groupsArray_ objectAtIndex:index];
    
}
-(GRPerson*)getPersonFromIndexPath:(NSIndexPath*)indexPath{
    
    GRGroup* group = [self getGroupFromIndex:indexPath.section];
    
    return [group getPersonAtIndex:indexPath.row];
    
}

-(void)removePerson:(GRPerson*)person{
    
    [allPersons_ removeObject:person];
    groupsArray_ = [self generationSectionFromArray:allPersons_ withFilter:nil];
    
}


-(void)addPerson:(GRPerson*)person{
    
    
    if ([person.firstName length] == 0) {
        
        if ([person.lastName length] > 1) {
            person.firstName = person.lastName;
            person.lastName = nil;
        }else if([person.phoneNumber length] > 1){
            person.firstName = person.phoneNumber;
        }
    }
    
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:allPersons_];
    
    [tempArray addObject:person];
    allPersons_ = tempArray;
    
    groupsArray_ = [self generationSectionFromArray:tempArray withFilter:nil];
}


-(void)changePerson:(GRPerson*)person newPerson:(GRPerson*)newPerson{
    
        if (!newPerson.firstName) {
            newPerson.firstName = person.firstName;
        }
        
        if (!newPerson.lastName) {
            newPerson.lastName = person.lastName;
        }
        
        if (!newPerson.phoneNumber) {
            newPerson.phoneNumber = person.phoneNumber;
        }
        
    [allPersons_ removeObject:person];
    
    [self addPerson:newPerson];
    
}


#pragma mark - Edit Array

-(void)generationSectionwithFilter:(NSString*)filterString{
    
    if ([self.thread isExecuting]) {
        [self.thread cancel];
    }
    self.thread = [[NSThread alloc]initWithTarget:self selector:@selector(searchThreadWithFilter:) object:filterString];
    self.thread.name = @"search";
    [self.thread start];
    
}

-(void)searchThreadWithFilter:(NSString*)filterString{
    
    groupsArray_ = [self generationSectionFromArray:allPersons_ withFilter:filterString];
    
    /*dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });*/
    
}

-(NSArray*)generationSectionFromArray:(NSArray*)array withFilter:(NSString*)filterString{
    
    NSSortDescriptor* firstName = [[NSSortDescriptor alloc]initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor* lastName = [[NSSortDescriptor alloc]initWithKey:@"lastName" ascending:YES];
    
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:array];
    [tempArray sortUsingDescriptors:[NSArray arrayWithObjects:firstName,lastName,nil]];
    
    NSMutableArray* sectionArray = [NSMutableArray array];
    NSMutableArray* tempNameOfGroup = [NSMutableArray array];
    
    NSString* currentLetter = nil;
    
    if ([filterString length] > 0 ) {
        
        NSString* searchStringLow = [filterString lowercaseString];
        NSString* searchStringUp= [filterString uppercaseString];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName CONTAINS %@ OR lastName CONTAINS %@ OR phoneNumber CONTAINS %@  OR                                                                firstName CONTAINS %@ OR lastName CONTAINS %@ OR phoneNumber CONTAINS %@  ",searchStringLow, searchStringLow,searchStringLow,searchStringUp, searchStringUp, searchStringUp];
        
        [tempArray filterUsingPredicate:predicate];
    }
    
    for (GRPerson* person  in tempArray) {
        
        NSString* string = person.firstName;
        
        /*if ([string substringToIndex:1] == nil) {
            string = person.lastName;
            string = [string substringToIndex:1];
        }*/
        NSString* firstLetter = [string substringToIndex:1];
        
        GRGroup* section = nil;
        
        if (![currentLetter isEqualToString:firstLetter]) {
            section = [[GRGroup alloc]init];
            
            [section setName:firstLetter];
//            section.name = firstLetter;
//            section.sectionArray = [NSMutableArray array];
            currentLetter = firstLetter;
            
            [sectionArray addObject:section];
            [tempNameOfGroup addObject:firstLetter];
            
            
        }else{
            section = [sectionArray lastObject];
        }
        
        [section addPerson:person];
    }
    
    nameOfGroup_ = tempNameOfGroup;
    
    return sectionArray;
}


@end
