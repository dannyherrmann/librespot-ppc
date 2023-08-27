//
//  libvorbis_test.m
//  libvorbis-test
//
//  Created by Danny Herrmann on 8/20/23.
//  Copyright (c) 2023 Danny Herrmann. All rights reserved.
//

#include "LibrespotObjC_lib.h"
#include <vorbis/vorbisfile.h>

void decodeOggVorbisFile(const char *inputPath, const char *outputPath) {
    FILE *inputFile = fopen(inputPath, "rb");
    if (!inputFile) {
        perror("Failed to open input file");
        return;
    }
    
    FILE *outputFile = fopen(outputPath, "wb");
    if (!outputFile) {
        perror("Failed to open output file");
        fclose(inputFile);
        return;
    }
    
    OggVorbis_File vf;
    if (ov_open(inputFile, &vf, NULL, 0) < 0) {
        fprintf(stderr, "Input is not a valid Ogg Vorbis file.\n");
        fclose(inputFile);
        fclose(outputFile);
        return;
    }
    
    char buffer[4096];
    int readSection;
    long bytesRead;
    
    while ((bytesRead = ov_read(&vf, buffer, sizeof(buffer), 0, 2, 1, &readSection)) > 0) {
        fwrite(buffer, 1, bytesRead, outputFile);
    }
    
    ov_clear(&vf);
    fclose(outputFile);
    fclose(inputFile);
}
