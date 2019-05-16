## Copyright (C) 2019 mosta
## 
## This program is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} filtLPF (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: mosta <mosta@DESKTOP-4LJLPCB>
## Created: 2019-01-27

function retval = filtLPF (input1, filtCoef)
  
alpha = filtCoef;
filterSF = input1(1);
for ii = 2:length(input1)
  filterSF(ii) = filterSF(ii-1) +  alpha*(input1(ii) - filterSF(ii-1));
end

retval = filterSF;

endfunction
