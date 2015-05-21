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
short** SetAngleLUT()
{
	short** pAngleLUT = new short*[255];
	int i, j, temp;
	for( i=0; i<255; i++ )
	{
		pAngleLUT[i] = new short[255];
	}
	for( i=0; i<255; i++ )
	{
		for( j=0; j<255; j++ )
		{
			pAngleLUT[j][i] = 0;
			if( i > 1 && j > 1 )
			{
				temp = abs( i- j );
				if( temp > 90 )
					temp = 180- temp;
				if( temp < 45 )
				{
					//					pAngleLUT[j][i] = (45-temp)* (45-temp);
					pAngleLUT[j][i] = (45-temp)>0? (45-temp): (temp-45);
				}
			}
		}
	}
	return pAngleLUT;
}
// 梯度方向相关
//  梯度方向图
void Image_Sobel_Direction_Fast(uchar* pImage, int width, int height, int avgsize )
{
	int	i, j, x, y, index, Imagesize= width* height;
	double angle;
	int* pDx = new int[Imagesize];
	int* pDy = new int[Imagesize];
	uchar* pTemp= new uchar[Imagesize];
	for( x=1; x<width-1; x++ )
	{
		for( y=1; y<height-1; y++ )
		{
			index = y* width+ x;
			pDx[index] = pImage[index+1]- pImage[index-1];
			pDy[index] = pImage[index+width]- pImage[index-width];
		}
	}	
	memset( pTemp, 1, Imagesize );// 1 表示数据为空
	int arm = avgsize;
	int dx, dy, sumd, nG, vx, vy;
	for( x = arm+1; x < width - arm-1; x ++)
	{
		for( y = arm+1;  y < height - arm-1; y ++)
		{
			vx = vy = sumd = 0;
			for( i = -arm; i <= arm; i++ )
			{
				for( j = -arm; j <= arm; j++ )
				{
					index = (y+j)* width+ x+i;
					dx = pDx[index-width]+ 2*pDx[index]+ pDx[index+width];
					dy = pDy[index-1]+ 2*pDy[index]+ pDy[index+1];
					vx += 2* dx* dy;
					dx = dx* dx, dy = dy* dy;
					vy += dx- dy;
					sumd += dx+ dy;
				}
			}
			nG  = sumd/ (2*arm+1)/ (2*arm+1);
			angle = ( CV_PI- atan2( double(vy), vx ) )/*/ 2.0+PI/2*/;
			pTemp[y*width+x] = (unsigned char)( int(angle/ CV_PI* 90)+ 74); //74~253
		}
	}
	memcpy( pImage, pTemp, Imagesize );
	delete []pDx;
	delete []pDy;
	delete []pTemp;
}
// 梯度方向相关
//  梯度方向图
void Template_Sobel_Direction_Fast(uchar* pImage, int width, int height, int avgsize )
{
	int	i, j, x, y, index, Imagesize= width* height;
	double angle;
	int* pDx = new int[Imagesize];
	int* pDy = new int[Imagesize];
	uchar* pTemp= new uchar[Imagesize];
	for( x=1; x<width-1; x++ )
	{
		for( y=1; y<height-1; y++ )
		{
			index = y* width+ x;
			pDx[index] = pImage[index+1]- pImage[index-1];
			pDy[index] = pImage[index+width]- pImage[index-width];
		}
	}	
	memset( pTemp, 1, Imagesize );// 1 表示数据为空
	int arm = avgsize;
	int dx, dy, sumd, nG, vx, vy;
	for( x = arm+1; x < width - arm-1; x ++)
	{
		for( y = arm+1;  y < height - arm-1; y ++)
		{
			vx = vy = sumd = 0;
			for( i = -arm; i <= arm; i++ )
			{
				for( j = -arm; j <= arm; j++ )
				{
					index = (y+j)* width+ x+i;
					dx = pDx[index-width]+ 2*pDx[index]+ pDx[index+width];
					dy = pDy[index-1]+ 2*pDy[index]+ pDy[index+1];
					vx += 2* dx* dy;
					dx = dx* dx, dy = dy* dy;
					vy += dx- dy;
					sumd += dx+ dy;
				}
			}
			nG  = sumd/ (2*arm+1)/ (2*arm+1);
			angle = ( CV_PI- atan2( double(vy), vx ) )/*/ 2.0+PI/2*/;
			pTemp[y*width+x] = nG < 1000 ? 0 : (unsigned char)( int(angle/ CV_PI* 90)+ 74); //74~253
		}
	}
	memcpy( pImage, pTemp, Imagesize );
	delete []pDx;
	delete []pDy;
	delete []pTemp;
}
int GetSim_fast(uchar *pRef, int refwstep, uchar *pReal, int realw, int realh, int realwstep, short** pLUT)
{
	int i,j,dref,dreal,sum=0;
	for (i=0;i<realh;i++)
	{
		for (j=0;j<realw;j++)
		{
			dref=*(pRef+i*refwstep+j);
			dreal=*(pReal+i*realwstep+j);
			sum = sum+ pLUT[dreal][dref]*(dref>0 && dreal>0);
		}
	}
	return sum;
}
void GetSimMap( IplImage *pLargeImg, IplImage *pSmallImg,IplImage *pSimMap, int matchStep)
{
	uchar* pRefImg= (uchar*)pLargeImg->imageData;
	uchar* pRealImg= (uchar*)pSmallImg->imageData;
	int realw = pSmallImg->width;
	int realwstep= pSmallImg->widthStep;
	int realh = pSmallImg->height;
	int refw  = pLargeImg->width;
	int refwstep= pLargeImg->widthStep;
	int refh = pLargeImg->height;
	int srWidth, srHeight;
	srWidth = refw-realw+1;
	srHeight= refh-realh+1;
	short** pAngleLUT= SetAngleLUT();
    
	cvSmooth(pLargeImg,pLargeImg,CV_GAUSSIAN,5);
	Image_Sobel_Direction_Fast( pRefImg, refwstep, refh, 1 );

	cvSmooth(pSmallImg,pSmallImg,CV_GAUSSIAN,5);
	Image_Sobel_Direction_Fast( pRealImg, realwstep, realh, 1 );
    
	int i,j;
	for(i= 0; i< srHeight; i+=matchStep)
	{
		for(j= 0; j< srWidth; j+=matchStep)
		{
			*(float*)((char*)(pSimMap->imageData)+pSimMap->widthStep*i+j*4) =
					GetSim_fast( pRefImg+i*refwstep+j, refwstep,
						pRealImg,realw,realh,realwstep,pAngleLUT);	
		 }
	}
	// 清理内存
	for( i=0; i<255; i++ )
	{
		delete[] pAngleLUT[i];
	}
	delete[] pAngleLUT;
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
    GetSimMap(im0,im1,imRslt,1);	
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

