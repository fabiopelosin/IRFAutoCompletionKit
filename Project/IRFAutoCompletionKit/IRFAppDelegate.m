//
//  IRFAppDelegate.m
//  IRFAutoCompletionKit
//
//  Created by Fabio Pelosin on 15/10/13.
//  Copyright (c) 2013 Discontinuity. All rights reserved.
//

#import "IRFAppDelegate.h"
#import <IRFAutoCompletionKit/IRFAutoCompletionKit.h>
#import <IRFEmojiCheatSheet/IRFEmojiCheatSheet.h>

//------------------------------------------------------------------------------

@interface IRFAppDelegate () <IRFAutoCompletionTextFieldManagerDelegate, NSTextFieldDelegate>
@property (strong) IRFAutoCompletionTextFieldManager *autoCompletionManager;
@end

//------------------------------------------------------------------------------

@implementation IRFAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    IRFEmojiAutoCompletionProvider *emojiCompletionProvider = [IRFEmojiAutoCompletionProvider new];
    IRFUserCompletionProvider *userCompletionProvider = [self _userCompletionProvider];
    IRFAutoCompletionProvider *testProvider = [self _testProvider];
    NSArray *completionsProviders = @[emojiCompletionProvider, userCompletionProvider, testProvider];
    [self setAutoCompletionManager:[IRFAutoCompletionTextFieldManager new]];
    [self.autoCompletionManager setCompletionProviders:completionsProviders];
    [self.autoCompletionManager attachToTextField:self.textField];
    [self.autoCompletionManager setTextFieldFowardingDelegate:self];

    [self.textField setTarget:self];
    [self.textField setAction:@selector(copyTextFieldContentsToPasteBoard)];
    [self.labelTextField setStringValue:@""];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:NSControlTextDidChangeNotification object:self.textField];
}

- (void)updateLabelTextField {
    NSString *converted = [IRFEmojiCheatSheet stringByReplacingEmojiAliasesInString:self.textField.stringValue];
    [self.labelTextField setStringValue:converted];
}

- (void)copyTextFieldContentsToPasteBoard {
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard clearContents];
    NSString *converted = [IRFEmojiCheatSheet stringByReplacingEmojiAliasesInString:self.textField.stringValue];
    NSString *trimmedString = [converted stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BOOL success = [pasteBoard writeObjects:[NSArray arrayWithObject:trimmedString]];
    if (success) {
        [self.labelTextField setStringValue:[converted stringByAppendingString:@" - Copied to the clipboard"]];
    }
}

//------------------------------------------------------------------------------
#pragma mark - Notifications
//------------------------------------------------------------------------------

- (void)textFieldDidChange:(NSNotification *)notification {
    [self updateLabelTextField];
}

//------------------------------------------------------------------------------
#pragma mark - IRFAutoCompletionTextFieldManagerDelegate
//------------------------------------------------------------------------------

- (void)autoCompletionTextFieldManagerDidPerformSubstitution:(IRFAutoCompletionTextFieldManager*)manager {
    [self updateLabelTextField];
    [self copyTextFieldContentsToPasteBoard];
}

//------------------------------------------------------------------------------
#pragma mark - Private
//------------------------------------------------------------------------------

- (IRFUserCompletionProvider *)_userCompletionProvider {
    IRFUserCompletionProvider *userCompletionProvider = [IRFUserCompletionProvider new];

    [userCompletionProvider setGroupsBlock:^NSArray *{
        return @[@"Online", @"Offline"];
    }];

    [userCompletionProvider setEntriesForGroupsBlock:^NSArray *(NSString *group) {
        if ([group isEqualToString:@"Online"]) {
            return @[@"Alloy", @"Orta", @"Marin", @"Michele"];
        } else {
            return @[@"Fabio"];
        }
    }];

    [userCompletionProvider setImageBlock:^NSImage *(NSString *entry) {
        return [NSImage imageNamed:@"Lion"];
    }];
    return userCompletionProvider;
}

- (IRFAutoCompletionProvider *)_testProvider {
    IRFAutoCompletionProvider *testProvider = [IRFAutoCompletionProvider new];
    [testProvider setStartCharacter:@"$"];
    [testProvider setSeparationCharacters:@[@" ", @"\n"]];
    [testProvider setEntriesBlock:^NSArray *{
        return @[@"test1", @"test2"];
    }];
    return testProvider;
}

@end
