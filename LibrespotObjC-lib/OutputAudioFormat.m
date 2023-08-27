//
//  OutputAudioFormat.m
//  LibrespotObjC-lib
//
//  Created by Danny Herrmann on 8/22/23.
//  Copyright (c) 2023 Danny Herrmann. All rights reserved.
//

#import "OutputAudioFormat.h"

static OutputAudioFormat *DEFAULT_FORMAT;

@implementation OutputAudioFormat

+ (void)initialize {
    if (self == [OutputAudioFormat class]) {
        DEFAULT_FORMAT = [[OutputAudioFormat alloc] initWithSampleRate:44100.0 sampleSizeInBits:16 channels:2 signed:YES bigEndian:NO];
    }
}

- (id)initWithSampleRate:(float)rate sampleSizeInBits:(int)size channels:(int)ch signed:(BOOL)signedFlag bigEndian:(BOOL)endianFlag {
    if ((self = [super init])) {
        encoding = signedFlag ? @"PCM_SIGNED" : @"PCM_UNSIGNED";
        sampleRate = rate;
        sampleSizeInBits = size;
        channels = ch;
        frameSize = (ch == -1 || size == -1) ? -1 : ((size + 7) / 8) * ch;
        frameRate = rate;
        bigEndian = endianFlag;
    }
    return self;
}

- (NSString *)encoding {
    return encoding;
}

- (float)sampleRate {
    return sampleRate;
}

- (int)sampleSizeInBits {
    return sampleSizeInBits;
}

- (int)channels {
    return channels;
}

- (int)frameSize {
    return frameSize;
}

- (float)frameRate {
    return frameRate;
}

- (BOOL)isBigEndian {
    return bigEndian;
}

- (BOOL)matches:(OutputAudioFormat *)format {
    return [[format encoding] isEqualToString:[self encoding]]
    && ([format channels] == -1 || [format channels] == [self channels])
    && ([format sampleRate] == (float)-1 || [format sampleRate] == [self sampleRate])
    && ([format sampleSizeInBits] == -1 || [format sampleSizeInBits] == [self sampleSizeInBits])
    && ([format frameRate] == (float)-1 || [format frameRate] == [self frameRate])
    && ([format frameSize] == -1 || [format frameSize] == [self frameSize])
    && ([self sampleSizeInBits] <= 8 || [format isBigEndian] == [self isBigEndian]);
}

- (void)dealloc {
    [encoding release];
    [super dealloc];
}

@end
