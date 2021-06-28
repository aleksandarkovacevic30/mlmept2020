

## Introduction

In this exercise, you will use IntegratedML to create, train, and execute a predictive model on a sample data.
While the use case here is based on oversimplified case of predicting Iris flowers, IntegratedML can be used to solve all kinds of different problems with machine learning.
It is intended for developers who want to implement machine learning in their applications but do not have the expertise on hand to do so.

## Objectives

By the end of this exercise, you will be able to:

* Explain what IntegratedML is
* Create a model definition
* Train a model on a set of training data
* Execute a model on set of testing data
* Find and Observe the training process
* Validate a model and view the results
* Choose a different provider to train and test models
* Setting up different IntegratedML configurations
* How to view and maintain existing models

## View Data

Before you can begin to see the benefits of machine learning in an application, you first need to familiarize yourself with the data your application is receiving. 
In this exercise, you will work with `DataMining.IrisDataset`. 
This dataset contains the information of 150 different Iris flowers, with information of their petal and sepal width and length, and its sub-categorization into exact species (Iris Setosa, Iris Virginica, and Iris versicolor).

Your training (input) data should be a representative sample; it needs to be representative enough to give your machine learning engine sufficient data to identify patterns and relationships. 
In a real ML use cases, the training processs takes a considerable amount of time. It can take from 10-15 minutes to even couple of weeks to train, depending on the size of the dataset. For the sake of time, we have chosen small Iris flowers dataset.
In this exercise, the two sets of data are already prepared for use in a machine learning application. To learn about some of the key considerations you should think about when preparing your data for machine learning, you can refer to this [infographic](https://learning.intersystems.com/course/view.php?id=1415&ssoPass=1).

Run the SQL command below to view the Iris dataset table (your training data).
You can run this statement in the <a href="/csp/sys/exp/%25CSP.UI.Portal.SQL.Home.zen?$NAMESPACE=USER" target="_blank">embedded SQL editor</a>: 

	SELECT * FROM DataMining.IrisDataset

Scroll through the table to see the types of values included in each record. Each column contains the following information:

* sepal length in cm
* sepal width in cm
* petal length in cm
* petal width in cm
* class:
	- Iris Setosa
	- Iris Versicolour
	- Iris Virginica

To make it a bit more clear, each of the flower's properties are depicted in the following photos.

![Iris Flowers](https://shahinrostami.com/images/ml-with-kaggle/iris_class.png "Iris Flowers with depicted Sepal and Petal width and Length")

Before we get further, let's take a look at what is average sepal and petal width and length for each of the iris species.

	SELECT ROUND(AVG(PetalLength),1) as AVGPetalLength, ROUND(AVG(PetalWidth),1) as AVGPetalWidth, ROUND(AVG(SepalLength),1) as AVGSepalLength, ROUND(AVG(SepalWidth),1) as AVGSepalWidth, Species FROM DataMining.IrisDataset GROUP BY Species

You will receive result like this:

<table>
<tr>
<th>AVGPetalLength (cm)</th><th>AVGPetalWidth (cm)</th><th>AVGSepalLength (cm)</th><th>AVGSepalWidth (cm)</th><th>Species</th>
</tr>
<tr>
<td>1.5</td><td>0.2</td><td>5.0</td><td>3.4</td><td>IRIS-SETOSA</td>
</tr>
<tr>
<td>4.3</td><td>1.3</td><td>5.9</td><td>2.8</td><td>IRIS-VERSICOLOR</td>
</tr>
<tr>
<td>5.6</td><td>2.0</td><td>6.6</td><td>3.</td><td>IRIS-VIRGINICA</td>
</tr>
</table>

From the first look, we can notice that *IRIS-VIRGINICA* is the largest of the species, where *IRIS-SETOSA* is the smallest. We will use this "intuition" later-on.

## Create and Train a Predictive Model

Let's say that we want the machine to learn how to recognize the species of the flower based on its sepal and petal width and length.
This kind of problem, where we try to "classify" the flower based on various input parameters is called **classification problem**.

Once you have your training data and know what you are trying to predict, you can create a model definition in IntegratedML. 
To do this, a single line of SQL is required. Run the module below to create a model named FlowerPredictor.

	CREATE MODEL FlowerPredictor PREDICTING(species) from DataMining.IrisDataset

When you run this command in the <a href="/csp/sys/exp/%25CSP.UI.Portal.SQL.Home.zen?$NAMESPACE=USER" target="_blank">SQL editor</a> successfully, you will see  the result similar to something like the following:

![CREATEMODELSS](createmodelss.png)

Using the command above, you created a model definition for `FlowerPredictor` and specified that it will be predicting the `Species` column from the `DataMining.IrisDataset` data set.
This command uses just the metadata about the dataset, namely the information about the columns like column type and size. The data itself is not being checked by `CREATE MODEL` statement.

Next, you can run the command below to train your `FlowerPredictor` model with the data set specified in the definition.
This statement usually takes the most of the time, but due to the fact that this dataset is small and simple, it is fast. 
Remember, IntegratedML is learning patterns and relationships across all columns and rows in `DataMining.IrisDataset`.
Click here to open the <a href="/csp/sys/exp/%25CSP.UI.Portal.SQL.Home.zen?$NAMESPACE=USER" target="_blank">SQL editor</a> in a new window.

	TRAIN MODEL FlowerPredictor

When it gets finshed, only result you will see it as follows:

![TRAINMODELSS](trainmodelss.png)

In this particular example, we trained the `FlowerPredictor` model without defining any specific dataset to train upon.
In this case, IntegratedML uses a dataset defined in `CREATE MODEL` statement.
However, throughout the lifetime of one ML use case, you might get additional data that you can use to make your ML makes even better forecasts. 
For that reason, `TRAIN MODEL` statement has optional, but essential, `FROM` option. This option enables you to "resume" training of your existing model.

In order to train this model, IntegratedML uses a machine learning provider. 
There are three primary machine learning providers available for use in IntegratedML:

- **AutoML** - a machine learning engine developed by InterSystems, housed in InterSystems IRIS
- **H2O** - an open-source automated machine learning platform
- **DataRobot** - an advanced enterprise automated machine learning platform

Later in this exercise, you will modify your ML Configuration to use different providers. Note that in order to use DataRobot, you need to be a DataRobot customer.

## Execute the Model

In two simple SQL commands, you have created and trained a model called `FlowerPredictor` that will predict the species of Iris Flower.

We can use this model to apply on new data. However, since we do not have any new data, we will be using the same dataset we used to train on.

Run the command below to return a table containing the original ID, the predicted species, and the actual species (already in the dataset) of the first 100 records.

	SELECT TOP 100 ID, PREDICT(FlowerPredictor) AS PredictedSpecies, Species AS ActualSpecies FROM DataMining.IrisDataset

Browse the results. You can see that the model performs perfectly. That is not always to be expected. 
As we noticed on the first look at dataset averages, we can very easily recognize flowers as their sizes are very distinctive.

To explore these results at a deeper level, you could select all rows (instead of just the top 100) and bring those results into other tool for analyzing how the model performed on your training data set.
In the next section, you will see more options for assessing the model’s performance.
In addition to the `PREDICT` function, you can also utilize the `PROBABILITY` function in your results. 

Run the command below to return a table containing the original ID, the probability of for each of the species, the predicted species, and the actual species of the first 100 records.

	SELECT TOP 100 ID, 
		PROBABILITY(FlowerPredictor FOR 'Iris-setosa') AS SetosaProbability, 
		PROBABILITY(FlowerPredictor FOR 'Iris-versicolor') AS VersicolorProbability, 
		PROBABILITY(FlowerPredictor FOR 'Iris-virginica') AS VirginicaProbability, 
		PREDICT(FlowerPredictor) AS PredictedSpecies, 
		Species AS ActualSpecies 
			FROM DataMining.IrisDataset

Browse the results and look at how the probabilities IntegratedML calculated compare to the predictions it made.

Notice that `FOR` clause within the brackets of `PROBABILITY` function. It is used to tell IntegratedML for which label it should show probability for. 
In case of Iris Dataset, it is the classifications '*Iris-setosa*', '*Iris-versicolor*' and '*Iris-virginica*'. 
Take care that these labels have to be entered case-sensitive.

When the results you are predicting are not classification choices, but just yes or no (1 or 0), 
you can use `PROBABILITY` function also without `FOR` clause. In that case, the default behavior would be `PROBABILITY(model-name FOR '1')`.

Let's try to give our FlowerPredictor custom values what our intuition would expect. 
As we saw on a table above, `Iris-virginica` is the largest flower, so let us see newly created model will recognize it as well.

	SELECT PREDICT(FlowerPredictor) as PredictedSpecies 
			FROM 
				(SELECT 101 AS ID, 5 As PetalLength, 1.8 As PetalWidth, 6.1 As SepalLength, 2.9 As SepalWidth)

You will notice that the model have predicted correct species `Iris-virginica`.
Now try running the same query, just with ID AS 95.

	SELECT PREDICT(FlowerPredictor) as PredictedSpecies 
		FROM 
			(SELECT 95 AS ID, 5 As PetalLength, 1.8 As PetalWidth, 6.1 As SepalLength, 2.9 As SepalWidth)

What is the prediction in this case?
The prediction has changed only because of different ID. 
Our common sense would tell us that ID of a row should have no influence to predicting species.
And this is correct. 
In our Iris Dataset, it is just a coincidence that that data was sorted so that first 50 flowers are Iris-setosa, second 50 iris-versicolor, and last 50 iris-virginica.
This has made our model to learn that for example if the ID is larger number, it is more likely to be 'Iris-virginica'.

AutoML providers usually rule out all unique ID-like columns before performing the training.
However, numeric ID values could represent a proxy to time axis as often data is entered in chronological order.
Therefore, all AutoML providers have built various mechanisms to balance this problem.

This is a great example that we need to take care of what data we feed to IntegratedML. 

Since we know ID represent no valuable information about Iris flowers, let us fix the issue.
First let us delete the previous model:

	DROP MODEL FlowerPredictor

`DROP MODEL` statement will drop the model definition along with all trained models performed.
We will create a new model, where we specifically define what should be used as inputs to train a model

	CREATE MODEL FlowerPredictor PREDICTING(Species)
		WITH (PetalLength double, PetalWidth double, SepalLength double, SepalWidth double) 
		FROM DataMining.IrisDataset

We are using here `WITH` clause, where we directly define which columns should be considered by IntegratedML. 
Another way to `CREATE MODEL` for this case is also (you do not need to run this, as you have already created the model above):

  CREATE MODEL FLowerPredictor
		PREDICTING(Species) 
		FROM (
				SELECT PetalLength, PetalWidth, SepalLength, SepalWidth, Species FROM DataMining.IrisDataset
				)

Let's train the model again: 

	TRAIN MODEL FlowerPredictor

Now we can check again the prediction for our new model:

	SELECT PREDICT(FlowerPredictor)
		FROM 
			(SELECT 5 As PetalLength, 1.8 As PetalWidth, 6.1 As SepalLength, 2.9 As SepalWidth)

Now we can see that we got a consistent prediction.

Utilizing both the `PREDICT` and `PROBABILITY` functions, you can assess how to best use the insights IntegratedML creates for your own application. 
In the next step, you will see how to validate a model in IntegratedML and see how accurate it is.

## Validate the Model

You may have looked at your results and assessed how well the model is performing, 
but there is more information from a machine learning perspective that you can gather about your model’s accuracy.
Run the command below to create a validation metric for your predictive model based on your training data set.

	VALIDATE MODEL FlowerPredictor FROM DataMining.IrisDataset

Then, run the command below to view the data in the `%ML.ValidationMetric` table, which contains the results of your model validation.

	SELECT * FROM %ML.ValidationMetric

You can see that there are four metrics available that provide information about your model for each of the classes ('*Iris-setosa*','*Iris-versicolor*','*Iris-virginica*'):

- **Precision** - is a measure that reflects the number of actual positive results out of all predicted positive results; in this case, the percentage of predicted species that were actual species.
- **Recall** - is a measure that reflects the number of predicted positives out of all actual positives; in this case, the percentage of actual species that were predicted as such.
- **F-Measure** - is a measure that reflects the concerns of both Precision and Recall in one composite score.
- **Accuracy** - is a measure that reflects the overall percentage of predictions that were correct.

Using this information, you can understand how well your model performs. 
Ultimately, to really hone and refine a predictive model, a data scientist is eventually needed. 
However, knowing this information can help you, even without that expertise.

For instance, if we think of a real-life scenario, when choosing a model for patient readmissions, you may want to err on the side of being cautious 
(e.g., a preference toward predicting readmission when in doubt, letting fewer true readmissions go undetected). 
In cases like these, where the cost of a false negative can be high, you may opt for a model with a high Recall score.

## Train Models Using Different Configurations

Throughout the first four steps of this exercise, you have viewed your data, created a model, trained it, and validated it. 
Those steps have been completed using the default ML configuration for this IRIS instance.
An ML configuration is a collection of settings that IntegratedML uses to train a model. 
Primarily, a configuration specifies a machine learning provider that will perform training.

By default, IntegratedML uses the internal %AutoML configuration.
However, as we mentioned before, there are more providers that you can use: %H2O, %DataRobot, and %PMML.
In this exercise, we will use the %H2O configuration, which sets H2O as the machine learning provider.

You can see a short example of how to easily change providers and retrain an existing model. 
Run the command below to set the new default configuration to be %AutoML.

	SET ML CONFIGURATION %H2O

Setting this configuration will set the machine learning provider to be H2O.
Run the command below to re-train your `FlowerPredictor` model with the current configuration, naming the new version `FlowerPredictorV2`. 
Like last time, you will use the `DataMining.IrisDataset` data set for this training.

	TRAIN MODEL FlowerPredictor AS FlowerPredictorV2

Yes, this `TRAIN` statement looks different from the other one.
Although the `TRAIN MODEL FlowerPredictor` would in our case be sufficient, we made this `TRAIN` statement a bit more complex.
Notice the `AS` clause in above `TRAIN MODEL` statement. It is used to give name to this specific training session.
This can be very useful if you want to track versions of the ML models you train.
In the same manner, you can use exact model you trained to make predictions, as follows:

	SELECT PREDICT(FlowerPredictor USE FlowerPredictorV2) as PredictedSpeciesH20
			FROM 
				(SELECT 5 As PetalLength, 1.8 As PetalWidth, 6.1 As SepalLength, 2.9 As SepalWidth)

Feel free to edit the SQL statement above to experiment with the various commands you have learned for creating, training, and validating models as well as executing the PREDICT and PROBABILITY functions.

### Training Models using DataRobot

In order to use DataRobot with IntegratedML, you would require a DataRobot license. If you dont have a license yet, you can start a [trial](https://www.datarobot.com/trial/) and check it out.
Once you have attained the access to DataRobot, you need to configure the connection between IRIS and DataRobot. In order to do so you need to copy the API Key into IRIS ML Configuration.
    
    1) login into datarobot website given within your registration email. It could be [https://app2.datarobot.com](https://app2.datarobot.com), but you might have some other link.
    2) on a top right corner, click on your profile (little man icon), and select `Profile`
    3) It will show your profile, and menu above your profile, where you should select `Developer Tools`
    4) Here you will see all your API keys, but since you have just started using DataRobot, you will see none. Select `Create New Key` and name it as you want. It will generate a 92 character key which you need to copy into clipboard.
    5) now enter the [InterSystems IRIS Management Portal](http://localhost:9092/csp/sys/utilhome.csp)
    6) Go to `System Administration` -> `Configuration` -> `Machine Learning Configurations`
    7) Select `Create New Configuration`
        - Under `Name` enter *DataRobotTrial* (optional but for further training defined)
        - For `Provider` enter *DataRobot*
        - As a `Owner` set *SuperUser*
        - For `URL` enter the link which brought you to datarobot website. It is most likely *https://app2.datarobot.com*
        - For `API Token`, enter the API Key you copied into clipboard in the step 4
    8) Click `Save` and that's it!

