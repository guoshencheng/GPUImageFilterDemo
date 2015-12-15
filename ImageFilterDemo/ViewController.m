//
//  ViewController.m
//  ImageFilterDemo
//
//  Created by guoshencheng on 12/15/15.
//  Copyright © 2015 zixin. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+tool.h"
#import <MobileCoreServices/MobileCoreServices.h>

//GPUImageBrightnessFilter亮度
//GPUImageExposureFilter曝光
//GPUImageContrastFilter对比度
//GPUImageSaturationFilter饱和度
//GPUImageGammaFilter伽马线
//GPUImageToneCurveFilter色调曲线
@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *filterArray;

@end

@implementation ViewController {
    UIActionSheet *actionSheet;
    GPUImageFilterPipeline *pipeline;
    GPUImagePicture *staticPicture;
    GPUImageOutput<GPUImageInput> *filter1;
    GPUImageOutput<GPUImageInput> *filter2;
    GPUImageOutput<GPUImageInput> *filter3;
    GPUImageOutput<GPUImageInput> *filter4;
}

+ (instancetype)create {
    return [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showActionSheet {
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

- (void)configureFilter4 {
    [self.slideFour setMinimumValue:0.0];
    [self.slideFour setMaximumValue:1.0];
    [self.slideFour setValue:0.5];
    self.label4.text = [NSString stringWithFormat:@"%.2f",0.5];
    filter4 = [[GPUImageToneCurveFilter alloc] init];
    [(GPUImageToneCurveFilter *)filter4 setBlueControlPoints:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)], [NSValue valueWithCGPoint:CGPointMake(1.0, 0.75)], nil]];
}

- (void)configureFilter1 {
    [self.slideOne setMinimumValue:-1.0];
    [self.slideOne setMaximumValue:1.0];
    [self.slideOne setValue:0.0];
    self.label1.text = [NSString stringWithFormat:@"%.2f",0.0];
    filter1 = [[GPUImageBrightnessFilter alloc] init];
}

- (void)configureFilter2 {
    [self.slideTwo setMinimumValue:0.0];
    [self.slideTwo setMaximumValue:4.0];
    [self.slideTwo setValue:1.0];
    self.label2.text = [NSString stringWithFormat:@"%.2f",1.0];
    
    filter2 = [[GPUImageContrastFilter alloc] init];
}

- (void)configureFilter3 {
    [self.slideThree setValue:1.0];
    [self.slideThree setMinimumValue:0.0];
    [self.slideThree setMaximumValue:2.0];
    self.label3.text = [NSString stringWithFormat:@"%.2f",1.0];
    filter3 = [[GPUImageSaturationFilter alloc] init];
}

- (void)setup {
    self.filterArray = [[NSMutableArray alloc] init];
    [self configureFilter1];
    [self configureFilter2];
    [self configureFilter3];
    [self configureFilter4];
    [self recoverAllFilter];
    
}

- (void)removeAllFilter {
    [self.filterArray removeAllObjects];
    pipeline = [[GPUImageFilterPipeline alloc]initWithOrderedFilters:self.filterArray input:staticPicture output:(GPUImageView*)self.photoImageView];
    [staticPicture processImage];
}

- (void)recoverAllFilter {
    [self.filterArray addObject:filter1];
    [self.filterArray addObject:filter2];
    [self.filterArray addObject:filter3];
    [self.filterArray addObject:filter4];
    pipeline = [[GPUImageFilterPipeline alloc]initWithOrderedFilters:self.filterArray input:staticPicture output:(GPUImageView*)self.photoImageView];
    [staticPicture processImage];
}

- (IBAction)cameraButtonClick:(id)sender {
    [self showActionSheet];
}

- (IBAction)didSlide:(id)sender {
    if (sender == self.slideOne) {
        [(GPUImageBrightnessFilter *)filter1 setBrightness:[(UISlider *)sender value]];
        self.label1.text = [NSString stringWithFormat:@"%@", @([(UISlider *)sender value])];
    } else if (sender == self.slideTwo) {
        [(GPUImageContrastFilter *)filter2 setContrast:[(UISlider *)sender value]];
        self.label2.text = [NSString stringWithFormat:@"%@", @([(UISlider *)sender value])];
    } else if (sender == self.slideThree) {
        [(GPUImageSaturationFilter *)filter3 setSaturation:[(UISlider *)sender value]];
        self.label3.text = [NSString stringWithFormat:@"%@", @([(UISlider *)sender value])];
    } else if (sender == self.slideFour) {
        [(GPUImageToneCurveFilter *)filter4 setBlueControlPoints:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)], [NSValue valueWithCGPoint:CGPointMake(0.5, [(UISlider *)sender value])], [NSValue valueWithCGPoint:CGPointMake(1.0, 0.75)], nil]];
        self.label4.text = [NSString stringWithFormat:@"%@", @([(UISlider *)sender value])];
    }
    [self update];
}

- (IBAction)switchButtonClicked:(id)sender {
    if (self.filterArray && self.filterArray.count > 0) {
        [self removeAllFilter];
    } else {
        [self recoverAllFilter];
    }
}

- (void)update {
    [staticPicture processImage];
}

- (void)actionSheet:(UIActionSheet *)actionsheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.allowsEditing = NO;
    self.imagePicker.delegate = self;
    if (buttonIndex == actionsheet.firstOtherButtonIndex) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            return;
        }
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if (buttonIndex == actionsheet.firstOtherButtonIndex+1) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    }
    else if (buttonIndex == actionsheet.cancelButtonIndex) {
        return;
    }
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = (UIImage*)(info[@"UIImagePickerControllerOriginalImage"]);
    staticPicture = [[GPUImagePicture alloc] initWithImage:[UIImage fixOrientation:image]];
    [self setup];
    //self.photoImageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
