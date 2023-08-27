//
//  Decoder.h
//  LibrespotObjC-lib
//
//  Created by Danny Herrmann on 8/22/23.
//  Copyright (c) 2023 Danny Herrmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SeekableInputStream;
@class OutputAudioFormat;

@interface CannotGetTimeException : NSException
@end

@interface DecoderException : NSException
@end

extern const int BUFFER_SIZE;

@interface Decoder : NSObject {
    SeekableInputStream *audioIn;
    float normalizationFactor;
    int duration;
    BOOL closed;
    int seekZero;
    OutputAudioFormat *format;
}

- (id)initWithAudioIn:(SeekableInputStream *)anAudioIn normalizationFactor:(float)aNormalizationFactor duration:(int)aDuration;
- (int)writeSomeTo:(NSOutputStream *)outputStream error:(NSError **)error;
- (int)readInternal:(NSOutputStream *)outputStream error:(NSError **)error; // To be overridden by subclasses
- (int)time; // To be overridden by subclasses
- (void)close;
- (void)seek:(int)positionMs;
- (OutputAudioFormat *)getAudioFormat;
- (void)setAudioFormat:(OutputAudioFormat *)aFormat;
- (int)sampleSizeBytes;
- (int)duration; // Custom getter for duration
- (int)size; // Placeholder method for size

@end

