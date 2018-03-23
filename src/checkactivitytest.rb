require_relative "checkActivities"
require "test/unit"

class TestCheckActivity < Test::Unit::TestCase

    @@outputFile = "testoutput.txt"
    @@expecOutputFile = "regressiontestoutput.txt"

    def change_stdout(file)
        if $stdout == STDOUT then $stdout = file
        else $stdout = STDOUT
        end
    end

    def test_check_files

        # generating expected output in @@outputFile
        ActivityCheck.initialize("testactivity")
        @testFile = File.open(@@outputFile, "w")
        change_stdout(@testFile)
        ActivityCheck.check_js_files
        ActivityCheck.check_qml_files
        change_stdout(@testFile)
        @testFile.close

        # generating corresponding arrays
        @outputFileContents = Array.new
        @expecOutputFileContents = Array.new

        File.foreach(@@outputFile) { |line| @outputFileContents.push line }
        File.foreach(@@expecOutputFile) { |line| @expecOutputFileContents.push line }

        assert_equal(@expecOutputFileContents, @outputFileContents)

    end

    def test_is_name_correct?

        # check correct name
        assert_equal("John Smith", ActivityCheck.is_name_correct?("John Smith"))

        # check wrong name
        assert_not_equal("John F. Kennedy", ActivityCheck.is_name_correct?("John F. Kennedy"))

    end

end