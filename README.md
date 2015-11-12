# ReplayButton
+(ScreenRecorder*)screenRecorder:(UIViewController*)VC;
This gives a usable button.Add it to any view,and you are done.
Demo::(In a viewController!!)

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self._screenRecorder=[ScreenRecorder screenRecorder:self];
    [self.view addSubview:self._screenRecorder];
    [self.view bringSubviewToFront:self._screenRecorder];
}
