#sed -i "s#127.0.0.1#10.1.1.1#g" /data/daemon/performance_report/config/config.js
cd /data/daemon/performance_report/
mv -f public/files/* /data/daemon/public/files
rm -rf public/files
ln -s /data/daemon/public/files public/files
#ln -s /data/daemon/result_tmp .
#ln -s /data/daemon/result_tmp2 .
pgrep node | xargs kill -9
crond
nohup pm2 start --no-daemon app.js -i 10&
tail -f nohup.out
