//
//  GRPerson.h
//  AdressBook
//
//  Created by Exo-terminal on 7/12/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRPerson : NSObject

@property(readonly, nonatomic)NSString* firstName;
@property(readonly, nonatomic)NSString* lastName;
@property(readonly, nonatomic)NSString* phoneNumber;
@property(readonly, nonatomic)NSArray* phoneArray;

-(void)setFirstName:(NSString *)newFirstName;
-(void)setLastName:(NSString *)newLastName;
-(void)setPhoneNumber:(NSString *)newPhoneNumber;

-(BOOL)isValidName:(NSString*)string;
-(BOOL)isValidPhoneNumber:(NSString*)string;

@end
