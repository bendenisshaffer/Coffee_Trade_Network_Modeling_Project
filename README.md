#Research Question

In today's global economy where communication and transportation technologies play a central role in nearly all industries, and as nations pursue more liberal trading policies, the international trade has become a vital component of all of our lives. Trade relationships like any other relationships can be though of in terms of a network of countries tied together with flows goods and services across the glob. One of the central commodities that many of us have come to expect anywhere and under any circumstance is coffee. But of course coffee can only be harvested in a particular set of countries with the right climate conditions. Thus it is of interest to study the trade of coffee as a network to better understand how nations form trading relationships all for our sake of getting a hot cup of coffee in the middle of the winter in Norway. In fact coffee is the second most traded commodity in the world when measured by value. To compare, sugar comes in fifth, while the natural gas is at the ninth place of the list.

The main objective of our analysis is to understand the internal processes of the trade network and the external factors that impact and drive formation of trading relationships.
We refer to the internal mechanism as endogenous variables, and external factors as exogenous variables. For example, it might be reasonable to think that the likelihood of an country A to trade with country B depends on who country B trades with. This would be considered an eternal process. On the other hand we may hypothesis that developing countries are more likely to trade coffee with developed nations rather than among themselves. The matching of economy types would be considered exogenous to the network. To this end we use a modeling approach to infer which factors are important for trade rations formation, and furthermore evaluate how well this modeling approach can predict the existence of any trading relationship between any two countries.

In addition to prediction of existence of trading relationships, which we refer to as edges between countries, we explore types of three country relationships that that any given country engages in. We refer to these as triplets and triangles, which are closed triplets. Given a particular position in the network, such a top traded by volume or value, we explore the composition of these triplet relationships to see if there are any noticeable difference in the way in which a nations trading relationship form. This exploration aims to give a picture of a network from the perspective of a given country, and further help formulation of models to analyze.


#Data


## Data Description

A network can be represented as a graph that consists of nodes and edges. In our analysis countries are representd as nodes, while their trading relationships are represented as edges. In addition, eche node and edge may have a set of attributes such as GDP or Population for a country, and volume or exporting price for an edge between two countries. Thus is structure of the data can be viewed as two linked datasets. The data that we focus on is the coffee trade network from 2010, in addition to which we include the coffee trade netwroks from 2005 and 2015, as well as netwroks for sugar trade, and natural gas trade for the same three sets of years. We include this data with eh intention to explore how implementing measures from these networks can help model the 2010 coffee network.

Specific variables in our data are:
* Reporter(country of origin), 
* Partner(country interacting with the country of origin)
* Trade Value(amount of exports in US dollars) 
* Net weight_Kg(weight of the goods in kilograms) 
* Commodity(the good we examine)
* Year(the year that the export took place)

Some of the node level variables that we have for each country in the 2010 notwork of coffee include:
* GDP (gross domestic product of each country)
* Population
* Economy (Developed, Developing, ..) 
* Continent
* Sub-region (of the continent)

Measures of nodes from other networks that we intend on including in the analysis are:
* Betweenness centrality
* Closeness centrality
* Indegree and OUtdegree centralities


## Data Collection

In order to start our analysis and perform the aforementioned tasks we had to find a way to collect the data described in section 2
Our primary source of data is the UN Comtrade Database which is a public database with an open API. This data contains information on bilateral trade volumes between all countries over various years as well as different commodities. We first complied 9 different datasets, each describing a commodity(coffee,gas,sugar) for a specific year (years of interest were 2005,2010,2015). For the geographical and social variables we used the World dataset, which is included in the tmap package in R and provides information about social and financial attributes of each country.


```{r, warning=FALSE, message=FALSE, echo=FALSE}

DF1 = read.csv("Data/Cleaned/clean_coffee_trade.csv")
DF2 = read.csv("Data/Cleaned/clean_gas_trade.csv")
DF3 = read.csv("Data/Cleaned/clean_sugar_trade.csv")
DF1 = DF1 %>% group_by(Reporter, Partner, Year) %>% summarise(Trade_Value__US__ = sum(as.numeric(Trade_Value__US__)),
                                                            Netweight__kg_ = sum(as.numeric(Netweight__kg_)),
                                                            Commodity = "Coffee")
DF2 = DF2 %>% group_by(Reporter, Partner, Year) %>% summarise(Trade_Value__US__ = sum(as.numeric(Trade_Value__US__)),
                                                            Netweight__kg_ = sum(as.numeric(Netweight__kg_)),
                                                            Commodity = "Gas")
DF3 = DF3 %>% group_by(Reporter, Partner, Year) %>% summarise(Trade_Value__US__ = sum(as.numeric(Trade_Value__US__)),
                                                            Netweight__kg_ = sum(as.numeric(Netweight__kg_)),
                                                            Commodity = "Sugar")

DF = rbind(DF1,DF2,DF3)
data("World")

```



