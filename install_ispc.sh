#!/bin/bash
set -e
LIB_DIR="/home/lwt595403/lib"
INST_DIR="/opt/ispc"
BUILD_TYPE="Release"
FORCE_REBUILD="false"

if [ ! -d $INST_DIR ];then
    mkdir $INST_DIR
fi
echo "$INST_DIR/deps/lib" > /etc/ld.so.conf.d/blender.conf

export PATH="$INST_DIR/deps/bin:$PATH"
export LD_LIBRARY_PATH="$INST_DIR/deps/lib:$LD_LIBRARY_PATH"
export CMAKE_PREFIX_PATH="$INST_DIR/deps:$CMAKE_PREFIX_PATH"

function prepare_build()
{
    SRC=$LIB_DIR/$1
    VERSION=$2
    if [ ! -d $SRC ];then
        git clone --recursive $3 $SRC
    fi
    cd $SRC
    git checkout $VERSION
    if [ ! -d build ];then
        mkdir build
    fi
    cd build
    if [ "$FORCE_REBUILD" = true ];then
        rm -rf *
    fi
}

prepare_build ispc v1.18.0 https://github.com/ispc/ispc.git
prepare_build llvm-ispc llvmorg-13.0.1 https://github.com/llvm/llvm-project.git 

PREFIX=$INST_DIR/llvm-ispc/13.0.1
if [ ! -d $PREFIX ];then
    cd $LIB_DIR/llvm-ispc
    git reset HEAD --hard
    for patch in $(ls $LIB_DIR/ispc/llvm_patches | grep 13_0)
    do 
        git apply $LIB_DIR/ispc/llvm_patches/$patch
    done
    cd $LIB_DIR/llvm-ispc/build
    cmake  -G "Ninja" -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS="clang;openmp" -DLLVM_ENABLE_DUMP=ON -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_INSTALL_UTILS=ON  -DLLVM_TARGETS_TO_BUILD=AArch64\;ARM\;X86  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly  ../llvm
    ninja install
fi

export PATH="$PREFIX/bin:$PATH"
export LD_LIBRARY_PATH="$PREFIX/lib:$LD_LIBRARY_PATH"
export CMAKE_PREFIX_PATH="$PREFIX:$CMAKE_PREFIX_PATH"

PREFIX=/usr/local
cd $LIB_DIR/ispc/build
cmake  -G "Ninja" .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PREFIX
ninja install







    
