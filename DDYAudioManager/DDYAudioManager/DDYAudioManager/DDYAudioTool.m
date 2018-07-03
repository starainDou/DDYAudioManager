#import "DDYAudioTool.h"
#import <MediaPlayer/MediaPlayer.h>
#import "lame.h"

#define ALPHA 0.02f  // 音频振幅调解相对值 (越小振幅就越高)

@implementation DDYAudioTool

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(routeChange:)
                                                     name:AVAudioSessionRouteChangeNotification
                                                   object:[AVAudioSession sharedInstance]];
    }
    return self;
}

- (void)routeChange:(NSNotification *)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger roteChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (roteChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"插入耳机");
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            NSLog(@"拔出耳机 暂停播放");
            break;
    }
}

#pragma mark 当前播放声道设置
- (void)currentRouteSettings {
    AVAudioSessionRouteDescription *route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription * desc in [route outputs]) { NSLog(@"声道%@、输出源名称%@",[desc portType], [desc portName]);
        
        if ([[desc portType] isEqualToString:@"Headphones"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
            });
        }
    }
}

#pragma mark 增加外放声音
+ (void)makeBiggerPower {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
}

#pragma mark 音量值转化
+ (CGFloat)audioPowerLevelsChange:(CGFloat)orignalPower {
    double aveChannel = pow(10, (ALPHA * orignalPower));
    if (aveChannel <= 0.05f) aveChannel = 0.05f;
    if (aveChannel >= 1.0f)  aveChannel = 1.0f;
    return aveChannel;
}

+ (int)ddy_ConvertPcmToMp3:(NSString *)pcmPath cafSampleRate:(CGFloat)sampleRate mp3SavePath:(NSString *)mp3Path;{

    @try {
        int read, write;
        
        FILE *pcm = fopen([pcmPath cStringUsingEncoding:1], "rb");  // source
        fseek(pcm, 4*1024, SEEK_CUR);                               // skip file header
        FILE *mp3 = fopen([mp3Path cStringUsingEncoding:1], "wb");  // output
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, sampleRate);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            write = read==0 ? lame_encode_flush(lame, mp3_buffer, MP3_SIZE) : lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            fwrite(mp3_buffer, write, 1, mp3);
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    } @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    } @finally {
        // 生成文件移除原文件
        // [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:pcmPath] error:nil];
    }
}

+ (NSString *)mp3ToBase64String:(NSString *)mp3Path {
    NSData *mp3Data = [NSData dataWithContentsOfFile:mp3Path];
    NSString *base64Str = [mp3Data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64Str;
}

/**
 *  MPMediaItemPropertyAlbumTitle // 专辑名
 *  MPMediaItemPropertyAlbumTrackCount  // 专辑个数
 *  MPMediaItemPropertyAlbumTrackNumber // 当前播放的专辑位置
 *  MPMediaItemPropertyArtist   // 艺术家
 *  MPMediaItemPropertyArtwork  // 封面
 *  MPMediaItemPropertyComposer // 作曲家
 *  MPMediaItemPropertyDiscCount    // 迪斯科 数量
 *  MPMediaItemPropertyDiscNumber   // 当前位置
 *  MPMediaItemPropertyGenre    // 流派
 *  MPMediaItemPropertyPersistentID // ID
 *  MPMediaItemPropertyPlaybackDuration // 后台播放时长
 *  MPMediaItemPropertyTitle    // 标题
 */
#pragma mark 锁屏界面
+ (void)setPlayingInfo {
    // 初始化一个可变字典
    NSMutableDictionary *songInfo = [ [NSMutableDictionary alloc] init];
    // 初始化一个封面
    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"img1"]];
    // 设置封面
    [ songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork ];
    // 设置标题
    [ songInfo setObject:@"追梦人" forKey:MPMediaItemPropertyTitle ];
    // 设置作者
    [ songInfo setObject:@"作者" forKey:MPMediaItemPropertyArtist ];
    // 设置专辑
    [ songInfo setObject:@"唱片集" forKey:MPMediaItemPropertyAlbumTitle ];
    // 流派
    [songInfo setObject:@"流派" forKey:MPMediaItemPropertyGenre];
    // 设置总时长
    [songInfo setObject:@"10.2" forKey:MPMediaItemPropertyPlaybackDuration];
    // 设置
    [ [MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end



/** https://www.jianshu.com/p/135ca0deceec
 https://www.jianshu.com/p/799c0a4d38ef
 https://www.cnblogs.com/kenshincui/p/4186022.html#audioRecord
 https://blog.csdn.net/kingshuo7/article/details/42588191
 https://www.cnblogs.com/yeng/p/6019507.html
 控制中心，锁屏界面 https://blog.csdn.net/qq_32010299/article/details/51316790
 */
