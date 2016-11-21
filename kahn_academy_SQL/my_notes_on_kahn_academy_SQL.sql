/* Notes from khan academy SQL course...based of off SQLite */
/* This is how you write comments. */
/* The first section of this document is general notes, followed by my notes on the course */


/* Creating tables */
CREATE TABLE customers (id INTEGER PRIMARY KEY, name TEXT, age INTEGER, weight REAL);
CREATE TABLE customers (id INTEGER PRIMARY KEY, age INTEGER); Using primary keys
/* Also see: specifying defaults, using foreign keys. For more details, see the SQLite reference for CREATE. */

/* Inserting data */
INSERT INTO customers VALUES (73, "Brian", 33);
INSERT INTO customers (name, age) VALUES ("Brian", 33); /* Inserting data for named columns  */
/* For more details, see the SQLite reference for INSERT.  */

/* Querying data  */
SELECT * FROM customers; /* Select everything  */
SELECT * FROM customers WHERE age > 21; /* Filter with condition  */
SELECT * FROM customers WHERE age < 21 AND state = "NY"; /* Filter with multiple conditions  */
SELECT * FROM customers WHERE plan IN ("free", "basic"); /* Filter with IN  */
SELECT name, age FROM customers; /* Select specific columns  */
SELECT * FROM customers WHERE age > 21 ORDER BY age DESC; /* Order results  */
SELECT name, CASE WHEN age > 18 THEN "adult" ELSE "minor" END "type" FROM customers; /* Transform with CASE  */
/* Also see: filtering with LIKE, restricting with LIMIT, using ROUND and other core functions. For more details, see the SQLite reference for SELECT. */

/* Aggregating data  */
SELECT MAX(age) FROM customers; /* Aggregate functions  */
SELECT gender, COUNT(*) FROM students GROUP BY gender; /* Grouping data  */
/* Also see: restricting results with HAVING.  */

/* Joining related tables */
SELECT customers.name, orders.item FROM customers JOIN orders ON customers.id = orders.customer_id; /* Inner join  */
SELECT customers.name, orders.item FROM customers LEFT OUTER JOIN orders ON customers.id = orders.customer_id; /* Outer join  */

/* Updating and deleting data  */
UPDATE customers SET age = 33 WHERE id = 73; /* Updating data  */
DELETE FROM customers WHERE id = 73; /* Deleting data  */
/* Also see: ALTER TABLE.  */



/* Notice in the below example that you can compute an average and then call it something else
e.g. "avg_words" to access it later (this is sort of like making a new, temporary, column I think).
The below example selects authors who, on average, write books longer than 150,000 words per book.
*/
SELECT author, AVG(words) as avg_words FROM books 
GROUP BY author HAVING avg_words > 15000;
/* The HAVING clause specifies conditions that determines the groups included in the
query. If the SQL SELECT statement does not contain aggregate functions, you can use a
SQL SELECT statement that contains a HAVING clause without a GROUP BY clause. The HAVING
clause without a GROUP BY clause acts like the WHERE clause. */




/* Lets say that you have two databases; 1) "artists" with columns for id, name, country, and genre
2) "songs" with columns for id, artist, and title
*/
/* Make a 'Pop' playlist. In preparation, select the name of all of the artists from the 'Pop' genre.
(Tip: Make sure you type it 'Pop', SQL considers that different from 'pop'.) */
SELECT name from artists WHERE genre = "Pop";

/* To finish creating the 'Pop' playlist, add another query that will select 
the title of all the songs from the 'Pop' artists. It should use IN on a nested 
subquery that's based on your previous query. */
SELECT title from songs WHERE artist IN(
    SELECT name from artists WHERE genre = "Pop");
    
    
/* ----------------------------------start of full-fledged CASE example -----------------*/    
    
/* Example of making a table (exercise_logs), using autoincrement of the primary key */
CREATE TABLE exercise_logs
    (id INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT,
    minutes INTEGER, 
    calories INTEGER,
    heart_rate INTEGER);

