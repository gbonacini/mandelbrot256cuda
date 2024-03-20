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
 
 
 #pragma once

 #include <complex>
 #include <vector>
 #include <initializer_list>

 #include <thrust/complex.h>


 namespace mandelbrot256cuda {

 using Complex=thrust::complex<double>;
 using Palette=std::vector<unsigned char>;
 using PaletteInit=std::initializer_list<unsigned char>;

  __global__  void cudaRender(int* out, int pixels, int width, int height, int maxiter, Complex span, Complex begin ) ;

 class MandelbrotShell{
     private:
         const   size_t  MIN_PALETTE_LEN { 8 };
         int     width,
                 height,
                 zoom,
                 pixels,
                 deltax,
                 deltay,
                 maxiter,
		 cudaBlocks,
		 *out { nullptr };


         Complex center,
                 span,
                 begin;

         Palette palette { 0x32, 0xA8, 0xB2, 0xC0, 0x6D, 0x80, 0x82, 0xE8, 0xF0, 0xF2, 0xFA, 0xFD };
     public:
        explicit   MandelbrotShell(int w=400, 
                                   int h=400, 
                                   int z=1, 
                                   int dx=1, 
                                   int dy=1, 
                                   int max=10000,
				   int blocks=256)         noexcept;
	~MandelbrotShell(void)                             noexcept;
        void       render(void)                    const   noexcept;
        void       print(void)                     const   noexcept;
        void       setFullColours(void)                    noexcept;
        void       setWidth(int ww)                        noexcept;
        void       setHeight(int hh)                       noexcept;
        void       setZoom(int zz)                         noexcept;
        void       setDeltaX(int dx)                       noexcept;
        void       setDeltaY(int dy)                       noexcept;
        void       setMaxiter(int max)                     noexcept;
        void       setCustomPalette(PaletteInit init)      noexcept;


 };

 } // End Namespace
