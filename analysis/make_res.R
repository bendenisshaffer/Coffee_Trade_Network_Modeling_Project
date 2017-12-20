load("saved_output/objects/ergm_models.RData")
load("saved_output/objects/net.RData")

y = as.matrix(net)
dim(y) = c(ncol(y)^2,1)
n = 30
errors0 = vector(mode = "numeric", length = n)
for(i in 1:length(errors0)){
        fitted0 = as.matrix(get.adjacency(sample_gnp(sqrt(length(y)), exp(ergm_models[[1]]$coef))))
        dim(fitted0) = c(length(y),1)
        pred0 = table(y, fitted0)
        errors0[i] = sum(diag(pred0))/sum(pred0)
}


rsqr = lapply(ergm_models, function(x) as.numeric(1 - x$mle.lik/x$null.lik))
AICs = lapply(ergm_models, AIC)

ff = function(mod){
        f = as.matrix(mod$newnetwork)
        dim(f) = c(length(y),1)
        p = sum(diag(table(f,y)))/sum(table(f,y))
        p
}

preds = lapply(ergm_models, ff)



res = data.frame(r2 = unlist(rsqr), AIC = unlist(AICs), correct = unlist(preds))
row.names(res) = unlist(lapply(ergm_models, function(x) x$formula))
res$correct[1] = mean(errors0)

save(res, file = "saved_output/objects/res.RData")

