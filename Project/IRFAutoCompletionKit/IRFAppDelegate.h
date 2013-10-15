//
//  IRFAppDelegate.h
//  IRFAutoCompletionKit
//
//  Created by Fabio Pelosin on 15/10/13.
//  Copyright (c) 2013 Discontinuity. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IRFAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSTextField *labelTextField;

@end
