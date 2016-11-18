
# General guidance
OSSILE follows typical open source processes for community contributions. This article contains great guidance on doing so:
http://blog.davidecoppola.com/2016/11/howto-contribute-to-open-source-project-on-github/

# Acceptance criteria
Contributions to OSSILE will be accepted if the following conditions are met:
 * Processes on this page have been followed
 * Code quality is believed to be acceptable by the maintainers of the project
 * The code contributes sufficient value and is aligned with the spirit of the project

# Contributing changes to existing OSSILE parts
There are no special processes. Just fork the project, make your changes, test them, and send us a pull request!


# Contributing a new buildable item to OSSILE
1. As is standard, start by creating a new fork for your contributions, use that fork for the following steps. 
2. Create a new subdirectory within the "main" directory with a logical name for your build item. By convention, use all lowercase
3. Drop the code into this new directory
4. In this new directory, create a file called "setup". 
5. Put all the build/compilation steps necessary in the "setup" file. It will be invoked as a script. Start with a '#!' line. **The script should build your ILE code into the OSSILE library on IBM i!**
  Please have your script obey the following rules:
    * Write useful information to standard out in cases of build failure (for instance, dependencies missing, etc)
    * Explicitly check that all operations finished successfully. If the build failed, exit with a nonzero return code
6. Update the buildlist.txt file (in the main/ directory) to include your new subdirectory name
7. Update the README.md text file to include:
    * A reference to your item in the "What's included in OSSILE" section, which should include 
        * A link to your item's own README.md file
        * Basic (20 words or less) description of what the item does
8. Test and commit your changes, send us a pull request!


# Contributing a new example to OSSILE
1. As is standard, start by creating new fork for your contributions, use that fork for the following steps. 
2. Create a new file in the "xxx_examples" directory (where 'xxx' is the programming language of interest, in all lowercase)
3. Test and commit your changes, send us a pull request!
