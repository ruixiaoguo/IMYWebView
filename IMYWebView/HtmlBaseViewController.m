//
//  HtmlBaseViewController.m
//  IMYWebView
//
//  Created by grx on 2018/8/17.
//  Copyright © 2018年 grx. All rights reserved.
//
/*! app尺寸 */
#define Main_Screen_Height [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width  [[UIScreen mainScreen] bounds].size.width
#define navBarHeight 64

#import "HtmlBaseViewController.h"
#import "IMYWebView.h"
#import "SDAutoLayout.h"

@interface HtmlBaseViewController ()<IMYWebViewDelegate>

@property (nonatomic,strong) IMYWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation HtmlBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.progressView];
    [self startLoadWithTitle:@"百度首页" url:@"https://www.baidu.com"];
}

- (void)startLoadWithTitle:(NSString *)title url:(NSString *)url {
    self.title = title;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSString *urlString = url;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.timeoutInterval = 15.0f;
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.webView];
    self.webView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).topSpaceToView(self.view, navBarHeight).heightIs(Main_Screen_Height);
}

/** initIMYWebView */
-(IMYWebView *)webView
{
    if (!_webView) {
        _webView = [IMYWebView new];
        _webView.delegate = self;
        [self.view addSubview:_webView];
        _webView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).topSpaceToView(self.view, navBarHeight).heightIs(Main_Screen_Height);
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    }
    return _webView;
}

-(UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [UIProgressView new];
        _progressView.backgroundColor = [UIColor lightGrayColor];
        _progressView.progressTintColor= [UIColor redColor];
        //设置进度条的高度
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        [self.view addSubview:_progressView];
        _progressView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).topSpaceToView(self.view, navBarHeight).heightIs(1);
    }
    return _progressView;
}

- (void)webViewDidStartLoad:(IMYWebView*)webView
{
    self.progressView.hidden = NO;
}

- (void)webViewDidFinishLoad:(IMYWebView*)webView
{
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';"completionHandler:nil];
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id object, NSError *error) {
        self.progressView.hidden = YES;
        NSLog(@"object=====%@",object);
    }];
}


- (void)webView:(IMYWebView*)webView didFailLoadWithError:(NSError*)error
{
    self.progressView.hidden = YES;
}
- (BOOL)webView:(IMYWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *strRequest = [request.URL.absoluteString stringByRemovingPercentEncoding];
    NSLog(@"strRequest=====%@",strRequest);
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
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
