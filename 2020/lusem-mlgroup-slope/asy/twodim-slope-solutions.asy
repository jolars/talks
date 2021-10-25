settings.outformat = "pdf";

import graph;
import contour;

size(180, 180);

path p = (-1,0)--(-0.75,0.75)--(0,1)--(0.75,0.75)--(1,0)--(0.75,-0.75)--(0,-1)--(-0.75,-0.75)--(-1,0);
draw(p);
draw(scale(0.5)*p);

pair x0 = (1.6, 0.8);

dot(x0);
draw(circle(x0, 0.822), dashed);
draw(circle(x0, 1.3), dashed);
draw(circle(x0, 0.344), dashed);

pair p1 = (0.75/2, 0.75/2);
dot("$\beta^*_{\lambda^{(1)}}$", p1);

pair p2 = (0.805, 0.59);
dot("$\beta^*_{\lambda^{(2)}}$", p2);

xaxis("$\beta_1$", xmin = -1.1);
yaxis("$\beta_2$", ymin = -1.1);
