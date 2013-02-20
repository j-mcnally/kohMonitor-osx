//
//  kohMonitorAppDelegate.m
//  kohMonitor
//
//  Created by Justin McNally on 2/19/13.
//  Copyright (c) 2013 Kohactive. All rights reserved.
//

#import "kohMonitorAppDelegate.h"
#import <RestKit/RestKit.h>
#import "Page.h"
#import "Headline.h"

@implementation kohMonitorAppDelegate

@synthesize webViewController;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSLog(@"HELLO LAUNCH");
  // Insert code here to initialize your application
  kohMonitorWindowController *wc = [[kohMonitorWindowController alloc] initWithWindow:self.window];
  self.webViewController = [[kohMonitorWebViewController alloc] initWithNibName:@"kohMonitorWebViewController" bundle:[NSBundle mainBundle]];
  [[[wc window] contentView] addSubview:self.webViewController.view];
  self.webViewController.window = wc.window;
  CGRect screenBound = [[NSScreen mainScreen] frame];
  CGSize screenSize = screenBound.size;
  CGFloat screenWidth = screenSize.width;
  CGFloat screenHeight = screenSize.height;
  
  [[NSApplication sharedApplication]
   setPresentationOptions:   NSApplicationPresentationAutoHideMenuBar
   | NSApplicationPresentationAutoHideDock];
  
  
  [[wc window] setFrame:NSMakeRect(0, 0, screenWidth,screenHeight) display:NO];
  [self.webViewController.view setFrame:NSMakeRect(0, 0, screenWidth, screenHeight)];
  [self.webViewController.webView setFrame:NSMakeRect(0, 100, screenWidth, screenHeight-100)];
  [self.webViewController.webViewMarquee setFrame:NSMakeRect(0, 0, screenWidth, 100)];
  
  
  
  

  [self mapData];
  [[self webViewController] startPolling];
  
}

-(void) mapData {
  
  [RKObjectManager objectManagerWithBaseURL:[NSURL URLWithString:@"http://monitor.kohsrv.net/api"]];
  
  //[RKObjectManager objectManagerWithBaseURL:[NSURL URLWithString:@"http://localhost:3000/api"]];
  
  
  RKObjectMapping* pageMapping = [RKObjectMapping mappingForClass:[Page class]];
  [pageMapping mapKeyPath:@"id" toAttribute:@"oid"];
  [pageMapping mapKeyPath:@"url" toAttribute:@"url"];
  [pageMapping mapKeyPath:@"duration" toAttribute:@"duration"];
  [pageMapping mapKeyPath:@"login_script" toAttribute:@"login_script"];
  
  RKObjectMapping* headlineMapping = [RKObjectMapping mappingForClass:[Headline class]];
  [headlineMapping mapKeyPath:@"id" toAttribute:@"oid"];
  [headlineMapping mapKeyPath:@"title" toAttribute:@"title"];
  [headlineMapping mapKeyPath:@"body" toAttribute:@"body"];
  
  [[RKObjectManager sharedManager].mappingProvider setMapping:headlineMapping forKeyPath:@"headlines"];
  [[RKObjectManager sharedManager].mappingProvider setMapping:pageMapping forKeyPath:@"pages"];
  
  [[RKObjectManager sharedManager] setClient:[RKClient sharedClient]];
  
  RKObjectRouter *router = [RKObjectManager sharedManager].router;
  [router routeClass:[Page class] toResourcePath:@"/pages" forMethod:RKRequestMethodGET];
  [router routeClass:[Headline class] toResourcePath:@"/headlines" forMethod:RKRequestMethodGET];

  
  
}


@end
