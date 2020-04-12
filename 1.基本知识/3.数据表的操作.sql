# 查看数据表
    show tables ;

# 查询一张表所有的字段名称
    select COLUMN_NAME, column_comment from INFORMATION_SCHEMA.Columns where table_name='你的表名';

# 创建数据表
    create table table_test(
        id int unsigned unique primary key not null auto_increment,
        name varchar(30) not null,
        age tinyint unsigned,
        high decimal(5,2),
        gender enum("男","女","中性","保密") default "保密",
        cls_id int unsigned
    );

# 查看数据表的结构
    desc table_test;

# 数据表中插入数据
    insert into python_test values (0, "老王", 23, 187, "男", 2);
    insert into python_test values (default, "老王", 23, 187, "男", 2);
    insert into python_test values (null, "老王", 23, 187, "男", 2);

# 修改表结构
    # 添加字段
    alter table studuent add brithday datetime;

    # 修改字段-不重命名版
    alter table studuent modify brithday date;

    # 修改字段-重命名版
    alter table studuent change brithday brith date default "2000-01-01";

    # 删除字段
    alter table studuent drop brith; #一般不会删除数据,多做加法,少做减法

    # 删除表
    drop table studuent;

# 查看表的创建语句
    show create table studuent;



