//
//  IRFAutoCompletionTextViewManager.h
//  Pods
//
//  Created by Fabio Pelosin on 08/11/13.
//
//

#import <Foundation/Foundation.h>
#import "IRFAutoCompletionManager.h"

@interface IRFAutoCompletionTextViewManager : IRFAutoCompletionManager <NSTextViewDelegate>

- (void)attachToTextView:(NSTextView*)textView;

@property (nonatomic, weak) id<NSTextViewDelegate> textViewFowardingDelegate;

@end
