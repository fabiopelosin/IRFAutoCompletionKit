//
//  DSEmojiAutoCompletionProvider.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 15/10/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "IRFEmojiAutoCompletionProvider.h"
#import <IRFEmojiCheatSheet/IRFEmojiCheatSheet.h>

@implementation IRFEmojiAutoCompletionProvider

//------------------------------------------------------------------------------

- (id)init
{
    self = [super init];
    if (self) {
        [self setStartCharacter:@":"];
        [self setEndCharacter:@":"];
        [self setSeparationCharacters:@[@" ", @"\n"]];
    }
    return self;
}

//------------------------------------------------------------------------------
#pragma mark - Display
//------------------------------------------------------------------------------

- (NSArray*)entries {
    NSMutableArray *completions = [NSMutableArray new];
    NSDictionary *aliases = [IRFEmojiCheatSheet emojisByAlias];

    [[aliases allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        [completions addObject:[key stringByReplacingOccurrencesOfString:@":" withString:@""]];
    }];
    return completions;
}

- (NSString*)completionForEntry:(id)entry {
    return entry;
}

- (NSString*)displayValueForEntry:(id)entry {
    NSString *base = [NSString stringWithFormat:@":%@: %@", entry, entry];
    NSString *result = [IRFEmojiCheatSheet stringByReplacingEmojiAliasesInString:base];
    return result;
}

- (NSImage*)imageForEntry:(id)entry {
    return nil;
}

//------------------------------------------------------------------------------
#pragma mark - Groups Support
//------------------------------------------------------------------------------

- (NSArray*)entryGroups {
    return [[IRFEmojiCheatSheet emojisByGroup] allKeys];
}

- (NSArray*)entriesForGroup:(NSString*)group {
    return [IRFEmojiCheatSheet emojisByGroup][group];
}

//------------------------------------------------------------------------------

@end
