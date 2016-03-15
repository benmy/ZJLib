
//
//  ZJVoicePlayerHelper.m
//  MyClass3
//
//  Created by 朱佳伟 on 15/6/8.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import "ZJVoicePlayerHelper.h"
#import "ZJStorageKit.h"
#import <UIKit/UIKit.h>

@implementation ZJVoicePlayerHelper

- (void)downloadWithReocrdUrl:(NSURL *)url filename:(NSString *)filename recordAnimationView:(UIImageView *)recordAnimationView {
    NSString *recordFile = [ZJStorageKit cachePathWithDirectory:kZJStorageDirVoice file:filename];
    NSData *recordData = [NSData dataWithContentsOfFile:recordFile];
    if (recordData) { // 有缓存，直接播放
        NSLog(@"缓存中取出播放");
        [self managerAudioWithData:recordData toPlay:YES resetCategory:YES];
        [recordAnimationView startAnimating];
    } else { // 没有缓存，先下载，再播放
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSLog(@"下载播放");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data) {
                    [data writeToFile:recordFile atomically:YES];
                    
                    [self managerAudioWithData:data toPlay:YES resetCategory:YES];
                    [recordAnimationView startAnimating];
                }
            });
        });
    }
}

- (void)managerAudioWithFileName:(NSString*)amrName toPlay:(BOOL)toPlay {
    if (toPlay) {
        [self playAudioWithFileName:amrName];
    } else {
        [self pausePlayingAudio];
    }
}

- (void)managerAudioWithData:(NSData*)data toPlay:(BOOL)toPlay resetCategory:(BOOL)reset{
    if (toPlay) {
        [self playAudioWithData:data resetCategory:reset];
    } else {
        [self pausePlayingAudio];
    }
}

//暂停
- (void)pausePlayingAudio {
    if (_player) {
        [_player pause];
        if ([self.delegate respondsToSelector:@selector(didAudioPlayerPausePlay:)]) {
            [self.delegate didAudioPlayerPausePlay:_player];
        }
    }
}

- (void)stopAudio {
    [self setPlayingFileName:@""];
    [self setPlayingIndexPathInFeedList:nil];
    if (_player && _player.isPlaying) {
        [_player stop];
        _player = nil;
    }
    [[AVAudioSession sharedInstance]setActive:NO error:nil];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
//    [self changeProximityMonitorEnableState:NO];
    if ([self.delegate respondsToSelector:@selector(didAudioPlayerStopPlay:)]) {
        [self.delegate didAudioPlayerStopPlay:_player];
    }
}

#pragma mark - action

- (void)playAudioWithFileName:(NSString*)fileName {
    if (fileName.length > 0) {
        [[AVAudioSession sharedInstance]setActive:YES error:nil];
        //不随着静音键和屏幕关闭而静音。code by Aevit
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        if (_playingFileName && [fileName isEqualToString:_playingFileName]) {//上次播放的录音
            if (_player) {
                [_player play];
                [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
                if ([self.delegate respondsToSelector:@selector(didAudioPlayerBeginPlay:)]) {
                    [self.delegate didAudioPlayerBeginPlay:_player];
                }
            }
        } else {//不是上次播放的录音
            if (_player) {
                [_player stop];
                self.player = nil;
            }
            AVAudioPlayer *pl = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:fileName] error:nil];
            pl.delegate = self;
            [pl play];
            self.player = pl;
            [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
            if ([self.delegate respondsToSelector:@selector(didAudioPlayerBeginPlay:)]) {
                [self.delegate didAudioPlayerBeginPlay:_player];
            }
        }
        self.playingFileName = fileName;
    }
}

- (void)playAudioWithData:(NSData*)data resetCategory:(BOOL)reset{
    if (data.length > 0) {
        [[AVAudioSession sharedInstance]setActive:YES error:nil];
        //不随着静音键和屏幕关闭而静音。code by Aevit
        if (reset) {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        }
        
        if (_player) {
            [_player stop];
            self.player = nil;
        }

        self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
//        [self changeProximityMonitorEnableState:YES];
        self.player.delegate = self;
        [self.player play];
        if ([self.delegate respondsToSelector:@selector(didAudioPlayerBeginPlay:)]) {
            [self.delegate didAudioPlayerBeginPlay:_player];
        }
    }
}

#pragma mark - Getter

- (AVAudioPlayer*)player {
    return _player;
}

- (BOOL)isPlaying {
    if (!_player) {
        return NO;
    }
    return _player.isPlaying;
}

#pragma mark - Setter

- (void)setDelegate:(id<ZJVoicePlayerHelperDelegate>)delegate {
    if (_delegate != delegate) {
        _delegate = delegate;
        
        if (_delegate == nil) {
            [self stopAudio];
        }
    }
}

#pragma mark - Life Cycle

+ (id)shareInstance {
    static ZJVoicePlayerHelper *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZJVoicePlayerHelper alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self changeProximityMonitorEnableState:YES];
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    }
    return self;
}

- (void)dealloc {
    [self changeProximityMonitorEnableState:NO];
}

#pragma mark - audio delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self stopAudio];

    //2.播放系统声音
    AudioServicesPlaySystemSound(1306);
    if ([self.delegate respondsToSelector:@selector(didAudioPlayerFinishPlay:)]) {
        [self.delegate didAudioPlayerFinishPlay:_player];
    }
}

#pragma mark - 近距离传感器

- (void)changeProximityMonitorEnableState:(BOOL)enable {
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        if (enable) {
            //添加近距离事件监听，添加前先设置为YES，如果设置完后还是NO的读话，说明当前设备没有近距离传感器
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:UIDeviceProximityStateDidChangeNotification object:nil];
        } else {
            //删除近距离事件监听
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        }
    }
}

- (void)sensorStateChange:(NSNotificationCenter *)notification {
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗
    if ([[UIDevice currentDevice] proximityState] == YES) {
        //黑屏,切换为听筒播放
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    } else {
        //没黑屏幕,切换为扬声器播放
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (!_player || !_player.isPlaying) {
            //没有播放了，也没有在黑屏状态下，就可以把距离传感器关了
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        }
    }
}
@end
