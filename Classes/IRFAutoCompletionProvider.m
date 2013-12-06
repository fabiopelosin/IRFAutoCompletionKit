//
//  IRFAbstractAutoCompletionProvider.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 15/10/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import "IRFAutoCompletionProvider.h"

@implementation IRFAutoCompletionProvider

- (id)init {
    self = [super init];
    if (self) {
        [self setStartCharacter:@""];
        [self setEndCharacter:@""];
        [self setSeparationCharacters:@[@" ", @"\n"]];
        [self setCaseSensitive:NO];
    }
    return self;
}

//------------------------------------------------------------------------------

- (BOOL)shouldStartAutoCompletionForString:(NSString*)string; {
    NSString *substringFromStartCharacter = [self _substringFromStartCharacterOfString:string];
    if (!substringFromStartCharacter) {
        return FALSE;
    }

    if ([substringFromStartCharacter isEqualToString:self.startCharacter]) {
        return TRUE;
    }

    if ([string hasSuffix:self.endCharacter]) {
        NSString *substringToEndCharacter = [string substringToIndex:string.length - self.endCharacter.length];
        NSRange previousStartRange = [substringToEndCharacter rangeOfString:self.startCharacter options:NSBackwardsSearch];
        if (previousStartRange.location != NSNotFound) {
            NSString *pontenialComplete = [substringToEndCharacter substringFromIndex:previousStartRange.location + previousStartRange.length];
            if (![self _stringHasInterruptionCharacters:pontenialComplete]) {
                return FALSE;
            }
        }
    }

    if([self candidatesEntriesForString:string].count == 0) {
        return FALSE;
    }

    return ![self _stringHasInterruptionCharacters:substringFromStartCharacter];
}

- (BOOL)shouldStartAutoCompletionForString:(NSString*)string insertionPoint:(NSInteger)insertionPoint {
    NSString *substring = [string substringToIndex:insertionPoint];
    return [self shouldStartAutoCompletionForString:substring];
}


- (BOOL)shouldEndAutoCompletionForString:(NSString*)string {
    if ([string hasSuffix:self.endCharacter]) {
        return TRUE;
    }

    NSString *substringFromStartCharacter = [self _substringFromStartCharacterOfString:string];
    if (!substringFromStartCharacter) {
        return TRUE;
    }

    if([self _stringHasInterruptionCharacters:substringFromStartCharacter]) {
        return TRUE;
    }

    if([self candidatesEntriesForString:string].count == 0) {
        return TRUE;
    }

    return FALSE;
}

- (BOOL)shouldEndAutoCompletionForString:(NSString*)string insertionPoint:(NSInteger)insertionPoint {
    NSString *substring = [string substringToIndex:insertionPoint];
    return [self shouldEndAutoCompletionForString:substring];
}

//------------------------------------------------------------------------------
#pragma mark - AutoCompletionCandidates
//------------------------------------------------------------------------------

- (NSArray*)candidatesEntriesForString:(NSString*)string insertionPoint:(NSInteger)insertionPoint group:(NSString*)group {
    NSArray *entries;
    if (group) {
        entries = [self entriesForGroup:group];
    } else {
        entries = [self entries];
    }

    NSString *searchKey = [self _autoCompletionPrefixForString:string];
    if ([searchKey isEqualToString:@""]) {
        return entries;
    } else {
        if (!self.isCaseSensitive) {
            searchKey = [searchKey lowercaseString];
        }
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id entry, NSDictionary *bindings) {
            NSString *completion = [self completionForEntry:entry];
            if (!self.isCaseSensitive) {
                completion = [completion lowercaseString];
            }
            return [completion hasPrefix:searchKey];
        }];
        NSArray *candidateEntries = [entries filteredArrayUsingPredicate:predicate];
        return candidateEntries;
    }
}

- (NSArray*)candidatesEntriesForString:(NSString*)string insertionPoint:(NSInteger)insertionPoint {
    return [self candidatesEntriesForString:string insertionPoint:insertionPoint group:nil];
}

- (NSArray*)candidatesEntriesForString:(NSString*)string group:(NSString*)group; {
    return [self candidatesEntriesForString:string insertionPoint:string.length group:nil];
}

- (NSArray*)candidatesEntriesForString:(NSString*)string; {
    return [self candidatesEntriesForString:string insertionPoint:string.length group:nil];
}

