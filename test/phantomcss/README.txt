
Easiest/Simplest method to install PhantomCSS:

If you do not have node package manager installed: Download and install from https://nodejs.org/en. Make sure you include the option to add to path.

1.  Install phantomcss using npm with command:
		npm install phantomcss
		
2.  Download and install python. https://www.python.org/downloads/

3.  Add casperjs and phantomjs to environment variable. 
	- Go to my computer or thispc, right click -> Properties -> Advanced system settings. 
	- Advanced tab -> Environment Variables.
	- Edit the path variable under System Variables and add the following new paths.  Replace path as needed.
		- <root>\casperjs\bin\
		- <root>\phantomjs\bin\
		
4.  Pull master.

5.  In the command line window, go to the phantomcss folder in your node_modules folder. Replace root with your path.
		cd <root>/node_modules/phantomcss
	
6.  Copy the images from C:\<root>\Sites\devedesktop\secgov-dev\test\phantomcss\screenshots to use as a baseline into your phantomcss screenshot folder C:\Users\vivian.kim\node_modules\phantomcss\screenshots.
	Run the test for the first time to generate screenshots. Replace root with your path. You may need to hit enter more than once.
		casperjs test C:\<root>\Sites\devedesktop\secgov-dev\test\phantomcss\screenshots
	
		
		
		
