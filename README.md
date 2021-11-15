# FunkyDarts api
Backend for FunkyDarts web-app

### Ideas:
mongo database will store users and game sessions
game sessions will be used for stats

GameTable:
|id|type|player-ids|finished|score-id|winner|
|-:|---:|----------|--------|-------:|------|
|1 |301 |1,2       |true    |1       |2     |
|2 |elem|1,2,3     |false   |2       |      |

ScoreTable:
|id|player-id|turn|dart1|dart2|dart3|
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
