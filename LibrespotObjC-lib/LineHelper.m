//
//  LineHelper.m
//  LibrespotObjC-lib
//
//  Created by Danny Herrmann on 8/23/23.
//  Copyright (c) 2023 Danny Herrmann. All rights reserved.
//


#import <CoreAudio/CoreAudio.h>

// Get the list of all available audio devices
void GetAllAudioDevices(AudioDeviceID **deviceIDs, UInt32 *deviceCount) {
    AudioObjectPropertyAddress propertyAddress = {
        kAudioHardwarePropertyDevices,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMaster
    };
    
    AudioObjectGetPropertyDataSize(kAudioObjectSystemObject, &propertyAddress, 0, NULL, deviceCount);
    *deviceIDs = (AudioDeviceID *)malloc(*deviceCount);
    AudioObjectGetPropertyData(kAudioObjectSystemObject, &propertyAddress, 0, NULL, deviceCount, *deviceIDs);
}

// Here you would add more functions to query each device for its supported formats,
// and to choose a device based on your criteria (like 'findMixer' in the Java code).

int main(int argc, const char * argv[]) {
    AudioDeviceID *deviceIDs = NULL;
    UInt32 deviceCount = 0;
    
    GetAllAudioDevices(&deviceIDs, &deviceCount);
    
    // Here, filter the devices and select the one you want (like findMixer does)
    // ...
    
    // Don't forget to free the allocated memory
    if (deviceIDs != NULL) {
        free(deviceIDs);
    }
    
    return 0;
}
