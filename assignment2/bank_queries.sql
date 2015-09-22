--Assignment 2:

--1
--Find all names and cities of borrowers
select distinct c.customer_name, c.customer_city
    from customer as c,borrower as b
    where b.customer_name = c.customer_name;
    --RESULT:
    -- +---------------+---------------+
    -- | customer_name | customer_city |
    -- +---------------+---------------+
    -- | Adams         | Pittsfield    |
    -- | Curry         | Rye           |
    -- | Hayes         | Harrison      |
    -- | Jackson       | Salt Lake     |
    -- | Jones         | Harrison      |
    -- | McBride       | Rye           |
    -- | Smith         | Rye           |
    -- | Williams      | Princeton     |
    -- +---------------+---------------+
    -- 8 rows in set (0.00 sec)

--2
--Find names and cities of customers w/ loans at PerryRidge
select distinct c.customer_name, c.customer_city
  from customer as c, loan as l, borrower as b
  where b.customer_name = c.customer_name and l.loan_number = b.loan_number
   and l.branch_name = 'Perryridge';
  -- RESULT
  --  +---------------+---------------+
  --  | customer_name | customer_city |
  --  +---------------+---------------+
  --  | Adams         | Pittsfield    |
  --  | Hayes         | Harrison      |
  --  +---------------+---------------+
  --  2 rows in set (0.00 sec)

--3
--Find the numbers of accounts w/ 700 <= balance <= 900
select distinct a.account_number
  from account as a
  where a.balance >= 700.00 and a.balance <= 900.00;
  --RESULT
  --   +----------------+
  -- | account_number |
  -- +----------------+
  -- | A-201          |
  -- | A-215          |
  -- | A-217          |
  -- | A-222          |
  -- | A-333          |
  -- +----------------+
  -- 5 rows in set (0.00 sec)

--4
--Find names of customers on streets with names ending in "Hill"
select distinct c.customer_name
  from customer as c
  where c.customer_street regexp '[hH]ill$';
  --RESULT
  --   +---------------+
  -- | customer_name |
  -- +---------------+
  -- | Glenn         |
  -- +---------------+
  -- 1 row in set (0.00 sec)

--5
--Find names of customers with accounts and loans at Perryridge
select b.customer_name
    from borrower as b
        join depositor as d on b.customer_name = d.customer_name
        join account as a on a.account_number = d.account_number
        join loan as l on l.loan_number = b.loan_number
    where l.branch_name = 'Perryridge' and a.branch_name = 'Perryridge';
    --RESULT
    -- +---------------+
    -- | customer_name |
    -- +---------------+
    -- | Hayes         |
    -- +--- ------------+
    -- 1 row in set (0.00 sec)

--6
--Find names of customers with accounts and no loans at Perryridge
select d.customer_name
    from depositor as d
        join account as a on d.account_number = a.account_number
        left join borrower as b on b.customer_name = d.customer_name
        left join loan as l on l.loan_number = b.loan_number
    where a.branch_name = 'Perryridge' and
        (l.branch_name != 'Perryridge' or l.branch_name is null);
    --RESULT
    -- +---------------+
    -- | customer_name |
    -- +---------------+
    -- | Johnson       |
    -- +---------------+
    -- 1 row in set (0.00 sec)

--7
--Find names of customers with accounts at branch with Hayes
select distinct d.customer_name
    from depositor as d
        join account as a on a.account_number = d.account_number
    where a.branch_name in (
            select a.branch_name
                from depositor as d
                  join account as a on a.account_number = d.account_number
                where d.customer_name = 'Hayes'
    ) and d.customer_name != 'Hayes';
    --RESULT
    -- +---------------+
    -- | customer_name |
    -- +---------------+
    -- | Johnson       |
    -- +---------------+
    -- 1 row in set (0.00 sec)

--8
--Find branch names whose assests are larger and Brooklyn assests (Take average)
select br.branch_name
    from branch as br
    where br.branch_city != 'Brooklyn' and
      br.assets >= (
        select (MIN(br.assets) + MAX(br.assets) / count(br.assets))
        from branch as br
        where br.branch_city = 'Brooklyn'
      );
      --RESULT
      -- +-------------+
      -- | branch_name |
      -- +-------------+
      -- | Round Hill  |
      -- +-------------+
      -- 1 row in set (0.00 sec)

