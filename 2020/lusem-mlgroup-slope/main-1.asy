if(!settings.multipleView) settings.batchView=false;
settings.tex="pdflatex";
settings.inlinetex=true;
deletepreamble();
defaultfilename="main-1";
if(settings.render < 0) settings.render=4;
settings.outformat="";
settings.inlineimage=true;
settings.embed=true;
settings.toolbar=false;
viewportmargin=(2,2);

import graph;
import contour;

size(180, 180);

pair x0 = (1.6, 0.8);

dot(x0);
draw(circle(x0, 0.822), dashed);
draw(circle(x0, 1.3), dashed);
draw(circle(x0, 0.344), dashed);

pair p1 = (1.6, 0.8);
dot("$\hat\beta$", p1);

xaxis("$\beta_1$", xmin = -1.1);
yaxis("$\beta_2$", ymin = -1.1);