#Methedology

## General Introduction to Exponential Random Graph Models

For out analysis we will be using the Exponential Random Graph Models (ERGMs).

Consider a random graph $G = (V,E)$ where $V = [v_1, v_2, ..., v_i]$ is a set of all vertices of the graph and $E = [(v_i,v_j),..., (v_{i'},v{_{j'}})]$ for $i \neq j$ is a set of all edges of the graph.
Then let $Y_{ij}$ be a Binary Random Variable s.t

$$ Y_{ij} = Y_{ji} = \begin{cases}
    1       & \quad \text{if and edge between i and j  exists} \\
    0  & \quad \text{otherwsie}
  \end{cases} $$
  
Then $\textbf{Y} = [Y_{ij}]$ is the adjacency matrix of $G$

Under the ERGM we assume that the probability of observing a particular adjacency matrix $\textbf{y}$ follows the following general form:

$$ P(\textbf{Y} = \textbf{y}; \theta) = \frac{1}{\kappa}\text{exp}\Big(\sum \theta g(\textbf{y})   \Big) $$
Where $g(\textbf{y})$ is a set of graph statistics (e.g. number of edges in the graph), and $\theta$ is a set of parameters that need to be estimated.Note that it is possible to include both Endogenous statistics and Exogenous variables when constructing an ERGMS. For example we may hypothesis that the probability of there being an edge between any two nodes depends on the attributes of the nodes, in which case we can define a graph statistic in the following way:

$$ g(\textbf{y},\textbf{x}) = \sum{y_{ij}h(x_i,x_j)} $$

Where $x_i$ is a value of an atribute $x$ for node $i$ and $h$ is a simmilarity or dissimarity function of some kind. (e.g a difference). In such a case we can write down the model as 

$$ P(\textbf{Y} = \textbf{y}|\textbf{X} = \textbf{x} ; \theta) = \frac{1}{\kappa}\text{exp}\Big(\sum \theta g(\textbf{y},\textbf{x})   \Big)  $$

When exogenous variables are included in the manner formulated above, such a model is commonly reffered to as a Markov Network.

## A Familiar Example: Erdős–Rényi Model as an ERGM

A theorem by Hammersley and Clifford asserts that under certain conditions any Markov Network can be represented an ERGM.
One such familiar exmaple is the Erdős–Rényi model that takes two parameters $(N,p)$ where $N$ is the size of the graph and $p$ is the probability of an edge forming between any two verticies. The $ER(N,p)$ model states that 

$$ P(\textbf{Y} = \textbf{y};p,N) = p^{L(\textbf{y})}(1-p)^{\big(1-L(\textbf{y})\big)N} $$

Where $L(\textbf{y}) = \sum y_{ij}$ is the number of edges in a graph. This may be re-writen in a way that better resembels an ERGM:


$$ P(\textbf{Y} = \textbf{y};p,N) = \Bigg(\frac{p}{1-p}\Bigg)^{L(\textbf{y})}(1-p)^N  =
\text{exp}\Big(L(\textbf{y})\frac{p}{1-p} - N(1-p)\Big) =\frac{1}{\kappa} \text{exp}\Big(L(\textbf{y})\frac{p}{1-p}\Big)$$


So we have $g(\textbf{y}) = L(\textbf{y})$ and $\theta = \frac{p}{1-p}$.


##Parameter Estimation

Now we can introduce some key methods that are being used in bibliography and research in order to fit MLE’s(maximum likelihood estimators) to ERGM(Exponential Random Graph Models).We have already defined the general case of ERGM and so now we can define the MLE for the vector $\theta$ as $\hat\theta = \text{argmax}_{\theta} l(\theta)$, where $l(\theta)$ is the log-likelihood, which has the form common to exponential families,

$$ l(\theta) = \theta^T\textbf{g}(\textbf{y}) - \psi(\theta)  \text{  where } \psi(\theta) = log(\kappa(\theta)) \textbf{ (1) }$$


