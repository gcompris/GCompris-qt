#! /usr/bin/python3

import sys
import os
import glob
import re

def initialize(activity_dir_name):	
    
    # js file name array
    js_files_array = glob.glob(
                        "../src/activities/" + activity_dir_name + "/**/*.js",
                        recursive=True)

    # qml file name array
    qml_files_array = glob.glob(
                        "../src/activities/" + activity_dir_name + "/**/*.qml",
                        recursive=True)

    return js_files_array, qml_files_array


# print error
def print_error(error):
    print("\tERROR:  ", error)


# print warning
def print_warning(error):
    print("\tWARNING:", error)


# checks 'variant' used instead of 'var'
def check_var(line_str, line_number):
    if "property variant" in line_str:
        print_warning("line:{} replace variant with var".format(line_number))


# checks import version
def check_import_version(line_str):
    # add modules and version in dictionary
    module_version_dict = { "QtQuick" : "2.6",
                            "QtGraphicalEffects" : "1.0",
                            "QtQuick.Controls" : "1.5",
                            "QtQml" : "2.2",
                            "QtQuick.Controls.Styles" : "1.4",
                            "QtQuick.Particles" : "2.0",
                            "QtSensors" : "5.0",
                            "QtMultimedia" : "5.0",
                            "GCompris" : "1.0",
                            "Box2D" : "2.0"}
    
    regex_string = re.compile(r"import (\w+) (\d+.\d+)")
    match_string = regex_string.search(line_str)
    if match_string:
        module_name = match_string.group(1)
        module_ver = match_string.group(2)
        correct_module_ver = module_version_dict[module_name]
        if module_ver != correct_module_ver:
            print_error("{} version must be {}".format(module_name, module_ver))


# checks credit updation
def check_credits_update(line_str):
    if "THE GTK VERSION AUTHOR" in line_str:
        print_error("Replace original GTK VERSION AUTHOR label by your own name")

    if "YOUR NAME <YOUR EMAIL>" in line_str or "\"YOUR NAME\" <YOUR EMAIL>" in line_str:
        print_error("Replace original Qt Quick copyright label email by your own email address")


# checks whether qsTr can be used in the line_str
def qsTr_use(line_str, line_number):
    regex_string = re.compile("""([^ ]+): ["][^"]+""")
    match_string = regex_string.search(line_str)
    if match_string:
        #if match_string.group(1) not in elements_to_escape:
            print_warning("line:{} {} qsTr may not be used".format(line_number, match_string.group(1)))


# checks copyrights updated
def activity_info_qml_file(line_str):
    values_to_test = ["author: \"Your Name &lt;yy@zz.org&gt;\"",
                      "name: \"test/Test.qml\"",
                      "difficulty: 1",
                      "icon: \"test/test.svg\"",
                      "demo: false",
                      "title: \"Test activity\"",
                      "description: \"\"",
                      "goal: \"\"",
                      "prerequisite: \"\"",
                      "manual: \"\"",
                      "credit: \"\"",
                      "section: \"\"",
                      "intro: \"put here in comment the " 
                      "text for the intro voice\""]
    
    for value in values_to_test:
        if value in line_str:
            if value == "difficulty: 1":
                print_warning("{} may not be updated.".format(value))
            else:
                print_error("{} may not be updated.".format(value))


# checks js files
def check_js_files(js_files_array):
    
    for js_file in js_files_array:
        with open(js_file, "r") as current_js_file:
            
            print("FilePath:", js_file)
            for line in current_js_file:
                check_credits_update(line)
                check_import_version(line)


# checks qml files
def check_qml_files(qml_files_array):
    
    for qml_file in qml_files_array:
        with open(qml_file, "r") as current_qml_file:

            line_number = 1
            print("FilePath:", qml_file)
            if os.path.basename(qml_file) == "ActivityInfo.qml":
                if "createdInVersion" not in current_qml_file.read():
                    print_error("ActivityInfo.qml does not have \"createdInVersion\":\n")
                # reset file pointer to the start
                current_qml_file.seek(0)
            
            for line in current_qml_file:
                if os.path.basename(qml_file) == "ActivityInfo.qml":
                    activity_info_qml_file(line)

                check_credits_update(line)
                qsTr_use(line, line_number)
                check_var(line, line_number)
                check_import_version(line)

                line_number += 1


# check if directory empty
def empty_directory(js_files_array, qml_files_array):

    if not js_files_array and not qml_files_array:
        sys.exit("No file to check! Did you enter a correct directory?")


def main():
    
    if len(sys.argv) < 2:
        sys.exit("\nMissing input filename."
                 "\nUsage: ./check_activity.py activity_directory_name"
                 "\neg: ./check_activity.py reversecount")
    
    js_files_array, qml_files_array = initialize(sys.argv[1])
    empty_directory(js_files_array, qml_files_array)
    check_js_files(js_files_array)
    check_qml_files(qml_files_array)


# if this file runs
if __name__ == "__main__":
    main()
