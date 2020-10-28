#!/usr/bin/python3
# -*- coding:utf-8 -*-

import os, sys
import fileinput
import time

print('\n')
print('=================== 参数 ==================')
print('argvs = %s'%sys.argv)
print('===========================================')
print('\n\n')

mygit = 'https://github.com/blackstar_lang@163.com/BSFrameworks.git'
sources = ['https://github.com/CocoaPods/Specs.git']


# 是否自动修改tag 和 .podspec的 version
auto_tag = False

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


for arg in sys.argv:
    if arg == 'autoTag':
        auto_tag = True
    elif arg == '--use-libraries':
        use_libraries = '{}{}'.format(' ',arg)
    elif arg == '--verbose':
        verbose = ' %s'%(arg)
    elif arg == '--allow-warnings':
        allow_warnings = ' ' + arg
    elif arg.startswith('repo='):
        liarg = arg.split('=',1)
        repo_name = liarg[1]
    
print('================== 变量 ====================')
print('=== auto_tag : %s' %auto_tag)
print('=== use_libraries : %s' % use_libraries)
print('=== verbose : %s' % verbose)
print('=== allow_warnings : %s' % allow_warnings)
print('=== spec_name : %s' % repo_name)
print('===========================================')
print('\n\n')


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

    file = open(filepath, 'r+')
    all_line = file.readlines()

    global auto_tag
    global tag_version

    for i,line in enumerate(all_line):

        if line.find('s.version') != -1:

            # 获取整个版本号，并trip掉空格和单引号
            version_full = line.split('=')[1]
            trip_version = version_full.replace(' ', '')
            trip_version = trip_version.replace('\'', '')

            if auto_tag == True:
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

    ctime = time.strftime("%Y-%m-%d %H:%M%:%S",time.localtime())
    commit_command = 'git commit -m "最新上传日期：%s       版本号：%s"' % (ctime,tag_version)
    print(commit_command)

    # 获取当前分支名称
    git_head = os.popen('git symbolic-ref --short -q HEAD')
    current_branch = git_head.read()
    git_head.close()

    push_command = 'git push origin %s'%(current_branch)
    print(push_command)

    git_tag_command_local = 'git tag -m "%s %s" %s'%('version :',tag_version,tag_version)
    git_tag_command_remote = 'git push --tag'
    print(git_tag_command_local)


    # 调用 git 命令
    os.system('git add .')

    commit_open = os.popen(commit_command)
    commit_rsp = commit_open.read()
    commit_open.close()

    push_open = os.popen(push_command)
    push_rsp = push_open.read()
    push_open.close()

    local_tag_open = os.popen(git_tag_command_local)
    local_tag_rsp = local_tag_open.read()
    local_tag_open.close()

    remote_tag_open = os.popen(git_tag_command_remote)
    remote_tag_rsp = remote_tag_open.read()
    remote_tag_open.close()

    print('\n')
    print('---------- git command 结果 ----------')
    print('\n')

    print('commit :' + commit_rsp + '\n')
    print('push :' + push_rsp + '\n')
    print('local tag :' + local_tag_rsp + '\n')
    print('remote tag :' + remote_tag_rsp)

    print('\n')
    print('-------------------------------------')
    

edit_spec_version()
commit_and_push_git()




# ======================  edit by yourself  ======================
# sources = ['https://github.com/blackstar_lang@163.com/BSFrameworks.git',]

# spec_libraries_name = 'cocoapods'
# use_libraries = '--use-libraries'
# is_allow_warnings = True
# is_use_libraries = True
# is_show_verbose_log = True
# # ==================================================================

# new_tag = ""
# lib_command = ""
# pod_push_command = ""
# podspec_file_name = ""
# spec_file_path = ""
# allow_warnings = ""
# use_libraries = ""
# show_verbose_log = ""
# find_version_flag = False


# def initSpecCmd():
#     current_file = os.getcwd()
#     list_file = os.path.split(current_file)
#     global podspec_file_name
#     global spec_file_path
#     global allow_warnings
#     global use_libraries
#     global show_verbose_log

