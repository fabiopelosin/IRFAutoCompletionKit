//
//  MMPopOverEmojiViewController.h
//  Marshmallow
//
//  Created by Fabio Pelosin on 11/10/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IRFAutoCompletionViewControllerDataSource.h"

@protocol IRFAutoCompletionViewControllerDelegate;

//------------------------------------------------------------------------------

/**
 A view controller which manages a table in order to display a list of autocompletions to the users.
 */
@interface IRFAutoCompletionViewController : NSViewController

/**
 @name Main logic
 **/

/**
 The table view which will display the values.
 */
@property (nonatomic, weak) NSTableView *tableView;

@property (nonatomic, strong) IRFAutoCompletionViewControllerDataSource *tableManager;


/**
 The delegate which will be informed of the user selections.
 */
@property (nonatomic, weak) id<IRFAutoCompletionViewControllerDelegate> delegate;

/** 
 Moves the selection up as if the user pressed the up arrow key with the table view selected.
 */
- (void)moveSelectionUp;

/**
 Moves the selection down as if the user pressed the down arrow key with the table view selected.
 */
- (void)moveSelectionDown;

/**
 @return The value which is currently selected. The selection is never empty and if the entities list is not empty a non nil value is guaranteed.
 */
- (NSString*)selectedValue;

/** 
 @name Appeareance Customization
 **/

@property (nonatomic, assign) CGFloat rowHeigth;

- (CGFloat)intrinsicHeight;

@end

//------------------------------------------------------------------------------

@protocol IRFAutoCompletionViewControllerDelegate <NSObject>

/**
 @param vc The sender view controller.
 @param value The value which was selected by the user.
 */
- (void)autoCompletionViewController:(IRFAutoCompletionViewController*)vc didSelectValue:(NSString*)value;

@end

