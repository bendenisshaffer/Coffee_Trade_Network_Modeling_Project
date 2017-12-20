require(network)
require(ergm)
source("functions/pred_sample.R")


load("saved_output/objects/net.RData")

cntr = control.ergm(parallel = 8, MCMLE.maxit = 20)

form0 = formula(net ~ edges)
form1 = formula(net ~ edges + mutual)
form2 = formula(net ~ edges + mutual + nodecov("GDP"))
form3 = formula(net ~ edges + mutual + nodemain("GDP") + nodemain("Population"))
form4 = formula(net ~ edges + mutual + nodemain("GDP") + nodemain("Population")
                + match("Economy") + match("Continent") + match("Subregion"))
form5 = formula(net ~ gwesp(2))
form6 = formula(net ~ edges + gwesp(2))
form7 = formula(net ~ edges + mutual + nodemain("Betweenness"))
form8 = formula(net ~ edges + mutual + nodemain("InDegree"))


form_list = list(form0, form1, form2, form3, form4, form5, form6, form7, form8)

ergm_models = lapply(form_list, function(x) ergm(formula = x, control = cntr))
ergm_summaries = lapply(ergm_models, summary)
errors = lapply(form_list[-c(1,6,7)], function(x) get_pred_sample(form = x, cntr, n, y))

save(ergm_models, file = "saved_output/objects/ergm_models.RData")
save(ergm_summaries, file = "saved_output/objects/ergm_summaries.RData")
save(errors, file = "saved_output/objects/errors.RData")
