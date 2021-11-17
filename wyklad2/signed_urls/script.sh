export PROJECT_ID=alk-data-d-0050
export SA_NAME=storage-admin-0010
export SA_EMAIL=${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com
export USER_EMAIL=$(gcloud config list account --format "value(core.account)" 2> /dev/null)
export USER_EMAIL=user@pwozniak-test.workshop.ongcp.co
export REGION=europe-central2
export BUCKET_NAME=alk-data-d-bkt-eucen2-signurl-0010
export OBJECT_NAME=spotify_logo.png


# (Optional) add Service Usage Consumer role to user on project level
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
--member "user:${USER_EMAIL}" \
--role "roles/serviceusage.serviceUsageConsumer"

# (Optional) verify permissions
gcloud projects get-iam-policy ${PROJECT_ID}
gcloud iam service-accounts get-iam-policy ${SA_EMAIL}

# Enable APIs:
gcloud services enable iamcredentials.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com

# Create SA
gcloud iam service-accounts create ${SA_NAME} --display-name ${SA_NAME}

# Add roles to SA on project level
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
--member serviceAccount:${SA_EMAIL} \
--role "roles/storage.admin"

# Add Service Account Token Creator role to user on SA level
gcloud iam service-accounts add-iam-policy-binding ${SA_EMAIL} \
--member "user:${USER_EMAIL}" \
--role "roles/iam.serviceAccountTokenCreator" 

# ---
# Switch to user
# ---

# (Optional) Upgrade pip
pip3 install --upgrade pip
# (Optional) Install pyopenssl
python3 -m pip install pyopenssl

# (Optional) Toggle impersonating SA
gcloud config set auth/impersonate_service_account ${SA_EMAIL}
gcloud config unset auth/impersonate_service_account

gsutil signurl -r europe-central2 -d 20s -u gs://${BUCKET_NAME}/${OBJECT_NAME}
gsutil signurl -r europe-central2 -d 20s -u gs://${BUCKET_NAME}/*

# Use in-command impersonation
gsutil -i ${SA_EMAIL} ls
gsutil -i ${SA_EMAIL} signurl -r europe-central2 -d 1m -u gs://${BUCKET_NAME}/${OBJECT_NAME}