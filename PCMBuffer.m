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
        if (data == NULL) {
            NSLog(@"Error: Failed to allocate memory for data in initWithInitialCapacity");
            return nil;  // return nil to indicate initialization failure
        }
        size = 0;
        capacity = initialCapacity;
    }
    return self;
}

- (void)appendToBuffer:(short *)newData size:(size_t)newSize {
    @synchronized(self) {
        if (size + newSize > capacity) {
            capacity *= 2;
            short *temp = (short *)realloc(data, capacity * sizeof(short));
            if (temp == NULL) {
                NSLog(@"Error: Failed to reallocate memory for data in appendToBuffer");
                return;  // exit the method; consider handling this more gracefully
            }
            data = temp;
        }
        memcpy(data + size, newData, newSize * sizeof(short));
        size += newSize;
    }
}

- (size_t)readFromBuffer:(short *)outData maxSize:(size_t)maxSize {
    @synchronized(self) {
        size_t bytesToCopy = MIN(size, maxSize);
        if (bytesToCopy > 0) {
            memcpy(outData, data, bytesToCopy);
            memmove(data, data + bytesToCopy / sizeof(short), size - bytesToCopy);
            size -= bytesToCopy;
        }
        return bytesToCopy;
    }
}

- (void)freeBuffer {
    @synchronized(self) {
        free(data);
        data = NULL;
        size = 0;
        capacity = 0;
    }
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

void audioQueueOutputCallback(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer) {
    NSLog(@"Size of short in bytes: %lu, in bits: %lu", sizeof(short), sizeof(short) * 8);

    PCMBuffer *buffer = (PCMBuffer *)inUserData;
    
    @synchronized(buffer) {
        if (buffer.size == 0) {
            AudioQueueStop(inAQ, false);
            return;
        }
        
        size_t bytesToCopy = MIN(buffer.size, inBuffer->mAudioDataBytesCapacity);
        
        memcpy(inBuffer->mAudioData, buffer.data, bytesToCopy);
        inBuffer->mAudioDataByteSize = bytesToCopy;
        
        // Shift the remaining audio data to the beginning of the buffer
        memmove(buffer.data, buffer.data + (bytesToCopy / sizeof(short)), buffer.size - bytesToCopy);
        
        // Update buffer size
        buffer.size -= bytesToCopy;
        
        // Re-enqueue the buffer for future use
        AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
    }
}

void playPCMBufferWithCoreAudio(PCMBuffer *buffer) {
    AudioStreamBasicDescription audioFormat;
    audioFormat.mSampleRate = 44100;  // Adjust based on actual sample rate
    audioFormat.mFormatID = kAudioFormatLinearPCM;
    audioFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    audioFormat.mBytesPerPacket = 2;  // 16-bit mono
    audioFormat.mFramesPerPacket = 1; // 1 frame per packet
    audioFormat.mBytesPerFrame = 2;   // 16-bit mono
    audioFormat.mChannelsPerFrame = 1; // mono
    audioFormat.mBitsPerChannel = 16; // 16-bit
    NSLog(@"Sample Rate: %lf", audioFormat.mSampleRate);
    NSLog(@"Format ID: %u", (unsigned int)audioFormat.mFormatID);
    NSLog(@"Format Flags: %u", (unsigned int)audioFormat.mFormatFlags);
    NSLog(@"Bytes Per Packet: %u", (unsigned int)audioFormat.mBytesPerPacket);
    NSLog(@"Frames Per Packet: %u", (unsigned int)audioFormat.mFramesPerPacket);
    NSLog(@"Bytes Per Frame: %u", (unsigned int)audioFormat.mBytesPerFrame);
    NSLog(@"Channels Per Frame: %u", (unsigned int)audioFormat.mChannelsPerFrame);
    NSLog(@"Bits Per Channel: %u", (unsigned int)audioFormat.mBitsPerChannel);

    AudioQueueRef audioQueue;
    AudioQueueNewOutput(&audioFormat, audioQueueOutputCallback, buffer, NULL, NULL, 0, &audioQueue);
    
    // Adding an initial buffer to start the queue.
    AudioQueueBufferRef initialBuffer;
    AudioQueueAllocateBuffer(audioQueue, 4096, &initialBuffer);
    audioQueueOutputCallback(buffer, audioQueue, initialBuffer);
    
    // Start the queue.
    AudioQueueStart(audioQueue, NULL);
}

