Multivariate Chi-Square Anomaly Classification (MCAC)
================
1Lt Alexander Trigo
17 January, 2018

Product Information
-------------------

Multivariate Chi-Square Anomaly Classification (MCAC)

MCAC will provide A user interface for quick and automated analysis of cyber intrusion detection data logs. functionality will identify outliers and provide visual insight into the underlying structure of the data set.

This product is being developed for use by DoD Sponsors.  The target end users will be cyber analysts, so MCAC will be mostly automated in order to ensure usability regardless of a formal education in multivariate analytic techniques. The user should strive to understand what the function output is telling them about the data, however, regardless of understanding, a list of outliers will be provided as a product of the analysis. The main responsibility of the user will be in the input of features. They will need to upload a raw data set containing many features, however, they must be able to input exactly which features are to be considered for analysis.

We will forgo construction of a user based R package in favor of a Shiney App due to DoD restrictions on R usage, and prerequisite training required to use R. A shiney app should provide a much more user friendly experience, where the analyst will be able to upload data, alter several parameters, and retrieve a spreadsheet output of detected outliers. The MCAC function will build upon several statistical methods and the `anomalyDetection` package.

The `anomlyDetection` package features several important tools we will use to conduct MCAC analysis. First, the package includes functionality which allows us to transform the user uploaded data frame into a tabulated state vector format which is conducive to multivariate analysis. Second, this package allows us to calculate the Mahalabnobis distance (1) of the observations, which is crucial for the Chi-Square Q-Q plot analysis.

$$MD = \\sqrt{(x - \\bar{x})^T C^{-1} (x - \\bar{x}) }  \\tag{1}$$

The classification of outliers based on the chi squared plot is contingent upon the fact that an underlying distribution of Mahalanobis distances for a multivariate normal population is chi-square with degrees of freedom equivalent to the the number of data set features(Gnanadesikan, 1977). Due to this relationship, Mahalanobis distances can be sorted in ascending order and plotted against a corresponding set of chi-square values. For a perfectly normal multivariate population, we would observe a straight line begin at the origin (0,0) and plot at 45 degrees to some arbitrary distant point such as (50,50). Often times, when our line does not behave well, it is due to the influence of outliers within the data set. If data points are anomalous, they will be removed iteratively, and co-variance of the data set will be recalculated in order to determine new Mahalanobis distances.

Finally, in order to determine the optimal number of observations for outlier classification, we will use the Standard Error of the Estimate as a basis of measurement. This estimate, often used in regression analysis is give by the equation $ \_e = $ where Y is the actual observation Y for a given X, Y' is the predicted Y value, and N is the number of observations. Ideally, as we remove anomalous observations, the data set will approach multivariate normality, and this error will be reduced iteratively. We will use a minimization of this value as a criteria for function termination resulting in classifications.

Delivery and Schedule
---------------------

<table>
<colgroup>
<col width="15%" />
<col width="5%" />
<col width="8%" />
<col width="20%" />
<col width="13%" />
<col width="15%" />
<col width="13%" />
<col width="5%" />
<col width="5%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">Feature</th>
<th align="center">Priority</th>
<th align="center">Status</th>
<th align="center">Value</th>
<th align="center">Input</th>
<th align="center">Output</th>
<th align="center">Use</th>
<th align="center">Deadline Viability?</th>
<th align="center">Needed?</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Data Upload: Upload the raw data</td>
<td align="center">1</td>
<td align="center">not started</td>
<td align="center">Allow user to upload their raw data set</td>
<td align="center">csv file</td>
<td align="center">N/A</td>
<td align="center">N/A</td>
<td align="center">Yes</td>
<td align="center">Yes</td>
</tr>
<tr class="even">
<td align="left">Automatic Data Cleaning: Prep data for analysis and then invoke anomalyDetection functionality</td>
<td align="center">2</td>
<td align="center">in progress</td>
<td align="center">Select desired features and format data into a usable form</td>
<td align="center">N/A</td>
<td align="center">N/A</td>
<td align="center">N/A</td>
<td align="center">Yes</td>
<td align="center">Yes</td>
</tr>
<tr class="odd">
<td align="left">Automatic Time Vector: Assign which feature corresponds to the time vector</td>
<td align="center">3</td>
<td align="center">in progress</td>
<td align="center">Generates an index of times with which to classify anomalies</td>
<td align="center">Block size/Time Feature</td>
<td align="center">Vector of Time/Date Ranges</td>
<td align="center">Better outlier location description</td>
<td align="center">Yes</td>
<td align="center">Yes</td>
</tr>
<tr class="even">
<td align="left">Classify Outliers: Function will eliminate anomalous data/re-plot</td>
<td align="center">4</td>
<td align="center">in progress</td>
<td align="center">remove and classify anomalies, replot</td>
<td align="center">Pre-processed data</td>
<td align="center">Chi-Square Q-Q plot/anomalies</td>
<td align="center">Find anomalies and assess multivariate normality</td>
<td align="center">Yes</td>
<td align="center">Yes</td>
</tr>
<tr class="odd">
<td align="left">Generate Plot: Initial Chi-Square Q-Q Plot Generated</td>
<td align="center">5</td>
<td align="center">in progress</td>
<td align="center">View untouched data</td>
<td align="center">Initial MD and Chi Square Vectors</td>
<td align="center">Initial Q-Q Plot</td>
<td align="center">Inspect untouched data structure</td>
<td align="center">Likely</td>
<td align="center">No</td>
</tr>
<tr class="even">
<td align="left">Export: Indexed anomalies exported to csv file</td>
<td align="center">6</td>
<td align="center">not started</td>
<td align="center">export analysis results</td>
<td align="center">Outlier Vector</td>
<td align="center">csv file</td>
<td align="center">easy snapshot of results</td>
<td align="center">Maybe</td>
<td align="center">No</td>
</tr>
<tr class="odd">
<td align="left">Manual Data Cleaning: Allow users to input which features to keep for analysis</td>
<td align="center">7</td>
<td align="center">not started</td>
<td align="center">allow greater analytic flexibility</td>
<td align="center">Feature Names</td>
<td align="center">See 1-5</td>
<td align="center">adapt to raw data format change/new feature criteria</td>
<td align="center">Unlikely</td>
<td align="center">No</td>
</tr>
<tr class="even">
<td align="left">Manual Time Vector input: Allows user to define which time vector to use</td>
<td align="center">8</td>
<td align="center">not started</td>
<td align="center">Allow for new time vector feature</td>
<td align="center">Feature Name</td>
<td align="center">See 3</td>
<td align="center">adapt to raw data format change/new feature criteria</td>
<td align="center">Unlikely</td>
<td align="center">No</td>
</tr>
<tr class="odd">
<td align="left">Manual Threshold: Allows user to define the size of function data threshold</td>
<td align="center">9</td>
<td align="center">not started</td>
<td align="center">Change threshold default from 3%</td>
<td align="center">Threshold Percentage</td>
<td align="center">See 4</td>
<td align="center">Consider greater data range for classification</td>
<td align="center">Unlikely</td>
<td align="center">No</td>
</tr>
<tr class="even">
<td align="left">Manual Block Size Input: Allows user to define the size of state vector block size</td>
<td align="center">10</td>
<td align="center">not started</td>
<td align="center">Impacts how many observations are allocated to a time block</td>
<td align="center">whole integer</td>
<td align="center">altered Time vector and state vector</td>
<td align="center">user can alter size of time block size and time vector size</td>
<td align="center">Unlikely</td>
<td align="center">No</td>
</tr>
</tbody>
</table>
