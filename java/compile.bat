:: 项目文件当前目录，等号前后不能有空格
@set currentDir=%~dp0

:: @echo %currentDir%




:: 定义函数，不一定命名为func
:func
	:: java项目目录
	@set projectDic=%currentDir%
	:: java项目源代码目录
	@set sourceDic=%projectDic%src\
	:: java项目依赖库目录
	@set libDic=%projectDic%lib\
	:: java项目编译后，存放生成文件的目录
	@set classDic=%projectDic%bin\


	:: @echo %projectDic%
	:: @echo %sourceDic%
	:: @echo %libDic%
	:: @echo %classDic%


	:: 初始化，创建 src, lib, bin 文件夹
	@if not exist %sourceDic% md %sourceDic%
	@if not exist %libDic% md %libDic%
	@if not exist %classDic% md %classDic%



	@goto start1		-段注释
		= 直接删除 src\sources.list，没有任务提示
		= 不需要每次删除 src\sources.list，每次 > 重定向数据流时会覆盖数据，每次 >> 重定向数据流时追加数据
		= @del /s /q /f %sourceDic%sources.list
	:start1


	:: 将src目录下的源文件保存到 sources.list
	@goto start2 	    - 段注释
		= 将src目录下的所有java文件的名称存入src\sources.list
		= "\.java$" 中的'.'不是匹配符，只是个点
		= "\.java$" 不能排除 src\cn\qixqi\forum\.java 异常文件，即使如果"*.java$" 可用，也排除不了
		= 重定向到 sources.list 的数据流，在 sources.list中是乱码，不过不影响，因为使用时又会读到 compile.bat中
	:start2
	@dir /s/b %sourceDic% | findstr "\.java$" > %sourceDic%sources.list


	:: 打印 sources.list 文件内容
	:: @type %sourceDic%sources.list



	:: 将lib目录下的依赖jar包保存到 libs.list
	@goto start3  		- 段注释
		= 不能排除 "lib\.jar"文件
	:start3
	@dir /s/b %libDic% | findstr "\.jar$" > %libDic%libs.list


	:: 打印 libs.list 文件内容
	:: @type %libDic%libs.list


	:: 批量编译java文件
	:: 编码格式: utf-8
	:: 依赖库: 隔开
	@goto start4
		= 第一种  复杂，需要手动罗列每个jar包
		= @javac -d %classDic% -encoding utf-8 -cp %libDic%mysql-connector-java-8.0.20.jar -g -sourcepath %sourceDic% @%sourceDic%sources.list 
		= 第二种  错误，因为多个jar包之间使用空格隔开，需要用';'或':'隔开
		= -cp %libDic%*.jar   利用适配符，导入lib一级目录下的jar包		
		= 第三种  错误，同样，每个jar包空格分隔
		= -cp %libDic% @%libDic%libs.list
		= 读取文件，然后 bat使用';'分割，shell 使用':'分割
		= 读取文件后等同于 -cp .;%libDic%mysql-connector-java-8.0.20.jar;%libDic%manager.jar;
	:start4
	:: 循环读取 lib/libs.list 文件每一行
	@setlocal enabledelayedexpansion
	@set classPath=.;
	@for /f "delims=" %%a in (%libDic%libs.list) do @set classPath=!classPath!%%a;
	:: @echo %classPath%

	@javac -d %classDic% -encoding utf-8 -classpath %classPath% -g -sourcepath %sourceDic% @%sourceDic%sources.list
	



	:: 运行程序
	:: jar包 + 生成class文件
	@java -cp %classPath%%classDic%; cn.qixqi.forum.dao.BaseDao






:: 终止函数
@goto:eof



:: 调用函数，函数调用要在函数声明上面，不然直接执行函数声明部分，函数调用部分不执行
:: @call:func   :: 不能调用函数，否则会执行两次