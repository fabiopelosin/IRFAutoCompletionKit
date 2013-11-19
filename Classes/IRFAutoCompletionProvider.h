//
//  IRFAbstractAutoCompletionProvider.h
//  Marshmallow
//
//  Created by Fabio Pelosin on 15/10/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Serves as a data source for autocompletions. Clients are mostly interested
 * in populating the class, which can be used with the rest of the kit. In this
 * regard is important to be aware that this class is built around the concept
 * of entries. Those entries are the list of the objects used for the auto 
 * completion and they can by used to provide different display strings or
 * images.
 */
@interface IRFAutoCompletionProvider : NSObject

//------------------------------------------------------------------------------
/// Delimiters
//------------------------------------------------------------------------------

/**
 * The character which should trigger the autcompletion.
 *
 * Defaults to the empty string.
 */
@property (copy, nonatomic) NSString *startCharacter;

/**
 * The string which should be used at the end of the autocompletion. For example
 * for emojis is `:` so the autocompletion for `:smi` actually inserts the colon
 * before the space.
 *
 * Defaults to the empty string.
 */
@property (copy, nonatomic) NSString *endCharacter;

/**
 * The list of characters which indicate an interruption of the autocompletion.
 *
 * The firs one is appneded after completions. Defaults to the space character
 * and to the newline symbol.
 */
@property (copy, nonatomic) NSArray *separationCharacters;

/**
 * Whether completions matching should be case sensitive.
 */
@property (assign, nonatomic, getter = isCaseSensitive) BOOL caseSensitive;


//------------------------------------------------------------------------------
/// Entries
//------------------------------------------------------------------------------

/**
 * Block used to pupulate the entries used for autocompletion.
 */
@property (nonatomic, copy) NSArray* (^entriesBlock)(void);

/**
 * The full list of the entries used for the completion. If entries can be 
 * grouped they should be specified by groups.
 */
- (NSArray*)entries;

/**
 * Block used to indicate the completions associated to each entry.
 */
@property (nonatomic, copy) NSString* (^completionBlock)(id entry);

/**
 * Returns the completion for a given entry. If not block has been provided
 * defaults to the string value of the entry.
 */
- (NSString*)completionForEntry:(id)entry;

/**
 * Block used to compute the string which should be used to represent a given 
 * entry to the user.
 */
@property (nonatomic, copy) NSString* (^displayValueBlock)(id entry);

/**
 * Returns the display value for a given entry. If not block has been provided
 * defaults to the completion for the entry.
 */
- (NSString*)displayValueForEntry:(id)entry;

/**
 * Block used to return the image associated with a given entry.
 */
@property (nonatomic, copy) NSImage* (^imageBlock)(id entry);

/**
 * Returns the image associated with a given entry.
 */
- (NSImage*)imageForEntry:(id)entry;

//------------------------------------------------------------------------------
/// Groups
//------------------------------------------------------------------------------

/**
 * Block used to pupulate the group entries used for autocompletion. 
 * If this block is provided the `entriesForGroupsBlock` should be set as well.
 * This block overrides the `entriesBlock`.
 *
 * The block should return an array of NSStrings.
 */
@property (nonatomic, copy) NSArray* (^groupsBlock)(void);

/**
 * The groups which should be used for the entries if the autcompletion should
 * be grouped.
 */
- (NSArray*)entryGroups;

/**
 * Block used to pupulate the entries for the given group. It must be set if
 * the `groupsBlock` has been provided.
 */
@property (nonatomic, copy) NSArray* (^entriesForGroupsBlock)(NSString *group);

/**
 * The entries associated with the given group.
 */
- (NSArray*)entriesForGroup:(NSString*)group;

//------------------------------------------------------------------------------
/// Queries
//------------------------------------------------------------------------------

/** 
 * Whether the autocomplation should be started after the user has typed a
 * character in the given string with the given inseriont insertion point.
 *
 * This method returns true if the user just typed the start character or if
 * the user is typing after the start character.
 *
 */
- (BOOL)shouldStartAutoCompletionForString:(NSString*)string insertionPoint:(NSInteger)insertionPoint;
- (BOOL)shouldStartAutoCompletionForString:(NSString*)string;

/**
 * Whether an autocompletion in progress should be terminated.
 */
- (BOOL)shouldEndAutoCompletionForString:(NSString*)string insertionPoint:(NSInteger)insertionPoint;
- (BOOL)shouldEndAutoCompletionForString:(NSString*)string;

/**
 * Returns the list of the entries which are candidate to complete the given
 * string.
 */
- (NSArray*)candidatesEntriesForString:(NSString*)string insertionPoint:(NSInteger)insertionPoint group:(NSString*)group;
- (NSArray*)candidatesEntriesForString:(NSString*)string insertionPoint:(NSInteger)insertionPoint;
- (NSArray*)candidatesEntriesForString:(NSString*)string;

/**
 * Returns the result of completing the given string with the given entry.
 */
- (NSString*)completeString:(NSString*)string candidateEntry:(id)candidate insertionPoint:(NSInteger)insertionPoint;
- (NSString*)completeString:(NSString*)string candidateEntry:(id)candidateEntry;
- (NSString*)completeString:(NSString*)string;

@end
