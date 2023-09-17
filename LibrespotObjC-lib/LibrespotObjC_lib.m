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
    buffer = [[PCMBuffer alloc] initWithInitialCapacity:initialCapacity];
}

void appendToPCMBuffer(PCMBuffer *buffer, short *newData, size_t newSize) {
    [buffer appendShorts:newData length:newSize];
}

void freePCMBuffer(PCMBuffer *buffer) {
    [buffer clearBuffer];
}

void decodeOggVorbisFile(const char *inputPath, PCMBuffer *pcmBuffer) {
    FILE *inputFile = fopen(inputPath, "rb");
    if (!inputFile) {
        perror("Failed to open input file");
        return;
    }
    
    FILE *pcmFile = fopen("/Users/dannyherrmann/Downloads/testing.pcm", "wb");
    if (!pcmFile) {
        perror("Failed to open output PCM file");
        return;
    }
    
    OggVorbis_File vf;
    if (ov_open(inputFile, &vf, NULL, 0) < 0) {
        fprintf(stderr, "Input is not a valid Ogg Vorbis file.\n");
        fclose(inputFile);
        return;
    }
    
    vorbis_info *info = ov_info(&vf, -1);
    if (info) {
        fprintf(stderr, "Channels: %d\n", info->channels);
        fprintf(stderr, "Rate: %ld\n", info->rate);
        fprintf(stderr, "Bit-depth: %d\n", info->bitrate_nominal);
    } else {
        fprintf(stderr, "Failed to retrieve vorbis info.\n");
    }
    
    initPCMBuffer(pcmBuffer, 4096);
    
    char readBuffer[4096];
    int readSection;
    long bytesRead;
    while ((bytesRead = ov_read(&vf, readBuffer, sizeof(readBuffer), 0, 2, 1, &readSection)) > 0) {
        [pcmBuffer appendShorts:(short *)readBuffer length:bytesRead / 2];
        
        fwrite(readBuffer, 1, bytesRead, pcmFile);
    }
    
    ov_clear(&vf);
    fclose(inputFile);
}
