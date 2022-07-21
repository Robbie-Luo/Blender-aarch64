### Blender安装脚本

### 1、编译ISPC

ISPC是Intel提供的SPMD编译器，使用install_ispc.sh脚本安装ispc，该脚本会自动从github拉取源码进行编译，并安装到/usr/local/目录。修改install_ispc.sh脚本中的路径, 其中LIB_DIR表示依赖库源码保存路径, INST_DIR为安装路径。

```shell
LIB_DIR="/home/[username]/lib"
INST_DIR="/opt/ispc"
```

```shell
bash install_ispc.sh
```

### 2、编译Blender

```shell
bash install_blender.sh
```