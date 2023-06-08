
foo = ones(1000,1000)*0.5;

bar = polyMutateCore(foo, 0, 1, 2);

histogram(bar);



