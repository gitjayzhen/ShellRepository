jmeter-docker 说明文档
====================
>1.启动办法 sh deploy.sh yes/no
>>（1）除10.1.1.1外，其他机器仅启动jmeternode<br>
>
>>（2）10.1.1.1机器是否重新启动mysql，可以通过添加yes/no标识来区分<br>
>
>>（3）jmeternode中的代码通过git下载后部署，container创建完成后可以直接到内部修改、更新代码<br>
>
>>（4）jmeternode日志文件存放在container内部的/data/daemon/jmeter-docker/jmeternode/log中<br>
>
>>（5）jmeter的过程文件存储在deploy.sh上级目录的uploadfiles文件中，请一定不要删除uploadfiles文件夹，否则所有测试记录将被删除<br>
>
--------------------

>2.mysql 
>>（1）mysql/jmxs.sql中存放数据库文件，将该文件放入/docker-entrypoint-initdb.d/中，即可在创建container的同时创建db。<br>
>
>>（2）mysql中存储jmx文件的部分信息、目标服务器信息和当前压测进程的状态。<br>
>
--------------------

>3.jmeternode
>>（1）container建立的同时在其内部使用sh start.sh部署并启动服务<br>
>
>>（2）执行jmeter性能测试or压力测试or稳定性测试。<br>
>
>>（3）ssh到目标服务器部署监控脚本和定时任务，echart显示监控结果(cpu、mem等)。<br>
>
>>（4）log.jtl文件过大时不可自动生成html报告，需要下载log.jtl文件并用jmeter客户端打开以查看测试结果。<br>
>
--------------------
>4.执行结果说明
>>（1）文件夹名称为 YYYYMMDDHHmmss_duration 时间_执行分钟数<br>
>
>>（2）log.jtl为jmeter执行的日志。<br>
>
>>（3）result为jmeter执行报告，包含qps、响应时间等。<br>
>
>>（4）process_duration_top/ps为测试时间内性能监测数据。<br>
>
>>（5）chart_process_duration为性能监测结果，包含cpu和mem的使用率等。<br>
>
--------------------