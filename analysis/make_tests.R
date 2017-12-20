require(tidyr)
require(ggplot2)

load("saved_output/objects/errors.RData") 
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

pvals = c(t.test(errors0, errors[[1]])$p.value,
          t.test(errors[[1]], errors[[2]])$p.value,
          t.test(errors[[2]], errors[[3]])$p.value,
          t.test(errors[[3]], errors[[4]])$p.value,
          t.test(errors[[4]], errors[[5]])$p.value,
          t.test(errors[[5]], errors[[6]])$p.value)

test_names = c("m1 vs m2", "m2 vs m3", "m3 vs m4", "m4 vs m5", "m5 vs m6", "m6 vs m7")

tests = data.frame(test = test_names, p_value = pvals)

save(tests, file = "saved_output/objects/tests.RData")


gdf = cbind(unlist(errors0),data.frame(errors))
names(gdf) = 1:ncol(gdf)

gdff = gather(gdf, "Model", "Accuracy")

g = ggplot(gdff, aes(x = Accuracy, fill = Model)) + 
        geom_density(alpha = 0.2) + 
        labs(title = "Density of Edge Presence Prediction")

ggsave(filename = "saved_output/plots/test_density_plot.png", device = "png")
