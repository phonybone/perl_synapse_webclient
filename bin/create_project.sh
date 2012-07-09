#!/bin/bash

description='Test project for ISB COMPLICATED project by John Earles, Victor Cassen'
entityType='org.sagebionetworks.repo.model.Project'
name='Complicated Test'

sessionToken=UmRYgjOV6d7AREXtOyDRrw00

cmd="curl -i  -d '{ \
  \"description\": \"$description\", \
  \"entityType\": \"$entityType\", \
  \"name\": \"$name\" \
}' \
-H sessionToken:$sessionToken \
-H Content-Type:application/json \
-H Accept:application/json \
'https://repo-alpha.sagebase.org/repo/v1/entity'"

echo $cmd
#$cmd
