#!/bin/bash

# set framework folder name
FILE_NAME=`find . -name *.podspec | awk -F "[/.]" '{print $(NF-1)}'`
# 工程名称(Project的名字)
PROJECT_NAME="${FILE_NAME}"
# scheme名称
# SCHEME_NAME="XXXSDK"
SCHEME_NAME="${FILE_NAME}"
Configuration="Debug"
# 项目所在的文件
PROJECT_DIR=$PWD
# 创建产物文件夹，文件夹名与库名一致，方便生成使用
INSTALL_DIR=${HOME}/Desktop/XCFrameworkSpace
# podspec文件路径
PODSPEC_FILE="$PWD/${SCHEME_NAME}.podspec"

if [ -e "${INSTALL_DIR}" ]
then
    echo "${INSTALL_DIR} 文件夹已存在，不重新创建"
else
    echo "${INSTALL_DIR} 文件夹不存在，重新创建"
    mkdir $INSTALL_DIR
fi

cd Example

XCWORKSPACE="${PROJECT_NAME}.xcworkspace"
FRAMEWORK_FOLDER_NAME="${SCHEME_NAME}_XCFramework"
TEMP_FRAMEWORK_DIR="${PROJECT_DIR}/${FRAMEWORK_FOLDER_NAME}"
# set framework name or read it from project by this variable

# 创建时间作为文件夹
create_time=`date +%Y%m%d%H%M%S`
# 生成的xcframework
EXPORT_FOLDER_PATH="${INSTALL_DIR}/${SCHEME_NAME}/${create_time}"
# 生成xcframework的路劲
EXPORT_XCFRAMEWORK_PATH="${EXPORT_FOLDER_PATH}/${SCHEME_NAME}.xcframework"
# 生成真机、模拟器二和一的路劲
EXPORT_MIX_FRAMEWORK_PATH="${EXPORT_FOLDER_PATH}/${SCHEME_NAME}.framework"
# set path for iOS simulator archive
# 生成的模拟器的库的文件
SIMULATOR_ARCHIVE_PATH="${TEMP_FRAMEWORK_DIR}/simulator.xcarchive"
# set path for iOS device archive
# 生成的真机的库的文件
IOS_DEVICE_ARCHIVE_PATH="${TEMP_FRAMEWORK_DIR}/iOS.xcarchive"
# 删除之前生成的xcframework的文件夹
rm -rf "${EXPORT_FOLDER_PATH}"
echo "Deleted ${EXPORT_FOLDER_PATH}"
mkdir -p "${EXPORT_FOLDER_PATH}"
echo "Created ${EXPORT_FOLDER_PATH}"
echo "Archiving ${SCHEME_NAME}"

# 更新pod配置

echo '==================start================'
total_startTime_s=`date +%s`

echo '开始install Pod'
pod_startTime_s=`date +%s`
pod install
pod_endTime_s=`date +%s`
echo '结束install Pod'
echo "install pod 时长：$[$pod_endTime_s - $pod_startTime_s]"

echo '开始模拟器archive'
archive_simulator_startTime_s=`date +%s`

# 创建simulator的framework
xcodebuild archive \
-workspace ${XCWORKSPACE} \
-scheme ${SCHEME_NAME} \
-configuration ${Configuration} \
-destination="iOS Simulator" \
-archivePath "${SIMULATOR_ARCHIVE_PATH}" \
-sdk iphonesimulator clean build \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

archive_simulator_endTime_s=`date +%s`
echo "模拟器archive时长：$[$archive_simulator_endTime_s - $archive_simulator_startTime_s]"
echo '结束模拟器archive'

echo '开始真机archive'
archive_iphone_startTime_s=`date +%s`
# 创建iPhone的framework
xcodebuild archive \
-workspace ${XCWORKSPACE} \
-scheme ${SCHEME_NAME} \
-configuration ${Configuration} \
-destination="iOS" \
-archivePath "${IOS_DEVICE_ARCHIVE_PATH}" \
-sdk iphoneos clean build \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

archive_iphone_endTime_s=`date +%s`
echo "真机archive时长：$[$archive_iphone_endTime_s - $archive_iphone_startTime_s]"
echo '结束真机archive'

#Creating XCFramework
# 创建的模拟器库的地址
SIMULATOR_Framework_PATH="${SIMULATOR_ARCHIVE_PATH}/Products/Library/Frameworks/${SCHEME_NAME}.framework"
# 创建的真机的库的地址
IPHONE_Framework_PATH="${IOS_DEVICE_ARCHIVE_PATH}/Products/Library/Frameworks/${SCHEME_NAME}.framework"

# 生成xcframework
echo '开始合成xcframework'
create_xcframework_startTime_s=`date +%s`

xcodebuild -create-xcframework \
-framework ${SIMULATOR_Framework_PATH} \
-framework ${IPHONE_Framework_PATH} \
-output "${EXPORT_XCFRAMEWORK_PATH}"

create_xcframework_endTime_s=`date +%s`
echo "合成xcframework时长：$[$create_xcframework_endTime_s - $create_xcframework_startTime_s]"
echo '结束合成xcframework'

# 移除临时文件夹
rm -rf "${TEMP_FRAMEWORK_DIR}"

# 复制podspec文件
cp -rf ${PODSPEC_FILE} ${EXPORT_FOLDER_PATH}
echo "结束Podspec复制"

total_endTime_s=`date +%s`
echo '==================end================'
echo "总共时长：$[$total_endTime_s - $total_startTime_s]"

open "${EXPORT_FOLDER_PATH}"
