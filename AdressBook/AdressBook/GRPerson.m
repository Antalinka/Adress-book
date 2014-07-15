//
//  GRPerson.m
//  AdressBook
//
//  Created by Exo-terminal on 7/12/14.
//  Copyright (c) 2014 Evgenia. All rights reserved.
//

#import "GRPerson.h"

@interface GRPerson(){
    
    NSString* firstName_;
    NSString* lastName_;
    NSString* phoneNumber_;

}

@end

@implementation GRPerson
@synthesize firstName = firstName_;
@synthesize lastName = lastName_;
@synthesize phoneNumber = phoneNumber_;

#pragma mark - Setter

-(void) setFirstName:(NSString *)newFirstName{
    
    firstName_ = newFirstName;
    
}

-(void)setLastName:(NSString *)newLastName{
    lastName_ = newLastName;
    
}

-(void)setPhoneNumber:(NSString *)newPhoneNumber{
    
    phoneNumber_ = [self editPhoneWithString:newPhoneNumber];
    
}

-(BOOL)isValidName:(NSString*)string{
    
    NSCharacterSet* validationSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSArray* componets = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([componets count] > 1) {
        return NO;
    }else{
        return YES;
    }
    
}

-(BOOL)isValidPhoneNumber:(NSString*)string{
    
    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray* componets = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([componets count] > 1) {
        return NO;
    }else{
        return YES;
    }
    
    
}

#pragma mark - Edit

- (NSString*) editPhoneWithString:(NSString*)string{
    
    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray* validComponents = [string componentsSeparatedByCharactersInSet:validationSet];
    string = [validComponents componentsJoinedByString:@""];
    
    
    
    static const int localNumberMaxLenght = 7;
    static const int areaCodeMaxLenght = 3;
    static const int coutryCodeMaxLenght = 3;
    
    
    /*if ([newString length] > localNumberMaxLenght + areaCodeMaxLenght + coutryCodeMaxLenght) {
        return NO;
    }
    */
    NSMutableString* resultString = [NSMutableString string];
    
    NSInteger localNumberLenght = MIN([string length], localNumberMaxLenght);
    
    if (localNumberLenght > 0) {
        NSString* number = [string substringFromIndex:(int)[string length] - localNumberLenght];
        [resultString appendString:number];
        
        if ([resultString length] > 3) {
            [resultString insertString:@"-" atIndex:3];
        }
    }
    
    if ([string length] > localNumberMaxLenght) {
        
        NSInteger areaCodeLenght = MIN((int)[string length] - localNumberMaxLenght, areaCodeMaxLenght);
        NSRange areaRange = NSMakeRange((int)[string length] - localNumberMaxLenght - areaCodeLenght, areaCodeLenght);
        NSString* area = [string substringWithRange:areaRange];
        
        area = [NSString stringWithFormat:@"(%@) ", area];
        [resultString insertString:area atIndex:0];
    }
    if ([string length] > localNumberMaxLenght + coutryCodeMaxLenght) {
        
        NSInteger coutryCodeLenght = MIN((int)[string length] - localNumberMaxLenght - coutryCodeMaxLenght, coutryCodeMaxLenght);
        NSRange countryCodeRange = NSMakeRange(0,coutryCodeLenght);
        NSString* countryCode = [string substringWithRange:countryCodeRange];
        
        countryCode = [NSString stringWithFormat:@"+%@ ", countryCode];
        [resultString insertString:countryCode atIndex:0];
    }
    
//    string.text = resultString;
    
    return resultString;
}

@end
