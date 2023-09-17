//
//  PCMBufferPortAudio.h
//  LibrespotObjC-lib
//
//  Created by Danny Herrmann on 9/9/23.
//  Copyright (c) 2023 Danny Herrmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <portaudio.h>

@interface PCMBuffer2 : NSObject {
@public
    short *data;
    size_t size;
    size_t capacity;
}

- (id)initWithInitialCapacity:(size_t)initialCapacity;
- (void)appendToBuffer:(short *)newData size:(size_t)newSize;
- (size_t)readFromBuffer:(short *)outData maxSize:(size_t)maxSize;
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

int audioCallback(const void *inputBuffer, void *outputBuffer,
                  unsigned long framesPerBuffer,
                  const PaStreamCallbackTimeInfo* timeInfo,
                  PaStreamCallbackFlags statusFlags,
                  void *userData);

void playPCMBufferWithPortAudio(PCMBuffer2 *buffer);
