//
//  PCMBuffer.m
//  LibrespotObjC-lib
//
//  Created by Danny Herrmann on 8/27/23.
//  Copyright (c) 2023 Danny Herrmann. All rights reserved.
//

#import "PCMBuffer.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation PCMBuffer

- (id)initWithInitialCapacity:(size_t)initialCapacity {
    self = [super init];
    if (self) {
        data = (short *)malloc(initialCapacity * sizeof(short));
        size = 0;
        capacity = initialCapacity;
    }
    return self;
}

- (void)appendToBuffer:(short *)newData size:(size_t)newSize {
    if (size + newSize > capacity) {
        capacity *= 2;
        data = (short *)realloc(data, capacity * sizeof(short));
    }
    
    memcpy(data + size, newData, newSize * sizeof(short));
    size += newSize;
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

@end

void audioQueueOutputCallback(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer) {
    PCMBuffer *buffer = (PCMBuffer *)inUserData;
    
    if (buffer.size == 0) {
        AudioQueueStop(inAQ, false);
        return;
    }
    
    size_t bytesToCopy = (buffer.size < inBuffer->mAudioDataBytesCapacity) ? buffer.size : inBuffer->mAudioDataBytesCapacity;
    
    memcpy(inBuffer->mAudioData, buffer.data, bytesToCopy);
    inBuffer->mAudioDataByteSize = bytesToCopy;
    buffer.size -= bytesToCopy;
    
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}

void playPCMBufferWithCoreAudio(PCMBuffer *buffer) {
    // Your existing logic
}

