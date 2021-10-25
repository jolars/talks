if(!settings.multipleView) settings.batchView=false;
settings.tex="pdflatex";
settings.inlinetex=true;
deletepreamble();
defaultfilename="main-4";
if(settings.render < 0) settings.render=4;
settings.outformat="";
settings.inlineimage=true;
settings.embed=true;
settings.toolbar=false;
viewportmargin=(2,2);

import graph;
import contour;

size(80, 80);

path p = (-1,0)--(0,1)--(1,0)--(0,-1)--(-1,0);
draw(p);
xaxis("$\beta_1$", xmax = 1.5, xmin = -1.1);
yaxis("$\beta_2$", ymax = 1.5, ymin = -1.1);