Now you can change the ML configuration with SQL statement

    SET ML CONFIGURATION DataRobotTrial

Now you can use the same statements like you did before. With `CREATE MODEL` statement, the model definition is being created.
`TRAIN MODEL` creates the DataRobot Project, which you can see when you click on 2 icon on the top right which looks like a folder and there select `Manage Projects`. It uploads the data into DataRobot, and automatically starts a autopilot. It will analyze the data, detect features, and initiate a queue of possible machine learning models that can be used.
Once the DataRobot autopilot is finished, `TRAIN MODEL` execution will finish and store link to DataRobot deployment.
It is important to mention that no trained machine learning model is transfered to IRIS Data Platform, but rather stores deployment ID which is used to communicate with DataRobot every time the ML model is being used, like within PREDICT function.
This enables us to select different `champion` models for the created project, for example which perform faster.

## Maintaining ML Models

Before we continue, let us take a look at the IntegratedML workflow. 
When we do the `CREATE MODEL` statement, we define the problem we want ML to solve. 
This is considered as a model definition. `TRAIN MODEL` statement will initiate the *TRAINING RUN* and result in *TRAINED MODEL*.
During the *TRAINING RUN*, IntegratedML will generate a detailed information of how the training has been performed.

![IMLWorkflow](IMLworkflow.png)

