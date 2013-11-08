//
//  IRFAutoCompletionKitTests.m
//  IRFAutoCompletionKitTests
//
//  Created by Fabio Pelosin on 15/10/13.
//  Copyright (c) 2013 Discontinuity. All rights reserved.
//

#import "Kiwi.h"
#import <IRFAutoCompletionKit/IRFEmojiAutoCompletionProvider.h>

SPEC_BEGIN(IRFEmojiAutoCompletionProviderSpec)

describe(@"IRFEmojiAutoCompletionProvider", ^{

    __block IRFEmojiAutoCompletionProvider *sut = nil;

    beforeEach(^{
        sut = [IRFEmojiAutoCompletionProvider new];
    });
    

    //--------------------------------------------------------------------------


    describe(@"initialization", ^{

        it(@"returns the start characters", ^{
            [[sut.startCharacter should] equal:@":"];
        });

        it(@"returns the end characters", ^{
            [[sut.endCharacter should] equal:@":"];
        });

        it(@"returns the separation characters", ^{
            [[sut.separationCharacters should] equal:@[@" ", @"\n"]];
        });

        it(@"returns the completions", ^{
            NSString *result = [sut entries][0];
            [[result should] equal:@"bell"];
        });
        
    });


    //--------------------------------------------------------------------------


    describe(@"robustness", ^{

        it(@"starts with a colon following a space", ^{
            BOOL result = [sut shouldStartAutoCompletionForString:@"text :"];
            [[theValue(result) should] beTrue];
        });

        it(@"starts with a colon following the line start", ^{
            BOOL result = [sut shouldStartAutoCompletionForString:@":"];
            [[theValue(result) should] beTrue];
        });

        it(@"doesn't start with a colon not following a space", ^{
            BOOL result = [sut shouldStartAutoCompletionForString:@"text:"];
            [[theValue(result) should] beFalse];
        });

        it(@"ends with a colon", ^{
            BOOL result = [sut shouldEndAutoCompletionForString:@"text :+1:"];
            [[theValue(result) should] beTrue];
        });

        it(@"ends with a space", ^{
            BOOL result = [sut shouldEndAutoCompletionForString:@"text :+1:"];
            [[theValue(result) should] beTrue];
        });

        it(@"complestes a given string adding the colon and a final space", ^{
            NSString *string = @"sometext :thumbsu";
            NSString *result = [sut completeString:string];
            [[result should] equal:@"sometext :thumbsup: "];
        });

        it(@"doesn't affects other emojis during completion", ^{
            NSString *string = @"sometext :+1: :thumbsu";
            NSString *result = [sut completeString:string];
            [[result should] equal:@"sometext :+1: :thumbsup: "];
        });

    });


    //--------------------------------------------------------------------------

});

SPEC_END