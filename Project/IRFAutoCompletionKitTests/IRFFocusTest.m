//
//  IRFUserCompletionProviderTests.m
//  IRFAutoCompletionKit
//
//  Created by Fabio Pelosin on 16/10/13.
//  Copyright (c) 2013 Discontinuity. All rights reserved.
//


#import "Kiwi.h"
#import <IRFAutoCompletionKit/IRFAutoCompletionProvider.h>

SPEC_BEGIN(FOCUS_TEST)

describe(@"FOCUS_TEST", ^{

    __block IRFAutoCompletionProvider* sut = nil;

    beforeEach(^{
        sut = [IRFAutoCompletionProvider new];
        [sut setStartCharacter:@":"];
        [sut setEndCharacter:@":"];
        [sut setSeparationCharacters:@[@" ", @"\n"]];
        [sut setEntriesBlock:^NSArray *{
            return @[@"thumbsup", @"thumbsdown", @"+1"];
        }];
    });
});

SPEC_END
