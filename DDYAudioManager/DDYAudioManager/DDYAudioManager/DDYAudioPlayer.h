#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface DDYAudioPlayer : NSObject

/** 播放进度 */
@property (nonatomic, assign, readonly) float palyProgress;
/** 播放音量 0-1 */
@property (nonatomic, assign) CGFloat volume;
/** 播放完成 */
@property (nonatomic, copy) void (^playFinishBlock)(void);

/** 播放本地音频 */
- (void)ddy_PlayAudio:(NSString *)path;
/** 暂停播放 */
- (void)ddy_PauseAudio;
/** 恢复播放 */
- (void)ddy_ReplayAudio;
/** 停止播放 */
- (void)ddy_StopAudio;
/** 获取播放分贝值 */
- (float)ddy_PlayLevels;

@end
