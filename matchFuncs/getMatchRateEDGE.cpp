#include "opencv2\opencv.hpp"
#include "mex.h"
using namespace cv;
void loadImageFromMatlab(const mxArray *mxImage, Mat& image) {

	unsigned char *values =  (unsigned char *) mxGetPr(mxImage);
	int N = mxGetN(mxImage); // width
	int M = mxGetM(mxImage); // height

	if (N == 0 || M == 0) {
		printf("Input image error\n");
		return;
	}

	for(int row=0;row<M;row++)
	{
		unsigned char * p1= image.ptr<unsigned char>(row);
		for(int col=0;col<N;col++) 
			p1[col] = values[row+col*M];
	}	
//	imshow("0",image);
//	waitKey(0);
}
double GetMatchRate(Mat& im0, Mat& im1, int winD, int evalStep, int matchStep, Mat& imF)
{
	int x=0,y=0,utime=0;
	Mat imwin(winD,winD,CV_8UC1);
	int sw= im0.cols-winD+1;
	int sh= im0.rows-winD+1;
    if(sw<1 || sh<1) 
        return 1;
	Mat result(sw,sh,CV_32FC1);
	double minVal,maxVal;
	Point minLoc,maxLoc;
	int rn=0, tn=0;
	GaussianBlur(im0, im0, Size(7, 7), 2, 2);	
	GaussianBlur(im1, im1, Size(7, 7), 2, 2);
	Canny(im0, im0, 30, 100, 3);
	Canny(im1, im1, 30, 100, 3);
	Mat im1d;
	const int nDilate = 3;
	for (int i=0;i<sh;i+=evalStep)
	{
		for (int j=0;j<sw;j+=evalStep)
		{
			im0(Range(i,i+winD), Range(j,j+winD)).copyTo(imwin);
			im1d = imwin.clone();
			imwin = imwin / (nDilate+1);
			for (int k = 0; k < nDilate; k++)
			{
				dilate(im1d, im1d, Mat());
				imwin = imwin + im1d / (nDilate + 1);
			}
			matchTemplate(im1,imwin,result,CV_TM_CCOEFF_NORMED);
			minMaxLoc(result,&minVal,&maxVal,&minLoc,&maxLoc);
			if(maxLoc.y-i<matchStep&& maxLoc.y-i>-matchStep && maxLoc.x-j<matchStep && maxLoc.x-j>-matchStep)
                rn++;  
			else
				imF.at<unsigned char>(j,i)= 255;
//				*((unsigned char*)(imF->imageData)+imF->widthStep*i+j)=255;
            tn++;
		}
	}	
	return rn/double(tn);
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs,const mxArray *prhs[]) 
{
    int w0= mxGetN(prhs[0]);
    int h0= mxGetM(prhs[0]);
	Mat im0,im1,imF;
	im0.create( w0,h0, CV_8UC1 );
    im1.create( w0,h0, CV_8UC1 );
	imF.create( w0,h0, CV_8UC1 );
    loadImageFromMatlab(prhs[0],im0);
    loadImageFromMatlab(prhs[1],im1);
    int winR= mxGetScalar(prhs[2]);
	int evalStep= mxGetScalar(prhs[3]);
	int matchStep= mxGetScalar(prhs[4]);
    plhs[0] = mxCreateDoubleMatrix( 1 ,  1, mxREAL);   
    double *M0 = mxGetPr(plhs[0]);
	plhs[1] = mxCreateNumericMatrix( w0 ,  h0, mxUINT8_CLASS, mxREAL);
	uchar *M1 = (uchar*)mxGetPr(plhs[1]);	
	memset(imF.data,0,imF.cols*imF.rows);
   *M0= GetMatchRate(im0,im1,winR,evalStep,matchStep,imF);
   for(int i=0;i<h0;i++)
   {
	    unsigned char * p1= imF.ptr<unsigned char>(i);
		for(int j=0;j<w0;j++)
			*(M1+j*h0+i)= p1[j];//*((unsigned char*)(imF->imageData)+imF->widthStep*i+j);
   }
}

