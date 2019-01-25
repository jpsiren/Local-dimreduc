function results = testAnalyses(S,Sobs,theta,thetaobs,dimreduc,reducpars)

tic
ntestdata = size(Sobs,1);
nth = size(theta,2);

Nvalid = reducpars.Nvalid;
nsamples = reducpars.nsamples;

RMSE = zeros(ntestdata,nth);
thetapost = zeros(nsamples,nth,ntestdata);

ncomps = zeros(ntestdata,1);
ncompsi = zeros(ntestdata,1);
ncompsl = zeros(ntestdata,1);
qopt = zeros(ntestdata,1);

niter = size(S,1);
q500 = 500/niter;

plain_inittr = struct;
[Snorm,normargs] = normalize(S);
plain_inittr.Sreg = Snorm;
plain_inittr.normargs = normargs;
plain_inittr.Znorm = normalize(theta);
plain_inittr.b = eye(size(S,2));


parfor i = 1:ntestdata
    
    Sobsi = Sobs(i,:);
    thetaobsi = thetaobs(i,:);
    
    switch dimreduc
        
        case 'plain'
            Stf = S;
            Stfobsi = Sobsi;
            
        case 'reg'
            
            [Stf,normargs,b] = oneStepReg(S,theta);
            Snobsi = normalize(Sobsi,normargs);
            Stfobsi = Snobsi*b;
            
        case 'PLS'
            
            [~,normargs,W,~,thnorm,~,mse] = oneStepPLS(S,theta,reducpars.maxncomp,10);
            ncomps(i) = chooseNcomps(thnorm,mse);
            W = W(:,1:ncomps(i));
            Sn = normalize(S,normargs);
            Stf = Sn*W;
            Snobsi = normalize(Sobsi,normargs);
            Stfobsi = Snobsi*W;
    
%         case 'PLSall'
%             
%             [~,normargs,W,~,thnorm,~,mse] = oneStepPLS(S,theta,reducpars.maxncomp);
%             Sn = normalize(S,normargs);
%             Stf = Sn*W;
%             Snobsi = normalize(Sobsi,normargs);
%             Stfobsi = Snobsi*W;
            
            
        case 'PLSopt'
            
            [normargs,W,ncomps(i)] = PLSSummaries(S,Sobsi,theta,Nvalid,reducpars.maxncomp);
            Sn = normalize(S,normargs);
            Stf = Sn*W;
            Snobsi = normalize(Sobsi,normargs);
            Stfobsi = Snobsi*W;
            
        case 'l500reg'
            [b,normargs,~,qopt(i),redund] = localSummariesReg(S,Sobsi,theta,0,q500);
            
            Sn = normalize(S(:,~redund),normargs);
            Stf = Sn*b;
            Snobsi = normalize(Sobsi(:,~redund),normargs);
            Stfobsi = Snobsi*b;
            
            
        case 'localreg'
            [b,normargs,~,qopt(i),redund] = localSummariesReg(S,Sobsi,theta,Nvalid,reducpars.qs);
            
            Sn = normalize(S(:,~redund),normargs);
            Stf = Sn*b;
            Snobsi = normalize(Sobsi(:,~redund),normargs);
            Stfobsi = Snobsi*b;
            
        case 'l500PLS'
            [W,normargs,~,ncompsl(i),ncompsi(i)] = localSummariesPLS_novalid(S,Sobsi,theta,q500,reducpars.maxncomp);
            
            Sn = normalize(S,normargs);
            Stf = Sn*W;
            Snobsi = normalize(Sobsi,normargs);
            Stfobsi = Snobsi*W;
            
        case 'localPLS'
            [W,normargs,~,qopt(i),ncompsl(i),ncompsi(i)] = localSummariesPLS(S,Sobsi,theta,Nvalid,reducpars.qs,reducpars.maxncomp);
            
            Sn = normalize(S,normargs);
            Stf = Sn*W;
            Snobsi = normalize(Sobsi,normargs);
            Stfobsi = Snobsi*W;
            
        case 'l500reg_plain'
            [b,normargs,~,qopt(i),redund] = localSummariesReg(S,Sobsi,theta,0,q500,plain_inittr);
            
            Sn = normalize(S(:,~redund),normargs);
            Stf = Sn*b;
            Snobsi = normalize(Sobsi(:,~redund),normargs);
            Stfobsi = Snobsi*b;
            
            
        case 'localreg_plain'
            [b,normargs,~,qopt(i),redund] = localSummariesReg(S,Sobsi,theta,Nvalid,reducpars.qs,plain_inittr);
            
            Sn = normalize(S(:,~redund),normargs);
            Stf = Sn*b;
            Snobsi = normalize(Sobsi(:,~redund),normargs);
            Stfobsi = Snobsi*b;
    end
    
%     if isequal(dimreduc,'PLSall')
%         closestall = closestQuantile(Stf,Stfobsi,nsamples,1:reducpars.maxncomp);
%         for j = 1:reducpars.maxncomp
%             thetaest = theta(closestall(:,j),:);
%             thetapost(:,:,i,j) = thetaest;
%             RMSE(i,:,j) = computeRMSE(thetaest,thetaobsi);
%         end
%         
%     else
        
        
        [closest] = closestQuantile(Stf,Stfobsi,nsamples);
        
        thetaest = theta(closest,:);
        thetapost(:,:,i) = thetaest;
        RMSE(i,:) = computeRMSE(thetaest,thetaobsi);
%     end
    
    if rem(i,10)==0
        %a = toc;
        a = size(S,1);
        disp([dimreduc ' ' num2str(i) ', ' num2str(a,4)]);
    end
    
end

switch dimreduc
    
        
    case 'PLS'
        
        results.ncomps = ncomps;
        
    case 'PLSopt'
        
        results.ncomps = ncomps;
        
        
    case {'localreg','localreg_plain'}
        results.qopt = qopt;
        
    case 'localPLS'
        results.qopt = qopt;

        results.ncompsi = ncompsi;
        results.ncompsl = ncompsl;
        
    case 'l500PLS'

        results.ncompsi = ncompsi;
        results.ncompsl = ncompsl;
end

results.thetapost = thetapost;
results.RMSE = RMSE;
results.runtime = toc;

