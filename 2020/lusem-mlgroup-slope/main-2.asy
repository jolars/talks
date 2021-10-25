if(!settings.multipleView) settings.batchView=false;
settings.tex="pdflatex";
settings.inlinetex=true;
deletepreamble();
defaultfilename="main-2";
if(settings.render < 0) settings.render=4;
settings.outformat="";
settings.inlineimage=true;
settings.embed=true;
settings.toolbar=false;
viewportmargin=(2,2);

import graph;
import contour;

size(150, 150);

path p = (-1,0)--(-0.75,0.75)--
(0,1)--(0.75,0.75)--
(1,0)--(0.75,-0.75)--
(0,-1)--(-0.75,-0.75)--(-1,0);
draw(p);

xaxis("$\beta_1$", xmax = 1.2, xmin = -1.2);
yaxis("$\beta_2$", ymin = -1.2, ymax = 1.2);
