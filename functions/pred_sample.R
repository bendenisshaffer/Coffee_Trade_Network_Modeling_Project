#define function
plot_pred_sample = function(errors){
        n = length(errors)
        plot(density(errors), main = "Correct Prediction of Edge Existance", xlab = str_c("Samples = ", n))
        abline(v = quantile(errors, 0.025), col = 2, lty = 5)
        abline(v = quantile(errors, 0.975), col = 2, lty = 5)
        text(quantile(errors, 0.025) - 0.001, 100, labels = round(quantile(errors, 0.025),3))
        text(quantile(errors, 0.975) + 0.001, 100, labels = round(quantile(errors, 0.975),3))
}
get_pred_sample = function(form, cntr, n, y){
        err = vector(mode = "numeric", length = n)
        for(i in 1:n){
                fit = ergm(formula = form, control = cntr, verbose = F)
                fitted = as.matrix(fit$newnetwork)
                dim(fitted) = c(length(y),1)
                confusion_mat = table(y, fitted)
                err[i] = sum(diag(confusion_mat))/sum(confusion_mat)
                print(paste(i/n * 100, " percent done."))
        }
        
        return(err)
}
measures_plot = function(G){
        par(mfrow = c(2,2))
        plot(degree_distribution(G, mode ="out", cumulative = T), type = "l", col = 2,
             main = "Cummulative Degree Distributions", ylab = "Probability", xlab = "")
        lines(degree_distribution(G, mode ="in", cumulative = T), col = 3)
        legend("topright", legend = list("Out Degree", "In Degree"), lty = c(1,1), col = c(2,3))
        
        plot(density(degree(G, mode ="out")),
             type = "l", col = 2, main = "Log Degree Centrality Distribution", 
             ylim = c(0,max(density(degree(G, mode = "in"))$y)),
             xlim = c(1,max(density(degree(G, mode = "in"))$x)))
        lines(density(degree(G, mode ="in")), col = 3)
        legend("topright", legend = list("Out Degree", "In Degree"), lty = c(1,1), col = c(2,3))
        
        plot(density(betweenness(G, normalized = T)), col = 4, 
             main = "Betweenness Centrality Distribution")
        plot(density(closeness(G, normalized = T)), col = 5, 
             main = "Closeness Centrality Distribution")
}