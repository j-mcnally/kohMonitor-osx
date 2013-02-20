//
//  kohMonitorWebViewController.m
//  kohMonitor
//
//  Created by Justin McNally on 2/19/13.
//  Copyright (c) 2013 Kohactive. All rights reserved.
//

#import "kohMonitorWebViewController.h"
#import "Page.h"
#import "Headline.h"

@interface kohMonitorWebViewController ()

@end

@implementation kohMonitorWebViewController

@synthesize pages, headlines;


-(void) setWindow:(NSWindow *)myWindow {
  _window = myWindow;
}
-(NSWindow *) window {
  return _window;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
    }
    
    return self;
}

- (void) startPolling {
  NSLog(@"Begin polling");
  [[self webView] setFrameLoadDelegate:self];
  [self performSelector:@selector(loadJSONFromServer) withObject:nil afterDelay:1.0f];
}


-(void) loadJSONFromServer {
  NSLog(@"LOAD!!!!");
  [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/pages" delegate:self];
  [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/headlines" delegate:self];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
  if (currentLoginScript != nil) {
    [sender stringByEvaluatingJavaScriptFromString:currentLoginScript];
  }
  
}

- (void) nextPage {
  if ([[self pages] count] > 0) {
    
    Page *page = [[self pages] objectAtIndex:pageIndex];
    double duration = 0;
    duration = [[page duration] doubleValue];
    

    
    
    

    
    if (duration < 5) {
      duration = 5;
    }
    
    pageIndex ++;
    NSLog(@"loading %@ with a duration of %f", [page url], duration);
    [[self webView] setMainFrameURL:[page url]];
    currentLoginScript = [page login_script];
    NSTimeInterval timeInterval = duration;
    
    if (pageIndex >= [[self pages] count]) {
      pageIndex = 0;
      [self performSelector:@selector(loadJSONFromServer) withObject:nil afterDelay:duration];
      return;
    }
    
    [self performSelector:@selector(nextPage) withObject:nil afterDelay:timeInterval];
    
    
  }
  else {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Load atleast one page into the CMS."];
    [alert addButtonWithTitle:@"OK"];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:nil contextInfo:nil];
    
    exit(0);
  }

}

-(void) scrollHeadlines {
  NSString *headliner = nil;
  if ([[self headlines] count] > 0) {
    NSMutableArray *titles = [NSMutableArray array];
    for (int i = 0; i < [[self headlines] count]; i++) {
      Headline *h = [[self headlines] objectAtIndex:i];
      [titles addObject:[h title]];
    }
    headliner = [titles componentsJoinedByString:@"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"];
  }
  else {
   headliner = @"Nothing is happening.";
  }


  NSString *summary = @"<html><body style=\"margin:0; padding:0;\"><marquee style=\"margin:0; padding:0;\"><h1 style=\"font-family: 'HelveticaNeue-Light', 'Helvetica Neue Light', 'Helvetica Neue', Helvetica, Arial, 'Lucida Grande', sans-serif; font-weight: 300; margin:0; padding:0; font-size: 70px;\">%@</h1></marquee></body></html>";
  
  
  
  NSString *ticker = [NSString stringWithFormat:summary, headliner, nil];
  
  NSLog(@"%@", ticker);

  [[[self webViewMarquee] mainFrame] loadHTMLString:ticker baseURL:nil];
}


- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  
  NSArray *unwrapedObjects = objects;
  
  if ([objects count] > 0) {
    if ([[objects objectAtIndex:0] isKindOfClass:[NSArray class]]) {
      unwrapedObjects = [objects objectAtIndex:0];
    }
  }
  

  
  NSString *url = [objectLoader.URL lastPathComponent];
  
  NSLog(@"URL:::: %@", url);
  
  if ([url isEqualToString:@"pages"]) {
    NSLog(@"pages");
 
    [self setPages:unwrapedObjects];
    [self nextPage];
  }
  else if ([url isEqualToString:@"headlines"]) {
    NSLog(@"headlines");

    [self setHeadlines:unwrapedObjects];
    [self scrollHeadlines];
  }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError *)error {
  NSLog(@"ERROR: %@", error);
}


@end
