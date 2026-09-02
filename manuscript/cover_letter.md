Jason Geller
Department of Psychology and Neuroscience
Boston College
McGuinn 300
Chestnut Hill, MA 02467, USA
drjasongeller@gmail.com

August 11, 2026

Dr. Erin M. Buchanan
Editor-in-Chief, *Behavior Research Methods*

Dr. Dora Matzke
Associate Editor, *Behavior Research Methods*

Dear Dr. Buchanan and Dr. Matzke,

We are submitting our manuscript, "This Is Not the ex-Gaussian Model You Are Looking For: On the Default Parameterization of Bayesian ex-Gaussian Models in brms," for consideration as a Commentary in *Behavior Research Methods*. The authors are Jason Geller (Boston College), Bernhard Angele (Nebrija University), and Dominique Makowski (University of Sussex).

The ex-Gaussian distribution is widely used in reaction-time research because it separates the central portion of a response-time distribution, indexed by the Gaussian parameters $\mu$ and $\sigma$, from its positively skewed tail, indexed by the exponential parameter $\tau$. We show that the default ex-Gaussian family in the popular {brms} R package does not parameterize the model this way: the parameter it labels `mu` is actually the mean of the *entire* distribution, $E(RT) = \mu_{\text{Gaussian}} + \tau$, not the location of the Gaussian component alone. Because changes in the Gaussian location and changes in the exponential tail can offset one another in this composite quantity, effects estimated on the default `mu` cannot generally be interpreted as changes in typical response speed, and some published inferences drawn from this parameter may be mistaken as a result.

We demonstrate the problem with simulated data in which the Gaussian location and tail shift in opposite directions while the overall mean is held constant, so that the default parameterization is guaranteed to miss the effect that researchers typically intend to capture with $\mu$. We then reanalyze Experiment 1 from Angele, Baciero, Gómez, and Perea (2023, *Behavior Research Methods*, 55, 151–167), which used the default {brms} ex-Gaussian family to evaluate Forster's (1998) savings hypothesis of masked priming. The reanalysis, fit using the classical parameterization via the {cogmod} package, shows that an effect of prime exposure duration originally attributed to the Gaussian location parameter is instead better explained by a change in the exponential tail, illustrating in a real dataset how the default parameterization can lead to a substantively different conclusion about which part of the RT distribution an experimental manipulation affects. We close with practical guidance for fitting the classical parameterization directly in {brms}.

We want to note that Bernhard Angele, a co-author on this commentary, is also the lead author of the 2023 paper we reanalyze. He joined this project once the parameterization issue had been identified, providing the original data and code and co-writing the reanalysis. We mention this so that the Commentary is understood for what it is: a collaborative, constructive correction undertaken with the original author, not an unsolicited critique.

We believe this Commentary will be of direct interest to the *Behavior Research Methods* readership, given the journal's role in disseminating best practices for quantitative methods in psychology and the increasing use of Bayesian ex-Gaussian models fit with {brms} across the reaction-time literature. Because the specific error we describe is easy to make and not obvious from {brms}'s documentation or output, we think it likely affects analyses beyond the one example we reanalyze here, and that the field would benefit from broader awareness of it.

This manuscript is original, has not been published previously, and is not under consideration elsewhere. The analyses were not preregistered. The authors have no conflicts of interest to disclose. All data, code, and materials needed to reproduce every analysis and figure in the manuscript are publicly available at https://github.com/jgeller112/exGauss_commentary.

Thank you for your consideration. Please do not hesitate to contact me with any questions.

Sincerely,

Jason Geller
Corresponding Author
On behalf of Bernhard Angele and Dominique Makowski