#     podspec_file_name = list_file[-1] + ".podspec"
#     spec_file_path = "./" + podspec_file_name

#     if (is_allow_warnings):
#         allow_warnings = " --allow-warnings"
#     else:
#         allow_warnings = ""

#     if (is_show_verbose_log):
#         show_verbose_log = " --verbose"
#     else:
#         show_verbose_log = ""

#     if (is_use_libraries):
#         use_libraries = " --use-libraries"
#     else:
#         use_libraries = ""


# def podCommandEdit():
#     global lib_command
#     global pod_push_command

#     source_suffix = 'https://github.com/CocoaPods/Specs.git'
#     lib_command = 'pod lib lint --sources='
#     pod_push_command = 'pod trunk push ' + spec_libraries_name + ' ' + podspec_file_name
#     if len(sources) > 0:
#         # rely on  private sourece
#         pod_push_command += ' --sources='

#         for index,source in enumerate(sources):
#             lib_command += source
#             lib_command += ','
#             pod_push_command += source
#             pod_push_command += ','
#         pod_push_command = pod_push_command + source_suffix + allow_warnings + show_verbose_log + use_libraries
#     else:
#         lib_command = 'pod lib lint'

#     lib_command = lib_command + source_suffix + allow_warnings + show_verbose_log + use_libraries
#     print lib_command
#     print pod_push_command

# def updateVersion():
#     f = open(spec_file_path, 'r+')
#     infos = f.readlines()
#     f.seek(0, 0)
#     file_data = ""
#     new_line = ""
#     global find_version_flag

#     for line in infos:
#         if line.find(".version") != -1:
#             if find_version_flag == False:
#                 # find s.version = "xxxx"

#                 spArr = line.split('.')
#                 last = spArr[-1]
#                 last = last.replace('"', '')
#                 last = last.replace("'", "")
#                 newNum = int(last) + 1

#                 arr2 = line.split('"')
#                 arr3 = line.split("'")

#                 versionStr = ""
#                 if len(arr2) > 2:
#                     versionStr = arr2[1]

#                 if len(arr3) > 2:
#                     versionStr = arr3[1]
#                 numArr = versionStr.split(".")

#                 numArr[-1] = str(newNum)
#                 # rejoint string
#                 global new_tag
#                 for index,subNumStr in enumerate(numArr):
#                     new_tag += subNumStr
#                     if index < len(numArr)-1:
#                         new_tag += "."

#                 # complete new_tag

#                 if len(arr2) > 2:
#                     line = arr2[0] + '"' + new_tag + '"' + '\n'

#                 if len(arr3) > 2:
#                     line = arr3[0] + "'" + new_tag + "'" + "\n"

#                 # complete new_line

#                 print "this is new tag  " + new_tag
#                 find_version_flag = True

#         file_data += line


#     with open(spec_file_path, 'w', ) as f1:
#         f1.write(file_data)

#     f.close()

#     print "--------- auto update version -------- "


# def libLint():
#     print("-------- waiting for pod lib lint checking ...... ---------")
#     os.system(lib_command)

# def gitOperation():
#     os.system('git add .')
#     commit_desc = "version_" + new_tag
#     commit_command = 'git commit -m "' + commit_desc + '"'
#     os.system(commit_command)
#     # git push
#     r = os.popen('git symbolic-ref --short -q HEAD')
#     current_branch = r.read()
#     r.close()
#     push_command = 'git push origin ' + current_branch

#     # tag
#     tag_command = 'git tag -m "' + new_tag + '" ' + new_tag
#     os.system(tag_command)

#     # push tags
#     os.system('git push --tags')

# def podPush():
#     print("--------  waiting for pod push  ...... ---------")
#     os.system(pod_push_command)



# run commands
# initSpecCmd()
# updateVersion()
# podCommandEdit()
# #libLint()
# gitOperation()
# podPush()
