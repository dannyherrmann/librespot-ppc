//
//  libvorbis_test.m
//  libvorbis-test
//
//  Created by Danny Herrmann on 8/20/23.
//  Copyright (c) 2023 Danny Herrmann. All rights reserved.
//

#include "LibrespotObjC_lib.h"
#include <vorbis/vorbisfile.h>

void initPCMBuffer(PCMBuffer *buffer, size_t initialCapacity) {
    buffer->data = (short *)malloc(initialCapacity * sizeof(short));
    buffer->size = 0;
    buffer->capacity = initialCapacity;
}

void appendToPCMBuffer(PCMBuffer *buffer, short *newData, size_t newSize) {
    if (buffer->size + newSize > buffer->capacity) {
        buffer->capacity *= 2;
        buffer->data = (short *)realloc(buffer->data, buffer->capacity * sizeof(short));
    }
    
    memcpy(buffer->data + buffer->size, newData, newSize * sizeof(short));
    buffer->size += newSize;
}

void freePCMBuffer(PCMBuffer *buffer) {
    free(buffer->data);
    buffer->data = NULL;
    buffer->size = 0;
    buffer->capacity = 0;
}

void decodeOggVorbisFile(const char *inputPath, PCMBuffer *pcmBuffer) {
    FILE *inputFile = fopen(inputPath, "rb");
    if (!inputFile) {
        perror("Failed to open input file");
        return;
    }
    
    OggVorbis_File vf;
    if (ov_open(inputFile, &vf, NULL, 0) < 0) {
        fprintf(stderr, "Input is not a valid Ogg Vorbis file.\n");
        fclose(inputFile);
        return;
    }
    
    initPCMBuffer(pcmBuffer, 4096);
    
    char buffer[4096];
    int readSection;
    long bytesRead;
    while ((bytesRead = ov_read(&vf, buffer, sizeof(buffer), 0, 2, 1, &readSection)) > 0) {
        appendToPCMBuffer(pcmBuffer, (short *)buffer, bytesRead / 2);
    }
    
    ov_clear(&vf);
    fclose(inputFile);
}
