
const express = require('express');
const app = express();

// 静的ファイルの提供設定
app.use(express.static('public'));


// ルートディレクトリへのGETリクエストに対する処理
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html');
  });
  //__dirnameは現在のプロジェクトファイルを示す。ここではindex.htmlを読み込む。


// APIのルートエンドポイント
app.get('/random', (req, res) => {
  const randomNumber = Math.floor(Math.random() * 10000) + 1;
  // リクエストを受けた場合、1~10000の間で乱数を生成する。
  const responseData = {
    randomNumber: randomNumber
  };
  res.json(responseData);
  // 乱数をjson形式で渡す
});


// サーバーを起動する
app.listen(3000, () => {
  console.log('Server is running on port 3000');
});