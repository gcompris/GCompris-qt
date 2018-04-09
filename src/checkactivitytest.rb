require_relative "checkActivities"
require "test/unit"

class TestCheckActivity < Test::Unit::TestCase

    @@outputFile = "testoutput.txt"
    @@expecOutputFile = "regressiontestoutput.txt"

    def change_stdout(file)
        $stdout = file
    end

    def test_check_files

        # generating expected output in @@outputFile
        ActivityCheck.initialize("testactivity")
        @testFile = File.open(@@outputFile, "w")
        change_stdout(@testFile)
        ActivityCheck.check_js_files
        ActivityCheck.check_qml_files
        change_stdout(STDOUT)
        @testFile.close

        # generating corresponding arrays
        @outputFileContents = Array.new
        @expecOutputFileContents = Array.new

        File.foreach(@@outputFile) { |line| @outputFileContents.push line }
        File.foreach(@@expecOutputFile) { |line| @expecOutputFileContents.push line }

        assert_equal(@expecOutputFileContents, @outputFileContents)

    end
end