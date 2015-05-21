#include "opencv\cv.h"
#include "opencv\highgui.h"
#include "mex.h"

void loadImageFromMatlab(const mxArray *mxImage, IplImage *image) {

	unsigned char *values =  (unsigned char *) mxGetPr(mxImage);
	int widthStep = image->widthStep;
	int N = mxGetN(mxImage); // width
	int M = mxGetM(mxImage); // height

	if (N == 0 || M == 0) {
		printf("Input image error\n");
		return;
	}

	for(int i=0;i<N;i++)
		for(int j=0;j<M;j++) 
			image->imageData[j*widthStep+i] = values[j+i*M];
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs,const mxArray *prhs[]) 
{
    int w0= mxGetN(prhs[0]);
    int h0= mxGetM(prhs[0]);
	IplImage *im0 = cvCreateImage( cvSize(w0,h0), 8, 1 );
    loadImageFromMatlab(prhs[0],im0);
    
    int w1= mxGetN(prhs[1]);
    int h1= mxGetM(prhs[1]);
	IplImage *im1 = cvCreateImage( cvSize(w1,h1), 8, 1 );
    loadImageFromMatlab(prhs[1],im1);
    
    int sw, sh;
    sw= w0-w1+1;
    sh= h0-h1+1;
    IplImage *imRslt = cvCreateImage( cvSize(sw,sh), 32, 1 );    
    cvMatchTemplate(im0,im1,imRslt,CV_TM_CCOEFF_NORMED);
    plhs[0] = mxCreateDoubleMatrix( sh ,  sw, mxREAL);   
   double *ML= mxGetPr(plhs[0]);
   int i,j;
   for(i=0;i<sh;i++)
       for(j=0;j<sw;j++)
           *(ML+j*sh+i)= *(float*)((char*)(imRslt->imageData)+imRslt->widthStep*i+j*4);
    cvReleaseImage(&im0);
    cvReleaseImage(&im1);
   cvReleaseImage(&imRslt);
}

