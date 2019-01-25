function c = launchParallel(n);

c=parcluster();
t=tempname();
mkdir(t)
c.JobStorageLocation=t;
parpool(c,n);