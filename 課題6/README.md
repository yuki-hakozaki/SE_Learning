React
- 課題5で作成したアプリ。Githubにアップし、EC2にデプロイする実際のアプリのソース。frontディレクトリに「frontstart.js」を追加した。これはビルドしたフロントを起動するための実行ファイル。また、Recatディレクトリに「ecosystem.config.js」を追加した。これはpm2でフロント、サーバーを同時に起動するための実行ファイル。front、backともにnode_modulesは無いので、起動時にyarn installをする必要がある。

ecosystem.config.js
- ローカルのマシンから、「Github→インスタンスへのデプロイ」を指示するファイル。React直下にあるファイルとは別の機能を有する。
- 1回目は「pm2 deploy ecosystem.config.js production setup」を実行する。するとディレクトリの整備とソースコードのコピーを行う。
- 2回目は「pm2 deploy ecosystem.config.js production　-force」を実行する。これにより、post-deploy内のコマンドが実行され、依存関係のインストールやpm2によるサーバーの起動が実行される。通常はforceオプションはいらないが、何故か原因不明のエラーが出たので強制実行している。

inventory.ini
- AnsibleでEC2のセットアップを行う際に、接続先のIP、ログインするユーザー名、SSHキーの場所を指定する設定ファイル。

setup_ec2.yml
- Ansibleでインスタンスの設定を行うためのyml。「Ansible-playbook -i inventory.ini setup_ec2.ini」を実行する。

おまけファイル
- インスタンスの自動生成までAnsibleでやってしまったときのファイル。マシンにGitをインストールし、AWSへのアクセスキーとシークレットアクセスキーを登録、また`pip install boto3`および`ansible-galaxy collection install amazon.aws`を実行したのちに、launchとsetupを同時に実行すれば、インスタンスの生成とセットアップまでを自動で完了させる。だが、インスタンスの自動生成はAnsibleではなくAWS Cloud formationで行うので、今回は使用しない。だが勉強にはなったので一応残しておく。