//
//  ZJVoiceRecordHelper.h
//  MyClass3
//
//  Created by 朱佳伟 on 15/6/4.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^ZJStartRecorderCompletion)();
typedef void(^ZJStopRecorderCompletion)();
typedef void(^ZJPauseRecorderCompletion)();
typedef void(^ZJResumeRecorderCompletion)();
typedef void(^ZJShortRecorderDeleteFileCompletion)();
typedef void(^ZJCancellRecorderDeleteFileCompletion)();

typedef void(^ZJRecordProgress)(float progress);
typedef void(^ZJPeakPowerForChannel)(float peakPowerForChannel);

@interface ZJVoiceRecordHelper : NSObject
{
    NSTimer *_timer;
    BOOL _isPause;
}

/**
 *  结束录音回调Block
 */
@property (nonatomic, copy) ZJStopRecorderCompletion maxTimeStopRecorderCompletion;

/**
 *  录音进度
 */
@property (nonatomic, copy) ZJRecordProgress recordProgress;

/**
 *  扬声器
 */
@property (nonatomic, copy) ZJPeakPowerForChannel peakPowerForChannel;

/**
 *  录音文件时长
 */
@property (nonatomic, copy) NSString *recordDuration;

/**
 *  录音最长时间
 */
@property (nonatomic) float maxRecordTime; // 默认 60秒为最大

/**
 *  录音保存路径
 */
@property (nonatomic, copy, readwrite) NSString *recordPath;

/**
 *  当前录音时间
 */
@property (nonatomic, readwrite) NSTimeInterval currentTimeInterval;

/**
 *  录音实例
 */
@property (nonatomic, strong) AVAudioRecorder *recorder;

/**
 *  开始录音
 *
 *  @param path                    录音文件路径
 *  @param startRecorderCompletion
 */
- (void)startRecordingWithPath:(NSString *)path StartRecorderCompletion:(ZJStartRecorderCompletion)startRecorderCompletion;

/**
 *  暂停录音
 *
 *  @param pauseRecorderCompletion
 */
- (void)pauseRecordingWithPauseRecorderCompletion:(ZJPauseRecorderCompletion)pauseRecorderCompletion;

/**
 *  恢复录音
 *
 *  @param resumeRecorderCompletion
 */
- (void)resumeRecordingWithResumeRecorderCompletion:(ZJResumeRecorderCompletion)resumeRecorderCompletion;

/**
 *  结束录音
 *
 *  @param stopRecorderCompletion
 */
- (void)stopRecordingWithStopRecorderCompletion:(ZJStopRecorderCompletion)stopRecorderCompletion andShortRecoderCompletion:(ZJShortRecorderDeleteFileCompletion)shortRecorderCompletion;

/**
 *  取消录音
 *
 *  @param cancelledDeleteCompletion
 */
- (void)cancelledDeleteWithCompletion:(ZJCancellRecorderDeleteFileCompletion)cancelledDeleteCompletion;

@end