Once we have a trained model, every time we want to validate it against new dataset, we do a *VALIDATION RUN*. 
When the *VALIDATION RUN* is finished, it will result in *VALIDATION METRIC*, which you can query to see how well did the model performed.

These are the terms we need to keep in mind when browsing and Maintaining ML Models.

As you can expect, once you start using IntegratedML, you will be creating many ML models, which you need to keep track of.

All model definitions (created using `CREATE MODEL` statement) can be seen using the following statement:

	SELECT * FROM INFORMATION_SCHEMA.ML_MODELS

If you haven't run any other SQL statements except above mentioned, you should see only one row, defining only one model definition.
Take a look at the result. Some columns worth mentioning are:

* **`MODEL_NAME`** - This is the model name you choose when writing a `CREATE MODEL` statement. In our case, this is `FlowerPredictor`
* **`PREDICTING_COLUMN_NAME`** - column it is predicted (`Species`)
* **`WITH_COLUMNS`** - columns it should use as "inputs"
* **`DEFAULT_TRAINING_QUERY`** - this is the default query IntegratedML takes from `CREATE MODEL` and uses when `TRAIN MODEL` statement does not have its own `FROM` clause

As we mentioned before, when IntegratedML performs training, this process is known as a "training run", and results in "trained model".
Let us take a look at all trained models we have so far. This is done using the following query:

	SELECT * FROM INFORMATION_SCHEMA.ML_TRAINED_MODELS

