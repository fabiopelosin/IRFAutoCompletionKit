//
//  IRFAutoCompletionTextFieldManager.m
//  Pods
//
//  Created by Fabio Pelosin on 18/10/13.
//
//

#import "IRFAutoCompletionTextFieldManager.h"

//------------------------------------------------------------------------------

@interface IRFAutoCompletionTextFieldManager ()
@property (nonatomic, strong) NSTextField *textField;
@end

//------------------------------------------------------------------------------

@implementation IRFAutoCompletionTextFieldManager

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)attachToTextField:(NSTextField*)textField {
    [self setAttachedView:textField];
    [self.textField setDelegate:nil];
    [self setTextField:textField];
    [textField setDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:NSControlTextDidChangeNotification object:textField];
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
    [self.textField setStringValue:newMessage];
    NSText* fieldEditor = [self.textField.window fieldEditor:YES forObject:self.textField];
    [self.textField.window makeFirstResponder:self.textField];
    [fieldEditor setSelectedRange:NSMakeRange(insertionPoint + deltaLength, 0)];
}

//------------------------------------------------------------------------------
#pragma mark - Notifications
//------------------------------------------------------------------------------

- (void)textFieldDidChange:(NSNotification *)notification {
    NSText *fieldEditor = [notification userInfo][@"NSFieldEditor"];
    NSUInteger insertionPoint = [fieldEditor selectedRange].location;
    NSTextField *textField = notification.object;
    NSString *text = textField.stringValue;
    BOOL didShowPopOver = [self updatePopOverForTextChange:text insertionPoint:insertionPoint];
    if (didShowPopOver) {
        //    [self.textField.window becomeKeyWindow];
        [self.textField.window makeFirstResponder:self.textField];
        NSText* fieldEditor = [self.textField.window fieldEditor:YES forObject:self.textField];
        [fieldEditor setSelectedRange:NSMakeRange(insertionPoint, 0)];
    }
}

//------------------------------------------------------------------------------
#pragma mark - NSTextFieldDelegate
//------------------------------------------------------------------------------

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector; {
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

    if([self.textFieldFowardingDelegate respondsToSelector:@selector(control:textView:doCommandBySelector:)]) {
        return [self.textFieldFowardingDelegate control:control textView:textView doCommandBySelector:commandSelector];
    } else {
        return returnValue;
    }
}



@end
