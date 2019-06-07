# LRN

## File structure

The *.lrn file contains the input data as tab separated values. Features in
columns, datasets in rows. The first column should be a unique integer key. The
optional header contains descriptions of the columns.

```
# comment
#
% n
% m
% s1          s2          ..      sm
% var_name1   var_name2   ..      var_namem
x11           x12         ..      x1m
x21           x22         ..      x2m
.             .           .       .
.             .           .       .
xn1           xn2         ..      xnm
```

|Element         | Description                                                            |
|:------         |:-----------                                                            |
|``n``           | Number of datasets                                                     |
|``m``           | Number of columns (including index)                                    |
|``s_i``         | Type of column: 9 for unique key, 1 for data, 0 to ignore column       |
|``var\_name_i`` | Name for the i-th feature                                              |
|``x_{ij}``      | Elements of the data matrix. Decimal numbers denoted by '.', not by ','|

## Code Documentation

```@autodocs
Modules = [DataIO.LRN]
```
