//
//  TemperatureViewController.m
//  TemperatureConverter
//
//  Created by Ruchi Varshney on 1/17/14.
//  Copyright (c) 2014 Ruchi Varshney. All rights reserved.
//

#import "TemperatureViewController.h"

@interface TemperatureViewController ()
@property (weak, nonatomic) IBOutlet UITextField *celsiusTextField;
@property (weak, nonatomic) IBOutlet UITextField *fahrenheitTextField;
@property (weak, nonatomic) IBOutlet UIButton *convertButton;

- (IBAction)onConvert:(id)sender;
- (IBAction)onCelsiusEdit:(id)sender;
- (IBAction)onFahrenheitEdit:(id)sender;
- (IBAction)onTap:(id)sender;

- (void)convert;
- (void)dismissKeyboard;

@end

@implementation TemperatureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.celsiusTextField.delegate = self;
    self.fahrenheitTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction handlers

- (void)convert
{
    // Determine which field is blank
    BOOL toCelsius = [self.celsiusTextField.text length] == 0;
    BOOL toFahrenheit = [self.fahrenheitTextField.text length] == 0;
    
    // If both are blank, there's nothing to do
    if (toFahrenheit && toCelsius) {
        return;
    }
    
    float convertValue, convertedValue;
    if (toFahrenheit) {
        convertValue = [self.celsiusTextField.text floatValue];
        convertedValue = convertValue * 1.8 + 32;
        
        // Always round to 2 decimal places
        self.fahrenheitTextField.text = [NSString stringWithFormat:@"%.2f", convertedValue];
        self.celsiusTextField.text = [NSString stringWithFormat:@"%.2f", convertValue];
    }
    
    if (toCelsius) {
        convertValue = [self.fahrenheitTextField.text floatValue];
        convertedValue = (convertValue - 32) / 1.8;
        
        // Always round to 2 decimal places
        self.celsiusTextField.text = [NSString stringWithFormat:@"%.2f", convertedValue];
        self.fahrenheitTextField.text = [NSString stringWithFormat:@"%.2f", convertValue];
    }
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (IBAction)onConvert:(id)sender
{
    [self dismissKeyboard];
    [self convert];
}

- (IBAction)onCelsiusEdit:(id)sender
{
    self.fahrenheitTextField.text = @"";
}

- (IBAction)onFahrenheitEdit:(id)sender
{
    self.celsiusTextField.text = @"";
}

- (IBAction)onTap:(id)sender
{
    [self dismissKeyboard];
}

#pragma mark - Text field delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self convert];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Use number formatter for decimal style number checking
    // The keyboard type is set as Number and Punctuation because
    // negative decimal numbers need to be handled as well
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if([text hasPrefix:@"-"]) {
        text = [text substringFromIndex:1];
    }
    
    // Blank string is always acceptable
    return [text isEqualToString:@""] || [formatter numberFromString:text] != nil;
}
@end
