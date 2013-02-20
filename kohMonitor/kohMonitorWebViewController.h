//
//  kohMonitorWebViewController.h
//  kohMonitor
//
//  Created by Justin McNally on 2/19/13.
//  Copyright (c) 2013 Kohactive. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <RestKit/RestKit.h>

@interface kohMonitorWebViewController : NSViewController <RKObjectLoaderDelegate> {
  int pageIndex;
  NSString *currentLoginScript;
  __unsafe_unretained NSWindow *_window;
}

@property (retain) IBOutlet WebView *webView;
@property (retain) IBOutlet WebView *webViewMarquee;
@property (retain) NSArray *pages;
@property (retain) NSArray *headlines;
@property (weak) NSWindow *window;
-(void) startPolling;

@end
