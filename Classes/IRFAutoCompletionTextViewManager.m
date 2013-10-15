//
//  IRFAutoCompletionTextViewManager.m
//  Pods
//
//  Created by Fabio Pelosin on 08/11/13.
//
//

#import "IRFAutoCompletionTextViewManager.h"

//------------------------------------------------------------------------------

@interface IRFAutoCompletionTextViewManager ()
@property (nonatomic, strong) NSTextView *textView;
@end

//------------------------------------------------------------------------------

@implementation IRFAutoCompletionTextViewManager

- (void)attachToTextView:(NSTextView*)textView {
    [self setAttachedView:textView];
    [self.textView setDelegate:nil];
    [self setTextView:textView];
    [self.textView setDelegate:self];
}


- (NSString*)autoCompleteAndDismissPopOver {
    NSString *newMessage = [super autoCompleteAndDismissPopOver];
    [self updateTextFieldForCompletion:newMessage];
    return newMessage;
}

- (void)updateTextFieldForCompletion:(NSString*)newMessage {
    NSString *message = self.lastText;
    NSUInteger insertionPoint = self.lastInsertionPoint;

    NSUInteger deltaLength = newMessage.length - message.length;
    [self.textView setString:newMessage];
    [self.textView.window makeFirstResponder:self.textView];
    [self.textView setSelectedRange:NSMakeRange(insertionPoint + deltaLength, 0)];
}

//------------------------------------------------------------------------------
#pragma mark - Notifications
//------------------------------------------------------------------------------

- (void)textDidChange:(NSNotification *)notification {
    NSTextView *textView = notification.object;
    NSUInteger insertionPoint = [textView selectedRange].location;
    NSString *text = textView.string;
    BOOL didShowPopOver = [self updatePopOverForTextChange:text insertionPoint:insertionPoint];
    if (didShowPopOver) {
        //    [self.textField.window becomeKeyWindow];
        [self.textView.window makeFirstResponder:self.textView];
        [self.textView setSelectedRange:NSMakeRange(insertionPoint, 0)];
    }
}

//------------------------------------------------------------------------------
#pragma mark - NSTextFieldDelegate
//------------------------------------------------------------------------------

- (BOOL)textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector; {
    BOOL returnValue = NO;

    if ([self.popover isShown]) {
        if (commandSelector == @selector(moveUp:)) {
            [self moveSelectionUp];
            returnValue = YES;
        }
        else if (commandSelector == @selector(moveDown:)) {
            [self moveSelectionDown];
            returnValue = YES;
        }
        else if (commandSelector == @selector(insertTab:) || commandSelector == @selector(insertNewline:)) {
            [self autoCompleteAndDismissPopOver];
            returnValue = YES;
        }
        else if (commandSelector == @selector(cancelOperation:)) {
            [self.popover close];
            returnValue = YES;
        }
    }

    if([self.textViewFowardingDelegate respondsToSelector:@selector(control:textView:doCommandBySelector:)]) {
        return [self.textViewFowardingDelegate textView:textView doCommandBySelector:commandSelector];
    } else {
        return returnValue;
    }
}

@end
