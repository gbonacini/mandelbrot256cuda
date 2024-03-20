// ---------------------------------------------------------------------------
// mandelbrot256cuda - a command line program able to render Mandelbrot set 
//                on terminal supporting ANSI ecape sequences.
// Copyright (C) 2024  Gabriele Bonacini
//
// This program is free software for no profit use, then you can redistribute 
// it and/or modify it under the terms of the GNU General Public License 
// as published by the Free Software Foundation; either version 2 of 
// the License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software Foundation,
// Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
// A commercial license is also available for a lucrative use.
// ---------------------------------------------------------------------------

 #include <stdlib.h>

 #include <string>
 #include <iostream>

 #include <parseCmdLine.hpp>
 #include <mandelbrot256cuda.hpp> 

 using namespace parcmdline;
 using namespace mandelbrot256cuda;
 using std::cerr,
       std::stoi,
       std::string;

 #ifdef __clang__
   void printInfo(char* cmd) __attribute__((noreturn));
 #else
   [[ noreturn ]]
   void printInfo(char* cmd);
 #endif
 
 int main(int argc, char** argv){ 
     const char       flags[]      { "Hw:h:m:z:u:d:l:r:b:"};
     ParseCmdLine     pcl          {argc, argv, flags};

     if(pcl.getErrorState()){
        string exitMsg{string("Invalid  parameter or value").append(pcl.getErrorMsg())};
        cerr << exitMsg << "\n";
        printInfo(argv[0]);
     }

     int width  { 400 },
         height { 400 },
         zoom   { 1 },
         deltax { 0 },
         deltay { 0 },
         maxit  { 10000 },
	 blocks {256 };

     if( pcl.isSet('u') && pcl.isSet('d') ){
        cerr << "Invalid args: -u and -d are mutually exclusive\n";
        printInfo(argv[0]);
     }

     if( pcl.isSet('l') && pcl.isSet('r') ){
        cerr << "Invalid args: -l and -r are mutually exclusive\n";
        printInfo(argv[0]);
     }

     if(pcl.isSet('H')) printInfo(argv[0]);
     if(pcl.isSet('w')) width = stoi(pcl.getValue('w'));
     if(pcl.isSet('h')) height = stoi(pcl.getValue('h'));
     if(pcl.isSet('z')) zoom = stoi(pcl.getValue('z'));
     if(pcl.isSet('u')) deltay = stoi(pcl.getValue('u'));
     if(pcl.isSet('d')) deltay = -1 * stoi(pcl.getValue('d'));
     if(pcl.isSet('l')) deltax = -1 * stoi(pcl.getValue('l'));
     if(pcl.isSet('r')) deltax = stoi(pcl.getValue('r'));
     if(pcl.isSet('m')) maxit = stoi(pcl.getValue('m'));
     if(pcl.isSet('b')) blocks = stoi(pcl.getValue('b'));

     if(width < 50 || height < 50 ){
        cerr << "Invalid dimensions: image should be at least 50x50\n";
        printInfo(argv[0]);
     }

     MandelbrotShell mbs(width, height, zoom, deltax, deltay, maxit, blocks);
     // mbs.setCustomPalette({17,35,45,85,105,38,13,27});
     mbs.setFullColours();
     mbs.render();
     mbs.print();
     
     return 0;  
 }

 void printInfo(char* cmd){
      cerr << cmd << " [-h <height>] [-w <width>] [-m <iterations>] | [-H]\n\n";
      cerr << " -m  <iterations>  number of iterations\n";
      cerr << " -w  <width>       specifies image width\n";
      cerr << " -h  <height>      specifies image height\n";
      cerr << " -z  <factor>      specifies zooming factor\n";
      cerr << " -u  <units>       move center up\n";
      cerr << " -d  <units>       move center down\n";
      cerr << " -l  <units>       move center left\n";
      cerr << " -r  <units>       move center rigth\n";
      cerr << " -b  <units>       Cuda block size\n";
      cerr << " -H                print this synopsis\n";
      exit(EXIT_FAILURE);
 }
