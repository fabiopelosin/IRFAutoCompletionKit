//
//  IRFAutoCompletionManager.m
//  Pods
//
//  Created by Fabio Pelosin on 18/10/13.
//
//

#import "IRFAutoCompletionManager.h"
#import "IRFUserCompletionProvider.h"
#import "IRFAutoCompletionViewController.h"
#import "IRFAutoCompletionViewControllerDataSource.h"
#import "IRFEmojiAutoCompletionProvider.h"
#import "IRFUserCompletionProvider.h"

//------------------------------------------------------------------------------
@interface IRFAutoCompletionManager () <IRFAutoCompletionViewControllerDelegate, IRFAutoCompletionViewControllerDataSourceDelegate>

@property (nonatomic, strong) IRFAutoCompletionProvider *autoCompletionProvider;
@property (nonatomic, strong, readonly) IRFAutoCompletionViewController *popOverViewController;

@end

//------------------------------------------------------------------------------

@implementation IRFAutoCompletionManager

- (id)init {
    self = [super init];
    if (self) {
        _popOverViewController = [IRFAutoCompletionViewController new];
        [_popOverViewController setDelegate:self];
        [_popOverViewController.tableManager setDelegate:self];

        _popover = [[NSPopover alloc] init];
        [_popover setContentViewController:_popOverViewController];
        [_popover setAnimates:NO];
        [_popover setBehavior:NSPopoverBehaviorTransient];
        [_popover setAppearance:NSPopoverAppearanceMinimal];

        _preferredEdge = NSMinYEdge;
        _popOverWidth = 300;
        _popOverMaxHeigh = 200;
    }
    return self;
}

//------------------------------------------------------------------------------
#pragma mark - Base Logic
//------------------------------------------------------------------------------

- (BOOL)updatePopOverForTextChange:(NSString*)text insertionPoint:(NSUInteger)insertionPoint {
    [self setLastText:text];
    [self setLastInsertionPoint:insertionPoint];

    BOOL didShowPopOver = FALSE;
    if ([self.popover isShown]) {
        if (!text || [self.autoCompletionProvider shouldEndAutoCompletionForString:text insertionPoint:insertionPoint]) {
            [self.popover close];
        } else {
            [self updatePopOverEntries];
        }
    } else {
        IRFAutoCompletionProvider *autoCompletionProvider = [self detectAutoCompletionProvider];
        if (autoCompletionProvider) {
            [self setAutoCompletionProvider:autoCompletionProvider];
            [self updatePopOverEntries];
            [self presentPopOver];
            didShowPopOver = TRUE;
        }
    }
    return didShowPopOver;
}

- (IRFAutoCompletionProvider*)detectAutoCompletionProvider {
    NSString *text = self.lastText;
    NSUInteger insertionPoint = self.lastInsertionPoint;

    NSUInteger index = [self.completionProviders indexOfObjectPassingTest:^BOOL(IRFAutoCompletionProvider *provider, NSUInteger idx, BOOL *stop) {
        return [provider shouldStartAutoCompletionForString:text insertionPoint:insertionPoint];
    }];

    if (index == NSNotFound) {
        return nil;
    } else {
        return self.completionProviders[index];
    }
}

//------------------------------------------------------------------------------
#pragma mark - PopOver
//------------------------------------------------------------------------------

- (void)presentPopOver {
    [self.popover showRelativeToRect: self.attachedView.frame ofView:self.attachedView.superview preferredEdge:self.preferredEdge];
}

- (void)updatePopOverEntries {
    NSString *text = self.lastText;
    NSUInteger insertionPoint = self.lastInsertionPoint;

    BOOL hasEntries = NO;
    [self.popOverViewController.tableManager startContentEditing];
    if ([self.autoCompletionProvider entryGroups]) {
        for (NSString *group in [self.autoCompletionProvider entryGroups]) {
            NSArray *groupCompletionCandidates = [self.autoCompletionProvider candidatesEntriesForString:text insertionPoint:insertionPoint group:group];
            if ([groupCompletionCandidates count] != 0) {
                hasEntries = YES;
                [self.popOverViewController.tableManager addGroup:group];
                for (NSString *candidate in groupCompletionCandidates) {
                    [self.popOverViewController.tableManager addEntry:candidate];
                }
            }
        }
    } else {
        NSArray *candidateEntries = [self.autoCompletionProvider candidatesEntriesForString:text insertionPoint:insertionPoint];
        hasEntries = candidateEntries.count;
        for (NSString *entry in candidateEntries) {
            [self.popOverViewController.tableManager addEntry:entry];
        }
    }
    [self.popOverViewController.tableManager endContentEditing];

    if (hasEntries) {
        [self.popover setContentSize:NSMakeSize(self.popOverWidth, MIN(self.popOverViewController.intrinsicHeight, self.popOverMaxHeigh))];
    } else {
        [self.popover close];
    }
}

- (NSString*)autoCompleteAndDismissPopOver {
    [self.popover close];

    NSString *text = self.lastText;
    NSUInteger insertionPoint = self.lastInsertionPoint;
    NSString *candidate = [self.popOverViewController selectedValue];
    NSString *newMessage = [self.autoCompletionProvider completeString:text candidateEntry:candidate insertionPoint:insertionPoint];
    if ([self.delegate respondsToSelector:@selector(autoCompletionTextFieldManagerDidPerformSubstitution:)]) {
        [self.delegate autoCompletionTextFieldManagerDidPerformSubstitution:self];
    }

    /*** Move ***/
    return newMessage;
}

//------------------------------------------------------------------------------
#pragma mark - Other Public Methods
//------------------------------------------------------------------------------

- (void)moveSelectionUp {
    if ([self.popover isShown]) {
        [self.popOverViewController moveSelectionUp];
    }
}

- (void)moveSelectionDown {
    if ([self.popover isShown]) {
        [self.popOverViewController moveSelectionDown];
    }
}


//------------------------------------------------------------------------------
#pragma mark - IRFAutoCompletionViewControllerDelegate
//------------------------------------------------------------------------------

- (void)autoCompletionViewController:(IRFAutoCompletionViewController*)vc didSelectValue:(NSString*)value {
    [self autoCompleteAndDismissPopOver];
}

//------------------------------------------------------------------------------
#pragma mark - IRFAutoCompletionViewControllerDataSourceDelegate
//------------------------------------------------------------------------------

- (NSString*)tableViewManager:(IRFAutoCompletionViewControllerDataSource*)tableViewManager displayValueForEntry:(NSString*)entry {
    return [self.autoCompletionProvider displayValueForEntry:entry];
}

- (NSImage*)tableViewManager:(IRFAutoCompletionViewControllerDataSource*)tableViewManager imageForEntry:(NSString*)entry {
    return [self.autoCompletionProvider imageForEntry:entry];
}



@end
