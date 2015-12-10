//
//  QKGameListViewController.m
//  kaixinwa
//
//  Created by 张思源 on 15/12/10.
//  Copyright © 2015年 乾坤翰林. All rights reserved.
//

#import "QKGameListViewController.h"
#import "QKGameObject.h"
#import "QKGameCell.h"
#import "QKWebViewController.h"

@interface QKGameListViewController ()
@property(nonatomic,strong)NSMutableArray * games;

@property (nonatomic, strong) NSMutableArray *gameFrames;
@end

@implementation QKGameListViewController
-(NSMutableArray *)games
{
    if (!_games) {
        _games = [NSMutableArray array];
        QKGameObject * game1 = [[QKGameObject alloc]initWithGameImageName:@"game_1" andGameUrl:@"http://qkhl-api.com/kxw_game/games/coreball" andGameName:@"动手动脑"];
        QKGameObject * game2 = [[QKGameObject alloc]initWithGameImageName:@"game_2" andGameUrl:@"http://qkhl-api.com/kxw_game/games/zpfff" andGameName:@"字牌翻翻翻"];
        QKGameObject * game3 = [[QKGameObject alloc]initWithGameImageName:@"game_3" andGameUrl:@"http://qkhl-api.com/kxw_game/games/get36" andGameName:@"GET36"];
        QKGameObject * game4 = [[QKGameObject alloc]initWithGameImageName:@"game_4" andGameUrl:@"http://qkhl-api.com/kxw_game/games/freekick" andGameName:@"任意球大师"];
        QKGameObject * game5 = [[QKGameObject alloc]initWithGameImageName:@"game_5" andGameUrl:@"http://qkhl-api.com/kxw_game/games/zuiqiangyanli" andGameName:@"最强眼力"];
        QKGameObject * game6 = [[QKGameObject alloc]initWithGameImageName:@"game_6" andGameUrl:@"http://qkhl-api.com/kxw_game/games/duimutou" andGameName:@"堆木头"];
        NSArray * array = @[game1,game2,game3,game4,game5,game6];
        [_games addObjectsFromArray:array];
    }
    return _games;
}

-(NSMutableArray *)gameFrames
{
    if (_gameFrames == nil) {
        _gameFrames = [NSMutableArray array];
    }
    return _gameFrames;
}
- (NSArray *)gameFramesWithGames:(NSArray *)games
{
    NSMutableArray *frames = [NSMutableArray array];
    for (QKGameObject *gameObject in games) {
        QKGameFrame *frame = [[QKGameFrame alloc] init];
        frame.gameObject = gameObject;
        [frames addObject:frame];
    }
    return frames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开心益智游戏";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = QKGlobalBg;
    self.gameFrames = [self gameFramesWithGames:self.games].mutableCopy;
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginGame:) name:BeginGameNotifacation object:nil];
}

-(void)beginGame:(NSNotification*)noti
{
    QKWebViewController * webVC = [[QKWebViewController alloc]init];
    webVC.urlStr = noti.userInfo[@"urlStr"];
    
    [self.navigationController pushViewController:webVC animated:YES];
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.games.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QKGameCell * cell = [QKGameCell cellWithTableView:tableView];
    // Configure the cell...
    cell.gameFrame = self.gameFrames[indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QKGameFrame * frame = self.gameFrames[indexPath.row];
    return frame.cellHeight;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
