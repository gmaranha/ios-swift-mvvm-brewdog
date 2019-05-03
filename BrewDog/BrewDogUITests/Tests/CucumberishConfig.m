//
//  CucumberishConfig.m
//  BrewDogUITests
//
//  Created by Giuliano Gobbo Maranha on 03/05/19.
//  Copyright © 2019 Giuliano Maranha. All rights reserved.
//

#import "BrewDogUITests-Swift.h"

__attribute__((constructor))
void CucumberishInit(){
    [CucumberishInitializer setupCucumberish];
}

