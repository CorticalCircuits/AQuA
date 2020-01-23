# AQuA for 3D
This is the development repository for the 3D version of AQuA. We will not include the GUI at this moment. The visualization should be done with external applications like Vaa3D.

# Example synthetic data
Download data from 
[here](https://1drv.ms/f/s!AmZJxr5-ArTyipImn4F_VQDGg0lpVQ). It contains the following files:

* `/Volterra3d/cell3d.mat`: extracted cell.
* `/evt_3D_25/`: data with 25 larer events. Noise standard deviation is 0.03. Each TIFF file is a TIFF stack, with `D` grayscale images each with size `H` by `W`. `D` is the number of stacks in the `z` direction.
* `/evt_3D_25_75/`: same as above, but with extra 75 smaller events.
* `/evt_3D_25.mat`: it contains `evtLst`, which is the groundtruth locations of each event. `sz` is the size of the movie (`H, W, D, T`).

# Generate synthetic data
Use script `sim_3d.m` to generate synthetic data. You need to set the corresponding input files and output files.

# Write movie
Use function `writeTiff5D()` to write the 4D data to disk. The major input is an `H x W x D x T` array. Each `H x W x D` subarray for each frame will be written to a separate TIFF file. Then we can use Vaa3D to read that folder. You also need to specify the output folder and file names. You can also choose whether to add noise or not.