Here,by taking the derivatives on each side and using the fact that  $E_{\theta} \Big[ \textbf{g(Y)} \Big] = \frac{  \partial \psi(\theta) }{ \theta }$, the MLE can be expressed as the solution to the system of equations $E_{\hat\theta} \Big[ \textbf{g(Y)} \Big] =  \textbf{g(y)}$.

Although these are true,unfortunately the function $\psi(\theta)$,can be evaluated explicitly only at the most trivial settings,and not as a general case.Hence, we have to use numerical methods in order to calculate the approximate values of θˆ .In order to perform this task we can use a method called Markov Chain Monte Carlo maximum likelihood estimation (MCMC-MLE).Now,instead of optimizing the log-likelihood (1),we can try to optimize the logarithm of the likelihood ratio, described as,

$$ r(\theta,\theta^{(0)}) = l(\theta) - l(\theta^{(0)}) = \big(\theta - \theta^{(0)}\big)^T \textbf{g(y)} - \big(\psi(\theta) - \psi(\theta^{(0)})\big) \textbf{ (2) } $$

Where $\theta^{(0)}$ is arbitrary and fixed.Furthermore we have that,

$$ exp\Big(\big(\psi(\theta) - \psi(\theta^{(0)})\big)\Big) = \sum_y exp\Big( \big(\theta - \theta^{(0)}\big)^T \textbf{g(y)} \Big) \Bigg(\frac{ exp \big( (\theta^{0})^T  \textbf{g(y)} \big) }{exp(\psi(\theta^{(0)})) } \Bigg) = E_{\theta^{(0)}}\bigg[ exp\Big( \big(\theta - \theta^{(0)}\big)^T \textbf{g(y)} \Big) \bigg] \textbf{ (3) }$$

Thus, in this way we end up that we can approximate the term $\big(\psi(\theta) - \psi(\theta^{(0)})\big)$ by using the following steps.First of all we generate  a MCMC sample $Y_1 ... Y_n$ from the ERGM $P(\textbf{Y} = \textbf{y}; \theta) = \frac{1}{\kappa}\text{exp}\Big(\sum \theta g(\textbf{y})   \Big)$, for $\theta^{(0)}$ .The second step is to approximate the expectation that we formed in (3) by taking the average based on the sample,while the third and final step is to take the logarithm of that average.Hence,the approximation to (2) will eventually converge its target and the optimal of this approximation of (2) will be approxiamte the MLE $\hat\theta$.


##Endogenous Graph Statistics

In our analysis we employ some well known graph statistics that are typically used when fitting ERGMs in practice. These include the number of edges (edges), mutuality (mutual), as well as the geometrically weighted edgewise shared partner distribution (gwesp). Mutual is a statistic that measures mutuality in a dircted graph. This statistic counts the number of pairs $i,j$ such that both edges $(i,j)$ and $(j,i)$ exist. This statistic is inspired by the notion of friendship is a social network; If I am your frind, you are my frind. In the context of our analysis this implies that if country A exports to B than contry B exports to A. Note that when estimating the parameter for this statistic it may positively or negatively impact the probability of incidence. Thus for out anaysis we may expect a negative effect. Lastly we have the GWESP which losely defined as:

$$ ep_k(\textbf{y}) = \text{Number of unordered pairs } (i,j) \text{ s.t } y_{i,j} = 1 \text{ where } (i,j) 
\text{ have } k \text{ common neighbors.}$$

This statistic is a measure of dependance of probability for an edge between $i$ and $j$ on the edges of their neighbors. In simple words this measures how a probability of an edge is affected by the edge distribution in the rest of the graph. The inclusion of thie statistica in the MCMLE estimation is particularly expensive.


##Prediction

Once an ERGM is fit we are able to retrieve the fitted adjacency matrix which will always be of the same dimension as the adjacency matrix of the original graph. We are then able to compare these matrices by essentially flattening and taking the inner product. This gives us a measure of the proportion of how many edges were correctly predicted to exists between any two nodes. We repeat this process of fitting and comparing the resultant matrix for a set number of times to form a sample of such proportions. Once we have samples for these proportions under different models we will then be able to test whether one model predicts better than the other. For our modeling, we are using the coffee trade data from 2010 as the target, and all other networks from 2005 and 2010 as sources for additional exogenous factors. The shortcoming of this approach is that we are not minimizing a loss function with respect to the objective measure, but rather we are using a modeling approach. In addition we are only able to retrieve the binary adjacency matrix which means that we are preforming a binary prediction and do not predict the direction or origin of the link.