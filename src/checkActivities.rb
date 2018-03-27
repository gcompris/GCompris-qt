require 'colorize'
require 'git'

module ActivityCheck

    def self.initialize(activityDirName)
        @activityDirName = activityDirName

        # create js file name array
        @jsFilesArray = Dir.glob("../src/activities/" + @activityDirName + "/*.js")

        # create qml file name array
        @qmlFilesArray = Dir.glob("../src/activities/" + @activityDirName + "/*.qml")

        # create git instance variable
        @git = Git.open(Dir.pwd + "/../")
    end

    # to print error
    def self.print_error(err)
        puts "\t#{" ERROR ".colorize(background: :red)}      #{err}"
    end

    # to print warning
    def self.print_warning(wrn)
        puts "\t#{" WARNING ".colorize(background: :yellow)}    #{wrn}"
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
    def self.qsTr_use(lineStr)
        matchStr = /(?<qsTr>(qsTr)\()?"[\w'!?:;]+( .*)*[.,]? ?"/.match(lineStr)
        if matchStr and not matchStr["qsTr"]
            print_warning "#{matchStr} qsTr may not be used"
        end
    end

    # checks copyrights updated
    def self.activityInfo_QmlFile(lineStr, directoryName)
        valuesToTestArray = ["author: \"Your Name &lt;yy@zz.org&gt;\"", "name: \"test/Test.qml\"", "difficulty: 1", "icon: \"test/test.svg\"",
                             "demo: true", "title: \"Test activity\"", "description: \"\"", "goal: \"\"", "prerequisite: \"\"",
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

            end
        end
    end

    def self.check_qml_files
        @qmlFilesArray.each do |qmlFile|

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

                qsTr_use line

            end
        end
    end

    def self.is_name_correct?(name)
        match = /^\b[\w\S]+\b \b[\w\S]+\b$/.match(name)
        if match then match[0]
        else nil
        end
    end

    # check commit names
    def self.check_commit_names(commitCount)
        puts "\nCommit Name Errors"
        @git.log(commitCount).each do |commitHash|
            unless is_name_correct?(commitHash.author.name) then puts print_error "'Name: #{commitHash.author.name}' ##{commitHash} Format: FirstName SecondName" end
        end
    end
end

# if it is the main file being run
if __FILE__ == $0
    if ARGV[0] == nil or ARGV[1] == nil
        fail "\nMissing input filename or commit count.\nUsage: ruby checkActivities.rb activity_directory_name commit_count\neg: ruby checkActivity reversecount 3"
    end

    commitCount = ARGV[1].to_i

    if commitCount < 1
        fail "\nLeast Commits to check: 1"
    end

    ActivityCheck.initialize(ARGV[0])
    ActivityCheck.empty_directory?
    ActivityCheck.check_js_files
    ActivityCheck.check_qml_files
    ActivityCheck.check_commit_names(commitCount)
end
