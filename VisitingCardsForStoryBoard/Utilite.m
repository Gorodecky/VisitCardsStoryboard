//
//  Utilite.m
//  VisitingCardsForStoryBoard
//
//  Created by Serg on 31.05.16.
//  Copyright (c) 2016 Vitaliy Horodecky. All rights reserved.
//

#import "Utilite.h"

@implementation Utilite


+ (NSManagedObjectContext*) managedObjectContext {
    
    NSManagedObjectContext* context = nil;// обявляется переменная контекст
    
    id delegate = [[UIApplication sharedApplication] delegate];//получаем объект апделегата
    
    if ([delegate performSelector:@selector(managedObjectContext)]) {//если наш объект делегат может ответить на метод менеджобжект контекст возвращает да попадаем в середину
        context = [delegate managedObjectContext];// получаем менеджобжектконтекст с апделегата
    }
    
    return context;
}
@end
