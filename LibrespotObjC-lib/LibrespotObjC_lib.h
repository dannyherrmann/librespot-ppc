//
//  libvorbis_test.h
//  libvorbis-test
//
//  Created by Danny Herrmann on 8/20/23.
//  Copyright (c) 2023 Danny Herrmann. All rights reserved.
//

#ifndef LibrespotObjC_lib_h
#define LibrespotObjC_lib_h

#include <stdio.h>
#include <stdlib.h>
#include "PCMBuffer.h"

void initPCMBuffer(PCMBuffer *buffer, size_t initialCapacity);
void appendToPCMBuffer(PCMBuffer *buffer, short *newData, size_t newSize);
void freePCMBuffer(PCMBuffer *buffer);
void decodeOggVorbisFile(const char *inputPath, PCMBuffer *pcmBuffer);

#endif

