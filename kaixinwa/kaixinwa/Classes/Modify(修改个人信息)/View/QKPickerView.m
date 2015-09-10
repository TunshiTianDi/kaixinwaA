//
//  QKPickerView.m
//  kaixinwa
//
//  Created by 张思源 on 15/7/22.
//  Copyright (c) 2015年 郭庆宇. All rights reserved.
//

#import "QKPickerView.h"
@interface QKPickerView()
/** 省数组*/
@property(nonatomic,strong)NSMutableArray * provinces;
/** 市数组*/
@property (nonatomic,strong)NSMutableArray * cities;
/** 区县数组*/
@property(nonatomic,strong)NSMutableArray * areas;


@end

@implementation QKPickerView
-(NSMutableArray *)provinces{
    if (_provinces==nil) {
        _provinces = [NSMutableArray array];
    }
    return _provinces;
}
-(NSMutableArray *)cities{
    if (_cities==nil) {
        _cities = [NSMutableArray array];
    }
    return _cities;
}
-(NSMutableArray *)areas{
    if (_areas==nil) {
        _areas = [NSMutableArray array];
    }
    return _areas;
}
-(QKLocation *)locate
{
    if (_locate == nil) {
        _locate = [[QKLocation alloc] init];
    }
    
    return _locate;
}

-(id)initWithDelegate:(id<QKAreaPickerDelegate>)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"QKPickerView" owner:self options:nil] objectAtIndex:0];
    if(self){
        self.delegate = delegate;
        self.areaPickView.delegate = self;
        self.areaPickView.dataSource = self;
        
        [self.sureButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancleButton addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
        NSString * areaPath = [[NSBundle mainBundle]pathForResource:@"area.plist" ofType:nil];
        self.provinces = [[NSMutableArray alloc]initWithContentsOfFile:areaPath];
        self.cities = [[self.provinces objectAtIndex:0] objectForKey:@"cities"];
        self.locate.state = [[self.provinces objectAtIndex:0] objectForKey:@"state"];
        self.locate.city = [[self.cities objectAtIndex:0]objectForKey:@"city"];
        self.areas = [[self.cities objectAtIndex:0] objectForKey:@"areas"];
        if (self.areas.count > 0) {
            self.locate.district = [self.areas objectAtIndex:0];
        }else{
            self.locate.district = @"";
        }
    }
    
    return self;
}
-(void)submit:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(clickSubmit)]) {
        [self.delegate clickSubmit];
    }
}
-(void)cancle:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(clickCancle)]) {
        [self.delegate clickCancle];
    }
}



#pragma mark - UIPickerView Date Source
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [self.provinces count];
            break;
        case 1:
            return [self.cities count];
            break;
        case 2:
            return [self.areas count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [[self.provinces objectAtIndex:row] objectForKey:@"state"];
            break;
        case 1:
            return [[self.cities objectAtIndex:row] objectForKey:@"city"];
            break;
        case 2:
            if ([self.areas count] > 0) {
                return [self.areas objectAtIndex:row];
                break;
            }
        default:
            return  @"";
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            self.cities = [[self.provinces objectAtIndex:row] objectForKey:@"cities"];
            [self.areaPickView selectRow:0 inComponent:1 animated:YES];
            [self.areaPickView reloadComponent:1];
            
            self.areas = [[self.cities objectAtIndex:0] objectForKey:@"areas"];
            [self.areaPickView selectRow:0 inComponent:2 animated:YES];
            [self.areaPickView reloadComponent:2];
            
            self.locate.state = [[self.provinces objectAtIndex:row] objectForKey:@"state"];
            self.locate.city = [[self.cities objectAtIndex:0] objectForKey:@"city"];
            if ([self.areas count] > 0) {
                self.locate.district = [self.areas objectAtIndex:0];
            } else{
                self.locate.district = @"";
            }
            break;
        case 1:
            self.areas = [[self.cities objectAtIndex:row] objectForKey:@"areas"];
            [self.areaPickView selectRow:0 inComponent:2 animated:YES];
            [self.areaPickView reloadComponent:2];
            
            self.locate.city = [[self.cities objectAtIndex:row] objectForKey:@"city"];
            if ([self.areas count] > 0) {
                self.locate.district = [self.areas objectAtIndex:0];
            } else{
                self.locate.district = @"";
            }
            break;
        case 2:
            if ([self.areas count] > 0) {
                self.locate.district = [self.areas objectAtIndex:row];
            } else{
                self.locate.district = @"";
            }
            break;
        default:
            break;
    }
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }
}
#pragma mark - animation

- (void)showInView:(UIView *) view
{
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.frame.size.height);
    
    [view addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.frame.size.height);
    }];
    
}

- (void)cancelPicker
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
    
}


@end
