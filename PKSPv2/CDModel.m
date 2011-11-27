//
//  CDModel.m
//  Fiszki
//
//  Created by Maciej Krok on 11-07-07.
//  Copyright 2011 Freelance. All rights reserved.
//

#import "CDModel.h"
#import "NSFileManager+DirectoryLocations.h"


@interface CDModel ()


@end


@implementation CDModel
@synthesize managedObjectContext=_managedObjectContext;
@synthesize managedObjectModel=_managedObjectModel;
@synthesize persistentStoreCoordinator=_persistentStoreCoordinator;
@synthesize wordsInCategories;

- (id)init {
    self = [super init];
    if (self) {
        DLog(@"CD init");
        [self managedObjectContext];
    }
    
    return self;
}

+ (id)sharedModel {
    static dispatch_once_t pred;
    static CDModel *cDModel = nil;
    
    dispatch_once(&pred, ^{ 
        cDModel = [[self alloc] init]; 
    });
    return cDModel;
}

- (void)saveContext {
    NSError *error = nil;
    if (_managedObjectContext != nil)
    {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}


- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil] ;
    return self.managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
//    DLog(@"%@",[[NSFileManager defaultManager] applicationSupportDirectory]);
    

    NSURL *libraryPath = [NSURL fileURLWithPath:[[NSFileManager defaultManager] applicationSupportDirectory]];
    
    NSURL *storeURL = [libraryPath URLByAppendingPathComponent:@"PKSPv2.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



- (void) saveCD{ 
    
    NSError *error;
    if(![[self managedObjectContext] save:&error]){  
        
        //This is a serious error saying the record  
        //could not be saved. Advise the user to  
        //try again or restart the application.   
        exit(-1);
        
    }  
    
    
}



-(NSInteger) nextNumber{
    NSInteger index = 0;
    NSArray* allNodesInCD = [self allNodes];
    
    for (int a = 0; a < [allNodesInCD count]; ++a) {
        if([[[allNodesInCD objectAtIndex:a] valueForKey:@"number"] intValue] > index){
            index = [[[allNodesInCD objectAtIndex:a] valueForKey:@"number"] intValue];
        }
    }
    
    ++index;
//    DLog(@"new index %i\n",index);
    return index;
    
    
}

-(Nodes*)addNewNode{
    Nodes* nod = (Nodes*)[NSEntityDescription insertNewObjectForEntityForName:@"Nodes" inManagedObjectContext:[self managedObjectContext]];  
    nod.number = [NSNumber numberWithInteger:[self nextNumber]];
    //    DLog(@"ok");
    return nod;
    
}

-(NSArray*) allNodes{
    NSManagedObjectContext *myManagedObjectContext = [[CDModel sharedModel] managedObjectContext];
    
    NSEntityDescription *nodes = [NSEntityDescription entityForName:@"Nodes" inManagedObjectContext:myManagedObjectContext];
    NSFetchRequest *requestToNodes = [[NSFetchRequest alloc] init]; 
    [requestToNodes setEntity:nodes]; 
    
    
    NSError *error = nil;  
    NSMutableArray* output = [[myManagedObjectContext executeFetchRequest:requestToNodes error:&error] mutableCopy]; 
    
    
    if(error == nil){
        return output;
    }
    
    return nil;    
    
    
}

-(void) removeNodeByNumber:(NSInteger)number{
    NSManagedObjectContext *myManagedObjectContext = [[CDModel sharedModel] managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Nodes" inManagedObjectContext:myManagedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init]; 
    [request setEntity:entity]; 
    NSPredicate *myNodeQuestion = [NSPredicate predicateWithFormat:@"number = %i", number];
    [request setPredicate:myNodeQuestion];
    NSError *error = nil;  
    NSMutableArray *mutableFetchResults = [[myManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if ([mutableFetchResults count] > 0) {
//        Nodes* del = (Nodes*) [mutableFetchResults objectAtIndex:0];
        for (Nodes* del in mutableFetchResults) {
            
            //        [self removeElementWithNodeWithNumber:number];
            
            [myManagedObjectContext deleteObject:del];
            [myManagedObjectContext save:&error];
            if (error != nil) {
                //TODO: error hendeling
                DLog(@"error %@\n", error);
            }
            DLog(@"usunieto %i\n",number);
        }
    }
    
}



-(NSArray*) allElements{
    NSManagedObjectContext *myManagedObjectContext = [[CDModel sharedModel] managedObjectContext];
    
    NSEntityDescription *nodes = [NSEntityDescription entityForName:@"Elements" inManagedObjectContext:myManagedObjectContext];
    NSFetchRequest *requestToNodes = [[NSFetchRequest alloc] init]; 
    [requestToNodes setEntity:nodes]; 
    
    
    NSError *error = nil;  
    NSMutableArray* output = [[myManagedObjectContext executeFetchRequest:requestToNodes error:&error] mutableCopy]; 
    
    
    if(error == nil){
        return output;
    }
    
    return nil;    
}

-(Elements*) makeElementFromNode1:(Nodes *)nn1 
                            Node2:(Nodes *)nn2 
                            Node3:(Nodes *)nn3{
    
    Elements* elem = (Elements*)[NSEntityDescription insertNewObjectForEntityForName:@"Elements" inManagedObjectContext:[self managedObjectContext]];
  
    [elem addNodesObject:nn1];
    [elem addNodesObject:nn2];
    [elem addNodesObject:nn3];
    elem.n1 = nn1;
    elem.n2 = nn2;
    elem.n3 = nn3;
    
    
//    DLog(@"ok");
    return elem;
    
}

-(Nodes*) getNodeWithNumber:(NSInteger)number{
    NSManagedObjectContext *myManagedObjectContext = [[CDModel sharedModel] managedObjectContext];
    
    NSEntityDescription *nodes = [NSEntityDescription entityForName:@"Nodes" inManagedObjectContext:myManagedObjectContext];
    NSFetchRequest *requestToNodes = [[NSFetchRequest alloc] init]; 
    [requestToNodes setEntity:nodes]; 
    NSPredicate *myNodeQuestion = [NSPredicate predicateWithFormat:@"number = %i", number];
    [requestToNodes setPredicate:myNodeQuestion];
    
    
    NSError *error = nil;  
    NSMutableArray* output = [[myManagedObjectContext executeFetchRequest:requestToNodes error:&error] mutableCopy]; 
    
    
    if(error == nil){
        return [output objectAtIndex:0];
    }
    
    return nil;    

}
@end
