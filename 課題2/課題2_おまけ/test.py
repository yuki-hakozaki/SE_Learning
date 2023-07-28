from flask import Flask, render_template, request, redirect, url_for
import sqlite3
import random

app = Flask(__name__)

conn = sqlite3.connect('data.db', check_same_thread=False)
with conn:
    cur = conn.cursor()
    cur.execute('CREATE TABLE IF NOT EXISTS Random_Number (id INTEGER PRIMARY KEY, Number INTEGER)')

@app.route('/', methods = ['POST', 'GET'])
def generate_random_number():
    if request.method == 'POST':
        number = random.randint(1, 100)
        with conn:
            cur = conn.cursor()
            cur.execute('INSERT INTO Random_Number (Number) VALUES (?)', (number,))
        return redirect(url_for('generate_random_number'))
    else:
       with conn:
            cur = conn.cursor()
            cur.execute('SELECT * FROM Random_Number')
            rows = cur.fetchall()
    return render_template('index.html', rows=rows)

@app.route('/delete/<int:id>', methods=['POST'])
def delete(id):
    with conn:
        cur = conn.cursor()
        cur.execute('DELETE FROM Random_Number WHERE id=?', (id,))
    return redirect(url_for('generate_random_number'))        

@app.route('/deleteall/', methods=['POST'])
def delete_all():
    with conn:
        cur = conn.cursor()
        cur.execute('DELETE FROM Random_Number')
        #rows = cur.fetchall()←必要かと思ったら、無くても動作した。
    return redirect(url_for('generate_random_number'))        


if __name__ == "__main__":
    app.run(debug=True)

#お試しコードだが、テーブル名のRandom_Number、カラム名のNumber、変数のnumberが混在していて初見では分かりずらい。