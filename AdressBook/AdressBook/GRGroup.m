//
//  GRGroup.m
//  AdressBook
//
//  Created by Exo-terminal on 7/12/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import "GRGroup.h"
#import "GRPerson.h"


@interface GRGroup(){
    
    NSString* name_;
    NSMutableArray* groupArray_;
}
@end


@implementation GRGroup

@synthesize name = name_;
@synthesize groupArray = groupArray_;

- (instancetype)init
{
    self = [super init];
    if (self) {
        groupArray_ = [[NSMutableArray alloc]init];
    }
    return self;
}


-(void)setName:(NSString *)newName{
    name_ = newName;
}

-(void)addPerson:(GRPerson*)person{
    
    [groupArray_ addObject:person];
    
}

-(GRPerson*)getPersonAtIndex:(int)index{
    
    GRPerson* person = [groupArray_ objectAtIndex:index];
    return person;
    
}



@end
