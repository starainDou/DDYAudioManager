#import "DDYAudioPlayer.h"

@interface DDYAudioPlayer ()<AVAudioPlayerDelegate>
/** 播放器 */
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation DDYAudioPlayer

#pragma mark - 播放
#pragma mark 播放本地音频
- (void)ddy_PlayAudio:(NSString *)path {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        _player.numberOfLoops = 0;
        _player.delegate = self;
        _player.meteringEnabled = YES;
        if ([_player prepareToPlay]) {
            [_player play];
        };
    }
}

#pragma mark 暂停播放
- (void)ddy_PauseAudio {
    [_player pause];
}

#pragma mark 停止播放
- (void)ddy_StopAudio {
    [_player stop];
}

#pragma mark 恢复播放
- (void)ddy_ReplayAudio {
    [_player play];
}

#pragma mark 播放完成
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [_player stop];
    if (self.playFinishBlock) {
        self.playFinishBlock();
    }
}

#pragma mark 设置音量
- (void)setVolume:(CGFloat)volume {
    _player.volume = volume;
}

#pragma mark 播放进度
- (float)palyProgress {
    return _player.currentTime / _player.duration;
}

#pragma mark 获取播放分贝值
- (float)ddy_PlayLevels {
    [_player updateMeters];
    return [_player averagePowerForChannel:0];
}

- (void)dealloc {
    [_player stop];
}

@end