- (NSString*)completeString:(NSString*)string candidateEntry:(id)candidateEntry insertionPoint:(NSInteger)insertionPoint {
    if (candidateEntry) {
        NSString *candidate = [self completionForEntry:candidateEntry];
        NSRange range = [self _replacementRangeOfString:string insertionPoint:insertionPoint];

        NSString *separator;
        if (self.separationCharacters.count) {
            NSUInteger endStringBeginning = range.location + range.length;
            if (string.length >= endStringBeginning) {
                NSString *rangeSubstring = [string substringFromIndex:endStringBeginning];
                NSString *rangeFirstCharacter = [rangeSubstring substringToIndex:1];
                if ([self.separationCharacters indexOfObject:rangeFirstCharacter] == NSNotFound) {
                    separator = self.separationCharacters[0];
                }
            } else {
                separator = self.separationCharacters[0];
            }
        }

        NSString *completion = [self _completionWithCandidate:candidate separator:separator];
        NSString *result = [self _replaceRange:range string:string replacement:completion];
        return result;
    } else {
        return string;
    }
}

- (NSString*)completeString:(NSString*)string candidateEntry:(id)candidateEntry {
    return [self completeString:string candidateEntry:candidateEntry insertionPoint:string.length];
}

- (NSString*)completeString:(NSString*)string {
    NSString *candidateEntry = [self candidatesEntriesForString:string][0];
    return [self completeString:string candidateEntry:candidateEntry insertionPoint:string.length];
}

//------------------------------------------------------------------------------
#pragma mark - Private Helpers
//------------------------------------------------------------------------------

- (NSString*)_completionWithCandidate:(NSString*)candidate separator:(NSString*)separator {
    NSMutableString *result = [NSMutableString new];
    if (self.startCharacter) {
        [result appendString:self.startCharacter];
    }
    if (candidate) {
        [result appendString:candidate];
    }
    if (self.endCharacter) {
        [result appendString:self.endCharacter];
    }
    if (separator) {
        [result appendString:separator];
    }
    return result;
}

- (NSString*)_autoCompletionPrefixForString:(NSString*)string {
    NSString *searchKey = [[string componentsSeparatedByString:self.startCharacter] lastObject];

    NSRange separatorRange = [self _searchString:searchKey forSubstrings:self.separationCharacters options:0];
    if (separatorRange.location != NSNotFound) {
        searchKey = [searchKey substringToIndex:separatorRange.location];
    }

    return searchKey;
}

- (NSRange)_replacementRangeOfString:(NSString*)string insertionPoint:(NSInteger)insertionPoint {
    NSString *startString = [string substringToIndex:insertionPoint];
    NSString *endString = [string substringFromIndex:insertionPoint];

    NSUInteger start = [startString rangeOfString:self.startCharacter options:NSBackwardsSearch].location;

    if (start == NSNotFound) {
        start = 0;
    }

    NSUInteger startLength = startString.length - start;
    NSUInteger endLength = NSNotFound;
    for (NSString *sep in self.separationCharacters) {
        NSUInteger newLength = [endString rangeOfString:sep].location;
        if (newLength < endLength) {
            endLength = newLength;
        }
    }

    if (self.endCharacter) {
        NSUInteger newLength = [endString rangeOfString:self.endCharacter].location;
        if (newLength < endLength) {
            endLength = newLength;
        }
    }

    if (endLength == NSNotFound) {
        endLength = string.length;
    }
    return NSMakeRange(start, startLength + endLength);
}

- (NSString*)_replaceRange:(NSRange)range string:(NSString*)string replacement:(NSString*)replacement {
    NSString *before = [string substringToIndex:range.location];
    NSString *after = @"";
    NSUInteger endStringIndex = range.location + range.length;
    if (string.length >= endStringIndex) {
        after = [string substringFromIndex:endStringIndex];
    }
    NSString *result = [NSString stringWithFormat:@"%@%@%@", before, replacement, after];
    return result;
}

- (NSString*)_sanitizeString:(NSString*)string {
    NSData *asciiEncoded = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *sanitized = [[NSString alloc] initWithData:asciiEncoded encoding:NSASCIIStringEncoding];
    return [sanitized lowercaseString];
}

//------------------------------------------------------------------------------
#pragma mark - Display
//------------------------------------------------------------------------------

