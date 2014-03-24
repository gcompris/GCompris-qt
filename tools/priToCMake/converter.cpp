/*
 * This script converts the .pri passed in parameter
 * and creates corresponding CMakeLists.txt and .qrc.
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

    
    std::string filename = argv[1];
    std::string basename = filename;
    basename.erase(basename.begin() + basename.find_first_of("."), basename.end());

    // Create qrc file    
    std::ifstream is(argv[1], std::ios::in);
    std::ofstream qrcOutput((basename + ".qrc").c_str(), std::ios::out);

    qrcOutput << "<RCC>\n    <qresource prefix=\"/gcompris/src/activities/"+basename+"\">\n";

    if (is.is_open()) {
        std::string str;
        while (is) {
            std::getline(is, str);
            
            if(!str.empty() && 
               (str.find("#") == std::string::npos) && 
               (str.find("APP_FILES") == std::string::npos) &&
               (str.find("SOURCES") == std::string::npos) && 
               (str.find("HEADERS") == std::string::npos) &&
               (str.find("OTHER") == std::string::npos)) {

                str.erase(remove(str.begin(), str.end(), ' '), str.end());
                str.erase(remove(str.begin(), str.end(), '\\'), str.end());
                str.erase(remove(str.begin(), str.end(), '\t'), str.end());

                str.erase( str.begin() + str.find_first_of("$"),
                           str.begin() + str.find_first_of("/")+1);

                qrcOutput << "        <file>" << str << "</file>\n";
            }
        }
        is.close();
    }

    qrcOutput << "    </qresource>\n</RCC>\n";

    // Create CMakeLists.txt file
    std::ofstream cmakeOutput("CMakeLists.txt", std::ios::out);
    cmakeOutput << " ### License ###\n";
    cmakeOutput << "set(gcompris_RCCS ${gcompris_RCCS} ${CMAKE_CURRENT_LIST_DIR}/" << basename + ".qrc" << " CACHE STRING \"resourceFile\" FORCE)\n";

    return 0;
}
