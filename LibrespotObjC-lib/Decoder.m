//
//  Decoder.m
//  LibrespotObjC-lib
//
//  Created by Danny Herrmann on 8/22/23.
//  Copyright (c) 2023 Danny Herrmann. All rights reserved.
//

#import "Decoder.h"
#import "SeekableInputStream.h" // Add necessary import
#import "OutputAudioFormat.h" // Add necessary import

@implementation CannotGetTimeException
@end

@implementation DecoderException
@end

const int BUFFER_SIZE = 2048;

@implementation Decoder

- (id)initWithAudioIn:(SeekableInputStream *)anAudioIn normalizationFactor:(float)aNormalizationFactor duration:(int)aDuration {
    if ((self = [super init])) {
        audioIn = [anAudioIn retain];
        normalizationFactor = aNormalizationFactor;
        duration = aDuration;
        closed = NO;
        seekZero = 0;
        format = nil;
    }
    return self;
}

- (int)writeSomeTo:(NSOutputStream *)outputStream error:(NSError **)error {
    return [self readInternal:outputStream error:error];
}

- (int)readInternal:(NSOutputStream *)outputStream error:(NSError **)error {
    NSLog(@"readInternal should be overridden by subclass.");
    return 0;
}

- (int)time {
    NSLog(@"time should be overridden by subclass.");
    return 0;
}

- (void)close {
    closed = YES;
    [audioIn close];
}

- (void)seek:(int)positionMs {
    if (positionMs < 0) {
        positionMs = 0;
    }
    
    @try {
        [audioIn seekToPosition:seekZero]; // Assuming that seekToPosition sets the position to 'seekZero'
        
        if (positionMs > 0) {
            NSUInteger available = [audioIn size]; // This would be the equivalent to 'audioIn.available()' in Java
            
            float skipFloat = (available / (float)duration) * positionMs;
            NSUInteger skip = roundf(skipFloat); // Rounding to the nearest integer
            
            if (skip > available) {
                skip = available;
            }
            
            long skipped = [audioIn skipBytes:skip]; // Assuming that 'skipBytes' returns the actual number of bytes skipped
            if (skip != skipped) {
                NSString *errorMsg = [NSString stringWithFormat:@"Failed seeking, skip: %lu, skipped: %ld", (unsigned long)skip, skipped];
                @throw [NSException exceptionWithName:@"IOException"
                                               reason:errorMsg
                                             userInfo:nil];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Failed seeking! %@", [exception reason]);
    }
}

- (OutputAudioFormat *)getAudioFormat {
    if (!format) {
        NSLog(@"Illegal state: format is nil");
    }
    return format;
}

- (void)setAudioFormat:(OutputAudioFormat *)aFormat {
    if (format != aFormat) {
        [format release];
        format = [aFormat retain];
    }
}

- (int)sampleSizeBytes {
    return [[self getAudioFormat] sampleSizeInBits] / 8;
}

- (int)duration {
    return duration;
}

- (int)size {
    // Implement logic to return size
    return 0;
}

- (void)dealloc {
    [audioIn release];
    [format release];
    [super dealloc];
}

@end