You should be seeing something similar like the following:

<table>
<tr>
<th>MODEL_NAME</th><th>TRAINED_MODEL_NAME</th><th>PROVIDER</th><th>TRAINED_TIMESTAMP</th><th>MODEL_TYPE</th><th>MODEL_INFO</th>
</tr>
<tr>
<td>FlowerPredictor</td><td>FlowerPredictor2</td><td>AutoML</td><td>2020-06-16 12:20:50.616</td><td>classification</td><td>ModelType:Random Forest, Package:sklearn, ProblemType:Classification</td>
</tr>
<tr>
<td>FlowerPredictor</td><td>FlowerPredictorV2</td><td>H2O</td><td>2020-06-16 12:26:15.109</td><td>classification</td>
</tr>
</table>

We can see exactly two models that we trained within our exercise.
Notice here that `TRAINED_MODEL_NAME` column comes from `AS` clause of the `TRAIN MODEL` statement. 
If it is omitted, it will automatically generate one.
As we have trained our `FlowerPredictor` model with two different providers, we can notice this in our results as well, under `PROVIDER` column.
`MODEL_TYPE` will show us what kind of a problem model resolves, which is in our case classification, because we try to classify species.
`MODEL_INFO` have sometime useful information about what kind of a model is trained, like in the first row, that model being used is [*Random Forest*](https://en.wikipedia.org/wiki/Random_forest).

It is often very useful to take a deeper look at the details of the training run itself. 
The information about each training runs can be seen with a following query:

	SELECT * FROM INFORMATION_SCHEMA.ML_TRAINING_RUNS

Here you can see the details about training run itself, like how long did it take (`TRAINING_DURATION`), 
if the training is completed or not (`RUN_STATUS`) and exact log of every step it took throughout the training process (`LOG`).
It is worth to mention that `TRAINED_MODEL_NAME` is always the same as `TRAINING_RUN_NAME`.

## Observing the ML training runs (Optional)

Let's take a look a bit deeper into the training process itself. 
As we mentioned above, each training run queries from `INFORMATION_SCHEMA.ML_TRAINING_RUNS` view.
Since InterSystems SQL editor removes various characters, like end of line and tabs before displaying it on a screen, 
we will use a small csp page which will show a properly formatted training run LOG.

In order to have a bit more complex result having diverse types of columns, let us use another dataset.
For this case, we will use dataset `Titanic.Passenger` which contains a list of passengers of Titanic's only journey along with information about their survival.
With IntegratedML, we want to prognose percentage of survival based on passenger details.
We will use internal %AutoML provider.

	SET ML CONFIGURATION %AutoML

Then create a model definition:

	CREATE MODEL Survival PREDICTING(Survived) FROM Titanic.Passenger

Now let's train the model. This time it will take a bit longer.

	TRAIN MODEL Survival AS SurvivalRun

We used clause `AS` intentionally, so that we can use it as `TRAINING_RUN_NAME`.
Please enter `SurvivalRun` into the following form. It will open you another window with a complete and nicely printed LOG.

<form name="trainingLog" method="get" action="trainingLog.csp" target="_blank">
<p>Training Run: <input type="text" name="trainingrun">
<input type="submit" value="Show Training Run" ></p>
</form>

Let's take a look at the training process. Each phase is marked with background color.

1. <span class="datapreps">First, IntegratedML collects all metadata available about columns and their data types</span>
2. <span class="featureengineering">then uses the feature engineering to modify existing features, create new ones, and remove unnecessary ones. These steps improve training speed and performance, including:</span>
    * <span class="featureengineering">Column type classification to correctly use features in models</span>
    * <span class="featureengineering">Feature elimination to remove redundancy and improve accuracy</span>
    * <span class="featureengineering">One-hot encoding of categorical columns</span>
    * <span class="featureengineering">Filling in missing or null values in incomplete datasets</span>
    * <span class="featureengineering">Creating new columns pertaining to hours/days/months/years, wherever applicable, to generate insights in your data related to time.</span>
3. <span class="modelselection">If a regression model is determined to be appropriate, AutoML uses a singular process for developing a regression model. For classification models, AutoML uses the following selection process to determine the most accurate model:</span>
    * <span class="modelselection">If the dataset is too large, AutoML samples down the data to speed up the model selection process.</span>
    * <span class="modelselection">AutoML determines if the dataset presents a binary classification problem, or if multiple classes are present, to use the proper scoring metric.</span>
    * <span class="modelselection">Using Monte Carlo cross validation, AutoML selects the model with the best scoring metrics for training on the entire dataset.</span>
4. <span class="training1">Notice</span><span class="training2"> how</span><span class="training3"> multiple </span><span class="training4">models</span><span class="training5"> are </span><span class="training1">getting</span><span class="training2"> trained</span><span class="training3"> and</span><span class="training4"> their</span><span class="training5"> final</span><span class="training1"> accuracy</span><span class="training2"> displayed</span><span class="training3"> at the end</span><span class="training4"> of training session</span>
5. <span class="formatedresult">and at the end, the winning model printed in json format as a result</span>


## Additional Material

This image contains additional dataset which you can try out:

* `Titanic.Passenger` - List of passengers of Titanic's only journey along with information about their survival.
* `DataMining.IrisDataset` - instead of predicting flowers, you can try predicting for example the `SepalLength` based on species and other parameters. Having a number as an output to predict, IntegratedML will treat it as a regression problem and use different and regression-problem-relevant models.
* `SQLUser.appointments` - a anonymized appointment record of one clinic. You can use this dataset to prognose the probability of patient showing to the appointment.


## Summary and Additional Resources

You have now completed Getting Started with IntegratedML. In this exercise, you:
* Created a model definition
* Trained a model on a set of training data
* Executed a model on set of testing data
* Validated a model and view the results
* Set a different ML configuration to train new models
* View and Maintain models 

To learn more about IntegratedML, visit the following learning resources:

* [Learn IntegratedML in InterSystems IRIS - resource guide](https://learning.intersystems.com/course/view.php?id=1346&ssoPass=1)
* [Using IntegratedML - Documentation](https://docs.intersystems.com/iris20202/csp/docbook/Doc.View.cls?KEY=GIML)
