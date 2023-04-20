#!/usr/bin/python3
# -*- coding:utf-8 -*-

import os,sys,time
import requests
import argparse
import linecache

################### 打包配置 ##################

# boundleId
bundleid = 'com.framework.BStar'

# 打包配置文件名称
profile_name = 'TestProfile'

# 打包证书的 teamID
teamid = '74WTP9NTZF'



################## 打包配置 #################

# 参数解析器
parser = argparse.ArgumentParser()

#判断是否有 workspace
has_workspace = False

# archive 整个路径
archive_full_path = ''

# .xcodeproj 文件名称，带后缀
project_full_name = ''

# .xcworkspace 文件名称，带后缀
workspace_full_name = ''

# 导出的 ipa 完成 path
ipa_path = ''


# 初始化参数
def init_parameter():

    print('\n=========== xcode base info ===========\n')

    os.system('xcodebuild -list')
    print('\n')
    build_list = os.popen('xcodebuild -list')

    # 获取 scheme 和 target
    schemes_name = ''
    target_name = ''
    params_temp_arr = []

    for line in build_list:
        if line == '\n' or line == ' ':
            continue
        else:
            temp = line.strip(' ')
            temp = temp.strip('\n')
            params_temp_arr.append(temp)

    for i, line in enumerate(params_temp_arr):

        if line.find('Schemes:') != -1:
            schemes_name = params_temp_arr[i+1]

        elif line.find('Targets:') != -1:
            target_name = params_temp_arr[i+1]


    # 增加 scheme 和 target 参数
    parser.add_argument('-scheme', default = schemes_name,
                        help='none input scheme will use fist scheme of "xcodebuild -list" command resualt')

    parser.add_argument('-target', default = target_name,
                        help='none input target will use fist target of "xcodebuild -list" command resualt')
    # 增加 环境 参数
    parser.add_argument('-env', default='Release',
                        help='none input will use "Release"')


    ######### 路径相关 ##########
    global archive_full_path
    global has_workspace
    global project_full_name
    global workspace_full_name

    # 获取当前目录下的所有文件名称
    list_file_name = os.listdir(os.getcwd())
    for file_name in list_file_name:
        
        if file_name.endswith('.xcodeproj'):

            name_split = file_name.split('.')
            project_full_name = file_name

        elif file_name.endswith('.xcworkspace'):

            has_workspace = True
            workspace_full_name = file_name

        else:
            pass

    parser.add_argument('-project', default=project_full_name,help='none input project will use the ".xcodeproj" file prefix name')

    user_root_pass = os.path.expanduser('~')
    archive_path = os.path.join(user_root_pass, 'Library/Developer/Xcode/Archives/%s' %
                                (time.strftime('%Y-%m-%d', time.localtime())))

    temp_parser = parser.parse_args()

    temp_time = time.strftime('%Y-%m-%d %H.%M %Ss', time.localtime())
    export_archive_name = '%s %s.xcarchive' % (temp_parser.target, temp_time)
    archive_full_path = os.path.join(archive_path, export_archive_name)

    

    print('\n************* 相关全局参数 ***************\n')
    print('scheme = %s \ntarget = %s' %(temp_parser.scheme, temp_parser.target))
    print('workspace_full_name : %s' % (workspace_full_name))
    print('project_full_name : %s' % (project_full_name))
    print('archive_full_path = %s' % (archive_full_path))
    print('has_workspace = %s' % (has_workspace))
    print('\n****************************')



# clean 工程
def xcode_clean():
    print('\n============ clean build ==========\n')
    clear_command = 'xcodebuild clean'
    os.system(clear_command)


# 归档工程，生成 .xcarchive 文件
def xcode_archive():
    print('\n============ xcode archive ==========\n')
    
    temp_parser = parser.parse_args()

    print(archive_full_path)

    archive_command = 'xcodebuild archive -project "%s" -scheme "%s" -configuration %s -archivePath "%s"' % (
        project_full_name, temp_parser.scheme,temp_parser.env, archive_full_path)

    if has_workspace == True:
        archive_command = 'xcodebuild archive -workspace "%s" -scheme "%s" -configuration %s -archivePath "%s"' % (
            workspace_full_name, temp_parser.scheme, temp_parser.env, archive_full_path)
        print(archive_command)

    os.system(archive_command)


