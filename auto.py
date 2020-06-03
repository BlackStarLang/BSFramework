import os, sys
import fileinput

# ======================  edit by yourself  ======================
sources = [
          'https://github.com/blackstar_lang@163.com/BSFrameworks.git',
          ]

spec_libraries_name = 'cocoapods'
use_libraries = '--use-libraries'
is_allow_warnings = True
is_use_libraries = True
is_show_verbose_log = False
# ==================================================================

new_tag = ""
lib_command = ""
pod_push_command = ""
podspec_file_name = ""
spec_file_path = ""
allow_warnings = ""
use_libraries = ""
show_verbose_log = ""
find_version_flag = False


def initSpecCmd():
    current_file = os.getcwd()
    list_file = os.path.split(current_file)
    global podspec_file_name
    global spec_file_path
    global allow_warnings
    global use_libraries
    global show_verbose_log

    podspec_file_name = list_file[-1] + ".podspec"
    spec_file_path = "./" + podspec_file_name

    if (is_allow_warnings):
        allow_warnings = " --allow-warnings"
    else:
        allow_warnings = ""

    if (is_show_verbose_log):
        show_verbose_log = " --verbose"
    else:
        show_verbose_log = ""

    if (is_use_libraries):
        use_libraries = " --use-libraries"
    else:
        use_libraries = ""


def podCommandEdit():
    global lib_command
    global pod_push_command

    source_suffix = 'https://github.com/CocoaPods/Specs.git'
    lib_command = 'pod lib lint --sources='
    pod_push_command = 'pod trunk push ' + spec_libraries_name + ' ' + podspec_file_name
    if len(sources) > 0:
        # rely on  private sourece
        pod_push_command += ' --sources='

        for index,source in enumerate(sources):
            lib_command += source
            lib_command += ','
            pod_push_command += source
            pod_push_command += ','
        pod_push_command = pod_push_command + source_suffix + allow_warnings + show_verbose_log + use_libraries
    else:
        lib_command = 'pod lib lint'

    lib_command = lib_command + source_suffix + allow_warnings + show_verbose_log + use_libraries
    print lib_command
    print pod_push_command

def updateVersion():
    f = open(spec_file_path, 'r+')
    infos = f.readlines()
    f.seek(0, 0)
    file_data = ""
    new_line = ""
    global find_version_flag

    for line in infos:
        if line.find(".version") != -1:
            if find_version_flag == False:
                # find s.version = "xxxx"

                spArr = line.split('.')
                last = spArr[-1]
                last = last.replace('"', '')
                last = last.replace("'", "")
                newNum = int(last) + 1

                arr2 = line.split('"')
                arr3 = line.split("'")

                versionStr = ""
                if len(arr2) > 2:
                    versionStr = arr2[1]

                if len(arr3) > 2:
                    versionStr = arr3[1]
                numArr = versionStr.split(".")

                numArr[-1] = str(newNum)
                # rejoint string
                global new_tag
                for index,subNumStr in enumerate(numArr):
                    new_tag += subNumStr
                    if index < len(numArr)-1:
                        new_tag += "."

                # complete new_tag

                if len(arr2) > 2:
                    line = arr2[0] + '"' + new_tag + '"' + '\n'

                if len(arr3) > 2:
                    line = arr3[0] + "'" + new_tag + "'" + "\n"

                # complete new_line

                print "this is new tag  " + new_tag
                find_version_flag = True

        file_data += line


    with open(spec_file_path, 'w', ) as f1:
        f1.write(file_data)

    f.close()

    print "--------- auto update version -------- "


def libLint():
    print("-------- waiting for pod lib lint checking ...... ---------")
    os.system(lib_command)

def gitOperation():
    os.system('git add .')
    commit_desc = "version_" + new_tag
    commit_command = 'git commit -m "' + commit_desc + '"'
    os.system(commit_command)
    # git push
    r = os.popen('git symbolic-ref --short -q HEAD')
    current_branch = r.read()
    r.close()
    push_command = 'git push origin ' + current_branch

    # tag
    tag_command = 'git tag -m "' + new_tag + '" ' + new_tag
    os.system(tag_command)

    # push tags
    os.system('git push --tags')

def podPush():
    print("--------  waiting for pod push  ...... ---------")
    os.system(pod_push_command)



# run commands
initSpecCmd()
updateVersion()
podCommandEdit()
#libLint()
gitOperation()
podPush()
