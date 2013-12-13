//
//  TextModel.h
//  TextKit
//
//  Created by sah-fueled on 13/12/13.
//  Copyright (c) 2013 fueled.co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextModel : NSObject

+ (TextModel *) sharedModel;
- (NSTextContainer *) containerAtIndex:(int)index;
- (NSTextContainer *) selectedContainer;
- (void) setContainerSelectedAtIndex:(int)index;
- (int) containerCount;
- (void) setContainerSize:(CGSize) size;
- (CGSize) getContainerSize;

@end
