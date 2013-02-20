//
//  Pages.h
//  kohMonitor
//
//  Created by Justin McNally on 2/19/13.
//  Copyright (c) 2013 Kohactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Page : NSObject

@property (nonatomic, retain) NSNumber* oid;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSNumber* duration;
@property (nonatomic, retain) NSString* login_script;


@end
