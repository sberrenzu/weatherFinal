//
//  Client.m
//  weather
//
//  Created by 黄健 on 16/8/25.
//  Copyright (c) 2016年 黄健. All rights reserved.
//
#import "Client.h"

@implementation Client

-(void)getWeatherInfoWithCity:(NSString *)cityName{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //rev add
    NSString *url=[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily"];
    //NSString *param =[NSString stringWithFormat:@"%@&mode=json&units=metric&cnt=7&appID=8b7661be7bbdbfb1004eb364dd045ab6", cityName];
    NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
    [param setObject:cityName forKey:@"q"];
    [param setObject:@"json" forKey:@"mode"];
    [param setObject:@"metric" forKey:@"units"];
    [param setObject:@"7" forKey:@"cnt"];
    [param setObject:@"8b7661be7bbdbfb1004eb364dd045ab6" forKey:@"appID"];

    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval=5;

    [manager GET:url parameters: param success:^(AFHTTPRequestOperation * operation, id responseObject) {
        NSLog(@"ssss");
        [self.delegate getWeatherInfoSuccessFeedback:responseObject];
        //suc
    } failure:^(AFHTTPRequestOperation * operation, NSError *error) {
        //fail
        NSLog(@"fffff");
        [self.delegate getWeatherInfoFailFeedback:error];
    }];
}

@end
