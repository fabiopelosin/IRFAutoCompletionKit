//
//  IRFUserCompletionProviderTests.m
//  IRFAutoCompletionKit
//
//  Created by Fabio Pelosin on 16/10/13.
//  Copyright (c) 2013 Discontinuity. All rights reserved.
//


#import "Kiwi.h"
#import <IRFAutoCompletionKit/IRFAutoCompletionProvider.h>

SPEC_BEGIN(IRFAutoCompletionProviderSpec)

describe(@"IRFAutoCompletionProvider", ^{

    __block IRFAutoCompletionProvider* sut = nil;

    beforeEach(^{
        sut = [IRFAutoCompletionProvider new];
        [sut setStartCharacter:@":"];
        [sut setEndCharacter:@":"];
        [sut setSeparationCharacters:@[@" ", @"\n"]];
        [sut  setEntriesBlock:^NSArray *{
            return @[@"thumbsup", @"thumbsdown", @"+1"];
        }];
    });

    //--------------------------------------------------------------------------

    context(@"-shouldStartAutoCompletionForString", ^{

        it(@"starts with a string ending with a colon after the begin of the line", ^{
            BOOL result = [sut shouldStartAutoCompletionForString:@":"];
            [[theValue(result) should] beTrue];
        });

        it(@"it starts with a string ending in a colon after a space", ^{
            BOOL result = [sut shouldStartAutoCompletionForString:@" :"];
            [[theValue(result) should] beTrue];
        });

        it(@"handles text before the space", ^{
            BOOL result = [sut shouldStartAutoCompletionForString:@"sometext :"];
            [[theValue(result) should] beTrue];
        });

        it(@"starts if the emjoi has not being completed", ^{
            BOOL result = [sut shouldStartAutoCompletionForString:@"sometext :thumbs"];
            [[theValue(result) should] beTrue];
        });

        it(@"doesn't starts with a completed emoji", ^{
            BOOL result = [sut shouldStartAutoCompletionForString:@"sometext :thumbs:"];
            [[theValue(result) should] beFalse];
        });

        it(@"doesn't starts with a space after a completed emoji", ^{
            BOOL result = [sut shouldStartAutoCompletionForString:@"sometext :thumbs: "];
            [[theValue(result) should] beFalse];
        });

        it(@"ends with a space", ^{
            BOOL result = [sut shouldStartAutoCompletionForString:@"sometext :thmbs: up"];
            [[theValue(result) should] beFalse];
        });

    });

    //--------------------------------------------------------------------------

    context(@"-shouldEndAutoCompletionForString", ^{

        it(@"ends with a space", ^{
            BOOL result = [sut shouldEndAutoCompletionForString:@":+1: "];
            [[theValue(result) should] beTrue];
        });

        it(@"ends if no colon is found", ^{
            BOOL result = [sut shouldEndAutoCompletionForString:@"text"];
            [[theValue(result) should] beTrue];
        });

        it(@"ends after the emoji has been completed", ^{
            BOOL result = [sut shouldEndAutoCompletionForString:@"text :+1:"];
            [[theValue(result) should] beTrue];
        });

        it(@"doesn't end if the emjoy is being completed", ^{
            BOOL result = [sut shouldEndAutoCompletionForString:@"text :+1"];
            [[theValue(result) should] beFalse];
        });

    });

    //--------------------------------------------------------------------------

    context(@"-autoCompletionCandidatesForString", ^{
        it(@"starts if the emjoi has not being completed", ^{
            NSArray *result = [sut candidatesEntriesForString:@"sometext :thumbs"];
            [[result should] equal:@[@"thumbsup", @"thumbsdown"]];
        });

    });

    //--------------------------------------------------------------------------

    context(@"-completeString:candidate:insertionPoint:", ^{
//        it(@"completes a string", ^{
//            NSString *string = @"sometext :thumbs";
//            NSString *result = [sut completeString:string candidate:@"thumbsdown" insertionPoint:string.length];
//            [[result should] equal:@"sometext :thumbsdown: "];
//        });
//
//        it(@"completes a string being editing in the middle", ^{
//            NSString *firstPart = @"sometext :thumbs";
//            NSString *secondPart = @" othertext";
//            NSString *string = [firstPart stringByAppendingString:secondPart];
//            NSString *result = [sut completeString:string candidate:@"thumbsdown" insertionPoint:firstPart.length];
//            [[result should] equal:@"sometext :thumbsdown: othertext"];
//        });

        it(@"completes a string containing emojis being editing in the middle", ^{
            NSString *firstPart = @":+1: sometext :thumbs";
            NSString *secondPart = @" :+1: othertext";
            NSString *string = [firstPart stringByAppendingString:secondPart];
            NSString *result = [sut completeString:string candidateEntry:@"thumbsdown" insertionPoint:firstPart.length];
            [[result should] equal:@":+1: sometext :thumbsdown: :+1: othertext"];
        });
    });

    //--------------------------------------------------------------------------
    
});

SPEC_END