//
//  SeekableInputStream.m
//  LibrespotObjC-lib
//
//  Created by Danny Herrmann on 8/22/23.
//  Copyright (c) 2023 Danny Herrmann. All rights reserved.
//

#import "SeekableInputStream.h"

@implementation SeekableInputStream

- (NSUInteger)size {
    [self doesNotRecognizeSelector:_cmd];
    return 0; // This line will not be reached.
}

- (NSUInteger)position {
    [self doesNotRecognizeSelector:_cmd];
    return 0; // This line will not be reached.
}

- (void)seekToPosition:(NSUInteger)seekZero {
    [self doesNotRecognizeSelector:_cmd];
}

- (long)skipBytes:(long)skip {
    [self doesNotRecognizeSelector:_cmd];
    return 0; // This line will not be reached.
}

- (NSInteger)readIntoBuffer:(uint8_t *)buffer maxLength:(NSUInteger)length {
    [self doesNotRecognizeSelector:_cmd];
    return 0; // This line will not be reached.
}

- (void)closeStream {
    [self doesNotRecognizeSelector:_cmd];
}

- (NSUInteger)decodedLength {
    [self doesNotRecognizeSelector:_cmd];
    return 0; // This line will not be reached.
}

@end

