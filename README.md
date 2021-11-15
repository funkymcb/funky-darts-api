# FunkyDarts api
Backend for FunkyDarts web-app

### Ideas:
mongo database will store users and game sessions
game sessions will be used for stats

GameTable:
|id|type|player-ids|finished|score-id|
|-:|---:|----------|--------|-------:|
|1 |301 |1,2,3,4   |false   |1       |

PlayerTable:
|id|first-name|last-name|username|password|games|
|-:|----------|---------|--------|--------|-----|
|1 |Max       |Musterman|ma.mu   |hello   |1    |
|2 |          |         |        |        |     |
...
