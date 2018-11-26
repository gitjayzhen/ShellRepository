@echo off  
echo ****************************************  
echo 自动创建文件夹（存放备份文件和备份脚本）  
echo ****************************************  
  
set Pan=d:\  
set AFolder=MIS\  
set BFolder=OracleDBAutoBackup\  
set C1Folder=BackupTools  
set C2Folder=AutoBakFiles  
set C3Folder=AutoBakHistoryFiles  
set C4Folder=AutoBakBatRunLogs  
  
  
  
echo 本批处理准备创建以下文件夹  
echo    1.存放备份的批处理脚本    %Pan%%AFolder%%BFolder%%C1Folder%  
echo    2.存放备份文件        %Pan%%AFolder%%BFolder%%C2Folder%  
echo    3.存放备份历史文件  %Pan%%AFolder%%BFolder%%C3Folder%  
echo    4.存放备份脚本执行日志    %Pan%%AFolder%%BFolder%%C4Folder%  
echo .  
echo 开始执行-----------------------  
  
if exist %Pan% (  
  
    if exist %Pan%%AFolder% (         
        rem 目录d:\<span style="font-family: Arial, Helvetica, sans-serif;">MIS</span>已存在，无需创建  
        echo 目录%Pan%%AFolder%已存在，无需创建  
    ) else (  
        rem 创建d:\MIS  
        echo 创建%Pan%%AFolder%         
        md %Pan%%AFolder%  
    )  
  
    if exist %Pan%%AFolder%%BFolder% (  
        rem 目录d:\MIS\OracleDBAutoBackup已存在，无需创建  
        echo 目录%Pan%%AFolder%%BFolder%已存在无需创建         
    ) else (  
        rem 创建d:\MIS\OracleDBAutoBackup   
        echo 创建%Pan%%AFolder%%BFolder%  
        md %Pan%%AFolder%%BFolder%  
    )  
  
    if exist %Pan%%AFolder%%BFolder%%C1Folder% (  
        rem 目录d:\MIS\OracleDBAutoBackup\BackupTools已存在，无需创建  
        echo 目录%Pan%%AFolder%%BFolder%%C1Folder%已存在，无需创建  
    ) else (  
        rem 创建d:\MIS\OracleDBAutoBackup\BackupTools  
        echo 创建%Pan%%AFolder%%BFolder%%C1Folder%  
        md %Pan%%AFolder%%BFolder%%C1Folder%  
    )  
  
    if exist %Pan%%AFolder%%BFolder%%C2Folder% (  
        rem 目录d:\MIS\OracleDBAutoBackup\AutoBakFiles已存在，无需创建  
        echo 目录%Pan%%AFolder%%BFolder%%C2Folder%已存在，无需创建  
    ) else (  
        rem 创建d:\MIS\OracleDBAutoBackup\AutoBakFiles  
        echo 创建%Pan%%AFolder%%BFolder%%C2Folder%  
        md %Pan%%AFolder%%BFolder%%C2Folder%  
    )  
  
    if exist %Pan%%AFolder%%BFolder%%C3Folder% (  
        rem 目录d:\MIS\OracleDBAutoBackup\AutoBakHistoryFiles已存在，无需创建  
        echo 目录%Pan%%AFolder%%BFolder%%C3Folder%已存在，无需创建  
    ) else (  
        rem 创建d:\MIS\OracleDBAutoBackup\AutoBakHistoryFiles  
        echo 创建%Pan%%AFolder%%BFolder%%C3Folder%  
        md %Pan%%AFolder%%BFolder%%C3Folder%  
    )  
  
    if exist %Pan%%AFolder%%BFolder%%C4Folder% (  
        rem 目录d:\MIS\OracleDBAutoBackup\AutoBakBatRunLogs已存在，无需创建  
        echo 目录%Pan%%AFolder%%BFolder%%C4Folder%已存在，无需创建  
    ) else (  
        rem 创建d:\MIS\OracleDBAutoBackup\AutoBakBatRunLogs  
        echo 创建%Pan%%AFolder%%BFolder%%C4Folder%  
        md %Pan%%AFolder%%BFolder%%C4Folder%  
    )  
  
) else (  
    echo !!  
    echo !!执行失败，当前系统上不存在%Pan%盘  
    echo !!  
)  
echo .  
echo 已执行完毕(退出请按任意键或直接关闭窗体)-----------------------  
echo .  
pause  