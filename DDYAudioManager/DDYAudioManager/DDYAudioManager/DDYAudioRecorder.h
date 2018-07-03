#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, DDYAudioRecorderState) {
    DDYAudioRecorderStateError = -1,    // 出错了
    DDYAudioRecorderStatePrepare = 0,   // 准备中
    DDYAudioRecorderStateRecording = 1, // 录音中
};

@interface DDYAudioRecorder : NSObject

/** 录音设置 */
@property (nonatomic, strong) NSDictionary *settings;
/** 是否正在录音 */
@property (nonatomic, assign, readonly) BOOL isRecording;
/** 录音完成 */
@property (nonatomic, copy) void (^recordFinishBlock)(NSString *path);

/** 开始录音 务必在录制前停止其它播放或录制 */
- (void)ddy_StartRecordAtPath:(NSString *)path state:(void (^)(DDYAudioRecorderState))state;
/** 结束录音 */
- (void)ddy_StopRecord;
/** 删除录音 */
- (void)ddy_DeleteRecord;
/** 获取录制分贝值 可通过[DDYAudioTool audioPowerLevelsChange:]转换 */
- (float)ddy_RecordLevels;

@end
