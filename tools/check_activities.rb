require 'pathname'


module ActivityCheck

    
    def self.readElementsToEscape
        @elementsToEscapeArray = Array.new
        f = File.open("./check_activities_ids_to_escape.txt", "r")
            f.each_line do |line|
                @elementsToEscapeArray.push(line.chomp.strip)
            end
        f.close

        puts "element ids escaped: "
        puts @elementsToEscapeArray

    end

    def self.initialize(activityDirName)

        # create js file name array
        @jsFilesArray = Dir.glob("../src/activities/" + activityDirName + "/**/*.js")

        # create qml file name array
        @qmlFilesArray = Dir.glob("../src/activities/" + activityDirName + "/**/*.qml")

    end

    # to print error
    def self.print_error(err)
        puts "\t ERROR       #{err}"
    end

    # to print warning
    def self.print_warning(wrn)
        puts "\t WARNING     #{wrn}"
    end

    # checks 'variant' used instead of 'var'
    def self.check_var (lineStr, lineNumber)
        if lineStr.include?("property variant")
            print_warning "line:#{lineNumber} replace variant with var"
        end
    end

    # checks import version
    def self.check_import_version(lineStr)
        # add modules and versions in hash
        moduleVersionHash = { "QtQuick" => "2.6", "QtGraphicalEffects" => "1.0",
                              "QtQuick.Controls" => "1.5", "QtQml" => "2.2",
                              "QtQuick.Controls.Styles" => "1.4",
                              "QtQuick.Particles" => "2.0", "QtSensors" => "5.0",
                              "QtMultimedia" => "5.0",
                              "GCompris" => "1.0", "Box2D" => "2.0" }

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

        if lineStr.include?("YOUR NAME <YOUR EMAIL>")
            print_warning "Replace original Qt Quick copyright label email by your own email address"
        end
    end

    # checks whether qsTr can be used in the lineStr
    def self.qsTr_use(lineStr, lineNumber)
        matchStr = /([^ ]+): "[^"]+"/.match(lineStr)
        if matchStr != nil
            if !@elementsToEscapeArray.include?(matchStr[1])
                print_warning "line:#{lineNumber} #{matchStr[1]} qsTr may not be used"
            end
        end
    end

    # checks copyrights updated
    def self.activityInfo_QmlFile(lineStr, directoryName)
        valuesToTestArray = ["author: \"Your Name &lt;yy@zz.org&gt;\"", "name: \"test/Test.qml\"", "difficulty: 1", "icon: \"test/test.svg\"",
                             "demo: false", "title: \"Test activity\"", "description: \"\"", "goal: \"\"", "prerequisite: \"\"",
                             "manual: \"\"", "credit: \"\"", "section: \"\"",
                             "intro: \"put here in comment the text for the intro voice\""]

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

            puts "FilePath: " + jsFile

            File.foreach(jsFile) do |line|

                check_credits_update line

                check_import_version line

            end
        end
    end

    def self.check_qml_files
        @qmlFilesArray.each do |qmlFile|

            lineNumber = 1
            puts "FilePath: " + qmlFile

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

                check_var line, lineNumber

                check_import_version line

                lineNumber = lineNumber + 1
            end
        end
    end


    def self.check_every_gcompris_activities
        dirArray = Dir.glob("../src/activities/*").select { |fn| File.directory?(fn) }
        dirArray.sort!
        
        dirArray.each { |dirName|
            dirName = File.basename(dirName)

            if (dirName != "." and dirName != "..")
                puts "\n\n\n*********************************--  " + dirName + " --***************************************"
                ActivityCheck.initialize(dirName)
                ActivityCheck.empty_directory?
                ActivityCheck.check_js_files
                ActivityCheck.check_qml_files
            end
        }
    end

 

end


# if it is the main file being run
if __FILE__ == $0
    if ARGV[0] == nil
        fail "\nMissing input filename.\nUsage: ruby checkActivities.rb activity_directory_name\neg: ruby checkActivity reversecount"
    end

    ActivityCheck.readElementsToEscape
    

    if ARGV[0] == "all"
        ActivityCheck.check_every_gcompris_activities
    else
        ActivityCheck.initialize(ARGV[0])
        ActivityCheck.empty_directory?
        ActivityCheck.check_js_files
        ActivityCheck.check_qml_files
    end
end


