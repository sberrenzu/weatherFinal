//
//  ViewController.m
//  weather
//
//  Created by 黄健 on 16/8/22.
//  Copyright (c) 2016年 黄健. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "DetailViewController.h"

#define LOCALCITY @"Auckland"

@interface ViewController ()
@property (nonatomic, strong) NSArray *weather;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *city;

@property Client *KYClient;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //_KYClient=[Client getInstance];
    _KYClient= [[Client alloc]init];
    _KYClient.delegate=self;
    [self GetWeatherInfoByName:LOCALCITY];
    UIImageView *tableBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg2"]];
    [self.tableView setBackgroundView:tableBg];
    self.tableView.backgroundColor = [UIColor clearColor];
    _city = LOCALCITY;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _weather.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"simpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSDictionary *weather = _weather[indexPath.row];
    NSString *timestamp = weather[@"dt"];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSString *dateString = [formatter stringFromDate:date];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ Temperature :%@",dateString,  weather[@"temp"][@"day"]];
    cell.backgroundColor = [UIColor clearColor];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)getWeatherInfoSuccessFeedback:(id)feedbackInfo{
    NSLog(@"%@",[feedbackInfo class]);
    NSDictionary *dic=feedbackInfo;
    _weather = dic[@"list"];
    [_tableView reloadData];}

-(void)getWeatherInfoFailFeedback:(id)failInfo{
    NSLog(@"%@",failInfo);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"Search Text %@", textField.text);
    [self GetWeatherInfoByName:textField.text];
    return  YES;
}

- (void)GetWeatherInfoByName:(NSString *)cityName{
    [_KYClient getWeatherInfoWithCity:cityName];
    _city = cityName;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *weather = _weather[indexPath.row];
    DetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
    vc.detailTemp = [NSString stringWithFormat:@"%@", weather[@"temp"][@"day"]];
    vc.detailCity = _city;
    [self.navigationController pushViewController:vc animated:YES];
//    NSDictionary *weather = _weather[indexPath.row];
//    NSString *city = _city;
//    NSString *min = weather[@"temp"][@"min"];
//    NSString *max = weather[@"temp"][@"max"];
//    NSDictionary *weather_day =weather[@"weather"][0];
//    NSString *description = weather_day[@"description"];
//    NSString *timestamp = weather[@"dt"];
//
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyyMMddHHMMss"];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
//    NSString *dateString = [formatter stringFromDate:date];
//
//    NSString *titileString = [NSString stringWithFormat:@"City:%@, Date:%@, Min:%@,Max:%@, Description:%@",city, dateString, min, max,description];
//    UIAlertView *alert = [[ UIAlertView alloc]initWithTitle:@"Weather Detail" message:titileString delegate:self    cancelButtonTitle:@"OK"otherButtonTitles: nil];
//    [alert show];
}

@end