INSERT INTO exercise_logs(type, minutes, calories, heart_rate) VALUES ("biking", 30, 100, 110);
INSERT INTO exercise_logs(type, minutes, calories, heart_rate) VALUES ("biking", 10, 30, 105);
INSERT INTO exercise_logs(type, minutes, calories, heart_rate) VALUES ("dancing", 15, 200, 120);
INSERT INTO exercise_logs(type, minutes, calories, heart_rate) VALUES ("dancing", 15, 165, 120);
INSERT INTO exercise_logs(type, minutes, calories, heart_rate) VALUES ("tree climbing", 30, 70, 90);
INSERT INTO exercise_logs(type, minutes, calories, heart_rate) VALUES ("tree climbing", 25, 72, 80);
INSERT INTO exercise_logs(type, minutes, calories, heart_rate) VALUES ("rowing", 30, 70, 90);
INSERT INTO exercise_logs(type, minutes, calories, heart_rate) VALUES ("hiking", 60, 80, 85);

SELECT * FROM exercise_logs; /* Returns the number of rows in the database exercise_logs */

SELECT COUNT(*) FROM exercise_logs WHERE heart_rate > 220 - 30; /* Returns the number of rows in the database exercise_logs where heart_rate is >190 */

/* 50-90% of max*/
SELECT COUNT(*) FROM exercise_logs WHERE
    heart_rate >= ROUND(0.50 * (220-30)) 
    AND  heart_rate <= ROUND(0.90 * (220-30));
    
/* CASE */
SELECT type, heart_rate,
    CASE 
        WHEN heart_rate > 220-30 THEN "above max"
        WHEN heart_rate > ROUND(0.90 * (220-30)) THEN "above target"
        WHEN heart_rate > ROUND(0.50 * (220-30)) THEN "within target"
        ELSE "below target"
    END as "hr_zone"
FROM exercise_logs;

/* output from about CASE
type	heart_rate	hr_zone
biking	110	within target
biking	105	within target
dancing	120	within target
dancing	120	within target
tree climbing	90	below target
tree climbing	80	below target
rowing	90	below target
hiking	85	below target
*/

SELECT COUNT(*),
    CASE 
        WHEN heart_rate > 220-30 THEN "above max"
        WHEN heart_rate > ROUND(0.90 * (220-30)) THEN "above target"
        WHEN heart_rate > ROUND(0.50 * (220-30)) THEN "within target"
        ELSE "below target"
    END as "hr_zone"
FROM exercise_logs
GROUP BY hr_zone;

/* output from about CASE
COUNT(*)	hr_zone
4	below target
4	within target
*/

/* ----------------------------------end of full-fledged CASE example -----------------*/  

/*We've created a database to track student grades, with their name, number grade, 
and what percent of activities they've completed.*/
/* In this first step, select all of the rows, and display the name, number_grade, 
and percent_completed, which you can compute by multiplying and rounding
the fraction_completed column.
*/  
SELECT name, number_grade, ROUND(100*fraction_completed) AS percent_completed FROM student_grades;

/* The goal is a table that shows how many students have earned which letter_grade.
You can output the letter_grade by using CASE with the number_grade column,
outputting 'A' for grades > 90, 'B' for grades > 80, 'C' for grades > 70, and 'F'
otherwise. Then you can use COUNT with GROUP BY to show the number of students with
each of those grades. */
SELECT count(*),
    CASE
        WHEN number_grade > 90 THEN "A"
        WHEN number_grade > 80 THEN "B"
        WHEN number_grade > 70 THEN "C"
        ELSE "F"
    END as "letter_grade"
FROM student_grades
GROUP BY letter_grade;




/* ----------------------- Relational Queries in SQL ----------------------------*/ 
/* -----------------------------------------------------------------------------*/ 
/* -----------------------------------------------------------------------------*/ 


