//
//  kohMonitorAppDelegate.h
//  kohMonitor
//
//  Created by Justin McNally on 2/19/13.
//  Copyright (c) 2013 Kohactive. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "kohMonitorWindowController.h"
#import "kohMonitorWebViewController.h"

@interface kohMonitorAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) kohMonitorWindowController *windowController;
@property (retain) kohMonitorWebViewController *webViewController;
@end
