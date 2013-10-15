//
//  MMPopOverEmojiViewController.m
//  Marshmallow
//
//  Created by Fabio Pelosin on 11/10/13.
//  Copyright (c) 2013 Fabio Pelosin. All rights reserved.
//

#import "IRFAutoCompletionViewController.h"
#import "IRFAutoCompletionViewControllerDataSource.h"

@interface IRFAutoCompletionViewController ()
@end

//------------------------------------------------------------------------------

@implementation IRFAutoCompletionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _rowHeigth = 18;
        _tableManager = [IRFAutoCompletionViewControllerDataSource new];
    }
    return self;
}

- (void)loadView {
    NSTableColumn * tableColumn = [[NSTableColumn alloc] initWithIdentifier:@"Column1"];
    [tableColumn setResizingMask:NSTableColumnAutoresizingMask];
    [tableColumn setWidth:300];

    NSTableView * tableView = [[NSTableView alloc] initWithFrame:NSMakeRect(0, 0, 300, 200)];
    [tableView addTableColumn:tableColumn];
    [self.tableManager setTableView:tableView];
    [tableView setDelegate:self.tableManager];
    [tableView setDataSource:self.tableManager];
    [tableView setAllowsEmptySelection:NO];
    [tableView setAllowsMultipleSelection:NO];
    [tableView setBackgroundColor:[NSColor clearColor]];
    [tableView setRowHeight:self.rowHeigth];
    [tableView setFloatsGroupRows:YES];
    [tableView setTarget:self];
    [tableView setAction:@selector(tableViewAction:)];
    [tableView setColumnAutoresizingStyle:NSTableViewUniformColumnAutoresizingStyle];
    [tableView setHeaderView:nil];
    [self setTableView:tableView];

    NSScrollView * tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, 300, 200)];
    [tableContainer setDrawsBackground:NO];
    [tableContainer setDocumentView:tableView];
    [tableContainer setHasVerticalScroller:YES];
    [self setView:tableContainer];
}

//------------------------------------------------------------------------------
#pragma mark - Main logic
//------------------------------------------------------------------------------

- (void)moveSelectionUp {
    [self _moveSelectionFromRow:[self.tableView selectedRow] directionUp:YES];
}

- (void)moveSelectionDown {
    [self _moveSelectionFromRow:[self.tableView selectedRow] directionUp:NO];
}

- (NSString*)selectedValue {
    if ([self.tableManager isEmpty]) {
        return nil;
    } else {
        NSInteger selectedRow = [self.tableView selectedRow];
        NSString *result = [self.tableManager entryAtIndex:selectedRow];
        return result;
    }
}

//------------------------------------------------------------------------------
#pragma mark - Appeareance Customization
//------------------------------------------------------------------------------

- (void)setRowHeigth:(CGFloat)rowHeigth {
//    _rowHeigth = rowHeigth;
//    [self.tableView setRowHeight:rowHeigth];
}

- (CGFloat)intrinsicHeight {
    CGFloat rowFullHeigh = self.rowHeigth + self.tableView.intercellSpacing.height;
    NSUInteger rowCount = self.tableManager.rowCount;
    CGFloat result = rowFullHeigh * rowCount;
    return result;
}

//------------------------------------------------------------------------------
#pragma mark - TableView Logic
//------------------------------------------------------------------------------

- (void)tableViewAction:(NSTableView*)tableView {
//    if ([self.delegate respondsToSelector:@selector(autoCompletionViewController:didSelectValue:)]) {
//        [self.delegate autoCompletionViewController:self didSelectValue:self.selectedValue];
//    }
}

- (void)keyDown:(NSEvent *)event {
//    if (event.keyCode == 36) {
//        [self tableViewAction:nil];
//    }
}

//------------------------------------------------------------------------------
#pragma mark - Private Helpers
//------------------------------------------------------------------------------

// Accepts -1
- (void)_moveSelectionFromRow:(NSInteger)row directionUp:(BOOL)isDirectionUp {
    NSInteger currentSelection = row;
    NSInteger numberOfRows = [self.tableView numberOfRows];

    BOOL shouldCheckNextRow = TRUE;
    NSInteger newIndex = currentSelection;
    while (shouldCheckNextRow) {
        NSInteger delta = isDirectionUp ? -1 : +1;
        newIndex = newIndex + delta;
        BOOL newIndexExists = newIndex >= 0 && newIndex < numberOfRows;
        if (newIndexExists) {
            if ([self.tableManager isGroup:newIndex]) {
            } else {
                shouldCheckNextRow = FALSE;
                currentSelection = newIndex;
            }
        } else {
            shouldCheckNextRow = FALSE;
        }

    }

    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:currentSelection] byExtendingSelection:NO];
    [self.tableView scrollRowToVisible:currentSelection];
}


@end