--9
--Find names of customers with accounts and loans at Perryridge
select b.customer_name
  from borrower as b
      join depositor as d on b.customer_name = d.customer_name
      left join account as a on a.account_number = d.account_number
      left join loan as l on l.loan_number = b.loan_number
  where l.branch_name = 'Perryridge' and a.branch_name = 'Perryridge';
  --RESULT
  -- +---------------+
  -- | customer_name |
  -- +---------------+
  -- | Hayes         |
  -- +--- ------------+
  -- 1 row in set (0.00 sec)

--10
--Find names of customers at Perryridge in alpabetical order
select d.customer_name
    from depositor as d
        join account as a on a.account_number = d.account_number
        left join borrower as b on b.customer_name = d.customer_name
        left join loan as l on l.loan_number = b.loan_number
    where a.branch_name = 'Perryridge'
    order by d.customer_name;
    --RESULT
    -- +---------------+
    -- | customer_name |
    -- +---------------+
    -- | Hayes         |
    -- | Johnson       |
    -- +---------------+
    -- 2 rows in set (0.00 sec)

--11
--Find loan data, ordered by decreasing amounts, then increasing loan numbers
select * from loan order by amount desc, loan_number;
  --RESULT
  -- +-------------+-------------+--------+
  -- | loan_number | branch_name | amount |
  -- +-------------+-------------+--------+
  -- | L-20        | North Town  |   7500 |
  -- | L-23        | Redwood     |   2000 |
  -- | L-14        | Downtown    |   1500 |
  -- | L-15        | Perryridge  |   1500 |
  -- | L-16        | Perryridge  |   1300 |
  -- | L-17        | Downtown    |   1000 |
  -- | L-11        | Round Hill  |    900 |
  -- | L-21        | Central     |    570 |
  -- | L-93        | Mianus      |    500 |
  -- +-------------+-------------+--------+
  -- 9 rows in set (0.00 sec)

--12
--Find ave balance of all accounts
select ROUND( AVG(balance), 2 ) as average_balance from account;
  --RESULT
  -- +-----------------+
  -- | average_balance |
  -- +-----------------+
  -- |          641.67 |
  -- +-----------------+
  -- 1 row in set (0.00 sec)

--13
--Find branch names w/ >=1 account w/ ave balances being > 700
select * from (
        select avg(balance) as ave, branch_name from account as a
        group by a.branch_name
    ) as br
  where br.ave > 700;
  --RESULT
  -- +------+-------------+
  -- | ave  | branch_name |
  -- +------+-------------+
  -- |  750 | Brighton    |
  -- |  850 | Central     |
  -- +------+-------------+
  -- 4 rows in set (0.00 sec)

--14
--Find the branch name(s) with the largest ave balance
select branch_name
  from (
    select avg(balance) as ave, branch_name
    from account as a
    group by a.branch_name
    order by ave desc
  ) as branch_aves
  LIMIT 1;
  --RESULT
  -- +-------------+
  -- | branch_name |
  -- +-------------+
  -- | Central     |
  -- +-------------+
  -- 1 row in set (0.00 sec)

--15
--Find ave balances of customers in Harrison w/ >=2 accounts
select AVG(a.balance) from account as a
    join depositor as d on a.account_number = d.account_number
    where d.customer_name in (
        select c.customer_name
        from customer as c join(
                    select count(a.account_number) as accounts, avg(a.balance) as avebalance, d.customer_name
                        from account as a
                        join depositor as d on d.account_number = a.account_number
                    ) as cust
        on c.customer_name = cust.customer_name
        where cust.accounts >= 2 and c.customer_city = 'Harrison'
    );
    --RESULT
    -- +----------------------+
    -- | AVG(account.balance) |
    -- +----------------------+
    -- |                  450 |
    -- +----------------------+
    -- 1 row in set (0.00 sec)
