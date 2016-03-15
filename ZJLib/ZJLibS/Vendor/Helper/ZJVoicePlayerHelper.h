//
//  ZJVoicePlayerHelper.h
//  MyClass3
//
//  Created by 朱佳伟 on 15/6/8.
//  Copyright (c) 2015年 朱佳伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@protocol ZJVoicePlayerHelperDelegate <NSObject>

@optional
/**
 *  开始播放语音
 *
 *  @param audioPlayer
 */
- (void)didAudioPlayerBeginPlay:(AVAudioPlayer*)audioPlayer;

/**
 *  停止播放语音
 *
 *  @param audioPlayer
 */
- (void)didAudioPlayerStopPlay:(AVAudioPlayer*)audioPlayer;

/**
 *  暂停播放语音
 *
 *  @param audioPlayer
 */
- (void)didAudioPlayerPausePlay:(AVAudioPlayer*)audioPlayer;

/**
 *  结束播放语音
 *
 *  @param audioPlayer
 */
- (void)didAudioPlayerFinishPlay:(AVAudioPlayer*)audioPlayer;

@end

@interface ZJVoicePlayerHelper : NSObject<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, copy) NSString *playingFileName;

@property (nonatomic, assign) id <ZJVoicePlayerHelperDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *playingIndexPathInFeedList;//给动态列表用

/**
 *  单例
 *
 *  @return
 */
+ (id)shareInstance;

/**
 *  播放器对象
 *
 *  @return
 */
- (AVAudioPlayer*)player;

/**
 *  是否播放中
 *
 *  @return
 */
- (BOOL)isPlaying;

/**
 *  录音播放，如本地存在录音文件则直接播放，如不存在则下载播放
 *
 *  @param url                 录音url
 *  @param filename            文件名
 *  @param recordAnimationView 播放动画
 */
- (void)downloadWithReocrdUrl:(NSURL *)url filename:(NSString *)filename recordAnimationView:(UIImageView *)recordAnimationView;

/**
 *  播放录音
 *
 *  @param amrName 录音文件名
 *  @param toPlay  是否马上播放
 */
- (void)managerAudioWithFileName:(NSString*)amrName toPlay:(BOOL)toPlay;

/**
 *  播放录音
 *
 *  @param data   录音数据
 *  @param toPlay 是否马上播放
 *  @param reset  设置播放器策略
 */
- (void)managerAudioWithData:(NSData*)data toPlay:(BOOL)toPlay resetCategory:(BOOL)reset;

/**
 *  暂停播放
 */
- (void)pausePlayingAudio;

/**
 *  停止播放
 */
- (void)stopAudio;

@end
