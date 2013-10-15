//
//  IRFAutoCompletionViewControllerDataSource.h
//  Pods
//
//  Created by Fabio Pelosin on 18/10/13.
//
//

#import <Foundation/Foundation.h>

@protocol IRFAutoCompletionViewControllerDataSourceDelegate;

//------------------------------------------------------------------------------

@interface IRFAutoCompletionViewControllerDataSource : NSObject <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, weak) id<IRFAutoCompletionViewControllerDataSourceDelegate> delegate;

@property (nonatomic, weak) NSTableView *tableView;

- (void)startContentEditing;
- (void)endContentEditing;
- (void)addGroup:(NSString*)group;
- (BOOL)isGroup:(NSInteger)index;
- (void)addEntry:(NSString*)entry;
- (NSString*)entryAtIndex:(NSInteger)index;


- (BOOL)isEmpty;
- (NSUInteger)rowCount;

@end

//------------------------------------------------------------------------------

@protocol IRFAutoCompletionViewControllerDataSourceDelegate <NSObject>
@optional
- (NSString*)tableViewManager:(IRFAutoCompletionViewControllerDataSource*)tableViewManager displayValueForGroup:(NSString*)group;
- (NSString*)tableViewManager:(IRFAutoCompletionViewControllerDataSource*)tableViewManager displayValueForEntry:(NSString*)entry;
- (NSImage*)tableViewManager:(IRFAutoCompletionViewControllerDataSource*)tableViewManager imageForEntry:(NSString*)entry;
@end
