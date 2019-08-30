#import "MBXContextSnapshotViewController.h"
#import <Mapbox/Mapbox.h>

@interface MBXContextSnapshotViewController () <MGLMapViewDelegate>
@property MGLMapView *mapView;
@property UIButton *button;
@property UIImageView *imageView;
@end

@implementation MBXContextSnapshotViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _mapView = [[MGLMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height / 2) styleURL:[MGLStyle lightStyleURL]];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;


    [_mapView setCenterCoordinate:_mapView.centerCoordinate zoomLevel:1 animated:NO];
    [self.view addSubview:_mapView];


    _button = [[UIButton alloc] initWithFrame:CGRectMake(_mapView.frame.origin.x + 100, _mapView.frame.origin.y + 45, 170, 30)];
    _button.layer.cornerRadius = 15;
    _button.backgroundColor = [UIColor blueColor];
    [_button setTitle:@"Create snapshot" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(createSnapshot) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];

    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height / 2, self.view.bounds.size.width, self.view.bounds.size.height / 2)];
    _imageView.backgroundColor = [UIColor blackColor];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_imageView];
}

- (void)createSnapshot {

    MGLMapSnapshotOptions *options = [[MGLMapSnapshotOptions alloc] initWithStyleURL:_mapView.styleURL camera:_mapView.camera size:_mapView.bounds.size];

    /**
     ------------------------ Configure image overlays ------------------------
     */
    UIImage *image = [UIImage imageNamed:@"happy-blob"];
    MGLMapSnapShotOverlay *overlay = [[MGLMapSnapShotOverlay alloc] initWithImage:image position:CGPointMake(20, 290)];
    overlay.alpha = 0.5;
    MGLMapSnapShotOverlay *overlay2 = [[MGLMapSnapShotOverlay alloc] initWithImage:image position:CGPointMake(240, 10)];
    options.overlayImages = @[overlay, overlay2];
    /**
     --------------------------------------------------------------------------
     */

    options.zoomLevel = _mapView.zoomLevel;

    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(_imageView.center.x - 30, _imageView.center.y - 30, 60, 60)];
    [self.view addSubview:indicator];
    [indicator startAnimating];

    __block MGLMapSnapshotter *snapshotter = [[MGLMapSnapshotter alloc] initWithOptions:options];

    [snapshotter startWithCompletionHandler:^(MGLMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to create a map snapshot.");
        } else if (snapshot != nil) {
            // Add the map snapshot's image to the image view.
            [indicator stopAnimating];
            self.imageView.image = snapshot.image;
        }

        snapshotter = nil;
    }];
}

@end
