//
//  IRFUserCompletionProviderTests.m
//  IRFAutoCompletionKit
//
//  Created by Fabio Pelosin on 16/10/13.
//  Copyright (c) 2013 Discontinuity. All rights reserved.
//


#import "Kiwi.h"
#import <IRFAutoCompletionKit/IRFUserCompletionProvider.h>

SPEC_BEGIN(IRFUserCompletionProviderSpec)

describe(@"IRFUserCompletionProvider", ^{

    __block IRFUserCompletionProvider *sut = nil;

    beforeEach(^{
        sut = [IRFUserCompletionProvider new];
        [sut setCompletions:@[@"UserName"]];
    });


    //--------------------------------------------------------------------------


    describe(@"initialization", ^{

        it(@"returns the start characters", ^{
            [[sut.startCharacter should] equal:@"@"];
        });

        it(@"returns the end characters", ^{
            [[sut.endCharacter should] beNil];
        });

        it(@"returns the separation characters", ^{
            [[sut.separationCharacters should] equal:@[@" ", @"\n", @":"]];
        });

    });


    //--------------------------------------------------------------------------


    describe(@"robustness", ^{

        it(@"starts with an at symbol following a space", ^{
            BOOL result = [sut shouldStartAutoCompletionForString:@"text @"];
            [[theValue(result) should] beTrue];
        });

        it(@"starts with a at symbol following the line start", ^{
            BOOL result = [sut shouldStartAutoCompletionForString:@"@"];
            [[theValue(result) should] beTrue];
        });

        it(@"doesn't start with a at symbol not following a space", ^{
            BOOL result = [sut shouldStartAutoCompletionForString:@"text@"];
            [[theValue(result) should] beFalse];
        });

        it(@"ends with a space", ^{
            BOOL result = [sut shouldEndAutoCompletionForString:@"text @User "];
            [[theValue(result) should] beTrue];
        });

        it(@"ends with a colon", ^{
            BOOL result = [sut shouldEndAutoCompletionForString:@"text @User:"];
            [[theValue(result) should] beTrue];
        });

        it(@"complestes a given string adding the colon and a final space", ^{
            NSString *string = @"sometext @User";
            NSString *result = [sut completeString:string];
            [[result should] equal:@"sometext @UserName "];
        });

        it(@"doesn't affects other emojis during completion", ^{
            NSString *string = @"sometext @User @User";
            NSString *result = [sut completeString:string];
            [[result should] equal:@"sometext @User @UserName "];
        });
        
    });
    
    
    //--------------------------------------------------------------------------
    
});

SPEC_END