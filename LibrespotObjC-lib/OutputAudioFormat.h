//
//  OutputAudioFormat.h
//  LibrespotObjC-lib
//
//  Created by Danny Herrmann on 8/22/23.
//  Copyright (c) 2023 Danny Herrmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutputAudioFormat : NSObject {
    NSString *encoding;
    float sampleRate;
    int sampleSizeInBits;
    int channels;
    int frameSize;
    float frameRate;
    BOOL bigEndian;
}

// Constructor
- (id)initWithSampleRate:(float)rate sampleSizeInBits:(int)size channels:(int)ch signed:(BOOL)signedFlag bigEndian:(BOOL)endianFlag;

// Getters
- (NSString *)encoding;
- (float)sampleRate;
- (int)sampleSizeInBits;
- (int)channels;
- (int)frameSize;
- (float)frameRate;
- (BOOL)isBigEndian;

// Method to match formats
- (BOOL)matches:(OutputAudioFormat *)format;

@end