- (NSArray*)entries {
    if (self.groupsBlock) {
        NSMutableArray *result = [NSMutableArray new];
        for (NSString *group in [self entryGroups]) {
            [result addObjectsFromArray:[self entriesForGroup:group]];
        }
        return result;
    } else if (self.entriesBlock) {
        return self.entriesBlock();

    } else {
        [NSException raise:NSInternalInconsistencyException format:@"No entries for autocompletion provider: %@", self];
        return nil;
    }
}

- (NSString*)completionForEntry:(id)entry {
    if (self.completionBlock) {
        return self.completionBlock(entry);
    } else {
        if ([entry isKindOfClass:[NSString class]]) {
            return entry;
        } else {
            return [entry description];
        }
    }}

- (NSString*)displayValueForEntry:(id)entry {
    if (self.displayValueBlock) {
        return self.displayValueBlock(entry);
    } else {
        return [self completionForEntry:entry];
    }
}

- (NSImage*)imageForEntry:(NSString*)entry {
    if (self.imageBlock) {
        return self.imageBlock(entry);
    } else {
        return nil;
    }
}

//------------------------------------------------------------------------------
#pragma mark - Groups Support
//------------------------------------------------------------------------------

- (NSArray*)entryGroups {
    if (self.groupsBlock) {
        return self.groupsBlock();
    } else {
        return nil;
    }
}

- (NSArray*)entriesForGroup:(NSString*)group {
    if (self.entriesForGroupsBlock) {
        return self.entriesForGroupsBlock(group);
    } if (self.groupsBlock) {
        [NSException raise:NSInternalInconsistencyException format:@"The groupsBlock has been set without an entriesForGroupsBlock for autocompletion provider: %@", self];
        return nil;
    } else {
        return nil;
    }
}

//------------------------------------------------------------------------------
#pragma mark - Private Helpers
//------------------------------------------------------------------------------

- (NSRange)_searchString:(NSString*)string forSubstrings:(NSArray*)strings options:(NSStringCompareOptions)mask {
    __block NSRange startRange = NSMakeRange(NSNotFound, 0);

    [strings enumerateObjectsUsingBlock:^(NSString *combination, NSUInteger idx, BOOL *stop) {
        NSRange range = [string rangeOfString:combination options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            if (startRange.location == NSNotFound || range.location > startRange.location) {
                startRange = range;
            }
        }
    }];

    return startRange;
}

- (NSString*)_substringFromStartCharacterOfString:(NSString*)string {
    if (!string || [string isEqualToString:@""]) {
        return nil;
    }

    if ([string isEqualToString:self.startCharacter]) {
        return @"";
    }

    if ([string hasPrefix:self.startCharacter]) {
        NSRange separatorRange = [self _searchString:string forSubstrings:self.separationCharacters options:NSBackwardsSearch];
        if (separatorRange.location == NSNotFound) {
            NSString *substring = [string substringFromIndex:self.startCharacter.length];
            return substring;
        }
    }

    NSMutableArray *possibleStartCombinations = [NSMutableArray new];
    [self.separationCharacters enumerateObjectsUsingBlock:^(NSString *separator, NSUInteger idx, BOOL *stop) {
        NSString *combination = [separator stringByAppendingString:self.startCharacter];
        [possibleStartCombinations addObject:combination];
    }];

    NSRange startRange = [self _searchString:string forSubstrings:possibleStartCombinations options:NSBackwardsSearch];
    if (startRange.location == NSNotFound) {
        return nil;
    } else {
        return [string substringFromIndex:startRange.location + startRange.length];
    }
}

- (BOOL)_stringHasInterruptionCharacters:(NSString*)string {
    NSMutableArray *interruptionCharacters = [NSMutableArray new];
    if (self.endCharacter && [self.endCharacter isNotEqualTo:@""]) {
        [interruptionCharacters addObject:self.endCharacter];
    }
    [self.separationCharacters enumerateObjectsUsingBlock:^(NSString *character, NSUInteger idx, BOOL *stop) {
        if (![character isEqualToString:@""]) {
            [interruptionCharacters addObject:character];
        }
    }];

    __block BOOL hasInterruptionCharacter = FALSE;
    [interruptionCharacters enumerateObjectsUsingBlock:^(NSString *character, NSUInteger idx, BOOL *stop) {
        if ([string rangeOfString:character].location != NSNotFound) {
            hasInterruptionCharacter = TRUE;
        }
    }];

    return hasInterruptionCharacter;
}

@end
