//
//  RecordingViewController.m
//  Demo
//
//  Created by 淼视觉 on 2017/9/11.
//  Copyright © 2017年 倪大头. All rights reserved.
//

#import "RecordingViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface RecordingViewController ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>

@end

@implementation RecordingViewController
{
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    NSTimer *recordTimer;//录音计时器
    NSTimer *playTimer;//播放计时器
    NSInteger recordSecond;//录音时间
    UILabel *beginRecordLabel;//录音倒计时
    NSInteger playSecond;//播放时间
    UILabel *playLimitLabel;//播放倒计时
    NSURL *tmpUrl;
    NSURL *mp3Url;
    UIImageView *recordImg;
    UIImageView *stopImg;
    UIImageView *playImg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createCustomNavi:@"录音"];
    
    [self createView];
}

- (void)createView {
    recordImg = [[UIImageView alloc]initWithFrame:CGRectMake(kScaleX*123.5, 64+kScaleY*70, kScaleX*128, kScaleY*128)];
    recordImg.image = [UIImage imageNamed:@"录音"];
    [self.view addSubview:recordImg];
    UITapGestureRecognizer *recordingTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(recordingAction)];
    recordImg.userInteractionEnabled = YES;
    [recordImg addGestureRecognizer:recordingTap];
    
    stopImg = [[UIImageView alloc]initWithFrame:CGRectMake(kScaleX*123.5, 64+kScaleY*70, kScaleX*128, kScaleY*128)];
    stopImg.image = [UIImage imageNamed:@"暂停"];
    stopImg.hidden = YES;
    [self.view addSubview:stopImg];
    UITapGestureRecognizer *stopTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stopAction)];
    stopImg.userInteractionEnabled = YES;
    [stopImg addGestureRecognizer:stopTap];
    
    playImg = [[UIImageView alloc]initWithFrame:CGRectMake(kScaleX*123.5, CGRectGetMaxY(recordImg.frame)+kScaleY*80, kScaleX*128, kScaleY*128)];
    playImg.image = [UIImage imageNamed:@"play"];
    playImg.hidden = YES;
    [self.view addSubview:playImg];
    UITapGestureRecognizer *playTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playAction)];
    playImg.userInteractionEnabled = YES;
    [playImg addGestureRecognizer:playTap];
    
    beginRecordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(recordImg.frame)+kScaleY*10, UI_SCREEN_WIDTH, kScaleY*20)];
    beginRecordLabel.textColor = [UIColor colorWithHexString:@"#333333" alpha:1];
    beginRecordLabel.font = [UIFont fontWithName:LightFont size:17];
    beginRecordLabel.textAlignment = 1;
    [self.view addSubview:beginRecordLabel];
    
    playLimitLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(playImg.frame)+kScaleY*10, UI_SCREEN_WIDTH, kScaleY*20)];
    playLimitLabel.textColor = [UIColor colorWithHexString:@"#333333" alpha:1];
    playLimitLabel.font = [UIFont fontWithName:LightFont size:17];
    playLimitLabel.textAlignment = 1;
    [self.view addSubview:playLimitLabel];
}

//录音
- (void)recordingAction {
    NSLog(@"开始录音");
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    //录音设置
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [recordSettings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
    //通道数
    [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //线性采样位数
    //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    
    NSError *error = nil;
    NSString *recordUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    tmpUrl = [NSURL URLWithString:[recordUrl stringByAppendingPathComponent:@"selfRecord.caf"]];
    
    recorder = [[AVAudioRecorder alloc]initWithURL:tmpUrl settings:recordSettings error:&error];
    
    if (recorder) {
        //启动或者恢复记录的录音文件
        if ([recorder prepareToRecord] == YES) {
            [recorder record];
            recordImg.hidden = YES;
            playImg.hidden = YES;
            stopImg.hidden = NO;
            beginRecordLabel.hidden = NO;
            playLimitLabel.hidden = YES;

            recordSecond = 0;
            recordTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recordSecondChange) userInfo:nil repeats:YES];
            [recordTimer fire];
        }
        
    }else {
        NSLog(@"录音创建失败");
    }
}

//录音计时
- (void)recordSecondChange {
    recordSecond ++;
    beginRecordLabel.text = [NSString stringWithFormat:@"开始录音:%lds",(long)recordSecond];
}

//停止录音
- (void)stopAction {
    NSLog(@"停止录音");
    //停止录音
    [recorder stop];
    recorder = nil;
    [recordTimer invalidate];
    
    playLimitLabel.text = [NSString stringWithFormat:@"%lds",(long)recordSecond];
    playImg.hidden = NO;
    recordImg.hidden = NO;
    stopImg.hidden = YES;
    beginRecordLabel.hidden = YES;
    playLimitLabel.hidden = NO;
}

//播放录音
- (void)playAction {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSError *playError;
    
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:tmpUrl error:&playError];
    //当播放录音为空, 打印错误信息
    if (player == nil) {
        NSLog(@"Error crenting player: %@", [playError description]);
    }else {
        player.delegate = self;
        NSLog(@"开始播放");
        //开始播放
        playSecond = recordSecond;
        if ([player prepareToPlay] == YES) {
            playImg.userInteractionEnabled = NO;
            [player play];
            playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playSecondChange) userInfo:nil repeats:YES];
            [playTimer fire];
        }
    }
}

//播放计时
- (void)playSecondChange {
    playSecond --;
    if (playSecond <= 0) {
        playSecond = 0;
        [playTimer invalidate];
    }
    playLimitLabel.text = [NSString stringWithFormat:@"%lds",(long)playSecond];
}

//当播放结束后调用这个方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"播放结束");
    [playTimer invalidate];
    playLimitLabel.text = [NSString stringWithFormat:@"%lds",(long)recordSecond];
    playImg.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
