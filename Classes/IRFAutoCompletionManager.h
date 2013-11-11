//
//  IRFAutoCompletionManager.h
//  Pods
//
//  Created by Fabio Pelosin on 18/10/13.
//
//

#import <Foundation/Foundation.h>

@protocol IRFAutoCompletionTextFieldManagerDelegate;

//------------------------------------------------------------------------------

@interface IRFAutoCompletionManager : NSObject

@property (nonatomic, weak) id<IRFAutoCompletionTextFieldManagerDelegate> delegate;

@property (nonatomic, strong) NSArray *completionProviders;

@property (nonatomic, strong, readonly) NSPopover *popover;

@property NSRectEdge preferredEdge;

@property CGFloat popOverWidth;

@property CGFloat popOverMaxHeigh;

- (BOOL)updatePopOverForTextChange:(NSString*)text insertionPoint:(NSUInteger)insertionPoint;

- (NSString*)autoCompleteAndDismissPopOver;

- (void)moveSelectionUp;

- (void)moveSelectionDown;

// Sub classes

@property (nonatomic, strong) NSView *attachedView;

@property NSUInteger lastInsertionPoint;

@property NSString *lastText;

- (void)presentPopOver;

- (void)updatePopOverEntries;

@end

//------------------------------------------------------------------------------

@protocol IRFAutoCompletionTextFieldManagerDelegate <NSObject>
@required
- (void)autoCompletionTextFieldManagerDidPerformSubstitution:(IRFAutoCompletionManager*)manager;

@end
