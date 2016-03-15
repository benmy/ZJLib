//
//  ZJVoiceRecordHelper.m
//  MyClass3
//
//  Created by 朱佳伟 on 15/6/4.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import "ZJVoiceRecordHelper.h"
#import "NSString+Extends.h"

#define kFileTypeJPG @"jpg"
#define kFileTypeCAF @"caf"
#define kFileTypeWAV @"wav"
#define kFileTypeAMR @"amr"

@implementation ZJVoiceRecordHelper

- (id)init {
    self = [super init];
    if (self) {
        self.maxRecordTime = 60.0;
        self.recordDuration = @"0";
    }
    return self;
}

- (void)dealloc {
    [self stopRecord];
    self.recordPath = nil;
}

- (void)resetTimer {
    if (!_timer)
        return;
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
}

- (void)cancelRecording {
    if (!_recorder)
        return;
    
    if (self.recorder.isRecording) {
        [self.recorder stop];
    }
    
    self.recorder = nil;
}

- (void)stopRecord {
    [self cancelRecording];
    [self resetTimer];
    [[AVAudioSession sharedInstance]setActive:NO error:nil];
}

- (void)startRecordingWithPath:(NSString *)path StartRecorderCompletion:(ZJStartRecorderCompletion)startRecorderCompletion {
    _isPause = NO;
    
    NSArray* extensions = [path componentsSeparatedByString:@"."];
    NSNumber* depthKey = [NSNumber numberWithInt:16];
    if ([[extensions lastObject] isEqualToString:kFileTypeWAV]) {
        depthKey = [NSNumber numberWithInt:8];
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
    NSError *error = nil;
    //completionHandler
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    
    NSMutableDictionary * recordSetting = [NSMutableDictionary dictionary];
    
    [recordSetting setObject:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setObject:[NSNumber numberWithFloat:8000] forKey:AVSampleRateKey];
    [recordSetting setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    [recordSetting setObject:depthKey forKey:AVLinearPCMBitDepthKey];
    
    self.recordPath = path;
    self.recordDuration = 0;
    self.currentTimeInterval = 0;
    
    if (self.recorder) {
        [self cancelRecording];
    } else {
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:self.recordPath] settings:recordSetting error:&error];
        [_recorder prepareToRecord];
        _recorder.meteringEnabled = YES;
    }
    
    if ([_recorder record]) {
        [self resetTimer];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
        if (startRecorderCompletion)
            dispatch_async(dispatch_get_main_queue(), ^{
                startRecorderCompletion();
            });
    }
//    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
//        
//        [audioSession requestRecordPermission:^(BOOL available) {
//            NSError *error = nil;
//            if (available) {
//                //completionHandler
//                [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
//                
//                NSMutableDictionary * recordSetting = [NSMutableDictionary dictionary];
//                
//                [recordSetting setObject:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
//                [recordSetting setObject:[NSNumber numberWithFloat:8000] forKey:AVSampleRateKey];
//                [recordSetting setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
//                [recordSetting setObject:depthKey forKey:AVLinearPCMBitDepthKey];
//                
//                self.recordPath = path;
//                
//                if (self.recorder) {
//                    [self cancelRecording];
//                } else {
//                    _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:self.recordPath] settings:recordSetting error:&error];
//                    [_recorder prepareToRecord];
//                    _recorder.meteringEnabled = YES;
//                }
//                
//                if ([_recorder record]) {
//                    [self resetTimer];
//                    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
//                    if (startRecorderCompletion)
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            startRecorderCompletion();
//                        });
//                }
//            }
//            else
//            {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    ZJCustomAlertView *alert = [[ZJCustomAlertView alloc]initWithTitle:NSLocalizedString(@"note", nil) contentText:@[NSLocalizedString(@"record_denied", nil)] leftButtonTitle:NSLocalizedString(@"ok", nil) rightButtonTitle:nil withAlertViewType:ZJCustomAlertViewNormal];
//                    [alert show];
//                });
//            }
//        }];
//    }
}

- (void)resumeRecordingWithResumeRecorderCompletion:(ZJResumeRecorderCompletion)resumeRecorderCompletion {
    _isPause = NO;

    if (_recorder) {
        if ([_recorder record]) {
            dispatch_async(dispatch_get_main_queue(), resumeRecorderCompletion);
        }
    }
}

- (void)pauseRecordingWithPauseRecorderCompletion:(ZJPauseRecorderCompletion)pauseRecorderCompletion {
    _isPause = YES;

    if (_recorder) {
        [_recorder pause];
    }
    if (!_recorder.isRecording)
        dispatch_async(dispatch_get_main_queue(), pauseRecorderCompletion);
}

- (void)stopRecordingWithStopRecorderCompletion:(ZJStopRecorderCompletion)stopRecorderCompletion andShortRecoderCompletion:(ZJShortRecorderDeleteFileCompletion)shortRecorderCompletion{
    [self getVoiceDuration:_recordPath];
    if (_recordPath) {
        _isPause = NO;
        
        [self stopRecord];
        if (self.recordDuration.integerValue < 1) {
            dispatch_async(dispatch_get_main_queue(), shortRecorderCompletion);
        }else{
            dispatch_async(dispatch_get_main_queue(), stopRecorderCompletion);
        }
    }    
}

- (void)cancelledDeleteWithCompletion:(ZJCancellRecorderDeleteFileCompletion)cancelledDeleteCompletion {
    _isPause = NO;
    [self stopRecord];
    
    if (self.recordPath) {
        // 删除目录下的文件
        NSFileManager *fileManeger = [NSFileManager defaultManager];
        if ([fileManeger fileExistsAtPath:self.recordPath]) {
            NSError *error = nil;
            [fileManeger removeItemAtPath:self.recordPath error:&error];
            if (error) {
                //NSLog(@"error :%@", error.description);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                cancelledDeleteCompletion(error);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                cancelledDeleteCompletion(nil);
            });
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            cancelledDeleteCompletion(nil);
        });
    }
}

- (void)updateMeters {
    if (!_recorder)
        return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_recorder updateMeters];
        
        self.currentTimeInterval = _recorder.currentTime;
        
        if (!_isPause) {
            float progress = self.currentTimeInterval / self.maxRecordTime * 1.0;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_recordProgress) {
                    _recordProgress(progress);
                }
            });
        }
        
        float peakPower = [_recorder averagePowerForChannel:0];
        double ALPHA = 0.04;
        double peakPowerForChannel = pow(10, (ALPHA * peakPower));
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新扬声器
            if (_peakPowerForChannel) {
                _peakPowerForChannel(peakPowerForChannel);
            }
        });
        
        if (self.currentTimeInterval > self.maxRecordTime) {
            [self stopRecord];
            dispatch_async(dispatch_get_main_queue(), ^{
                _maxTimeStopRecorderCompletion();
            });
        }
    });
}

- (void)getVoiceDuration:(NSString*)recordPath {
    if (recordPath) {
        AVAudioPlayer *play = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:recordPath] error:nil];
        NSLog(@"时长:%f", play.duration);
        self.recordDuration = [NSString stringWithInteger:MAX(floor(_currentTimeInterval), floor(play.duration))];
    }
    //    return play.duration;
}
@end
