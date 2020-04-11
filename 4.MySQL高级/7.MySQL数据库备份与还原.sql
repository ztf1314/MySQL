-- 备份对于数据库而言是至关重要的。当数据文件发生损坏、MySQL服务出现错误、系统内核崩溃、计算机硬件损坏或者数据被误删等事件时，使用一种有效的数据备份方案，就可以快速解决以上所有的问题。MySQL提供了多种备份方案，包括：逻辑备份、物理备份、全备份以及增量备份，你可以选择最适合自己使用的方式备份数据。
-- -- 物理备份通过直接复制包含有数据库内容的目录与文件实现，这种备份方式适用于对重要的大规模数据进行备份，并且要求实现快速还原的生产环境。典型的物理备份就是复制 MySQL数据库的部分或全部目录，物理备份还可以备份相关的配置文件。但采用物理备份需要MySQL处于关闭状态或者对数据库进行锁操作，防止在备份的过程中改变发送数据。物理备份可以使用mysqlbackup对InnoDB数据进行备份，使用mysqlhotcopy对MyISAM数据进行备份。另外，也可以使用文件系统级别的cp、scp、tar、rsync等命令。
-- -- 逻辑备份通过保存代表数据库结构及数据内容的描述信息实现，如，保存创建数据结构以及添加数据内容的SQL语句，这种备份方式适用于少量数据的备份与还原。逻辑备份需要查询MySQL服务器获得数据结构及内容信息，因为需要查询数据库信息并将这些信息转换为逻辑格式，所以相对于物理备份而言比较慢。逻辑备份不会备份日志、配置文件等不属于数据库内容的资料。逻辑备份的优势在于不管是服务层面、数据库层面还是数据表层面的备份都可以实现，由于是以逻辑格式存储的，所以这种备份与系统、硬件无关。
-- -- 全备份将备份某一时刻所有的数据，增量备份仅备份某一段时间内发生过改变的数据。通过物理或逻辑备份工具就可以完成完全备份，而增量备份需要开启MySQL二进制日志，通过日志记录数据的改变，从而实现增量差异备份。
-- -- 下面将通过一些案例介绍如何使用MySQL提供的工具命令进行逻辑备份。使用 mysqldump 备份数据库，默认该工具会将SQL语句信息导出至标准输出，可以通过重定向将输出保存至文件：
-- （1）备份所有的数据库

    mysqldump -u root -p --all-databases > bak.sql

-- （2）备份指定的数据库db1、db2以及db3

    mysqldump -u root -p --databases db1 db2 db3 > bak.sql

-- （3）备份db数据库，当仅备份一个数据库时，--databases可以省略

    mysqldump -u root -p db4 > bak.sql

    mysqldump -u root -p --databases db4 > bak.sql

-- 两者之间的差别在于不使用 --databases 选项，则备份输出信息中不会包含CREATE DATABASE或USE语句。不使用 --databases 选项备份的数据文件，在后期进行数据还原操作时，如果该数据库不存在，必须先创建该数据库。

-- 使用mysql命令读取备份文件，实现数据还原功能：

    mysql -u root -p < bak.sql

    mysql -u root -p db4 < bak.sq1

-- 案例：下面将 testDB 数据库中的内容导出成一个文件，并保存到 /home/目录下
    [root@192 home]# mysqldump -u root -p testDB > /home/bak.sql
    Enter password:

-- 然后进入MySQL数据库，彻底删除 testDB 数据库，然后重新创建 testDB 数据库

    mysql> select * from testDB.mybook;
    +--------+-------+-------+
    | name   | price | pages |
    +--------+-------+-------+
    | Linux2 |    40 |   200 |
    | Linux4 |    60 |   400 |
    +--------+-------+-------+
    rows in set (0.00 sec)

    mysql> drop database testDB;
    Query OK, 1 row affected (0.00 sec)

    mysql> show databases;
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | mysql              |
    | performance_schema |
    | sys                |
    +--------------------+
    rows in set (0.00 sec)

-- 创建数据库
    mysql> create database testDB;
    Query OK, 1 row affected (0.00 sec)

    mysql> exit
    Bye

-- 将备份的数据导入到刚新建的 testDB 数据库中

    [root@192 home]# mysql -u root -p testDB < /home/bak.sql
    Enter password:

-- 查看数据是否恢复成功
    [root@192 home]# mysql -u root -p
    Enter password:

    mysql> select * from testDB.mybook;
    +--------+-------+-------+
    | name   | price | pages |
    +--------+-------+-------+
    | Linux2 |    40 |   200 |
    | Linux4 |    60 |   400 |
    +--------+-------+-------+
    rows in set (0.00 sec)