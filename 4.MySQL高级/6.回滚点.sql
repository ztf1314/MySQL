-- 回滚点操作
-- 开启事务
start transaction ;

-- 事务处理1:张三加钱
update my_account set money = money + 1000 where id=1;

-- 设置回滚点
savepoint sp1;

-- 银行扣税
update my_account set money = money-10000*0.05 where id=1;

-- 回滚到回滚点
rollback to sp1;

-- 查看结果
select * from my_account;

-- 提交结果
commit ;

--设置回滚点语法: savepoint 回滚点名字;
--回到回滚点语法: rollbackto 回滚点名字
