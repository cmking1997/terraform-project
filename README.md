For a full-stack modern application my stack consists of the following:
Amplify for the frontend, this will make hosting a React application quite simple.
Lambda backend focused on micoservice infrasatructure.
S3 for document storage and requirements there
RDS for regular data storage using mySQL, potentially could be swapped to PostgreSQL based on preference
if Route 53 is used that can be included, for custom domains but since this is a dev env i excluded it
