filebeg = '..\results\gkResults';

load([filebeg '1a.mat']);


extrafiles = {[filebeg '1b.mat'],[filebeg '2a.mat'],[filebeg '2b.mat']};

nextra = length(extrafiles);

extracol = [3 4 4];
extrarows = {1:6,1:5,6};

for i = 1:nextra
    c = load(extrafiles{i});
    
    coli = extracol(i);
    rowsi = extrarows{i};
    
    results_reg(rowsi,coli) = c.results_reg(rowsi,coli);
    results_localreg(rowsi,coli) = c.results_localreg(rowsi,coli);
    results_l500reg(rowsi,coli) = c.results_l500reg(rowsi,coli);
    
    results_PLS(rowsi,coli) = c.results_PLS(rowsi,coli);
    results_PLSopt(rowsi,coli) = c.results_PLSopt(rowsi,coli);
    results_l500PLS(rowsi,coli) = c.results_l500PLS(rowsi,coli);
    results_localPLS(rowsi,coli) = c.results_localPLS(rowsi,coli);
    clear c; clear Sij;
end

save ..\results\gkResults.mat