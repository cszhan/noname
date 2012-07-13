/*


=====================

File: SoundEffect.h
Abstract: SoundEffect is a simple Objective-C wrapper around Audio Services
functions that allow the loading and playing of sound files.

Version: 1.5



*/

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>


@interface NTESMBSoundEffect : NSObject {
    SystemSoundID _soundID;

}


/*!
    @method     play:
    @abstract   play a sound at path
    @discussion sound should be wav or aiff
    @param      path the path to the sound file
*/
- (void)play:(NSString*)path;
- (void)playSoundNamed:(NSString*)path ofType:(NSString*)type;
- (void)play;
- (void)vibration;
@end
