#!/usr/bin/python3
# -*- coding:utf-8 -*-


""" 
*****************************************************************
脚本说明：

目录：需要放在pod工程的根目录下，即和 .podspec 文件同一目录

执行脚本可选参数有
--auto          : 自增版本号，只增加最后一位(只有自增版本号时，才会自动打tag，否则手动打tag)
--auto-remove   : 删除当前tag并重新打tag，不修改podspec的版本号
--use-libraries : 使用 --use-libraries
--verbose       : 使用 ---verbose       (发布时将显示所有log)
--allow-warnings: 使用 --allow-warnings (是否忽略警告，大多数都需要此参数)
--push          : 表示直接上传到pod       (默认为 验证 ，即 pod lib lint)
repo=           : 暂时无用，准备做私有库发布的，目前没写

完整示例: 
python auto.py --auto --use-libraries --verbose --allow-warnings --push

*****************************************************************
"""


import os, sys
import fileinput
import time

# print('\n')
# print('=================== 参数 ==================')
# print('argvs = %s'%sys.argv)
# print('===========================================')
# print('\n\n')

# mygit = 'https://github.com/blackstar_lang@163.com/BSFrameworks.git'
# sources = ['https://github.com/CocoaPods/Specs.git']


# 是否是正式发布， False 为验证
is_release_push = False

# 是否自动修改tag 和 .podspec的 version
auto_tag = ''

# podspec 和 git tag 的版本号
tag_version = ''

# 用于接收 --use-libraries 参数
use_libraries = ''

# 用于接收 --verbose 参数
verbose = ''

# 用于接收 --allow-warnings 参数
allow_warnings = ''

# .podspec 的名称
spec_name = ''

# .podspec 的名称
repo_name = ''


# 获取参数
def get_args():

    global auto_tag
    global use_libraries
    global verbose
    global allow_warnings
    global repo_name
    global is_release_push

    for arg in sys.argv:
        if arg == '--auto' or arg == '--auto-remove':
            auto_tag = arg
        elif arg == '--use-libraries':
            use_libraries = '{}{}'.format(' ', arg)
        elif arg == '--verbose':
            verbose = ' %s' % (arg)
        elif arg == '--allow-warnings':
            allow_warnings = ' ' + arg
        elif arg.startswith('repo='):
            liarg = arg.split('=', 1)
            repo_name = liarg[1]
        elif arg == '--push':
            is_release_push = True
        elif arg == '--retag':
            is_release_push = True

    print('\n======== 解析参数，赋值给全局变量 ==========')
    if auto_tag == '--auto':
        print('=== auto_tag : %s (自动增加版本号)' % auto_tag)
    elif auto_tag == '--auto-remove':
        print('=== auto_tag : %s (删除当前tag并重新打tag)' % auto_tag)
    else:
        print('=== auto_tag : 不处理版本号和 git tag')
    
    print('=== use_libraries    : %s' % use_libraries)
    print('=== verbose          : %s' % verbose)
    print('=== allow_warnings   : %s' % allow_warnings)
    print('=== spec_name        : %s' % repo_name)
    print('==========================================\n')




# ============================
# 获取spec路径
# ============================
def get_spec_filepath():

    global spec_name
    # 获取 podspec文件路径和文件名
    work_path = os.getcwd()
    list_file = os.path.split(work_path)
    spec_name = list_file[-1]+'.podspec'
    spec_full_path = work_path + '/' + spec_name

    return (spec_full_path)


# ============================
# 修改 spec 的 version，
# 并同步给tag_version
# ============================
def edit_spec_version():

    filepath = get_spec_filepath()
    print('================ spec 路径 ==================')
    print(filepath)
    print('============================================')
    print('\n')

    global auto_tag
    global tag_version

    file = open(filepath, 'r+')
    all_line = file.readlines()

    for i,line in enumerate(all_line):

        if line.find('s.version') != -1:

            # 获取整个版本号，并trip掉空格和单引号
            version_full = line.split('=')[1]
            trip_version = version_full.replace(' ', '')
            trip_version = trip_version.replace('\'', '')

            if auto_tag == '--auto':
                # 获取版本号的最后一位
                versionWrap = trip_version.split('.')
                version_last_value = versionWrap[2]

                # 获取 +1 后的版本号
                new_last_version = int(version_last_value) + 1
                versionWrap[2] = str(new_last_version)

                # 得到最新版本号，并赋给 tag_version
                new_version = str.join('.',versionWrap)
                tag_version = new_version

                # 修改当前行的版本内容，为写入做准备，需要有回车
                # 样例 line = s.version = '0.1.8' + 回车
                write_version = ' \'%s\'\n'%(new_version)
                line = line.replace(version_full, write_version)
                all_line[i] = line
           
            else:
                tag_version = trip_version

            break

    file.close()

    with open(filepath ,'w') as wfile:
        wfile.writelines(all_line)
        wfile.close()
        
    

def commit_and_push_git():

    global tag_version
    global auto_tag

    # commit 命令
    ctime = time.strftime("%Y-%m-%d %H:%M%:%S",time.localtime())
    commit_command = 'git commit -m "AUTO_VERSION   最新上传日期：%s       版本号：%s"' % (ctime,tag_version)

    # 获取当前分支名称, push命令
    git_head = os.popen('git symbolic-ref --short -q HEAD')
    current_branch = git_head.read()
    git_head.close()
    push_command = 'git push origin %s'%(current_branch)

    if auto_tag == '--auto-remove':
        remove_localtag_command = 'git tag -d %s'%(tag_version)
        remove_tag_command = 'git push origin :refs/tags/%s' % (tag_version)
        print('\n')
        print('---------- git tag -d ----------')
        os.system(remove_localtag_command)
        os.system(remove_tag_command)

    # tag 命令
    git_tag_command_local = 'git tag -m "%s %s" %s'%('version :',tag_version,tag_version)
    git_tag_command_remote = 'git push --tag'

    # 调用 git 命令
    os.system('git add .')

    commit_open = os.popen(commit_command)
    commit_rsp = commit_open.read()
    commit_open.close()
    print('\n---------- git commit ----------')
    print(commit_rsp)

    print('\n---------- git push ----------')
    push_open = os.popen(push_command)
    push_rsp = push_open.read()
    push_open.close()


    print('\n---------- git tag ----------')
    local_tag_open = os.popen(git_tag_command_local)
    local_tag_rsp = local_tag_open.read()
    local_tag_open.close()

    remote_tag_open = os.popen(git_tag_command_remote)
    remote_tag_rsp = remote_tag_open.read()
    remote_tag_open.close()


# pod 验证
def pod_spc_lint():
    pod_lint_command = 'pod spec lint %s%s%s%s' % (
        spec_name, allow_warnings, use_libraries, verbose)
    print('\n======== %s ========' % pod_lint_command)
    os.system(pod_lint_command)

# pod 发布
def pod_trunk_push():
    pod_push_command = 'pod trunk push %s%s%s%s' % (
        spec_name, allow_warnings, use_libraries, verbose)
    print('\n======== %s ========' % pod_push_command)
    os.system(pod_push_command)



# ========================================
#               程序启动入口
# ========================================

if __name__ == "__main__":

    #获取参数后，修改version，修改后，提交代码导git，然后发布
    get_args()
    edit_spec_version()

    # 如果自动更改版本号，则提交代码
    if auto_tag == '--auto' or auto_tag == '--auto-remove':
        commit_and_push_git()


    if is_release_push == True:
        pod_trunk_push()
    else:
        pod_spc_lint()
