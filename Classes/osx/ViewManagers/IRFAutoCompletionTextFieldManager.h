//
//  IRFAutoCompletionTextFieldManager.h
//  Pods
//
//  Created by Fabio Pelosin on 18/10/13.
//
//

#import <Foundation/Foundation.h>
#import "IRFAutoCompletionManager.h"


@interface IRFAutoCompletionTextFieldManager : IRFAutoCompletionManager <NSTextFieldDelegate>

- (void)attachToTextField:(NSTextField*)textField;

@property (nonatomic, weak) id<NSTextFieldDelegate> textFieldFowardingDelegate;

@end


