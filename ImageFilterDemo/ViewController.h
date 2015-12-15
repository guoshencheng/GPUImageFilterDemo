//
//  ViewController.h
//  ImageFilterDemo
//
//  Created by guoshencheng on 12/15/15.
//  Copyright © 2015 zixin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet GPUImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UISlider *slideOne;
@property (weak, nonatomic) IBOutlet UISlider *slideTwo;
@property (weak, nonatomic) IBOutlet UISlider *slideThree;
@property (weak, nonatomic) IBOutlet UISlider *slideFour;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

+ (instancetype)create;

@end

