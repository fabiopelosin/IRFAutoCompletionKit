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
        [sut setEntriesBlock:^NSArray *{
            return @[@"thumbsup", @"thumbsdown", @"+1"];
        }];
    });

    //--------------------------------------------------------------------------

    context(@"-shouldStartAutoCompletionForString", ^{

        it(@"starts after the start character", ^{
            BOOL result = [sut shouldStartAutoCompletionForString:@":"];
            [[theValue(result) should] beTrue];
        });

        it(@"doesnt' starts if the start character could not be found", ^{
            BOOL result = [sut shouldStartAutoCompletionForString:@"Some string!"];
            [[theValue(result) should] beFalse];
        });

        it(@"starts after the user typed the start character in a string", ^{
            BOOL result = [sut shouldStartAutoCompletionForString:@"substring :"];
            [[theValue(result) should] beTrue];
        });

        it(@"starts after the start character if a completion is still in progress", ^{
            NSString *string = @"sometext :thumbs";
            BOOL result = [sut shouldStartAutoCompletionForString:string];
            [[theValue(result) should] beTrue];
        });

        it(@"doesn't starts with a space after a completed emoji", ^{
            NSString *string = @"sometext :thumbs: ";
            BOOL result = [sut shouldStartAutoCompletionForString:string];
            [[theValue(result) should] beFalse];
        });

        it(@"doesn't start after a separation character", ^{
            NSString *string = @"sometext :thmbs: up";
            BOOL result = [sut shouldStartAutoCompletionForString:string];
            [[theValue(result) should] beFalse];
        });

        it(@"doesn't start when the completion has been terminated and has the same charater for the start and the end", ^{
            NSString *string = @"sometext :thumbs:";
            BOOL result = [sut shouldStartAutoCompletionForString:string];
            [[theValue(result) should] beFalse];
        });
    });

    //--------------------------------------------------------------------------

    context(@"-shouldEndAutoCompletionForString", ^{

        it(@"ends with a space", ^{
            BOOL result = [sut shouldEndAutoCompletionForString:@":+1: "];
            [[theValue(result) should] beTrue];
        });

        it(@"ends if no start character is found", ^{
            NSString *string = @"text";
            BOOL result = [sut shouldEndAutoCompletionForString:string];
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

    context(@"-candidatesEntriesForString", ^{
        it(@"starts if the emjoi has not being completed", ^{
            NSArray *result = [sut candidatesEntriesForString:@"sometext :thumbs"];
            [[result should] equal:@[@"thumbsup", @"thumbsdown"]];
        });

        it(@"is case insensitive", ^{
            NSArray *result = [sut candidatesEntriesForString:@"sometext :Thumbs"];
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