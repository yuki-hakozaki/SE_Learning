
 
 SELECT name From teachers
  -- SELECT "カラム1", "カラム2", ... FROM "テーブル"; で、指定テーブルにおけるカラムデータを取得
 SELECT * from teachers
 -- カラム名を*にすることで全てのカラムを取得



 
 -- セクション1回答
 SELECT classes.class_name, teachers.name FROM classes 
 INNER JOIN teachers ON  classes.teacher_id = teachers.teacher_id;
 -- JOIN "テーブル2" ON  "テーブル1.カラム1 = "テーブル2.カラム1";　により、同一カラムを通じて別のテーブル同士を結合する。(外部キーの関係になっていないカラムを結合できるかは要質問)
 -- INNER JOIN や OUTER JOINなど複数の結合方法がある。
 -- テーブル結合により、引用元のテーブルが複数になった場合は、SELECT "テーブル1.カラム1"のように、カラムの前にテーブル名を記述すると分かりやすい(テーブル名が無くても実行はできる)。
 -- JOINを行わない(例えばSELECT classes.class_name, teachers.name FROM classes, teachersのように記述する)と、クラス名と教師名が紐づかないまま出力されてしまう。
 






 -- セクション2回答
 SELECT students.name, teachers.name, classes.class_name 
 -- teachers.name, classes.class_nameは確認のため出力。
 FROM students 
 INNER JOIN classes ON students.class_id =  classes.class_id
 INNER JOIN teachers ON teachers.teacher_id = classes.teacher_id
 -- JOINを繰り返すことで、2つ以上のテーブルを結合できる。
 WHERE teachers.name = "Andrew"
 -- WHERE構文により、SELECTで取得するデータの条件を指定できる。上記の場合、teachers.name = "Andrew"に紐づくデータのみを出力する。教師名を変えることで、出力されるデータも変わる。
 
 
 
 



 -- セクション3回答
 SELECT students.name, grades.grade_id, grades.subject, grades.score FROM grades 
 INNER JOIN students ON grades.student_id = students.student_id 
 WHERE grades.subject = "Japanese" AND score >= 70
 -- WHEREで指定する条件は、ANDにより複数指定が可能。上記の場合、科目がJapaneseでスコア70以上を指定している。






 -- セクション4回答
 SELECT teachers.name, students.name, SUM(grades.score) AS total_score
 -- SUM関数により、()内のカラムの合計値を取得することができる。またAS構文により、取得データの出力時のカラム名を再定義できる。
 FROM teachers
 INNER JOIN classes ON teachers.teacher_id = classes.teacher_id 
 INNER JOIN students ON classes.class_id = students.class_id 
 INNER JOIN grades ON students.student_id = grades.student_id 
 GROUP BY grades.student_id
 -- GROUP BY構文により、そのカラムについてグループ化し値を出力できる。今回はgrades.student_idについてグループ化したので、生徒IDごとの合計点が出力される。(グループ化しなかった場合は、全生徒の全科目の合計点が出力される)
 HAVING SUM(grades.score) = (
 -- HAVNG構文により、GROUP BYでグループ化した後のデータについて条件設定をすることが出来る。今回は、「科目の合計点が最大」を指定する。
 -- ただし、AS構文で定義したエイリアス(上でいう所のtotal_score)は、この時点でどのテーブルにもカラムとして存在しないので、条件設定の際のカラム名としては使えない。従って「HAVING total_score」と記述するとエラーになる。
 -- また、「HAVING SUM(grades.score) = SUM(MAX(grades.score))」のように、関数を重ねて記述することも出来ない。上記のように合計値の中で最大値を求める場合など、関数を重ねて使用する場合は、サブクエリを記述する。
        SELECT MAX(total_score)
 -- サブクエリ内でMAX(total_score)を取得。そのために、「FROM」以下の新たなサブクエリでテーブルを作成し、そこからMAX(total_score)を取得する。
        FROM ( SELECT teachers.name, students.name, SUM(grades.score) AS total_score
               FROM teachers
               INNER JOIN classes ON teachers.teacher_id = classes.teacher_id 
               INNER JOIN students ON classes.class_id = students.class_id 
               INNER JOIN grades ON students.student_id = grades.student_id 
               GROUP BY grades.student_id))
        






--セクション5回答
SELECT classes.class_name, classes.class_id, SUM(grades.score) AS class_total_score
FROM classes 
JOIN grades  ON students.student_id = grades.student_id
JOIN students  ON students.class_id = classes.class_id
GROUP BY students.class_id
HAVING SUM(grades.score) = (
       SELECT MAX(class_total_score)
       FROM ( SELECT students.class_id, SUM(grades.score) AS class_total_score
              FROM students 
              JOIN grades  ON students.student_id = grades.student_id
              GROUP BY students.class_id));
-- セクション4と同様に、class_idでグループ化し、クラスの合計点が最大となる条件でデータを取得する。







