//
//  RSLContactViewController.m
//  FindMyFriends4IOS
//
//  Created by lizhijie on 9/4/14.
//  Copyright (c) 2014 ___resolr___. All rights reserved.
//

#import "RSLContactViewController.h"

#import "XMPPFramework.h"
#import "XMPP.h"
#import "XMPPLogging.h"
#import "RSLConstants.h"
#import "RSLAppDelegate.h"
#import "XMPPRoomMemoryStorage.h"

#import "DDLog.h"
#import "DDTTYLogger.h"

@interface RSLContactViewController (){
    RSLAppDelegate* appDelegate;
    NSArray* roomJidArray;
    NSArray* roomNameArray;
}

@end


@implementation RSLContactViewController
@synthesize tableview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Rooms";
    tableview.delegate = self;
    tableview.dataSource = self;
    
    roomJidArray = [[NSArray alloc] init];
    roomNameArray = [[NSArray alloc] init];
    
    appDelegate = (RSLAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    [appDelegate.xmppStream removeDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];


    [self requestGroupList];
}


- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//	DDLogVerbose(@"%@", [iq description]);
    if([iq.type isEqualToString:@"result"] && [iq.fromStr isEqualToString:JABBER_ROOM_IP]){
        NSArray* children = [[iq.children objectAtIndex:0] children];
        NSMutableArray* jidArray = [[NSMutableArray alloc] init];
        NSMutableArray* nameArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < children.count; i++) {
            DDXMLElement* element = [children objectAtIndex:i];
            NSString* jid = [element attributeStringValueForName:@"jid"];
            NSString* name = [element attributeStringValueForName:@"name"];
            [jidArray addObject:jid];
            [nameArray addObject:name];
        }
        roomJidArray = jidArray;
        roomNameArray = nameArray;
        [tableview reloadData];
    }

	return NO;
}

- (void)xmppRoomDidCreate:(XMPPRoom *)sender{
//    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender{
//    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//    XMPPPresence* presence = [[XMPPPresence alloc] initWithType:@"available" to:sender.roomJID];
//    [appDelegate.xmppStream sendElement:presence];
    
    appDelegate.mapController.roomJid = sender.roomJID;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return roomJidArray.count;
}

-(void)requestGroupList
{
    if (appDelegate.xmppStream.isConnected) {
        
        NSString* server = JABBER_ROOM_IP; //or whatever the server address for muc is
        XMPPJID *serverJID = [XMPPJID jidWithString:server];
        XMPPIQ *iq = [XMPPIQ iqWithType:@"get" to:serverJID];
        
        [iq addAttributeWithName:@"from" stringValue:[appDelegate.xmppStream myJID].full];
        NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
        [query addAttributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/disco#items"];
        [iq addChild:query];
        [appDelegate.xmppStream sendElement:iq];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *labelFormatString = NSLocalizedString(@"Row %i", @"master table view label format string");
	cell.textLabel.text = [roomNameArray objectAtIndex:indexPath.row];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPRoomMemoryStorage * _roomMemory = [[XMPPRoomMemoryStorage alloc]init];
    NSString* roomID = [NSString stringWithFormat:@"%@@%@",[roomNameArray objectAtIndex:indexPath.row],JABBER_ROOM_IP];
    XMPPJID * roomJID = [XMPPJID jidWithString:roomID];
    XMPPRoom* xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:_roomMemory
                                                           jid:roomJID
                                                 dispatchQueue:dispatch_get_main_queue()];
    [xmppRoom activate:appDelegate.xmppStream];
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppRoom joinRoomUsingNickname:appDelegate.xmppStream.myJID.user
                            history:nil
                           password:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onAdd:(id)sender {
}
@end
