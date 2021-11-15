# Ideas:
mongo database will store users and game sessions
game sessions will be used for stats

dbName: funkydarts
{
    Game: [
        gameID: int,
        scoreID: int,
        gameType: string,
        winnerID: int           #if 0, game is still going
        player: [
            {
                playerID: int,
                turn: [

                ]
            }
            player2ID: int
            player3ID: int
            ... max 8 players?
        ],
    ]
}
GameTable:
|id|score-id|type|player-ids|finished|winner|
|-:|-------:|---:|----------|--------|------|
|1 |1       |301 |1,2       |true    |2     |
|2 |2       |elem|1,2,3     |false   |      |

ScoreTable:
|id|player-id|turn|darts|dart2|dart3|
|-:|--------:|:---|----:|----:|----:|
| 1|1        |1   |18   |t-20 |d-1  |
| 1|2        |1   |5    |t-19 |b    |
| 1|1        |2   |1    |d-b  |5    |
...


PlayerTable:
|id|first-name|last-name|username|password-hash|games|
|-:|----------|---------|--------|-------------|----:|
|1 |Max       |Musterman|ma.mu   |adi9ham3ef   |1    |
|2 |          |         |        |             |     |
...


dart    >   turn    >   leg     >   set
            3 darts     n turns     n legs
