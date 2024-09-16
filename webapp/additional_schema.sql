# Query 2: 2.70k QPS, 0.35x concurrency, ID 0x422390B42D4DD86C7539A5F45EB76A80 at byte 1565234
# Scores: V/M = 0.00
# Time range: 2024-09-16T06:06:02 to 2024-09-16T06:07:02
# Attribute    pct   total     min     max     avg     95%  stddev  median
# ============ === ======= ======= ======= ======= ======= ======= =======
# Count         45  161996
# Exec time     32     21s    37us    11ms   127us   403us   192us    76us
# Lock time     46   151ms       0     3ms       0     1us    14us     1us
# Rows sent     24 158.20k       1       1       1       1       0       1
# Rows examine   2 576.59k       0      23    3.64   13.83    5.07       0
# Query size    40  10.14M      62      66   65.62   65.89    1.51   65.89
# String:
# Databases    isuconp
# Hosts        localhost
# Users        isuconp
# Query_time distribution
#   1us
#  10us  ################################################################
# 100us  ##################
#   1ms  #
#  10ms  #
# 100ms
#    1s
#  10s+
# Tables
#    SHOW TABLE STATUS FROM `isuconp` LIKE 'comments'\G
#    SHOW CREATE TABLE `isuconp`.`comments`\G
# EXPLAIN /*!50100 PARTITIONS*/
# SELECT COUNT(*) AS `count` FROM `comments` WHERE `post_id` = 9997\G

CREATE TABLE comment_counts (
  post_id INT PRIMARY KEY,
  count INT NOT NULL
);
INSERT INTO comment_counts (post_id, count) SELECT post_id, COUNT(*) FROM comments GROUP BY post_id ON DUPLICATE KEY UPDATE count = VALUES(count);
CREATE TRIGGER comment_counts_insert AFTER INSERT ON comments
  FOR EACH ROW INSERT INTO comment_counts (post_id, count) VALUES (NEW.post_id, 1) ON DUPLICATE KEY UPDATE count = OLD.count + 1;
