rm -rf jmeter-docker
git clone -b jmeternode https://git.qadev.com/jayzhen/jmeter-docker.git
sed -i "s#127.0.0.1#host_ip#g" /data/daemon/jmeter-docker/jmeternode/config/config.js
sed -i "s#127.0.0.1#host_ip#g" /data/daemon/jmeter-docker/jmeternode/routes/index.js
cd jmeter-docker/jmeternode
ln -s /data/daemon/public/files public/files
npm install
nohup npm run test &
tail -f nohup.out