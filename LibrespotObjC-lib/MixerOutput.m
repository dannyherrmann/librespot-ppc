//
//  MixerOutput.m
//  LibrespotObjC-lib
//
//  Created by Danny Herrmann on 8/23/23.
//  Copyright (c) 2023 Danny Herrmann. All rights reserved.
//

#import "MixerOutput.h"

@implementation MixerOutput

- (void)setMixerSearchKeyword:(NSString *)newKeyword {
    [newKeyword retain];
    [mixerSearchKeyword release];
    mixerSearchKeyword = newKeyword;
}

- (NSString *)mixerSearchKeyword {
    return mixerSearchKeyword;
}

- (void)setLogAvailableMixers:(BOOL)newLogAvailableMixers {
    logAvailableMixers = newLogAvailableMixers;
}

- (BOOL)logAvailableMixers {
    return logAvailableMixers;
}

- (void)setAudioFormat:(AudioStreamBasicDescription)newAudioFormat {
    audioFormat = newAudioFormat;
}

- (AudioStreamBasicDescription)audioFormat {
    return audioFormat;
}

- (void)setLastVolume:(Float32)newLastVolume {
    lastVolume = newLastVolume;
}

- (Float32)lastVolume {
    return lastVolume;
}

- (BOOL)startWithFormat:(AudioStreamBasicDescription)format {
    // Implement CoreAudio code to initialize audio components
    // This might involve setting up an AudioQueue, or an AUGraph, etc
    return YES;
}

- (void)writeBuffer:(void *)buffer offset:(UInt32)offset length:(UInt32)length {
    // Implement CoreAudio code to write to audio buffer
    // This will depend on how you've set up your audio components
}

// Implement other methods

@end


