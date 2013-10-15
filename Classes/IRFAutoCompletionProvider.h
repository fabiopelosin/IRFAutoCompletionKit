//
//  IRFAbstractAutoCompletionProvider.h
//  Marshmallow
//
//  Created by Fabio Pelosin on 15/10/13.
//  Copyright (c) 2013 Fabio Angelog Pelosin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IRFAutoCompletionProvider : NSObject

@property (nonatomic, copy) NSArray* (^entriesBlock)(void);
@property (nonatomic, copy) NSString* (^completionBlock)(id entry);
@property (nonatomic, copy) NSImage* (^imageBlock)(id entry);

@property (copy, nonatomic) NSString *startCharacter;
@property (copy, nonatomic) NSString *endCharacter;
@property (copy, nonatomic) NSArray *separationCharacters;

//------------------------------------------------------------------------------
/// Concrete Methods
//------------------------------------------------------------------------------

- (BOOL)shouldStartAutoCompletionForString:(NSString*)string insertionPoint:(NSInteger)insertionPoint;
- (BOOL)shouldStartAutoCompletionForString:(NSString*)string;

- (BOOL)shouldEndAutoCompletionForString:(NSString*)string insertionPoint:(NSInteger)insertionPoint;
- (BOOL)shouldEndAutoCompletionForString:(NSString*)string;

- (NSArray*)candidatesEntriesForString:(NSString*)string insertionPoint:(NSInteger)insertionPoint group:(NSString*)group;
- (NSArray*)candidatesEntriesForString:(NSString*)string insertionPoint:(NSInteger)insertionPoint;
- (NSArray*)candidatesEntriesForString:(NSString*)string;

- (NSString*)completeString:(NSString*)string candidateEntry:(id)candidate insertionPoint:(NSInteger)insertionPoint;
- (NSString*)completeString:(NSString*)string candidateEntry:(id)candidateEntry;
- (NSString*)completeString:(NSString*)string;

// Display

- (NSArray*)entries;
- (NSString*)completionForEntry:(id)entry;
- (NSString*)displayValueForEntry:(id)entry;
- (NSImage*)imageForEntry:(id)entry;

// Groups support

- (NSArray*)entryGroups;
- (NSArray*)entriesForGroup:(NSString*)group;


@end