/* There is one big thing to realize about these tables: they are describing relational data
 - as in, they are describing data that relates to each other. Each of these tables describe
  data related to a particular student, and many of the tables replicate the same data.
  When the same data is replicated across multiple tables, there can be interesting consequences.

For example, what if a student's email changed? We would need to update multiple tables

*It's often preferable to make sure that a particular column of data is only stored in a
single location*, so there are less places to update and less risk of having different data 
in different places. If we do that, we need to make sure we have a way to relate the 
data across the tables, which we'll get to later.

What if 2 students had the same name? (Did you know that in Bali, every person has only 
1 of 4 possible first names?) We can't rely on name to look up a student, and really, 
we should never rely on something like name to identify anything uniquely in a table. 

So the best thing to do is to remove the student_name and replace that with student_id (from
all but one (detailed student info) table, since that is a guaranteed unique identifier:

**Another warning sign that you can break up your table into multiple related tables
 is when you have repeated info in a table (e.g. title and author for Jabberwocky)
repeated several times. So, make a table just about books with an id column for each book.**
N
ow student_books looks like this:
student_id	book_id
1	1
1	2
2	3
2	2

I know, this table doesn't look nearly as readable as the old table that had all of 
information stuffed into every row. But, tables are often not designed to be readable 
to humans-- they're designed to be the best way to store data with the highest amount 
of maintainability and which is the least bug prone. In many cases, it may be best to 
split information into multiple related tables, so that there is less redundant data 
and less places to update.
*/

/* Joining tables: SQL CROSS JOIN will return all records where each row from the first 
table is combined with each row from the second table. Which also mean CROSS JOIN returns 
the Cartesian product of the sets of rows from the joined tables. It doesn't seem super useful */

/* implicit inner join...not the best practice */
SELECT * FROM student_grades, students
    WHERE student_grades.student_id = students.id;
    
/* explicit inner join - JOIN (note students.id grabs the id column from the students table) 
Note that this is an inner join because it only returns things that match in all tables */
SELECT students.first_name, students.email, student_grades.test, student_grades.grade
    FROM students
    JOIN student_grades
    ON students.id = student_grades.student_id;
    
/* To get just one student based on their name */
SELECT students.first_name, students.email, student_grades.test, student_grades.grade
    FROM students
    JOIN student_grades
    ON students.id = student_grades.student_id
    WHERE students.first_name = "Jim";

/* Outer join is used to show things even if they don't have a match:
Show students next to their teachers,
   even if they don't have a teacher assigned (puts NULL in that column).
   Note that the "left" table is the one after FROM (see RIGHT OUTER JOIN and FULL OUTER JOIN)*/ 
SELECT students.name, teachers.name AS teacher_name
    FROM students
    LEFT OUTER JOIN teachers
    ON students.teacher_id = teachers.id;
/* Note that if you get an ambiguous column name make sure that your LEFT OUT JOIN is on the right database */

/* Now, create another query that will result in one row per each customer, with their 
name, email, and total amount of money they've spent on orders. Sort the rows according 
to the total money spent, from the most spent to the least spent.
(Tip: You should always GROUP BY on the column that is most likely to be unique in a row.) */
SELECT customers.name, customers.email, SUM(orders.price) AS total_spent 
FROM customers 
LEFT OUTER JOIN orders 
ON customers.id = orders.customer_id
GROUP BY customers.name
ORDER BY total_spent DESC;

/* self join */
/* Lets say that we have one database with the following columns:
    id, first_name, last_name, email, phone, birthday, buddy_id
    and we want to print out the student's name and then their buddies e-mail address.
    To do this, we need to join the table to itself. in the below code, note that
    the word buddies in the line "JOIN students buddies" is creating an alias of students
    so that we can join the table on itself!
*/
SELECT students.first_name, students.last_name, buddies.email as buddy_email
    FROM students
    JOIN students buddies
    ON students.buddy_id = buddies.id;

/* Another self join example:
We've created a table with all the 'Harry Potter' movies, with a sequel_id column that 
matches the id of the sequel for each movie. Issue a SELECT that will show the title of 
each movie next to its sequel's title (or NULL if it doesn't have a sequel).
Column names are id, title, released, sequel_id */
SELECT movies.title, sequel.title AS sequel_title FROM movies 
LEFT OUTER JOIN movies sequel ON movies.sequel_id = sequel.id;




/* We've created a database for a friend networking site, with a table storing data 
on each person ("persons"), a table on each person's hobbies ("hobbies"), and a table of friend connections 
between the people ("friends").*/

/*
persons 5 rows
id (PK) INTEGER
fullname TEXT
age INTEGER

hobbies 10 rows
id (PK) INTEGER
person_id INTEGER
name TEXT

friends 2 rows
id (PK) INTEGER
person1_id INTEGER
person2_id INTEGER
*/

