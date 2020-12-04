//
//  ViewController.m
//  KVO KVC Demo
//
//  Created by Paul Solt on 4/9/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

#import "ViewController.h"
#import "LSIDepartment.h"
#import "LSIEmployee.h"
#import "LSIHRController.h"


@interface ViewController ()

@property (nonatomic) LSIHRController *hrController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    LSIDepartment *marketing = [[LSIDepartment alloc] init];
    marketing.name = @"Marketing";
    LSIEmployee * philSchiller = [[LSIEmployee alloc] init];
    philSchiller.name = @"Phil";
    philSchiller.jobTitle = @"VP of Marketing";
    philSchiller.salary = 10000000; 
    marketing.manager = philSchiller;

    
    LSIDepartment *engineering = [[LSIDepartment alloc] init];
    engineering.name = @"Engineering";
    LSIEmployee *craig = [[LSIEmployee alloc] init];
    craig.name = @"Craig";
    craig.salary = 9000000;
    craig.jobTitle = @"Head of Software";
    engineering.manager = craig;
    
    LSIEmployee *e1 = [[LSIEmployee alloc] init];
    e1.name = @"Chad";
    e1.jobTitle = @"Engineer";
    e1.salary = 200000;
    
    LSIEmployee *e2 = [[LSIEmployee alloc] init];
    e2.name = @"Lance";
    e2.jobTitle = @"Engineer";
    e2.salary = 250000;
    
    LSIEmployee *e3 = [[LSIEmployee alloc] init];
    e3.name = @"Joe";
    e3.jobTitle = @"Marketing Designer";
    e3.salary = 100000;
    
    [engineering addEmployee:e1];
    [engineering addEmployee:e2];
    [marketing addEmployee:e3];

    LSIHRController *controller = [[LSIHRController alloc] init];
    [controller addDepartment:engineering];
    [controller addDepartment:marketing];
    self.hrController = controller;
    
    NSLog(@"%@", self.hrController);
    
    NSString *key = @"name";
    id object = craig;
    key = @"privateName";
    
    NSString *value = [object valueForKey:key];
    NSLog(@"value for key %@: %@", key, value);
    
    [object setValue:@"Hair Force One" forKey:key];
    
    value = [object valueForKey:key];
    NSLog(@"value for key %@: %@", key, value);
    
//    for (id employee in engineering.employees) {
//        NSString *value = [employee valueForKey:key];
//        NSLog(@"value for key %@: %@", key, value);
//    }
    
    key = @"jobTitle";
    object = philSchiller;
    
    value = [object valueForKey:key];
    NSLog(@"value for key %@: %@", key, value);
    
    [object setValue:@"Apple Fellow" forKey:key];
    
    value = [object valueForKey:key];
    NSLog(@"value for key %@: %@", key, value);
    
    
    object = marketing;
    NSString *keyPath = @"manager.salary";
    
    value = [object valueForKeyPath:keyPath];
    NSLog(@"value for keyPath %@: %@", keyPath, value);
    
    [object setValue:@(1) forKeyPath:keyPath];
    value = [object valueForKeyPath:keyPath];
    NSLog(@"value for keyPath %@: %@", keyPath, value);
    
    keyPath = @"hrController.departments.employees.manager";
    value = [self valueForKeyPath:keyPath];
    NSLog(@"value for keyPath %@: %@", keyPath, value);
    
    keyPath = @"hrController.departments.employees.@unionOfArrays.manager";
//    keyPath = @"hrController.departments.employees.@distinctUnionOfArrays.manager"; // Removes duplicates
    value = [self valueForKeyPath:keyPath];
    NSLog(@"value for keyPath %@: %@", keyPath, value);
    
    id allEmployees = [self valueForKeyPath:@"hrController.departments.@unionOfArrays.employees"];
    NSLog(@"All employees: %@", allEmployees);
    
    NSLog(@"Average Salary: %@", [allEmployees valueForKeyPath:@"@avg.salary"]);
    NSLog(@"Max Salary: %@", [allEmployees valueForKeyPath:@"@max.salary"]);
    NSLog(@"Min Salary: %@", [allEmployees valueForKeyPath:@"@min.salary"]);
    NSLog(@"Number of Salaries: %@", [allEmployees valueForKeyPath:@"@count.salary"]);
    
    @try {
        NSNumber *averageSalary = [self valueForKeyPath:@"hrController.departments.@unionOfArrays.employees.@avg.salary"];
        NSLog(@"Average Salary: %@", averageSalary);
    } @catch (NSException *exception) {
        NSLog(@"Got an exception! %@", exception);
    }
    
    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSSortDescriptor *salarySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"salary" ascending:YES];
    
    LSIEmployee *e4 = [[LSIEmployee alloc] init];
    e4.name = @"Craig";
    e4.jobTitle = @"Marketing Supervisor";
    e4.salary = 60000;
    [marketing addEmployee:e4];
    
    allEmployees = [self valueForKeyPath:@"hrController.departments.@unionOfArrays.employees"];
    
    NSArray *sortedEmployees = [allEmployees sortedArrayUsingDescriptors:@[nameSortDescriptor, salarySortDescriptor]];
    NSLog(@"Sorted employees! %@", sortedEmployees);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"Craig"];
    NSArray *filteredEmployees = [allEmployees filteredArrayUsingPredicate:predicate];
    NSLog(@"Filtered: %@", filteredEmployees);
}


@end
