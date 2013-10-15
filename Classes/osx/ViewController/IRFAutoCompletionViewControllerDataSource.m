//
//  IRFAutoCompletionViewControllerDataSource.m
//  Pods
//
//  Created by Fabio Pelosin on 18/10/13.
//
//

#import "IRFAutoCompletionViewControllerDataSource.h"

@interface IRFAutoCompletionViewControllerDataSource ()

@property (nonatomic, strong) NSMutableArray* entriesList;
@property (nonatomic, strong) NSMutableArray* groupIndexes;


@end


//------------------------------------------------------------------------------

@implementation IRFAutoCompletionViewControllerDataSource

- (id)init
{
    self = [super init];
    if (self) {
        _entriesList = [NSMutableArray new];
        _groupIndexes = [NSMutableArray new];
    }
    return self;
}

- (void)startContentEditing;
{
    [self.entriesList removeAllObjects];
    [self.groupIndexes removeAllObjects];
}

- (void)endContentEditing;
{
    [self.tableView reloadData];
}

- (void)addGroup:(NSString*)group;
{
    [self.entriesList addObject:group];
    [self.groupIndexes addObject:@(self.entriesList.count-1)];
}

- (void)addEntry:(NSString*)entry;
{
    [self.entriesList addObject:entry];
}

- (NSString*)entryAtIndex:(NSInteger)index
{
    NSString *result = [self.entriesList objectAtIndex:index];
    return result;
}

- (BOOL)isGroup:(NSInteger)index;
{
    BOOL result = [self.groupIndexes indexOfObject:@(index)] != NSNotFound;
    return result;
}

- (NSUInteger)rowCount;
{
	NSInteger result = [self.entriesList count];
    return result;

}

- (BOOL)isEmpty;
{
    return [self rowCount] == 0;
}


//------------------------------------------------------------------------------
#pragma mark - Private Methods
//------------------------------------------------------------------------------

- (NSString*)displayValueForGroup:(NSInteger)index
{
    NSString *group = [self.entriesList objectAtIndex:index];
    NSString *result = group;
    if ([self.delegate respondsToSelector:@selector(tableViewManager:displayValueForGroup:)]) {
        NSString *delegateValue = [self.delegate tableViewManager:self displayValueForGroup:group];
        if (delegateValue) {
            result = delegateValue;
        }
    }
    return result;
}

- (NSString*)displayValueForEntry:(NSInteger)index
{
    NSString *entry = [self.entriesList objectAtIndex:index];
    NSString *result = entry;
    if ([self.delegate respondsToSelector:@selector(tableViewManager:displayValueForEntry:)]) {
        NSString *delegateValue = [self.delegate tableViewManager:self displayValueForEntry:entry];
        if (delegateValue) {
            result = delegateValue;
        }
    }
    return result;
}

- (NSImage*)imageForEntry:(NSInteger)index
{
    NSImage *result;
    NSString *entry = [self.entriesList objectAtIndex:index];
    if ([self.delegate respondsToSelector:@selector(tableViewManager:imageForEntry:)]) {
        result = [self.delegate tableViewManager:self imageForEntry:entry];
    }
    return result;
}


//------------------------------------------------------------------------------
#pragma mark - NSTableViewDataSource
//------------------------------------------------------------------------------

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self rowCount];
}

//------------------------------------------------------------------------------
#pragma mark - NSTableViewDelegate
//------------------------------------------------------------------------------

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row {
    return [self isGroup:row];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cell;

    if ([self isGroup:row]) {
        cell = [tableView makeViewWithIdentifier:@"Group" owner:self];
        if (cell == nil) {
            cell = [self createGroupCell];
        }
        [cell.textField setStringValue:[self displayValueForGroup:row]];

    } else {
        cell = [tableView makeViewWithIdentifier:@"ValueCell" owner:self];
        if (cell == nil) {
            cell = [self createValueCell];
        }
        [cell.textField setStringValue:[self displayValueForEntry:row]];
        NSImage *image = [self imageForEntry:row];

        if (image) {
            [cell.imageView setHidden:NO];
            [cell.imageView setImage:image];
            [cell.textField setFrame:CGRectMake(35, 0, cell.textField.frame.size.width - 25, cell.textField.frame.size.height)];
        } else {
            [cell.imageView setHidden:YES];
            [cell.imageView setImage:nil];
            [cell.textField setFrame:CGRectMake(10, 0, cell.textField.frame.size.width + 25, cell.textField.frame.size.height)];
        }
    }

    return cell;
}

- (NSIndexSet *)tableView:(NSTableView *)tableView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes {
    NSUInteger row = proposedSelectionIndexes.firstIndex;
    if([self isGroup:row]) {
        if(row + 1 < [tableView numberOfRows]) {
            return [NSIndexSet indexSetWithIndex:row + 1];
        } else if (row - 1 > 0) {
            return [NSIndexSet indexSetWithIndex:row - 1];
        } else {
            return tableView.selectedRowIndexes;
        }

    } else {
        return proposedSelectionIndexes;
    }
}

- (void)tableViewAction:(NSTableView*)tableView {
//    if ([self.delegate respondsToSelector:@selector(autoCompletionViewController:didSelectValue:)]) {
//        [self.delegate autoCompletionViewController:self didSelectValue:self.selectedValue];
//    }
}

- (void)keyDown:(NSEvent *)event {
    if (event.keyCode == 36) {
        [self tableViewAction:nil];
    }
}

//------------------------------------------------------------------------------
#pragma mark - Helpers exposed for subclasses
//------------------------------------------------------------------------------

- (NSTableCellView*)createGroupCell {
    CGRect frame = CGRectMake(0, 0, 100, 100);
    NSTableCellView *cell = [[NSTableCellView alloc] initWithFrame:frame];
    [cell setIdentifier:@"Group"];
    NSTextField *textField = [[NSTextField alloc] initWithFrame:CGRectMake(10, 0, 90, 100)];
    [textField setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [textField setBezeled:NO];
    [textField setDrawsBackground:NO];
    [textField setEditable:NO];
    [textField setSelectable:NO];
    [textField setFont:[self _defaultFont]];
    [textField.cell setLineBreakMode:NSLineBreakByTruncatingTail];
    [cell addSubview:textField];
    [cell setTextField:textField];
    return cell;
}

- (NSTableCellView*)createValueCell {
    CGRect frame = CGRectMake(0, 0, 100, 100);
    NSTableCellView *cell = [[NSTableCellView alloc] initWithFrame:frame];
    [cell setIdentifier:@"ValueCell"];

    NSTextField *textField = [[NSTextField alloc] initWithFrame:CGRectMake(10, 0, 90, 100)];
    [textField setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [textField setBezeled:NO];
    [textField setDrawsBackground:NO];
    [textField setEditable:NO];
    [textField setSelectable:NO];
    [textField setFont:[self _defaultFont]];
    [textField.cell setLineBreakMode:NSLineBreakByTruncatingTail];
    [cell addSubview:textField];
    [cell setTextField:textField];

    NSImageView *imageView = [[NSImageView alloc] initWithFrame:CGRectMake(10, 0, [self _rowHeigth], [self _rowHeigth])];
    [cell addSubview:imageView];
    [cell setImageView:imageView];
    
    return cell;
}

//------------------------------------------------------------------------------
#pragma mark - Private Helpers
//------------------------------------------------------------------------------

- (NSFont*)_defaultFont {
    return [NSFont systemFontOfSize:12];
}

- (CGFloat)_rowHeigth {
    return 18;
}

@end
