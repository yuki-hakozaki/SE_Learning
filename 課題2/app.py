from flask import Flask, render_template, request, redirect, url_for
import sqlite3

app = Flask(__name__)

# データベースに接続
conn = sqlite3.connect('data.db', check_same_thread=False)

# テーブルの作成
with conn:
    cur = conn.cursor()
    cur.execute('CREATE TABLE IF NOT EXISTS todos (id INTEGER PRIMARY KEY, task TEXT, completed INTEGER DEFAULT 0)')
    #executeの中身はSQLiteのSQL文

@app.route('/', methods=['GET', 'POST'])
#app に対して / というURLに対応するアクションを登録する。methodは取り得るHTTPのリクエストで、htmlに対応する記述がある。
def index():
    if request.method == 'POST':
        # フォームから送信されたタスクをデータベースに追加
        task = request.form['task']
        with conn:
            cur = conn.cursor()
            cur.execute('INSERT INTO todos (task) VALUES (?)', (task,))
        return redirect(url_for('index'))

    else:
        # データベースから全てのタスクを取得
        with conn:
            cur = conn.cursor()
            cur.execute('SELECT * FROM todos')
            rows = cur.fetchall()
        return render_template('index.html', rows=rows)

@app.route('/complete/<int:id>', methods=['POST'])
def complete(id):
    # タスクの完了状態を反転
    completed = int(request.form.get('completed', 0))
    with conn:
        cur = conn.cursor()
        cur.execute('UPDATE todos SET completed=? WHERE id=?', (1 - completed, id))
    return redirect(url_for('index'))

@app.route('/edit/<int:id>', methods=['GET', 'POST'])
def edit(id):
    if request.method == 'POST':
        # タスクを更新
        task = request.form['task']
        with conn:
            cur = conn.cursor()
            cur.execute('UPDATE todos SET task=? WHERE id=?', (task, id))
        return redirect(url_for('index'))

    else:
        # 編集するタスクを取得
        with conn:
            cur = conn.cursor()
            cur.execute('SELECT * FROM todos WHERE id=?', (id,))
            row = cur.fetchone()
        return render_template('edit.html', id=id, task=row[1])

@app.route('/delete/<int:id>', methods=['POST'])
def delete(id):
    # タスクを削除
    with conn:
        cur = conn.cursor()
        cur.execute('DELETE FROM todos WHERE id=?', (id,))
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True)
