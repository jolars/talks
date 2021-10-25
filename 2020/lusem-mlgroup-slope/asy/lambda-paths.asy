import graph;
import gsl;

import graph;
import gsl;

size(160, 160, IgnoreAspect);

real p = 100;

real oscar(real i) {
    real q = 0.02;
    real p = 100;
    return q*(p - i) + 1.0;
}

real bh(real i) {
    real p = 100;
    real q = 0.2;
    return cdf_gaussian_Pinv(1 - q*i/(2*p), mu = 0, sigma = 1);
}

int p = 100;
int n = 300;

real bh_seq[] = new real[p];
real oscar_seq[] = new real[p];
real gaussian_seq[] = new real[p];
real i_seq[] = new real[p];
real cumsum = 0.0;

for (int i = 0; i < 100; ++i) {
    i_seq[i] = i + 1;
    oscar_seq[i] = 0.01*(p - i + 1) + 1.5;
    bh_seq[i] = cdf_gaussian_Pinv(1 - 0.2*(i+1)/(2*p), mu = 0, sigma = 1);
    if (i == 0) {
        gaussian_seq[i] = bh_seq[i];
    } else {
        gaussian_seq[i] = bh_seq[i]*sqrt(1 + cumsum/(n-i+1));
        if (gaussian_seq[i] > gaussian_seq[i-1])
            gaussian_seq[i] = gaussian_seq[i-1];
    }

    cumsum = cumsum + gaussian_seq[i]*gaussian_seq[i];
}

draw(graph(i_seq, oscar_seq));
draw(graph(i_seq, bh_seq));
draw(graph(i_seq, gaussian_seq));

xaxis("\(i\)", Bottom, LeftTicks);
yaxis("\(\lambda\)", Left, RightTicks);