# 导出 IPA 包
def xcode_export_ipa():
    print('\n============ xcode export ipa ==========\n')
    global ipa_path

    user_path = os.path.expanduser('~')
    temp_time = time.strftime('%Y-%m-%d %H%M %Ss',time.localtime())
    ipa_path = os.path.join(user_path, 'Downloads/PYXCODE-IPA', temp_time)

    if os.path.exists(ipa_path) == False:
        os.system('mkdir -p "%s"' % (ipa_path))

    plist_path = creat_config_plist(ipa_path)

    if plist_path != '':
        export_command = 'xcodebuild -exportArchive -archivePath "%s" -target app.ipa -exportPath "%s" -exportOptionsPlist "%s"' % (
            archive_full_path, ipa_path, plist_path)
        os.system(export_command)
    

# 创建用于导出的 plist 配置文件
def creat_config_plist(plist_path):
    
    """
    关键参数
    method = ad-hoc
    <dict>
        <key > com.framework.BStar < /key >
        <string > BStar Framework ADHoc < /string >
    </dict>
    teamID = 'xxx'
    """

    config_plist_content = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>compileBitcode</key>
            <true/>
            <key>destination</key>
            <string>export</string>
            <key>method</key>
            <string>develop</string>
            <key>provisioningProfiles</key>
            <dict>
                <key>%s</key>
                <string>%s</string>
            </dict>
            <key>signingCertificate</key>
            <string>Apple Distribution</string>
            <key>signingStyle</key>
            <string>manual</string>
            <key>stripSwiftSymbols</key>
            <true/>
            <key>teamID</key>
            <string>%s</string>
            <key>thinning</key>
            <string>&lt;none&gt;</string>
        </dict>
        </plist>
    """ %(bundleid,profile_name,teamid)

    plist_full_path = os.path.join(plist_path, 'ExportOptions.plist')

    with open(plist_full_path, 'w') as plist:
        plist.write(config_plist_content)
        return plist_full_path
    return ''


# 上传到蒲公英
def upload_to_pyger():
    
    url = 'https://www.pgyer.com/apiv2/app/upload'

    api_key = '530d2e8f9e50012acff783689e3af26d'
    buildInstallType = 2
    buildPassword = '111111'
    buildUpdateDescription = '版本更新 version = %s' % (time.strftime('%Y-%m-%d %H%M', time.localtime()))
    
    temp_parser = parser.parse_args()
    file_path = '%s/%s.ipa' % (ipa_path, temp_parser.target)
    
    # 为保证 能够找到ipa文件，做一步容错，
    # 如果没有根据路径找到，就遍历文件夹，找到.ipa文件
    if os.path.exists(file_path) == False:
        ipa_list = os.listdir(ipa_path)
        for file_name in ipa_list:
            if file_name.find('.ipa') != -1:
                file_path = '%s/%s' % (ipa_path, file_name)
                break 

    try:

        print('\n------------ 上传应用到 蒲公英 -------------\n')
        print('\nfilepath = %s\n' % (file_path))

        file = open(file_path, 'rb')
        data = {
            '_api_key': api_key,
            'buildInstallType': buildInstallType,
            'buildPassword': buildPassword,
            'buildUpdateDescription': buildUpdateDescription,
        }

        print('\nparams = %s\n' % (data))

        rsp = requests.post(url, params=data, files={'file': file})
        file.close()

        print ('%s\n%s'%(rsp,rsp.text))

    except IOError as identifier:
        print('****** 读取文件失败 ******')
    
    except requests.ConnectionError as cerror:
        print('****** 链接不到服务器 ******')




if __name__ == '__main__':
    init_parameter()
    xcode_clean()
    xcode_archive()
    xcode_export_ipa()
#    upload_to_pyger()
