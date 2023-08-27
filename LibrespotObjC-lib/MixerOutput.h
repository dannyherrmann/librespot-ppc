//
//  MixerOutput.h
//  LibrespotObjC-lib
//
//  Created by Danny Herrmann on 8/23/23.
//  Copyright (c) 2023 Danny Herrmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudio.h>

@interface MixerOutput : NSObject {
    NSString *mixerSearchKeyword;
    BOOL logAvailableMixers;
    AudioStreamBasicDescription audioFormat;
    Float32 lastVolume;
}

// Manual getter and setter for mixerSearchKeyword
- (void)setMixerSearchKeyword:(NSString *)newKeyword;
- (NSString *)mixerSearchKeyword;

// Manual getter and setter for logAvailableMixers
- (void)setLogAvailableMixers:(BOOL)newLogAvailableMixers;
- (BOOL)logAvailableMixers;

// Manual getter and setter for audioFormat
- (void)setAudioFormat:(AudioStreamBasicDescription)newAudioFormat;
- (AudioStreamBasicDescription)audioFormat;

// Manual getter and setter for lastVolume
- (void)setLastVolume:(Float32)newLastVolume;
- (Float32)lastVolume;

// ... rest of your methods
- (id)initWithMixerSearchKeyword:(NSString *)keyword logAvailableMixers:(BOOL)logAvailableMixers;
- (BOOL)startWithFormat:(AudioStreamBasicDescription)format;
- (void)writeBuffer:(void *)buffer offset:(UInt32)offset length:(UInt32)length;

@end



