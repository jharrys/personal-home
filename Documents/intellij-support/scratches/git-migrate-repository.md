# Migrating a repository from Bitbucket

## Follow the instructions above to create a repository in Github

Use the following command to create a raw clone of your Bitbucket repository

	git clone --mirror https://git.churchofjesuschrist.org/scm/projectID/gitrepositoryname.git

Change directories into the "gitrepositoryname" directory

	Run git remote -v to see the origin path of the repository.

Run the following command to change the origin to the new Github repository.
	git remote set-url origin https://github.com/ICSEng/mynewgitrepositoryname

Github's default branch is "main" and creating a main branch is recommended.
If not you will need to set the default branch after you push your repository to Github.
Ensure your Bitbucket default branch is checked out before creating a new "main" branch (git checkout -b defaultbranch)
Create a branch called main.

	git branch -M main

Run the following command to push your raw git repository to Github

	git push --mirror origin

Refresh your Github page and you should have access to the git repository and the full history of the repository as it existed in Bitbucket
