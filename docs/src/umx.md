# UMX
## File structure
The `*.umx` file contains a height value for each neuron of an ESOM, e.g. the elements of the U-Matrix. 

```
% k l
h11	h21	h31	..	hk1
h12	h22	h32	..	hk2
.	 .	 .	..	 .
.	 .	 .	.. 	 .
h1l	h2l	h3l	..	hkl
```

|Element    | Description                                                            |
|:------    | :----------                                                            |
|``k``      | Number of rows of the ESOM.                                            |
|``l``      | Number of columns of the ESOM.                                         |
|``h_{ij}`` | Height of the neuron at position i in x-direction and j in y-direction.|
