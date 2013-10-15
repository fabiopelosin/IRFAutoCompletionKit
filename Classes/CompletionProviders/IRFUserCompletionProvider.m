//
//  DSUserCompletionProvider.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 15/10/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "IRFUserCompletionProvider.h"

@implementation IRFUserCompletionProvider

- (id)init
{
    self = [super init];
    if (self) {
        [self setStartCharacter:@"@"];
        [self setSeparationCharacters:@[@" ", @":"]];
    }
    return self;
}

@end
