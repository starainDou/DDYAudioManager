#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface DDYAudioTool : NSObject

/**
 增加外放声音
 */
+ (void)makeBiggerPower;

/**
 分贝值转化
 @param orignalPower 播放器或者录音器返回的分贝值 -160到0之间 可能有越界
 @return 转换后某个范围内的数值
 */
+ (CGFloat)audioPowerLevelsChange:(CGFloat)orignalPower;

/**
 PCM(wav、caf)转MP3
 @param pcmPath 原文件路径
 @param sampleRate 采集率 推荐11025保证转换的mp3不失真
 @param mp3Path 转换后MP3保存路径
 */
+ (void)ddy_ConvertPcmToMp3:(NSString *)pcmPath sampleRate:(CGFloat)sampleRate mp3SavePath:(NSString *)mp3Path;

/**
 音频转Base64字符串
 @param path 文件路径
 @return Base64字符串
 */
+ (NSString *)ddy_ConvertToBase64String:(NSString *)path;

/**
 播放音效
 @param soundName 在bundle中的加后缀名称 如:@"DDYQRCode.bundle/sound.caf"
 */
+ (void)ddy_palySoundWithName:(NSString *)soundName;

@end