/* In this first step, use a JOIN to display a table showing people's 
names with their hobbies. */

SELECT persons.fullname, hobbies.name FROM
    persons JOIN hobbies ON hobbies.person_id = persons.id;

/* Now, use another SELECT with a JOIN to show the names of each pair of friends, 
based on the data in the friends table...JMS: I think that this is like a self join from I
make an alias of persons called "p" */
SELECT persons.fullname, p.fullname FROM friends JOIN persons 
    ON friends.person1_id = persons.id JOIN persons p ON friends.person2_id = p.id;

/* SQL automatically compares different ways to perform your query and picks one...sometimes you want to change it
 Once you start dealing with bigger data sets, you'll start to care more about the speed of your queries, 
 and you might find yourself wondering if there's any way you can improve the performance of your queries.
Many times, especially for complex queries, there are indeed ways you can help optimize a query, 
and that's known as "query tuning".
In SQLlite, you can stick EXPLAIN QUERY PLAN in front of any SQL to see what it's doing behind the scenes.
 If we knew ahead of time that we would want to do hundreds of queries that restricted WHERE on the author 
 column, then we could explicitly create the index, using CREATE INDEX. Then the SQL engine would be able 
 to use that index to efficiently find the matching rows. You can read this guide about SQLite query planning 
 to help you understand when indexes would help.

Creating indexes can often make repeated queries more efficient. But there are many other approaches as well. 
For SQLite, you can get more insight in their query planner overview and take careful note of the "manual" sections.


(Here are some deep dives into different SQL query planners that I found interesting: 
SQL Server Query Optimizer, Oracle SQL Tuning, MSSQL Execution Plan Basics)*/

/* An example of a "read-only operation" is a data analysis on a data dump from some app or 
research study. For example, if I was a data scientist working for a daily diary, I might 
query what percentage of users eat ice cream on the same day that they run, to understand 
if exercise makes people want to reward themselves: */

SELECT * FROM diary_logs WHERE
       food LIKE "%ice cream%" AND activity LIKE "%running%";

/* An example of "read/write operations" is a software engineer creating the backend for a 
webapp. For example, if I was the software engineer working on the health tracker, I might 
write code that knows how to insert a new daily log in the database every time a user submits a form:*/

INSERT INTO diary_logs (id, food, activity)
            VALUES (123, "ice cream", "running");
/* I would probably be issuing that SQL command from inside a server-side language, likely 
using a library to make it easier to construct the commands. This is what that insertion 
would look like if I was using Python with the SQLAlchemy library: */

diary_logs.insert().values(id=123, food="ice cream", activity='running')








/* How to change the content of a cell (in this case the column is called "content") and you have to indicate the row */
UPDATE diary_logs SET content = "I had a horrible fight with OhNoesGuy" WHERE user_id=1 AND date = "2015-04-01";
/* But using the id is safer if you know it */
UPDATE diary_logs SET content = "I had a horrible fight with OhNoesGuy" WHERE user_id=1;
/* To delete a row */
DELETE FROM diary_logs WHERE id = 1;
/* To add a new column...note that default = "unknown" sets a default value */
ALTER TABLE diary_logs ADD emotion TEXT default = "unknown";
/* To delete a whole table use: DROP TABLE table_name */