-- AS構文による引用名の再定義を使って、カラム指定の際の引用テーブル名を省略することもできる。
-- ASすらも省略可能(例えばFROM classes c や JOIN grades g でもOK)だが、そこまでやると逆に可読性が下がると感じるので、個人的には非推奨。
SELECT c.class_name, c.class_id, SUM(g.score) AS class_total_score
FROM classes AS c
JOIN grades AS g  ON s.student_id = g.student_id
JOIN students AS s  ON s.class_id = c.class_id
GROUP BY s.class_id
HAVING SUM(g.score) = (
       SELECT MAX(class_total_score)
       FROM ( SELECT s.class_id, SUM(g.score) AS class_total_score
              FROM students AS s
              JOIN grades AS g ON s.student_id = g.student_id
              GROUP BY s.class_id));






-- 以下は雑記


SELECT students.class_id, classes.class_name, SUM(grades.score) AS class_total_score
FROM classes 
JOIN grades  ON students.student_id = grades.student_id
JOIN students  ON students.class_id = classes.class_id
--ここまでで、grades.scoreの全合計値を出力する
GROUP BY students.class_id
--ここまでで、class_idによってグループ化するので、class_idごとの合計値を出力する
HAVING SUM(grades.score) >=1000
--ここまでで、グループの中での条件選択を行う。上記例はクラスごとの合計が1000以上の場合。



SELECT students.class_id, classes.class_name, SUM(grades.score) AS class_total_score
-- クラスID、クラス名、成績の合計値を取得(合計値は下記GROUP BYにより、カラム全体の合計ではなくクラスごとの合計になる)
FROM students 
-- studentsテーブルから取得
JOIN grades  ON students.student_id = grades.student_id
JOIN classes  ON students.class_id = classes.class_id
-- gradesテーブルとclassesテーブルをstudentsテーブルと結合
GROUP BY students.class_id
-- class.idについてグループ化
HAVING SUM(grades.score) = (
-- 抽出条件...クラスの成績の合計値が最大値の場合。ここではエイリアス(上でいう所のclass_total_score)は、その時点でどのテーブルにもカラムとして存在しないので、条件設定の際のカラム名としては使えない。
-- 従って"HAVING class_total_score"と記述するとエラーになる。
    SELECT MAX(class_total_score)
    -- 一方で、"SUM(grades.score) = SUM(MAX(grades.score))"のように記述することも出来ない。上記のように合計値の中で最大値を求める場合など、関数を重ねて使用する場合は、サブクエリを記述する。
    FROM (
    -- 合計値を記述するテーブルは存在しないので、FROM(以下の新たなサブクエリでテーブルを作成し、そこからclass_total_scoreの最大値を取得する。
        SELECT students.class_id, SUM(grades.score) AS class_total_score
        FROM students 
        JOIN grades  ON students.student_id = grades.student_id
        GROUP BY students.class_id
    ) subquery
);



--クラスの平均点が最大となるクラスを、クラス名、平均点、受け持つ先生の名前で取得
SELECT students.class_id, classes.class_name, teachers.name, AVG(grades.score) AS class_average_score
FROM students 
JOIN grades  ON students.student_id = grades.student_id
JOIN classes  ON students.class_id = classes.class_id
JOIN teachers ON classes.teacher_id = teachers.teacher_id
GROUP BY students.class_id
HAVING AVG(grades.score) = (
    SELECT MAX(class_average_score)
    FROM (
        SELECT students.class_id, AVG(grades.score) AS class_average_score
        FROM students 
        JOIN grades  ON students.student_id = grades.student_id
        GROUP BY students.class_id
    ) subquery
);



--サブクエリの学習
SELECT subject, sum(score) AS subject_total_score
FROM grades
GROUP BY subject
HAVING sum(score) = (
    SELECT max(subject_total_score) 
    FROM (SELECT sum(score) AS subject_total_score
          FROM grades 
          GROUP BY subject));



-- サブクエリでテーブルを作成することで、関数にエイリアスを使うことができる。
SELECT max(class_total_score)
FROM (
SELECT students.class_id, classes.class_name, SUM(grades.score) AS class_total_score
FROM students 
JOIN grades  ON students.student_id = grades.student_id
JOIN classes  ON students.class_id = classes.class_id
GROUP BY students.class_id)



 -- セクション4の誤回答だが、一応残しておく。
 SELECT teachers.name, students.name, grades.grade_id, grades.subject, MAX(grades.score) AS max_score 
 FROM teachers 
 INNER JOIN classes ON teachers.teacher_id = classes.teacher_id 
 INNER JOIN students ON classes.class_id = students.class_id 
 INNER JOIN grades ON students.student_id = grades.student_id 
 GROUP BY grades.subject
 -- MAX関数により、()内のカラムの最大値を取得する。
 -- AS関数により、取得したデータのカラム名を再定義する。
 -- GROUP BY関数により、指定したカラムをグループ化する。
 --もし科目を問わない点数の比較をする場合は、GROUP BYは必要ない。