module ActivityCheck

    def self.initialize(activityDirName)
        @activityDirName = activityDirName

        # create js file name array
        @jsFilesArray = Dir.glob("../src/activities/" + @activityDirName + "/**/*.js")

        # create qml file name array
        @qmlFilesArray = Dir.glob("../src/activities/" + @activityDirName + "/**/*.qml")

    end

    # to print error
    def self.print_error(err)
        puts "\t ERROR       #{err}"
    end

    # to print warning
    def self.print_warning(wrn)
        puts "\t WARNING     #{wrn}"
    end

    # checks import version
    def self.check_import_version(lineStr)
        # add modules and versions in hash
        moduleVersionHash = { "QtQuick" => "2.6", "GCompris" => "1.0" }

        matchStr = /import (?<module>(\w+)) (?<ver>(\d+.\d+))/.match(lineStr)
        if matchStr
            moduleName = matchStr["module"]
            correctModuleVersion = moduleVersionHash[moduleName]
            if matchStr["ver"] != correctModuleVersion
                print_error "#{moduleName} version must be #{correctModuleVersion}"
            end
        end
    end

    # checks credit updation
    def self.check_credits_update(lineStr)
        if lineStr.include?("THE GTK VERSION AUTHOR")
            print_error "Replace original GTK VERSION AUTHOR label by your own name"
        end

        if lineStr.include?("THE GTK VERSION AUTHOR")
            print_warning "Replace original QT Quick copyright label email by your own email address"
        end
    end

    # checks whether qsTr can be used in the lineStr
    def self.qsTr_use(lineStr, lineNumber)
        matchStr = /(?<qsTr>(qsTr)\()?"[\w'!?:;]+( .*)*[.,]? ?"/.match(lineStr)
        if matchStr and not matchStr["qsTr"]
            print_warning "line:#{lineNumber} #{matchStr} qsTr may not be used"
        end
    end

    # checks copyrights updated
    def self.activityInfo_QmlFile(lineStr, directoryName)
        valuesToTestArray = ["author: \"Your Name &lt;yy@zz.org&gt;\"", "name: \"test/Test.qml\"", "difficulty: 1", "icon: \"test/test.svg\"",
                             "demo: false", "title: \"Test activity\"", "description: \"\"", "goal: \"\"", "prerequisite: \"\"",
                             "manual: \"\"", "credit: \"\"", "section: \"\""]

        valuesToTestArray.each do |valueToTestStr|
            if lineStr.include?(valueToTestStr)
                if valueToTestStr.include?("difficulty: 1") then print_warning "#{valueToTestStr} may not be updated."
                else print_error "#{valueToTestStr} may not be updated."
                end
            end
        end
    end

    # check if directory empty
    def self.empty_directory?
        if @qmlFilesArray.empty? and @jsFilesArray.empty?
            fail "No file to check! Did you enter a correct directory?"
        end
    end

    def self.check_js_files
        @jsFilesArray.each do |jsFile|

            puts "\nFilePath: " + jsFile

            File.foreach(jsFile) do |line|

                check_credits_update line

                check_import_version line

            end
        end
    end

    def self.check_qml_files
        @qmlFilesArray.each do |qmlFile|

            lineNumber = 1
            puts "\nFilePath: " + qmlFile

            # Assuming ActivityInfo.qml won't be much bigger
            if File.basename(qmlFile) == "ActivityInfo.qml"
                unless File.foreach(qmlFile).grep(/createdInVersion:/).any?
                    print_error "ActivityInfo.qml does not have \"createdInVersion\":\n\n"
                end
            end

            File.foreach(qmlFile) do |line|

                if File.basename(qmlFile) == "ActivityInfo.qml"
                    activityInfo_QmlFile line, @activityDirName
                end

                check_credits_update line

                qsTr_use line, lineNumber

                check_import_version line

                lineNumber = lineNumber + 1
            end
        end
    end
end

# if it is the main file being run
if __FILE__ == $0
    if ARGV[0] == nil
        fail "\nMissing input filename.\nUsage: ruby checkActivities.rb activity_directory_name\neg: ruby checkActivity reversecount"
    end

    ActivityCheck.initialize(ARGV[0])
    ActivityCheck.empty_directory?
    ActivityCheck.check_js_files
    ActivityCheck.check_qml_files
end