/* MAKING YOUR SQL SAFER:....PARTICULARLY "LIMIT", "BEGIN TRANSACTION" and "COMMIT"
Avoiding bad updates/deletes

Before you issue an UPDATE, run a SELECT with the same WHERE to make sure you're updating the right column and row.

For example, before running:

UPDATE users SET deleted = true WHERE id = 1;
You could run:

SELECT id, deleted FROM users WHERE id = 1;
Once you decide to run the update, you can use the LIMIT operator to make sure you don't accidentally update too many rows:

UPDATE users SET deleted = true WHERE id = 1 LIMIT 1;
Or if you were deleting:

DELETE users WHERE id = 1 LIMIT 1;
Using transactions

When we issue a SQL command that changes our database in some way, it starts what is called a "transaction." A transaction is a sequence of operations treated as a single logical piece of work (like a bank transaction), and in the world of databases, a transaction must comply to the "ACID" principles to make sure they are processed reliably. 

Whenever we issue a command like CREATE, UPDATE, INSERT, or DELETE, we are automatically starting a transaction. However, if we want, we can also wrap up multiple commands inside a bigger transaction. It may be that we only want an UPDATE to go through if another UPDATE goes through as well, so we want to put both of them in the same transaction.

In that case, we can wrap the commands in BEGIN TRANSACTION and COMMIT:

BEGIN TRANSACTION;
UPDATE people SET husband = "Winston" WHERE user_id = 1;
UPDATE people SET wife = "Winnefer" WHERE user_id = 2;
COMMIT;
If the database is unable to issue both those UPDATE commands for some reason, then it will rollback the transaction and leave the database how it was when it started.

We also use transactions when we want to make sure that all of our commands operate on the same view of the data - when we want to ensure that no other transactions operate on that same data while the sequence of commands is running. When you're looking at a sequence of commands you want to run, ask yourself what would happen if another user issued commands at the same time. Could your data end up in a weird state? In that case, you should run in a transaction.

For example, the following commands create a row denoting that a user earned a badge, and then update the user's recent activity to describe that:

INSERT INTO user_badges VALUES (1, "SQL Master", "4pm");
UPDATE user SET recent_activity = "Earned SQL Master badge" WHERE id = 1;
At the same time, another user or process might be awarding the user a second badge:

INSERT INTO user_badges VALUES (1, "Great Listener", "4:05pm");
UPDATE user SET recent_activity = "Earned Great Listener badge" WHERE id = 1;
These commands could now actually be issued in this order:

INSERT INTO user_badges VALUES (1, "SQL Master");
INSERT INTO user_badges VALUES (1, "Great Listener");
UPDATE user SET recent_activity = "Earned Great Listener badge" WHERE id = 1;
UPDATE user SET recent_activity = "Earned SQL Master badge" WHERE id = 1;
Their recent activity would now be "Earned SQL Master badge" even though the most recently inserted badge was "Great listener". That's not the end of the world, but it's also probably not what we expected.

Instead, we could run those in a transaction, to guarantee that no other transactions happen in the middle:

BEGIN TRANSACTION;
INSERT INTO user_badges VALUES (1, "SQL Master");
UPDATE user SET recent_activity = "Earned SQL Master badge" WHERE id = 1;
COMMIT;
Making backups

You should definitely follow all those tips, but sometimes mistakes still happen. Because of that, most companies make backups of their databases - on an hourly, daily, or weekly basis, depending on the size of the database and space available. When something bad happens, they can then import data from the old database for whichever tables were damaged or lost. The data may end up a little outdated, but outdated data is often better than no data at all.

Replication

A related approach is replication - always storing multiple copies of the databases in different places. If for some reason a particular copy of the database is unavailable (like lightning hit the building that it's in, which has actually happened to me!), then the query can be sent to another copy of the database which is hopefully still available. If the data is very important, then it should probably be replicated to ensure availability. For example, if a doctor is trying to pull up a list of a patient's allergies to determine how to treat them in an emergency situation, then they can't afford to wait for engineers to get the data out of a backup, they need it immediately. 

However, it is a lot more effort to replicate databases and it often means slower performance since write operations have to be performed in all of them, so companies must decide whether the benefits of replication are worth the costs, and investigate the best way of setting it up for their environment.

Granting privileges

Many database systems have users and privileges built into them, because they are stored on a server and accessed by multiple users. There is no concept of user/privilege in the SQL scripts on Khan Academy, because SQLite is typically used in a single-user scenario, and thus you can write to it as long as you have access to the drive it's stored on.

But if you are using a database system on a shared server one day, then you should make sure to set up users and privileges properly from the beginning. As a general rule, there should be only a few users that have full access to the database (like backend engineers), since it can be so dangerous.

For example, here's how we can give full access to a particular user:

GRANT FULL ON TABLE users TO super_admin;
And here's how we can give only SELECT access to a different user:

GRANT SELECT ON TABLE users TO analyzing_user;
In a big company, you often don't even want to give SELECT access to most users, because there might be private data in a table, like a user's email address or name. Many companies have anonymized version of their databases that they can query on without worrying about access to private information.
*/







