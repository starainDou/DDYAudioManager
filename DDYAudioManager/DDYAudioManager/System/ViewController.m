#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *recordButton;

@property (nonatomic, strong) UIButton *playButton;

@end

@implementation ViewController

- (UIButton *)recordButton {
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordButton setTitle:@"长按录制" forState:UIControlStateNormal];
        _recordButton
    }
    return _recordButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
