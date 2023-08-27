//
//  SeekableInputStream.h
//  LibrespotObjC-lib
//
//  Created by Danny Herrmann on 8/22/23.
//  Copyright (c) 2023 Danny Herrmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeekableInputStream : NSInputStream {
}

- (NSUInteger)size;
- (NSUInteger)position;
- (void)seekToPosition:(NSUInteger)seekZero; // throws
- (long)skipBytes:(long)skip; // throws
- (NSInteger)readIntoBuffer:(uint8_t *)buffer maxLength:(NSUInteger)length; // throws
- (void)closeStream;
- (NSUInteger)decodedLength;

@end

