#import "DDYAudioRecorder.h"

@interface DDYAudioRecorder ()<AVAudioRecorderDelegate>
/** 录音器 */
@property (nonatomic, strong) AVAudioRecorder *recorder;

@end

@implementation DDYAudioRecorder

#pragma mark 默认设置
/**
 caf要转换成mp3格式必须为双通道(AVNumberOfChannelsKey:@2)
 AVSampleRateKey==8000/44100/96000（影响音频的质量）, 采样率必须要设为11025才能使转化成mp3格式后不会失真
 */
- (NSDictionary *)settings {
    if (!_settings) {
        _settings = @{AVSampleRateKey:@(8000), AVFormatIDKey:@(kAudioFormatLinearPCM), AVLinearPCMBitDepthKey:@(16), AVNumberOfChannelsKey:@(1)};
    }
    return _settings;
}

#pragma mark 开始录音
- (void)ddy_StartRecordAtPath:(NSString *)path state:(void (^)(DDYAudioRecorderState))state {
    
    if (state) state(DDYAudioRecorderStatePrepare);
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:path] settings:self.settings error:nil];
    _recorder.meteringEnabled = YES;
    _recorder.delegate = self;
    if ([_recorder prepareToRecord] && [_recorder record]) {
        if (state) state(DDYAudioRecorderStateRecording);
    } else {
        if (state) state(DDYAudioRecorderStateError);
    }
}

#pragma mark 结束录音
- (void)ddy_StopRecord {
    [_recorder stop];
}

#pragma mark 删除录音
- (void)ddy_DeleteRecord {
    [_recorder stop];
    [_recorder deleteRecording];
}

#pragma mark 获取录制分贝值 一般-160到0, 可能存在越界情况
- (float)ddy_RecordLevels {
    [_recorder updateMeters];
    return [_recorder averagePowerForChannel:0];
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (self.recordFinishBlock) {
        self.recordFinishBlock([[_recorder url] path]);
    }
    // 音频转换
    // NSString *amrPath = [[wavPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"amr"];
    // [VoiceConverter ConvertWavToAmr:wavPath amrSavePath:amrPath];
}

- (void)dealloc {
    [_recorder stop];
}

@end
