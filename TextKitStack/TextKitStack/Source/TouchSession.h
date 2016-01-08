//
//  TouchSession.h
//  TextKitStack
//
//  Created by hsusmita on 07/09/15.
//  Copyright (c) 2015 hsusmita.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextKitStack.h"

@interface TouchSession : NSObject

@property (nonatomic, assign) NSInteger touchIndex;

- (instancetype)initWithTextKitStack:(TextKitStack *)textKitStack;
- (void)beginSession;
- (void)endSession;
- (void)cancelSession;
- (BOOL)shouldHandleTouch;

@end
