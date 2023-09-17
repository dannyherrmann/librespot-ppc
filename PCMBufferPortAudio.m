//
//  PCMBufferPortAudio.m
//  LibrespotObjC-lib
//
//  Created by Danny Herrmann on 9/9/23.
//  Copyright (c) 2023 Danny Herrmann. All rights reserved.
//

#import "PCMBufferPortAudio.h"

@implementation PCMBuffer2

- (id)initWithInitialCapacity:(size_t)initialCapacity {
    self = [super init];
    if (self) {
        data = malloc(initialCapacity * sizeof(short));
        if (data == NULL) {
            NSLog(@"Failed to allocate memory.");
            return nil;
        }
        size = 0;
        capacity = initialCapacity;
    }
    return self;
}

- (void)appendToBuffer:(short *)newData size:(size_t)newSize {
    if (size + newSize > capacity) {
        capacity *= 2;
        data = realloc(data, capacity * sizeof(short));
        if (data == NULL) {
            NSLog(@"Failed to reallocate memory.");
            return;
        }
    }
    memcpy(data + size, newData, newSize * sizeof(short));
    size += newSize;
}

- (size_t)readFromBuffer:(short *)outData maxSize:(size_t)maxSize {
    size_t bytesToCopy = MIN(size, maxSize);
    if (bytesToCopy > 0) {
        memcpy(outData, data, bytesToCopy);
        memmove(data, data + bytesToCopy / sizeof(short), size - bytesToCopy);
        size -= bytesToCopy;
    }
    return bytesToCopy;
}

- (void)freeBuffer {
    free(data);
    data = NULL;
    size = 0;
    capacity = 0;
}

// Manual Getters and Setters

- (short *)data {
    return data;
}

- (void)setData:(short *)newData {
    if (data != newData) {
        free(data);  // Free existing data
        data = newData;  // Assign new data
    }
}

- (size_t)size {
    return size;
}

- (void)setSize:(size_t)newSize {
    size = newSize;
}

- (size_t)capacity {
    return capacity;
}

- (void)setCapacity:(size_t)newCapacity {
    capacity = newCapacity;
}

- (void) appendShorts:(short *)shorts length:(size_t)length {
    [self appendToBuffer:shorts size:length];
}

- (void) clearBuffer {
    [self freeBuffer];
}


@end

int audioCallback(const void *inputBuffer, void *outputBuffer,
                  unsigned long framesPerBuffer,
                  const PaStreamCallbackTimeInfo* timeInfo,
                  PaStreamCallbackFlags statusFlags,
                  void *userData) {
    PCMBuffer2 *buffer = (PCMBuffer2 *)userData;
    short *out = (short *)outputBuffer;
    size_t bytesToCopy = MIN(framesPerBuffer * sizeof(short), buffer->size);
    NSLog(@"Audio callback called. Bytes to copy: %zu", bytesToCopy);
    [buffer readFromBuffer:out maxSize:bytesToCopy];
    return paContinue;
}

void playPCMBufferWithPortAudio(PCMBuffer2 *buffer) {
    NSLog(@"Buffer size: %zu", buffer.size);
    PaError err = Pa_Initialize();
    if (err != paNoError) {
        NSLog(@"PortAudio error: %s", Pa_GetErrorText(err));
        return;
    }
    
    PaStream *stream;
    err = Pa_OpenDefaultStream(&stream, 0, 1, paInt16, 44100, 256, audioCallback, buffer);
    if (err != paNoError) {
        NSLog(@"PortAudio error: %s", Pa_GetErrorText(err));
        return;
    }
    
    Pa_StartStream(stream);
    if (err!= paNoError) {
        NSLog(@"PortAudio Stream error: %s", Pa_GetErrorText(err));
        return;
    }
    
//    NSLog(@"Press Enter to stop...");
    getchar();
    
    Pa_StopStream(stream);
    Pa_CloseStream(stream);
    Pa_Terminate();
}

