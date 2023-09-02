//
//  PCMBuffer.h
//  LibrespotObjC-lib
//
//  Created by Danny Herrmann on 8/27/23.
//  Copyright (c) 2023 Danny Herrmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCMBuffer : NSObject {
    short *data;
    size_t size;
    size_t capacity;
}

- (id)initWithInitialCapacity:(size_t)initialCapacity;
- (void)appendToBuffer:(short *)newData size:(size_t)newSize;
- (void)freeBuffer;

// Manual Getters and Setters
- (short *)data;
- (void)setData:(short *)newData;
- (size_t)size;
- (void)setSize:(size_t)newSize;
- (size_t)capacity;
- (void)setCapacity:(size_t)newCapacity;

- (void) appendShorts:(short *) shorts length:(size_t) length;
- (void) clearBuffer;

@end

