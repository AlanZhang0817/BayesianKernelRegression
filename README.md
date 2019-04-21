# BayesianKernelRegression

This project focuses on image denoising task with Bayesian Approach. Specifically, the idea of kernel regression is implemented. 

high-level program flow:
The denoising task is opertaed pixel-wise. For each point, the algorithm construct the poeterior under the Bayesian Framework. The final decision is made by using model averaging from all w_MAP.

To run the result, open Matlab and directly run the "test3.m" file, which will output two denoised images from both classical Gaussian Filtering and our approach.

Run time: 10 -20 mins. Device: Macbook pro 15' mid


