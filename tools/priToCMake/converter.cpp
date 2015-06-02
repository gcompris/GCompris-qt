/*
 * This script converts the .pri passed in parameter
 * and creates corresponding CMakeLists.txt
 * To compile, make converter.
 */
#include <string>
#include <iostream>
#include <fstream>
#include <algorithm>

using namespace std;

int main(int argc, char **argv) {

    if(argc < 2) {
        std::cerr << "Usage: " << argv[0] << " activity.pri\n" << std::endl;
        return -1;
    }

    std::string basename = argv[1];
    basename.erase(basename.begin() + basename.find_first_of("."), basename.end());

    // Create CMakeLists.txt file
    std::string outputName = "CMakeLists_" + basename + ".txt";
    std::ofstream cmakeOutput(outputName.c_str(), std::ios::out);
    cmakeOutput << "GCOMPRIS_ADD_RCC(activities/" << basename << " *.qml *.svg *.svgz *.js resource/*)\n";

    return 0;
}
