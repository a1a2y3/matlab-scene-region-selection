#include "opencv2\opencv.hpp"
#include "opencv2/nonfree/features2d.hpp"
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
	int x = 0, y = 0, utime = 0;
	Mat imwin(winD, winD, CV_8UC1);
	int sw = im0.cols - winD + 1;
	int sh = im0.rows - winD + 1;
	if (sw<1 || sh<1)
		return 1;
	int rn = 0, tn = 0;
	int minHessian = 400;
	SurfFeatureDetector detector(minHessian);
	std::vector<KeyPoint> keypoints_scene;
	detector.detect(im1, keypoints_scene);
	SurfDescriptorExtractor extractor;
	Mat descriptors_scene;
	extractor.compute(im1, keypoints_scene, descriptors_scene);
	FlannBasedMatcher matcher;
	for (int i = 0; i<sh; i += evalStep)
	{
		for (int j = 0; j<sw; j += evalStep)
		{
			im0(Range(i, i + winD), Range(j, j + winD)).copyTo(imwin);
			// match SURF start
			//-- Step 1: Detect the keypoints using SURF Detector
			std::vector<KeyPoint> keypoints_object;
			detector.detect(imwin, keypoints_object);
			//-- Step 2: Calculate descriptors (feature vectors)
			Mat descriptors_object;
			extractor.compute(imwin, keypoints_object, descriptors_object);
			//-- Step 3: Matching descriptor vectors using FLANN matcher			
			std::vector< DMatch > matches;
			matcher.match(descriptors_object, descriptors_scene, matches);
			double max_dist = 0; double min_dist = 100;

			//-- Quick calculation of max and min distances between keypoints
			for (int k = 0; k < descriptors_object.rows; k++)
			{
				double dist = matches[k].distance;
				if (dist < min_dist) min_dist = dist;
				if (dist > max_dist) max_dist = dist;
			}
			//-- Draw only "good" matches (i.e. whose distance is less than 3*min_dist )
			std::vector< DMatch > good_matches;
			for (int i = 0; i < descriptors_object.rows; i++)
			{
				if (matches[i].distance < 3 * max(min_dist, 0.02))
				{
					good_matches.push_back(matches[i]);
				}
			}
			//-- Localize the object from img_1 in img_2
			std::vector<Point2f> obj;
			std::vector<Point2f> scene;

			for (size_t k = 0; k < good_matches.size(); k++)
			{
				//-- Get the keypoints from the good matches
				obj.push_back(keypoints_object[good_matches[k].queryIdx].pt);
				scene.push_back(keypoints_scene[good_matches[k].trainIdx].pt);
			}

			Mat H = findHomography(obj, scene, CV_RANSAC);
			//-- Get the corners from the image_1 ( the object to be "detected" )
			std::vector<Point2f> obj_corners(1);
			obj_corners[0] = Point(0, 0); 
			std::vector<Point2f> scene_corners(0);

			perspectiveTransform(obj_corners, scene_corners, H);
			// match SURF over
			if (scene_corners[0].y - i<matchStep&& scene_corners[0].y - i>-matchStep &&
				scene_corners[0].x - j<matchStep && scene_corners[0].x - j>-matchStep)
				rn++;
			else
				imF.at<unsigned char>(j, i) = 255;
			tn++;
		}
	}
	return rn / double(tn);
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

