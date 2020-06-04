## 使用
* 在项目根文件夹下，运行compile.bat / compile.sh，会自动创建java项目框架，包括 /bin, /src, /lib 文件夹
  * /bin   存放生成的 .class文件
  * /src   存放源代码
  * /lib   存放依赖jar包
* 完成代码编辑后，运行compile.bat / compile.sh，编译并运行java项目
* 编译运行结束后，会生成 /src/sources.list 以及 /lib/libs.list 文件
  * /src/sources.list   存放 /src下各个 .java文件路径
  * /lib/libs.list      存放 /lib下各个 jar包路径

## 注意
* compile.bat 批处理文件，在 Windows下运行
* compile.sh  脚本文件，一般在 Linux/Mac OS下运行
