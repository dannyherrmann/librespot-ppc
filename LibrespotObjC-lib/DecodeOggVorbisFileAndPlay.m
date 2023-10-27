//
//  DecodeOggVorbisFileAndPlay.m
//  LibrespotObjC-lib
//
//  Created by Danny Herrmann on 10/26/23.
//  Copyright (c) 2023 Danny Herrmann. All rights reserved.
//

#import <vorbis/vorbisfile.h>
#include <AudioToolbox/AudioToolbox.h>

// Function to decode an Ogg Vorbis file

void decodeOggVorbisFileAndPlay(const char *inputFilePath) {
    FILE *inputFile = fopen(inputFilePath, "rb");
    
    OggVorbis_File vf;
    
    vorbis_info *vi = ov_info(&vf, -1);
    
    int samplesRead;
    
    const int bufferSize = 1024;
    
    short pcmBuffer[bufferSize];
    
    int totalSamples = 0;
    
    AudioComponentInstance audioUnit;
    
    OSStatus status;
    
    // Create an audio component instance
    
    AudioComponentDescription desc;
    desc.componentType = kAudioUnitType_Output;
    desc.componentSubType = kAudioUnitSubType_DefaultOutput;
    desc.componentManufacturer = kAudioUnitManufacturer_Apple;
    desc.componentFlags = 0;
    desc.componentFlagsMask = 0;
    
    AudioComponent comp = AudioComponentFindNext(NULL, &desc);
    
    status = AudioComponentInstanceNew(comp, &audioUnit);
    
    AudioUnitInitialize(audioUnit);
    AudioOutputUnitStart(audioUnit);
    
    while (totalSamples < bufferSize)
    {
        samplesRead = ov_read(&vf, (char *)(pcmBuffer + totalSamples), bufferSize - totalSamples, 0, 2, 1, NULL);
        
        totalSamples += samplesRead;
        
        AudioBufferList audioBufferList;
        
        audioBufferList.mNumberBuffers = 1;
        
        audioBufferList.mBuffers[0].mData = pcmBuffer;
        
        audioBufferList.mBuffers[0].mDataByteSize = samplesRead *sizeof(short);
        
        audioBufferList.mBuffers[0].mNumberChannels = 2;
        
        status = audioUnitRender(audioUnit, 0, 0, 0, 0, &audioBufferList);
        
        ov_clear(&vf);
        fclose(inputFile);
        
        // Cleanup Core Audio
        
        AudioOutputUnitStop(audioUnit);
        AudioUnitUninitialize(audioUnit);
        
        AudioComponentInstanceDispose(audioUnit);
        
    }
}
